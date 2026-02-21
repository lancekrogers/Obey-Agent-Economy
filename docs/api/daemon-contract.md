# Obey Daemon Interface Contract

> **Status:** Scaffolded but **not called at runtime**. All agent coordination currently runs over HCS (Hedera Consensus Service). This document records what the agents expect so the obey daemon can be updated to match.

## Architecture Overview

The system has two coordination layers:

1. **HCS (active)** — Agents coordinate peer-to-peer over Hedera Consensus Service. The coordinator publishes `task_assignment` messages to an HCS topic, worker agents subscribe, execute, and publish `task_result` back. Payments settle via HTS tokens. This is the live agentic economy.

2. **gRPC / obey daemon (scaffolded, unused)** — A `DaemonService` proto exists in `agent-coordinator/proto/daemon.proto` with Register, Execute, and Heartbeat RPCs. Client code exists but is never invoked at runtime. Worker agents have stub-only daemon clients.

## gRPC Service Definition

**Proto source:** `projects/agent-coordinator/proto/daemon.proto`
**Go package:** `github.com/lancekrogers/agent-coordinator-ethden-2026/pkg/daemon/pb`
**Generated with:** protoc-gen-go v1.36.11, protoc-gen-go-grpc v1.5.1

```proto
syntax = "proto3";
package daemon;

service DaemonService {
  rpc Register(RegisterReq) returns (RegisterResp);
  rpc Execute(ExecuteReq) returns (ExecuteResp);
  rpc Heartbeat(HeartbeatReq) returns (HeartbeatResp);
}
```

All three RPCs are **unary** (no streaming).

### Full gRPC Method Paths

```
/daemon.DaemonService/Register
/daemon.DaemonService/Execute
/daemon.DaemonService/Heartbeat
```

## RPC Details

### Register

Agent registers itself with the daemon on startup.

**Request:**

| Field | Type | Description |
|-------|------|-------------|
| `agent_name` | string | Human-readable name (e.g., "coordinator") |
| `agent_type` | string | Agent role (e.g., "coordinator", "inference", "defi") |
| `capabilities` | repeated string | List of capabilities the agent offers |
| `hedera_account_id` | string | Agent's Hedera testnet account ID |

**Response:**

| Field | Type | Description |
|-------|------|-------------|
| `agent_id` | string | Unique identifier assigned by the daemon |
| `session_id` | string | Session identifier for heartbeat correlation |
| `registered_at_unix` | int64 | Registration timestamp (Unix seconds) |

### Execute

Agent sends a task for the daemon to route/execute.

**Request:**

| Field | Type | Description |
|-------|------|-------------|
| `task_id` | string | Unique task identifier |
| `task_type` | string | Type of task to execute |
| `payload` | bytes | JSON-encoded task payload |
| `timeout_ms` | int64 | Maximum execution time in milliseconds |

**Response:**

| Field | Type | Description |
|-------|------|-------------|
| `task_id` | string | Echoed task identifier |
| `status` | string | Execution result status |
| `result` | bytes | JSON-encoded result payload |
| `duration_ms` | int64 | Actual execution duration |

### Heartbeat

Agent sends periodic liveness signal.

**Request:**

| Field | Type | Description |
|-------|------|-------------|
| `agent_id` | string | Agent's assigned ID (from Register response) |
| `session_id` | string | Session ID (from Register response) |
| `timestamp_unix` | int64 | Current timestamp (Unix seconds) |

**Response:** Empty message.

## Connection Configuration

The coordinator's `pkg/daemon/config.go` defines the client configuration:

```go
type Config struct {
    Address     string        // default: "localhost:50051"
    DialTimeout time.Duration // default: 10s
    CallTimeout time.Duration // default: 30s
    TLSEnabled  bool          // default: false
    TLSCertPath string        // required if TLSEnabled
}
```

**Per-call timeout behavior:**
- `Register` and `Heartbeat` use `CallTimeout` (30s default)
- `Execute` uses `req.Timeout` if nonzero, otherwise `CallTimeout`

### Port Convention (inconsistent — needs reconciliation)

| Agent | Default Port | Env Var |
|-------|-------------|---------|
| coordinator (`pkg/daemon`) | `50051` | hardcoded in `DefaultConfig()` |
| agent-defi | `9090` | `DEFI_DAEMON_ADDR` |
| agent-inference | `9090` | `INFERENCE_DAEMON_ADDR` |

If the daemon integration is activated, these need to agree on a single port.

## Current Implementation Status Per Agent

### agent-coordinator

- **Proto + generated code:** Full implementation in `pkg/daemon/pb/`
- **Go client:** `pkg/daemon/grpc.go` — fully implemented `GRPCClient` struct with `Register`, `Execute`, `Heartbeat`, `Close`
- **Go interface:** `pkg/daemon/client.go` — `DaemonClient` interface with all 3 RPCs + `io.Closer`
- **Runtime usage:** None. `cmd/coordinator/main.go` does not import or instantiate the daemon client. `internal/daemon/client.go` is an empty package.

### agent-defi

- **Client:** `internal/daemon/client.go` — stub struct that stores endpoint string only
- **Methods:** `New(endpoint)`, `Endpoint()` — no RPC calls
- **Runtime usage:** `cfg.DaemonAddr` is loaded from env but daemon client is never constructed in `main.go`

### agent-inference

- **Client:** `internal/daemon/client.go` — stub struct that stores endpoint string only
- **Methods:** `New(endpoint)` — no RPC calls, no `Endpoint()` method
- **Runtime usage:** `cfg.DaemonAddr` is loaded from env but daemon client is never constructed in `main.go`

## HCS Protocol (Active Runtime Coordination)

This is the live coordination channel that powers the agentic economy.

### Wire Format

All agents serialize JSON `Envelope` structs to HCS topics:

```go
type Envelope struct {
    Type        string          `json:"type"`
    Sender      string          `json:"sender"`
    Recipient   string          `json:"recipient,omitempty"`
    TaskID      string          `json:"task_id,omitempty"`
    SequenceNum uint64          `json:"sequence_num"`
    Timestamp   time.Time       `json:"timestamp"`
    Payload     json.RawMessage `json:"payload,omitempty"`
}
```

Recipient filtering: agents skip envelopes where `Recipient != "" && Recipient != myAgentID`.

### Message Types

| Type | Publisher | Subscriber | Description |
|------|-----------|------------|-------------|
| `task_assignment` | coordinator | defi, inference | Coordinator assigns work to a specific agent |
| `status_update` | defi, inference | coordinator | Agent reports status change |
| `task_result` | defi, inference | coordinator | Agent returns completed task output |
| `heartbeat` | defi, inference | coordinator | Periodic liveness signal |
| `quality_gate` | coordinator | — | Quality validation checkpoint |
| `payment_settled` | coordinator | — | HTS payment confirmation |
| `pnl_report` | defi | coordinator | DeFi agent P&L summary |
| `strategy_update` | defi | — | DeFi strategy change notification |

### HCS Topic Configuration

All three agents must point to the **same two underlying Hedera topics**, but each uses different env var names:

| Agent | Task Topic Env Var | Result/Status Topic Env Var |
|-------|-------------------|----------------------------|
| coordinator | `HCS_TASK_TOPIC_ID` | `HCS_STATUS_TOPIC_ID` |
| inference | `HCS_TASK_TOPIC` | `HCS_RESULT_TOPIC` |
| defi | `HCS_TASK_TOPIC` (via `DEFI_HCS_TASK_TOPIC` in compose) | `HCS_RESULT_TOPIC` (via `DEFI_HCS_RESULT_TOPIC` in compose) |

**These must all resolve to the same two Hedera topic IDs** (e.g., `0.0.12345` for tasks, `0.0.12346` for results/status).

### Task Assignment Payload

Coordinator publishes:

```json
{
  "task_id": "string",
  "task_name": "string",
  "task_type": "string",
  "agent_id": "string",
  "model_id": "string",
  "input": "string",
  "priority": 0,
  "max_tokens": 0,
  "dependencies": ["string"]
}
```

- `task_type`, `model_id`, `input`, `max_tokens` are used by inference agent
- `task_type` is used by defi agent (values: `"execute_trade"`, `"update_strategy"`)

### Task Result Payloads

**From defi:**
```json
{
  "task_id": "string",
  "status": "completed|failed",
  "tx_hash": "string",
  "error": "string",
  "duration_ms": 0
}
```

**From inference:**
```json
{
  "task_id": "string",
  "status": "completed|failed",
  "output": "string",
  "duration_ms": 0,
  "tokens_used": 0,
  "storage_content_id": "string",
  "inft_token_id": "string",
  "audit_submission_id": "string",
  "error": "string"
}
```

### Heartbeat Payloads

**From defi (every 30s default):**
```json
{
  "agent_id": "string",
  "status": "idle|trading|error",
  "active_strategy": "string",
  "current_pnl": 0.0,
  "uptime_seconds": 0,
  "trade_count": 0
}
```

**From inference (every 30s default):**
```json
{
  "agent_id": "string",
  "status": "string",
  "active_task_id": "string",
  "uptime_seconds": 0,
  "completed_tasks": 0,
  "failed_tasks": 0
}
```

### PnL Report (defi only, every 5m default)

```json
{
  "agent_id": "string",
  "total_revenue": 0.0,
  "total_gas_costs": 0.0,
  "total_fees": 0.0,
  "net_pnl": 0.0,
  "trade_count": 0,
  "win_rate": 0.0,
  "is_self_sustaining": false,
  "period_start": "2026-01-01T00:00:00Z",
  "period_end": "2026-01-01T00:00:00Z",
  "active_strategy": "string"
}
```

### HCS Transport Interface

Worker agents implement:
```go
type Transport interface {
    Publish(ctx context.Context, topicID string, data []byte) error
    Subscribe(ctx context.Context, topicID string) (<-chan []byte, <-chan error)
}
```

Coordinator uses typed wrappers with `hiero.TopicID`:
```go
type MessagePublisher interface {
    Publish(ctx context.Context, topicID hiero.TopicID, msg Envelope) error
}
type MessageSubscriber interface {
    Subscribe(ctx context.Context, topicID hiero.TopicID) (<-chan Envelope, <-chan error)
}
```

### Agent Identity

- **coordinator:** Hardcodes agent IDs `"inference-001"` and `"defi-001"` in `main.go`
- **defi:** Registers on-chain via ERC-8004 identity contract on Base Sepolia at startup
- **inference:** No explicit registration; begins subscribing to HCS immediately

### Payment Flow

1. Worker agent publishes `task_result` with `status: "completed"`
2. Coordinator's `ResultHandler` receives it, looks up agent's Hedera account ID
3. Coordinator calls `Payment.ProcessResult()` which transfers HTS tokens via `TransferService`
4. Coordinator publishes `payment_settled` envelope to confirm
