# Build Sequence

Ordered by dependency and priority. This is the input for creating the actual festival plan via `fest create`.

## Phase 1: Foundation

Everything else depends on this.

### Sequence 1.1: Hedera Core (P0)

1. Set up Hedera testnet accounts (coordinator, inference agent, defi agent)
2. Implement HCS adapter: create topics, publish messages, subscribe via mirror node
3. Implement HTS adapter: create fungible token (AGT), transfer between agents
4. Implement basic festival protocol: publish plan to HCS, track task states
5. Verify: three accounts can exchange HCS messages and HTS tokens

### Sequence 1.2: obey daemon Agent Integration (P0)

1. Configure daemon to spawn three agent processes
2. Wire daemon ↔ Hedera: agent messages route through HCS
3. Implement coordinator logic: read festival plan, assign tasks, check gates
4. Implement health monitoring: heartbeat messages via HCS
5. Verify: daemon spawns agents, coordinator assigns a task, specialist completes it

### Sequence 1.3: Camp Workspace Setup (P0)

1. Initialize projects/ structure (agent-coordinator, agent-inference, agent-defi, dashboard, hiero-plugin)
2. Create justfiles per project (build, test, run, deploy)
3. Create root justfile importing all project justfiles
4. Verify: `just build` works, `cgo` navigation works

**Phase 1 Gate**: Coordinator agent can publish a festival plan to HCS, assign a task to another agent via HCS message, receive a result, and pay via HTS. All running in the daemon.

## Phase 2: Chain Agents

Build the specialist agents in parallel.

### Sequence 2.1: Inference Agent — 0G Integration (P1)

1. Set up 0G Compute broker connection (`@0glabs/0g-serving-broker`)
2. Implement inference request flow: submit job → wait → receive result
3. Set up 0G Storage: upload/download agent memory and knowledge
4. Deploy ERC-7857 iNFT contract on 0G Chain
5. Mint agent iNFT with encrypted metadata
6. Implement dynamic metadata updates (agent learning)
7. Wire agent to coordinator: receive tasks via HCS, return results via HCS
8. Verify: Coordinator sends inference task → agent runs on 0G Compute → result published to HCS → agent paid via HTS

### Sequence 2.2: DeFi Agent — Base Integration (P1)

1. Set up Coinbase AgentKit with Agentic Wallet on Base
2. Register agent with ERC-8004 (Identity Registry)
3. Implement x402 payment flow for compute/data access
4. Add ERC-8021 builder code to all transactions
5. Implement basic DeFi strategy (DEX arbitrage or LP management)
6. Wire agent to coordinator: receive strategy via HCS, report P&L via HCS
7. Verify: Agent executes a trade on Base mainnet, attributed via ERC-8021, pays for data via x402

### Sequence 2.3: Schedule Service Automation (P0 — part of Track 3)

1. Implement scheduled heartbeat transactions via native Schedule Service
2. Implement scheduled settlement cycles (batch HTS transfers)
3. Wire to coordinator: scheduled checks trigger status updates
4. Verify: Heartbeat fires on schedule, settlement batch processes correctly

**Phase 2 Gate**: All three agents operational. Coordinator assigns tasks from a festival plan. Inference agent runs on 0G. DeFi agent trades on Base. All communication flows through HCS. All payments flow through HTS.

## Phase 3: Dashboard & Polish

### Sequence 3.1: Dashboard (P1)

1. Scaffold Next.js app
2. Build Festival Progress component (phases, sequences, task states)
3. Build HCS Feed component (real-time message stream via mirror node WebSocket)
4. Build HTS Payment Flow component (token transfer visualization)
5. Build Base P&L component (trade history, revenue vs. costs)
6. Build 0G Metrics component (compute jobs, storage usage)
7. Build Agent Status cards (health, current task, chain-specific stats)
8. Verify: Dashboard shows live data from all three chains

### Sequence 3.2: Hiero CLI Plugin (P0)

1. Read PLUGIN_ARCHITECTURE_GUIDE.md from hiero-cli repo
2. Create Node.js plugin following architecture spec
3. Implement `hiero camp init` (wraps camp binary)
4. Implement `hiero camp status` (wraps camp status)
5. Add Hedera-specific templates (agent-economy, no-solidity, etc.)
6. Write usage documentation
7. Submit PR to hiero-cli repo
8. Record demo video of plugin usage

### Sequence 3.3: 0G Dev Tooling Templates (P2)

1. Create camp template: `0g-agent` (scaffolds full 0G agent project)
2. Create fest template: `0g-inft-build` (pre-built festival plan)
3. Document templates with examples
4. Verify: `camp init --template 0g-agent` produces working project structure

**Phase 3 Gate**: Dashboard shows live agent activity. Hiero plugin PR submitted. All submission deliverables in progress.

## Phase 4: Submission

### Sequence 4.1: Testing & Hardening

1. End-to-end test: full festival cycle (plan → assign → execute → gate → next phase → settle)
2. Failure recovery test: agent crashes, daemon restarts, work resumes
3. Dashboard stress test: handles rapid HCS message bursts
4. Base agent profitability verification: revenue > costs over test period
5. Security review: no committed secrets, proper key handling, testnet isolation

### Sequence 4.2: Submission Prep

1. Write root README (architecture overview, setup instructions, demo link)
2. Write per-project READMEs
3. Record 3-minute video walkthrough
4. Deploy dashboard to public URL
5. Prepare Demo Day slides/script
6. Submit to each bounty track on Devfolio

### Sequence 4.3: Optional Track 2 (P2)

1. Write AgentSettlement.sol with HIP-1215 scheduling
2. Write ReputationDecay.sol with periodic decay
3. Deploy to Hedera testnet
4. Wire to dashboard for observability
5. Submit as separate Track 2 entry

**Phase 4 Gate**: All submissions uploaded. Dashboard live. Demo rehearsed.

---

## Dependency Graph

```
Phase 1 (Foundation)
├── 1.1 Hedera Core ──────────┐
├── 1.2 Daemon Integration ───┤ (1.2 depends on 1.1)
└── 1.3 Camp Workspace ───────┘ (1.3 is independent)
                              │
                              ▼
Phase 2 (Chain Agents)        │
├── 2.1 0G Agent ─────────────┤ (depends on 1.1 + 1.2)
├── 2.2 Base Agent ────────────┤ (depends on 1.1 + 1.2)
└── 2.3 Schedule Service ─────┘ (depends on 1.1)
                              │
                              ▼
Phase 3 (Dashboard & Polish)  │
├── 3.1 Dashboard ─────────────┤ (depends on 2.1 + 2.2)
├── 3.2 Hiero Plugin ─────────┤ (depends on 1.3 only)
└── 3.3 0G Templates ─────────┘ (depends on 2.1)
                              │
                              ▼
Phase 4 (Submission)          │
├── 4.1 Testing ───────────────┤ (depends on 3.1)
├── 4.2 Submission Prep ───────┤ (depends on 4.1)
└── 4.3 Optional Track 2 ─────┘ (independent, P2)
```

**Note**: Sequence 3.2 (Hiero Plugin) depends only on camp (1.3), so it can be built in parallel with Phase 2 agent work.

---

## Critical Path

The minimum viable submission (P0 tracks only) requires:

```
1.1 → 1.2 → 2.3 → 3.2 → 4.1 → 4.2
 │           │
 └─ 1.3 ────┘ (parallel)
```

This gets us:
- Hedera Track 3: Agent economy with native services
- Hedera Track 4: Hiero camp plugin

Everything else (0G, Base, dashboard, competition tracks) adds bounty potential but isn't on the critical path for our two strongest submissions.
