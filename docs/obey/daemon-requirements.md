# Obey Daemon Requirements

The obey daemon (`obeyd`) is the runtime bridge between the Go agents and the dashboard. It exposes a gRPC server for agents and a WebSocket server for the dashboard, translating agent lifecycle events into real-time UI updates.

This document specifies the contracts the daemon must fulfill for the full system to operate.

## gRPC Server (Agent-Facing)

The daemon implements the `DaemonService` defined in `projects/agent-coordinator/proto/daemon.proto`:

```protobuf
service DaemonService {
  rpc Register(RegisterReq) returns (RegisterResp);
  rpc Execute(ExecuteReq) returns (ExecuteResp);
  rpc Heartbeat(HeartbeatReq) returns (HeartbeatResp);
}
```

### Register

Called once when an agent starts. Returns a session ID that must be included in all subsequent calls.

| Field | Type | Description |
|-------|------|-------------|
| `agent_name` | string | Human-readable name (e.g., `coordinator`, `inference`, `defi`) |
| `agent_type` | string | Agent category (`coordinator`, `inference`, `defi`) |
| `capabilities` | repeated string | What this agent can do (e.g., `hcs_messaging`, `gpu_inference`, `uniswap_swap`) |
| `hedera_account_id` | string | The agent's Hedera testnet account (e.g., `0.0.12345`) |

**Response**: `agent_id` (UUID), `session_id` (UUID), `registered_at_unix` (epoch seconds).

### Execute

Called when the daemon dispatches a task to an agent, or when an agent reports a task result.

| Field | Type | Description |
|-------|------|-------------|
| `task_id` | string | Unique task identifier |
| `task_type` | string | One of: `inference_job`, `defi_trade`, `hcs_publish`, `quality_gate` |
| `payload` | bytes | JSON-encoded task-specific parameters |
| `timeout_ms` | int64 | Maximum execution time before the daemon marks the task as failed |

**Response**: `task_id`, `status` (one of `accepted`, `completed`, `failed`), `result` (JSON bytes), `duration_ms`.

### Heartbeat

Called every 30 seconds by each agent to maintain session liveness.

| Field | Type | Description |
|-------|------|-------------|
| `agent_id` | string | The agent's UUID from Register |
| `session_id` | string | The session UUID from Register |
| `timestamp_unix` | int64 | Current time (epoch seconds) |

**Response**: Empty acknowledgment. If no heartbeat is received within 90 seconds, the daemon marks the agent as `stopped` and broadcasts an `agent_stopped` event.

## WebSocket Server (Dashboard-Facing)

### Endpoint

```
ws://<host>:<port>/ws
```

The dashboard connects on startup and receives a stream of `DaemonEvent` JSON objects. No authentication is required in the ETHDenver demo; the endpoint is read-only.

### DaemonEvent Schema

Every message on the WebSocket is a JSON object matching `DaemonEvent` from `projects/dashboard/src/lib/data/types.ts`:

```json
{
  "type": "<DaemonEventType>",
  "agentId": "uuid-string",
  "agentName": "coordinator | inference | defi",
  "timestamp": "2026-02-23T12:00:00.000Z",
  "payload": { ... }
}
```

### Event Types

| Type | Trigger | Description |
|------|---------|-------------|
| `agent_started` | Agent calls Register | New agent session began |
| `agent_stopped` | Heartbeat timeout (90s) | Agent is no longer responsive |
| `agent_error` | Agent reports an error | Error details in payload |
| `heartbeat` | Agent calls Heartbeat | Periodic liveness signal with metrics |
| `task_assignment` | Daemon dispatches a task | Task details in payload |
| `status_update` | Agent reports progress | Intermediate status change |
| `task_result` | Agent completes a task | Result data in payload |
| `quality_gate` | Coordinator evaluates a gate | Pass/fail with gate name |
| `payment_settled` | Coordinator transfers tokens | HTS transfer details |

## Payload Contracts for Dashboard Panels

The dashboard's `useLiveData.ts` hook processes incoming events and extracts structured data based on event type and agent identity. The daemon must emit payloads that match these shapes.

### Agent Activity Panel

Populated from `heartbeat` events. The `ws.agents` array is maintained by `useWebSocket`, which tracks agent state from `agent_started`, `heartbeat`, and `agent_stopped` events.

```json
{
  "type": "heartbeat",
  "agentId": "uuid",
  "agentName": "coordinator",
  "timestamp": "...",
  "payload": {
    "status": "running",
    "currentTask": "task-uuid or null",
    "uptimeSeconds": 3600,
    "errorCount": 0,
    "lastError": null
  }
}
```

Fields map to `AgentInfo`:

| Payload Field | Type | Description |
|---------------|------|-------------|
| `status` | `"running" \| "idle" \| "error" \| "stopped"` | Current agent state |
| `currentTask` | `string \| null` | Active task ID |
| `uptimeSeconds` | number | Seconds since Register |
| `errorCount` | number | Cumulative error count |
| `lastError` | `string \| null` | Most recent error message |

### DeFi P&L Panel

Populated from `task_result` events where `payload.txHash` or `payload.pair` is present. Sent by the DeFi agent after each trade execution.

```json
{
  "type": "task_result",
  "agentId": "defi-uuid",
  "agentName": "defi",
  "timestamp": "...",
  "payload": {
    "tradeId": "trade-001",
    "pair": "ETH/USDC",
    "side": "buy",
    "amount": 0.5,
    "price": 3200.50,
    "pnl": 12.30,
    "gasCost": 0.002,
    "txHash": "0xabc..."
  }
}
```

Fields map to `Trade`:

| Payload Field | Type | Description |
|---------------|------|-------------|
| `tradeId` | string | Unique trade identifier |
| `pair` | string | Trading pair (e.g., `ETH/USDC`) |
| `side` | `"buy" \| "sell"` | Trade direction |
| `amount` | number | Trade size |
| `price` | number | Execution price |
| `pnl` | number | Realized P&L for this trade |
| `gasCost` | number | Gas cost in ETH |
| `txHash` | string | Base Sepolia transaction hash |

The hook accumulates trades and computes a running `PnLSummary` (totalRevenue, totalCosts, netProfit, tradeCount, winRate) and `PnLDataPoint[]` chart series.

### Inference Metrics Panel

Populated from `heartbeat` events where the agent name contains `"inference"` and `payload.gpuUtilization` is present.

```json
{
  "type": "heartbeat",
  "agentId": "inference-uuid",
  "agentName": "inference",
  "timestamp": "...",
  "payload": {
    "gpuUtilization": 78.5,
    "memoryUtilization": 62.0,
    "activeJobs": 3,
    "avgLatencyMs": 450,
    "totalInferences": 1247,
    "storage": {
      "totalStorageGb": 100,
      "usedStorageGb": 34.2,
      "objectCount": 1247
    },
    "inft": {
      "tokenId": "0x...",
      "status": "active",
      "modelName": "llama-3.2-70b",
      "inferenceCount": 1247,
      "lastActive": "2026-02-23T12:00:00.000Z"
    }
  }
}
```

Top-level fields map to `ComputeMetrics`:

| Payload Field | Type | Description |
|---------------|------|-------------|
| `gpuUtilization` | number | GPU usage percentage (0-100) |
| `memoryUtilization` | number | GPU memory usage percentage |
| `activeJobs` | number | Currently running inference jobs |
| `avgLatencyMs` | number | Average job latency in milliseconds |
| `totalInferences` | number | Lifetime inference count |

Nested `storage` maps to `StorageMetrics`:

| Field | Type | Description |
|-------|------|-------------|
| `totalStorageGb` | number | Total 0G storage capacity |
| `usedStorageGb` | number | Storage consumed |
| `objectCount` | number | Number of stored objects |

Nested `inft` maps to `INFTStatus`:

| Field | Type | Description |
|-------|------|-------------|
| `tokenId` | string | ERC-7857 iNFT token ID |
| `status` | `"active" \| "minting" \| "inactive"` | Current iNFT state |
| `modelName` | string | Model powering the agent |
| `inferenceCount` | number | Inferences performed by this iNFT |
| `lastActive` | string | ISO timestamp of last inference |

### Inference Jobs Panel

Populated from `task_result` events where `payload.jobId` or `payload.model` is present. Sent by the inference agent after each job completes.

```json
{
  "type": "task_result",
  "agentId": "inference-uuid",
  "agentName": "inference",
  "timestamp": "...",
  "payload": {
    "jobId": "job-001",
    "model": "llama-3.2-70b",
    "status": "completed",
    "inputTokens": 512,
    "outputTokens": 256,
    "latencyMs": 380
  }
}
```

Fields map to `InferenceJob`:

| Payload Field | Type | Description |
|---------------|------|-------------|
| `jobId` | string | Unique job identifier |
| `model` | string | Model used for inference |
| `status` | `"pending" \| "running" \| "completed" \| "failed"` | Job status |
| `inputTokens` | number | Input token count |
| `outputTokens` | number | Output token count |
| `latencyMs` | number | End-to-end latency |

### Payment Settled Events

Populated from `payment_settled` events. Generated when the coordinator transfers AGT tokens to an agent.

```json
{
  "type": "payment_settled",
  "agentId": "coordinator-uuid",
  "agentName": "coordinator",
  "timestamp": "...",
  "payload": {
    "paymentId": "pay-001",
    "amount": 100,
    "fee": 0.001,
    "txHash": "0xdef..."
  }
}
```

These are appended to the trades list as `side: "sell"`, `pair: "HBAR/USD"`.

## Session Lifecycle

```
1. Agent starts → calls Register → receives (agentId, sessionId)
2. Daemon broadcasts agent_started event to WebSocket
3. Agent sends Heartbeat every 30s → daemon updates lastHeartbeat
4. Daemon forwards heartbeat events (with metrics payload) to WebSocket
5. Daemon dispatches tasks via Execute → broadcasts task_assignment
6. Agent completes task → calls Execute with result → daemon broadcasts task_result
7. If no heartbeat for 90s → daemon broadcasts agent_stopped
8. Dashboard connects to ws://<host>:<port>/ws → receives all events from all agents
```

## Event Flow

```
Agents ──gRPC──► Daemon ──WebSocket──► Dashboard
                   │
                   ├── Register/Heartbeat/Execute (agent lifecycle)
                   ├── Event persistence (optional, for replay)
                   └── Broadcast to all connected WebSocket clients
```

## What Works Without the Daemon

The dashboard supports three data source tiers (see `useLiveData.ts`):

1. **Mock data** (`just demo`): All panels render with simulated data. No daemon, no env vars.
2. **Mirror Node** (`just live`): Festival View and HCS Feed panels pull directly from the Hedera Mirror Node REST API. Real on-chain data, no daemon needed.
3. **WebSocket** (requires daemon): Agent Activity, DeFi P&L, and Inference Metrics panels need the daemon's WebSocket feed to display live data.

The agents themselves communicate over HCS and execute real transactions on their respective chains — they do not require the daemon to function. The daemon's role is to aggregate their events into a single stream for the dashboard.
