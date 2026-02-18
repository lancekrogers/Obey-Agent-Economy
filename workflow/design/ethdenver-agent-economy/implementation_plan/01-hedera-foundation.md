# Festival: hedera-foundation

## Goal

Stand up the entire Hedera layer so that the coordinator agent can publish
plans, assign tasks, monitor progress, and settle payments — all using
native Hedera services with zero Solidity.

## Scope

### Hedera Core (agent-coordinator project)
- Create and manage Hedera testnet accounts for all three agents
- Implement HCS (Consensus Service) for agent-to-agent messaging
- Implement HTS (Token Service) for task payments and settlement
- Set up Schedule Service for automated heartbeats and settlement cycles
- Festival protocol: serialize/deserialize fest task assignments over HCS

### Coordinator Logic
- Task assignment engine: read festival plan → assign tasks to agents via HCS
- Progress monitoring: listen for agent status messages on HCS
- Quality gates: enforce sequence completion before advancing
- Payment flow: trigger HTS transfers on task completion

### Daemon Client (consumer only)
- Implement the daemon gRPC client used by all agents
- This festival does NOT build the daemon itself — the daemon is a separate
  project outside this campaign. Agents are consumers of the daemon API.

## Key Deliverables

- Coordinator agent binary that starts and runs
- HCS topic creation + message publish/subscribe working end-to-end
- HTS token creation + transfer between agent accounts
- Schedule Service heartbeat running on interval
- Festival plan → HCS task assignment → result collection → HTS payment cycle
- Shared daemon client package (used by all 3 agents)

## Dependencies

- The obey daemon must be available as an external dependency (separate project)

## Projects Touched

- `agent-coordinator` (primary)

## Bounties

- Hedera Track 3 ($5k, 3 winners) — native Hedera services, no Solidity

## Estimated Complexity

3 phases: Plan → Implement (HCS/HTS/Schedule + coordinator logic) → Verify
