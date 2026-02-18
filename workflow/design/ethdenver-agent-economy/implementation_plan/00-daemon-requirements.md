# Daemon Requirements (External — Not a Festival in This Campaign)

## Purpose

The obey daemon is a separate project in its own campaign. This document
captures what the ETHDenver agent economy **needs from the daemon** so that
those requirements can be turned into a festival in the daemon's campaign.

## What the Agents Need

### Execute RPC
- Agents (especially the coordinator) need to run `fest` commands within
  the campaign sandbox via the daemon's Execute RPC
- The coordinator reads festival plans, checks sequence status, and
  advances tasks — all through fest CLI invocations

### Agent Lifecycle Management
- Daemon starts/stops/monitors all three agent processes
- Health check endpoint: agents report heartbeat, daemon detects failures
- Graceful shutdown and restart on failure

### Hub WebSocket (for Dashboard)
- Dashboard connects to the daemon's hub WebSocket to receive real-time events
- Events needed: agent status changes, task assignments, task completions,
  HCS messages relayed, HTS payment notifications
- Production path: `wss://api.obey.app/v1/events`

### gRPC Client Library
- Shared Go client package that all three agents import
- Connects to daemon socket (`$OBEY_DAEMON_SOCKET`)
- Methods: Register, Heartbeat, Execute, StreamEvents

### Campaign Awareness
- Daemon must know the campaign root to resolve `festivals/` paths
- `fest` commands need campaign context to find the right festival

## What Already Exists vs What's Needed

| Capability | Status | Notes |
|------------|--------|-------|
| Execute RPC | ? | Need to verify current daemon API |
| Agent lifecycle | ? | May need agent registration flow |
| Hub WebSocket | ? | Events schema needed for dashboard |
| gRPC client lib | ? | Shared package for Go agents |
| Campaign awareness | ? | Daemon may already handle this |

## Action

Use this document as input when creating the daemon festival in the
daemon's own campaign. The `?` statuses need to be filled in by reviewing
what the daemon currently supports.
