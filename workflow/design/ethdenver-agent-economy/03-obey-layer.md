# Obey Integration Layer

How the obey daemon, fest, and camp integrate into the project — and how they get maximum exposure.

## obey daemon — The Orchestrator

The obey daemon IS the coordinator. It doesn't wrap another framework. It doesn't call out to OpenClaw. The daemon manages the agent lifecycle directly.

### Agent Lifecycle

```
daemon start
  │
  ├── spawn coordinator-agent
  │     config: { provider: claude, model: opus, hedera_account: 0.0.xxx }
  │
  ├── spawn inference-agent
  │     config: { provider: 0g-compute, 0g_broker: <url>, hedera_account: 0.0.yyy }
  │
  └── spawn defi-agent
        config: { provider: claude, model: sonnet, base_wallet: 0x..., hedera_account: 0.0.zzz }
```

Each agent is a daemon-managed process with:
- Its own LLM provider connection (provider-agnostic)
- Its own blockchain account(s)
- Its own task queue (festival-structured)
- Health monitoring and restart capability
- Hierarchical reporting to the coordinator

### Hierarchical Execution Model

```
Executive Layer (Coordinator Agent)
│
├── Decides WHAT needs to happen (reads festival plan)
├── Assigns tasks to specialist agents
├── Monitors progress via HCS messages
├── Enforces quality gates between phases
│
├── Specialist: Inference Agent
│   └── Executes inference tasks on 0G
│
└── Specialist: DeFi Agent
    └── Executes trading strategies on Base
```

The daemon enforces hierarchy. Specialist agents cannot override the coordinator. The coordinator cannot bypass quality gates. This is deterministic orchestration, not a free-for-all agent swarm.

### What the Daemon Exposes

For the hackathon, the daemon needs to support:

1. **Agent spawn/stop** — create and destroy agent processes
2. **Configuration** — per-agent provider, model, credentials
3. **Message routing** — forward inter-agent messages (backed by HCS)
4. **Health monitoring** — heartbeat checks, restart on failure
5. **Status API** — expose agent states for the dashboard
6. **Festival integration** — read fest plans, track phase progress

### Daemon ↔ Hedera Bridge

The daemon connects to Hedera as its coordination backbone:

```
daemon                          Hedera
  │                               │
  ├── Publish festival plan ────▶ HCS Topic (immutable)
  ├── Send task assignment ─────▶ HCS Message
  ├── Receive task result ◀───── HCS Subscription (mirror node)
  ├── Transfer payment ─────────▶ HTS Transfer
  ├── Check agent health ───────▶ Scheduled heartbeat TX
  └── Read audit trail ◀──────── HCS Message history
```

This means all inter-agent communication is both:
- Locally observable (daemon APIs for dashboard)
- On-chain verifiable (HCS for audit trail)

## fest — The Planning Protocol

### How fest Structures Agent Work

Every multi-agent task follows festival methodology:

```
Festival: "Analyze ETH/USDC opportunity on Base"
│
├── Phase 1: Research
│   ├── Sequence 1.1: Market Data
│   │   ├── Task 1.1.1: Fetch pool states [Inference Agent]
│   │   ├── Task 1.1.2: Historical volatility analysis [Inference Agent]
│   │   └── Task 1.1.3: Compile research report [Inference Agent]
│   │
│   └── Quality Gate: Research report meets minimum data points
│
├── Phase 2: Strategy
│   ├── Sequence 2.1: Strategy Formation
│   │   ├── Task 2.1.1: Generate strategy candidates [Coordinator]
│   │   ├── Task 2.1.2: Risk-score each candidate [Inference Agent]
│   │   └── Task 2.1.3: Select optimal strategy [Coordinator]
│   │
│   └── Quality Gate: Selected strategy passes risk threshold
│
└── Phase 3: Execution
    ├── Sequence 3.1: Trade Execution
    │   ├── Task 3.1.1: Execute entry position [DeFi Agent]
    │   ├── Task 3.1.2: Monitor position [DeFi Agent]
    │   └── Task 3.1.3: Execute exit [DeFi Agent]
    │
    └── Quality Gate: Position closed, P&L recorded
```

### On-Chain Festival Protocol

Festival plans are published to HCS, creating an immutable audit trail:

```json
// Message 1: Festival creation
{
  "type": "festival_create",
  "festival_id": "eth-usdc-001",
  "phases": [
    {
      "id": 1,
      "name": "Research",
      "gate": { "min_data_points": 5 }
    },
    {
      "id": 2,
      "name": "Strategy",
      "gate": { "max_risk_score": 0.7 }
    },
    {
      "id": 3,
      "name": "Execution",
      "gate": { "position_closed": true }
    }
  ]
}

// Message 2: Task assignment
{
  "type": "task_assign",
  "festival_id": "eth-usdc-001",
  "phase": 1, "sequence": 1, "task": 1,
  "agent": "inference-agent",
  "description": "Fetch current pool states for ETH/USDC on Base DEXes"
}

// Message 3: Task completion
{
  "type": "task_complete",
  "festival_id": "eth-usdc-001",
  "phase": 1, "sequence": 1, "task": 1,
  "agent": "inference-agent",
  "result_ref": "0g://storage/<cid>"  // Result stored on 0G
}

// Message 4: Quality gate evaluation
{
  "type": "gate_check",
  "festival_id": "eth-usdc-001",
  "phase": 1,
  "passed": true,
  "reason": "7 data points collected (minimum 5)"
}
```

### fest CLI During the Build

We ALSO use fest to plan and track the hackathon build itself:

```bash
# Create the build festival
fest create ethdenver-agent-economy

# Track build progress
fest status

# Mark tasks complete as we build
fest complete 1.1.1

# The meta-angle: we used fest to plan the project,
# AND the project demonstrates fest working for agents
```

## camp — The Workspace

### Campaign Structure

This ETHDenver campaign IS a camp campaign. The project structure in 01-architecture.md is the camp layout. Every project is navigable via `cgo`:

```bash
cgo p                    # → projects/
cgo p agent-coordinator  # → projects/agent-coordinator/
cgo p dashboard          # → projects/dashboard/
cgo f                    # → festivals/
cgo w                    # → workflow/
cgo d                    # → docs/
```

### Hiero CLI Plugin

The `hiero camp` plugin exposes camp's workspace management to Hedera developers:

```
Plugin Architecture:
├── Follows Hiero CLI PLUGIN_ARCHITECTURE_GUIDE.md
├── Node.js wrapper around camp Go binary
├── Registers commands under `hiero camp` namespace
└── Hedera-specific templates bundled

Plugin Manifest (package.json):
{
  "name": "hiero-plugin-camp",
  "hiero": {
    "type": "plugin",
    "commands": ["camp"]
  }
}
```

The plugin is genuinely useful: any Hedera developer can use `hiero camp init` to get a structured workspace for their Hedera project. This isn't a hackathon toy — it's a real developer tool.

## Exposure Matrix

| Moment | What They See | Tool Showcased |
|--------|-------------|----------------|
| **Demo Day (2 min)** | Agents operating across 3 chains | obey daemon |
| **Demo Day** | Festival progress advancing in real-time | fest |
| **Demo Day** | Clean multi-project workspace shown | camp |
| **GitHub README** | camp campaign structure visible | camp |
| **GitHub README** | Festival plan in festivals/ directory | fest |
| **Hiero CLI PR** | Plugin in Hedera's own repository | camp |
| **Dashboard** | Festival progress visualization | fest / festui |
| **Dashboard** | Agent lifecycle and health | obey daemon |
| **Other hackers** | "What tools did you use to build this?" | all three |
| **Sponsors** | Organized, professional submission | camp + fest |
| **Workshop pitch** | "Structured planning for AI agents" | fest |
| **Post-hackathon** | Blog: "How we built a multi-chain agent economy in 5 days" | all three |

## The Narrative

The story we tell at every touchpoint:

> "We built a multi-chain agent economy. Three AI agents, three blockchains, one orchestrator.
>
> The agents settle on Hedera, run inference on 0G, and trade on Base. They coordinate using festival-structured plans — the same planning methodology we used to build the project itself.
>
> The orchestrator is our obey daemon. The planning is our fest CLI. The workspace is our camp CLI. These are open-source tools you can use today.
>
> Obedience Corp: AI that does what you want, the way you want it done."
