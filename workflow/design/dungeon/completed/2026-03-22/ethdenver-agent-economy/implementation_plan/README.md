# Implementation Plan — Festival Index

This directory contains 1-page summaries for each festival needed to build
the ETHDenver agent economy. Each file describes the festival's goal, scope,
key deliverables, and dependencies — enough to create the actual festival
structure via `fest create festival`.

The festivals themselves (with full phases, sequences, and tasks) will live
in `festivals/` at the campaign root.

## Festival Overview

| # | Festival Name | Scope | Bounties Covered |
|---|--------------|-------|------------------|
| 1 | hedera-foundation | Hedera primitives + coordinator logic | Hedera Track 3 |
| 2 | chain-agents | 0G inference agent + Base DeFi agent | 0G Tracks 2&3, Base |
| 3 | hiero-plugin | Hiero CLI plugin for camp | Hedera Track 4 |
| 4 | dashboard | Observer dashboard across all chains | Demo requirement |
| 5 | submission-and-polish | Testing, docs, video, deployment | All tracks |

## Dependency Graph

```
1. hedera-foundation ──┐
                       ├──→ 2. chain-agents ──→ 4. dashboard ──→ 5. submission-and-polish
3. hiero-plugin (parallel) ─────────────────────────────────────┘
```

Festivals 1 and 3 can start simultaneously. Festival 2 depends on 1.
Festival 4 depends on 2 (needs live agent data). Festival 5 is the final pass.

## Daemon: External Dependency

The obey daemon is **not a festival in this campaign** — it's a separate
project in its own campaign. However, the agents in this campaign are
consumers of the daemon API. See `00-daemon-requirements.md` for what
the daemon needs to support, which can be used to create a festival in
the daemon's campaign.

## Optional Add-On

The `contracts` project (Solidity settlement, Hedera Track 2) is P2/optional.
If time permits, it becomes a sequence within festival 5 or a standalone mini-festival.

## Files

| File | Description |
|------|-------------|
| `00-daemon-requirements.md` | What agents need from the daemon (for daemon's own campaign) |
| `01-hedera-foundation.md` | Festival 1: Hedera core + coordinator |
| `02-chain-agents.md` | Festival 2: 0G inference + Base DeFi agents |
| `03-hiero-plugin.md` | Festival 3: Hiero CLI plugin |
| `04-dashboard.md` | Festival 4: Observer dashboard |
| `05-submission-and-polish.md` | Festival 5: Testing, docs, submission |
