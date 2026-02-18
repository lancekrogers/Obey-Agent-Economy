# Festival: dashboard

## Goal

Build the observer dashboard that visualizes the entire agent economy in
real-time across all three chains. This is the primary demo surface — judges
see the dashboard to understand what the system is doing.

## Scope

### Dashboard Components (dashboard project)
- **Festival View**: Shows structured phase/sequence/task progress from fest
- **HCS Feed**: Live stream of agent-to-agent messages on Hedera
- **Agent Activity**: Status of all three agents (coordinator, inference, defi)
- **DeFi P&L**: Base trading performance — revenue vs costs
- **Inference Metrics**: 0G compute utilization, storage usage, iNFT status

### Data Sources
- Daemon events via hub WebSocket (production path)
- Direct daemon gRPC (dev mode)
- Hedera mirror node REST API for HCS/HTS history
- Read-only — the dashboard observes, never acts

### UI/UX
- Single-page layout with all panels visible simultaneously
- Real-time updates (WebSocket-driven)
- Clean enough for a 2-minute demo walkthrough

## Key Deliverables

- Running Next.js app showing all 5 panels with live data
- Connects to daemon hub WebSocket for real-time events
- Falls back to Hedera mirror node for historical data
- Deployable for demo day

## Dependencies

- Festival 2 (chain-agents): needs live agent data to display
- Festival 1 (hedera-foundation): needs HCS/HTS data flowing

## Projects Touched

- `dashboard` (primary)

## Bounties

- Not a direct bounty target but required for demo across all tracks

## Estimated Complexity

3 phases: Plan (component design) → Implement (5 panels + data layer) → Polish for demo
