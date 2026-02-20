# Daemon Requirements — ETHDenver Agent Economy

This is the key document. It separates what works today, what must be built, and what Lance is planning beyond the hackathon.

---

## A. What Works Today (Leverage for Hackathon)

These capabilities exist in obeyd v0.1.0 and can be used immediately:

### Event Routing Infrastructure

- Full event pipeline: source → router → dedup → state update → hub forward
- Campaign and festival event types cover all lifecycle states
- Agent activity event types exist (THINKING, TOOL_CALL, TOOL_RESULT, COMPLETION)
- Events flow to hub via WebSocket for dashboard consumption
- **Hackathon use**: Agent events can flow through this existing pipeline with zero changes to the router

### Command Execution Sandbox

- `Execute` RPC with streaming stdout/stderr
- Allowlist-based: fest, camp, just, git
- Path validation bound to campaign root (symlink-aware)
- Timeout support, exit code reporting
- **Hackathon use**: Agents can run fest/camp/just commands within sandbox — no need to shell out unsafely

### State Tracking (SQLite)

- `agent_sessions` table: session ID, campaign, festival, task, agent name, provider, model, tokens, working dir
- `agent_activities` table: activity type, content, tool name/ID, success flag
- `festivals` table: status, current phase, current task, completed count
- 7-day event retention, 30-day activity retention
- **Hackathon use**: Agent session data has a home — sessions can be created and queried today

### Hub Sync

- Real-time WebSocket connection to obey.app
- Protobuf-encoded events with exponential backoff reconnection
- Bidirectional: outbound events + inbound commands
- **Hackathon use**: Dashboard could consume agent events via hub without direct daemon connection

### gRPC API

- `Ping` — health check with version, hostname, hub status, campaign count
- `GetState` — query campaigns, festivals, task progress
- `StreamAgentActivity` — client-streaming for activity events
- **Hackathon use**: Dashboard or coordinator can query daemon state over gRPC

---

## B. What Needs to Be Built (Agent Management)

These are the new daemon capabilities required for the hackathon. This is **real product work** — agent management is being added to the daemon as a permanent feature, not a hackathon hack.

### 1. Agent Registry

**Purpose**: Register agent definitions so the daemon knows what agents exist and how to run them.

**Data model** (new table: `agents`):

```
id TEXT PK
name TEXT UNIQUE          -- e.g., "coordinator", "inference-agent", "defi-agent"
type TEXT                 -- e.g., "coordinator", "inference", "defi"
command TEXT[]            -- how to spawn: ["go", "run", "./cmd/agent"]
working_dir TEXT          -- agent's working directory
config JSONB              -- per-agent config (blockchain accounts, etc.)
status TEXT               -- "registered", "running", "stopped", "failed"
created_at TIMESTAMP
updated_at TIMESTAMP
```

**gRPC additions**:

- `RegisterAgent(AgentDefinition) → AgentRegistration`
- `ListAgents() → AgentList`
- `GetAgent(agent_id) → AgentState`
- `UnregisterAgent(agent_id) → Ack`

### 2. Agent Process Management

**Purpose**: Spawn agents as child processes, monitor health, restart on failure, stop gracefully.

**Process lifecycle**:

```
RegisterAgent → StartAgent → [running: heartbeat monitoring] → StopAgent
                                     ↓ (failure)
                              RestartAgent (with backoff)
```

**Key requirements**:

- Spawn agent as OS child process with daemon as parent
- Capture agent stdout/stderr and route to event pipeline
- Heartbeat monitoring: agent must ping daemon within configurable interval
- Restart policy: configurable max restarts, backoff interval
- Graceful stop: SIGTERM → wait → SIGKILL
- Process group isolation: agent crash doesn't take down daemon

**gRPC additions**:

- `StartAgent(agent_id) → AgentStartResponse`
- `StopAgent(agent_id, graceful) → Ack`
- `RestartAgent(agent_id) → AgentStartResponse`

### 3. Agent Configuration

**Purpose**: Per-agent settings that the daemon injects into the agent's environment.

**Config categories**:

- **Blockchain accounts**: Hedera account ID, Base wallet address (injected as env vars)
- **Working directory**: where the agent operates within the campaign
- **Environment variables**: arbitrary key-value pairs for agent-specific config
- **Restart policy**: max restarts, backoff base, backoff max

**What the daemon does NOT configure**:

- LLM provider/model — agents handle their own LLM connections
- Agent logic or prompts — agents are autonomous programs
- Blockchain private keys — agents read from their own `.env` files

### 4. Agent State API

**Purpose**: gRPC endpoints to query what agents are running, their health, and current work.

**State information per agent**:

- Process status: `registered`, `running`, `stopped`, `failed`, `restarting`
- Health: last heartbeat timestamp, heartbeat interval, healthy/unhealthy
- Current work: active session ID, festival ID, task ID
- Resource usage: PID, uptime, restart count
- Token counts: input/output tokens from activity stream

**gRPC additions**:

- `GetAgentStatus(agent_id) → AgentStatus` (detailed single-agent state)
- `ListAgentStatuses() → AgentStatusList` (all agents summary)
- `WatchAgentStatus(agent_id) → stream AgentStatus` (server-streaming status updates)

### 5. Agent Event Enrichment

**Purpose**: Tag existing event pipeline events with `agent_id` so the dashboard can filter by agent.

**Changes**:

- Add `agent_id` field to internal `Event` struct
- Add `agent_id` column to `events` table
- Add `agent_id` to `StreamAgentActivity` message (currently only has `session_id`)
- Router includes `agent_id` when forwarding to hub
- Dashboard can filter events by agent

**This is the smallest change but the most impactful for the demo** — it connects agent identity to the existing event stream.

---

## C. Daemon Roadmap

### By Feb 21 (Hackathon Deadline)

**Build priority — agent management MVP only.** No daemon refactors, no hub protocol changes. Ship the minimum surface area that unblocks Festival 2.

| Item | Owner | Status |
|------|-------|--------|
| Agent registry (table + gRPC CRUD) | Agent (Festival 0, Phase 1) | Not started |
| Process management (spawn/stop/restart) | Agent (Festival 0, Phase 2) | Not started |
| Event enrichment (agent_id on events) | Agent (Festival 0, Phase 3) | Not started |
| Agent state query API | Agent (Festival 0, Phase 4) | Not started |
| Agent config injection (env vars) | Agent (Festival 0, Phase 5) | Not started |

**What I will NOT touch before the deadline:**

- Hub protocol — existing WebSocket sync is sufficient; agent events flow through the same pipeline
- Daemon startup flow — agents register after daemon is already running, no boot-order changes
- Sandbox redesign — agents use the existing sandbox boundary (campaign root) for now

**What stays out of scope for the hackathon:**

- Remote agents, agent discovery protocols, distributed registration
- Agent-to-agent RPC (agents communicate via HCS, not daemon)
- Hot reload of agent configs (stop + update + start is fine)

### Post-Hackathon: Agent Management V2

**Child processes → pluggable runtimes.** The hackathon proves the pattern with OS child processes. Post-hackathon, the daemon gains a runtime interface:

```go
type AgentRuntime interface {
    Start(ctx context.Context, def AgentDefinition) (AgentHandle, error)
    Stop(ctx context.Context, handle AgentHandle, graceful bool) error
    Health(ctx context.Context, handle AgentHandle) (HealthStatus, error)
}
```

Built-in runtimes:

- `ProcessRuntime` — what we build for the hackathon (child process, local)
- `ContainerRuntime` — Docker/Podman agent isolation (post-hackathon)
- `RemoteRuntime` — agent running on another machine, reporting back via hub (later)

This means the hackathon's `ProcessRuntime` becomes one implementation behind a stable interface — no throwaway code.

**Declarative agent configs (YAML).** Post-hackathon, agents are defined in campaign-level YAML:

```yaml
# .campaign/agents.yaml
agents:
  - name: coordinator
    runtime: process
    command: ["go", "run", "./cmd/coordinator"]
    working_dir: projects/agent-coordinator
    restart_policy:
      max_restarts: 3
      backoff: 5s
    env:
      HEDERA_ACCOUNT_ID: "0.0.xxx"
      LLM_PROVIDER: "claude"
```

For the hackathon, agents are registered programmatically via gRPC. The YAML layer wraps the same gRPC calls — it's additive, not a rewrite.

### Post-Hackathon: Hub Integration

**Agent status synced to hub in real-time.** The hub already receives all daemon events. Adding agent lifecycle events (`AGENT_REGISTERED`, `AGENT_STARTED`, `AGENT_STOPPED`, `AGENT_HEALTH_CHANGED`) to the existing event pipeline requires no hub protocol changes — just new event types.

**Hub dashboard gets read-only agent views first.** Start/stop controls come later when the hub has an authenticated command channel back to the daemon. For the hackathon, the dashboard observes only.

### Post-Hackathon: Agent Security Model

**Per-agent sandbox boundaries.** Today all agents share the campaign-root sandbox. Post-hackathon:

- Each agent gets its own boundary (its `working_dir` subtree)
- Cross-agent file access requires explicit grants in the agent config
- Agent-specific command allowlists extend the default set

**Agent-to-agent communication stays on-chain.** Agents don't talk to each other through the daemon. HCS is the communication backbone — the daemon is an observer, not a router. This is a design choice, not a limitation: on-chain communication creates the audit trail that makes the project valuable.

**Agent credential isolation.** Each agent loads its own `.env` from its working directory. The daemon injects non-secret config (account IDs, endpoint URLs) via environment variables. Private keys never pass through the daemon.

---

## Implementation Order (Suggested)

If building Festival 0 (Daemon Agent Management):

```
Phase 1: Agent Registry          ← Foundation, must come first
Phase 2: Process Management      ← Core capability
Phase 3: Event Enrichment        ← Small change, big demo impact
Phase 4: Agent State API         ← Dashboard dependency
Phase 5: Agent Configuration     ← Can be iterative
Phase 6: Integration Testing     ← End-to-end verification
```

**Minimum viable for demo**: Phases 1 + 2 + 3 — daemon can register agents, spawn them, and tag events with agent_id so the dashboard can show which agent did what.
