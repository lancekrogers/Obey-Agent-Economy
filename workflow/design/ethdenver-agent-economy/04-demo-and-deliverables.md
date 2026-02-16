# Demo Day Plan & Deliverables

## Demo Day Script (2 minutes — Feb 21 @ 2 PM)

### [0:00 - 0:15] The Hook

*Dashboard is already running on screen. Three agents visible, all active.*

"Right now, three AI agents are operating across three blockchains. Autonomously. One is running inference on 0G. One is executing DeFi strategies on Base. And one is coordinating everything through Hedera. No human in the loop."

### [0:15 - 0:45] The Live Demo

Point to the dashboard panels:

**HCS Feed panel**: "Every message you see here is agent-to-agent communication, published to Hedera Consensus Service. Immutable. Timestamped. Ordered."

**Festival Progress panel**: "The agents are working through a structured plan — phases, sequences, tasks. This isn't random behavior. It's orchestrated execution."

**Base P&L panel**: "Our DeFi agent on Base has made $X in the last hour. It pays for its own compute via x402. Every transaction is attributed on-chain via ERC-8021. It's self-sustaining."

**0G Metrics panel**: "Inference is running on 0G's decentralized compute network. The agent's intelligence is tokenized as an ERC-7857 iNFT — buy the NFT, get the agent."

### [0:45 - 1:15] The Infrastructure

"What you're seeing isn't held together with API calls and cron jobs. The orchestrator is our obey daemon — a hierarchical agent management engine. It spawns these agents, assigns them tasks, monitors their health, and enforces quality gates between phases."

*Flash the festival plan on screen.*

"The task structure these agents follow is called the Festival Methodology. Phases. Sequences. Tasks. Quality gates. We designed it for human-AI collaboration. Turns out, it works just as well for agent-to-agent collaboration."

### [1:15 - 1:40] The Meta Reveal

"Here's the part I'm most proud of: we built this entire project using the same tools the agents use."

*Flash camp campaign structure.*

"Our camp CLI organized five codebases across three blockchains. Our fest CLI planned every phase of this five-day build. Our daemon orchestrates the agents you see running."

"We didn't build these tools for the hackathon. We brought the tools we already use. And they worked."

### [1:40 - 2:00] The Close

"Three agents. Three chains. One orchestrator. This is what Obedience Corp builds: infrastructure for autonomous AI systems."

"The agents run on Hedera, 0G, and Base. The orchestration runs on Obedience Corp. Everything is open source."

*Show URL on screen.*

---

## Submission Deliverables

### Required for ALL Submissions

| Deliverable | Status | Notes |
|-------------|--------|-------|
| Public GitHub repository | | Monorepo with camp structure |
| Live demo URL | | Dashboard hosted (Vercel or similar) |
| Video walkthrough (< 3 min) | | Record Demo Day performance |
| README with setup instructions | | Per-project + root README |

### Hedera Track 3 (No Solidity) Submission

| Deliverable | Description |
|-------------|-------------|
| **Testnet app** | Coordinator Agent managing festivals on HCS, payments on HTS |
| **Native SDK usage** | HCS + HTS + Schedule Service + Accounts (4 services) |
| **Security model doc** | Per-agent accounts, key handling, multi-sig |
| **Zero Solidity proof** | No .sol files in the Track 3 submission path |

### Hedera Track 4 (Hiero CLI Plugin) Submission

| Deliverable | Description |
|-------------|-------------|
| **PR to hiero-cli repo** | Following PLUGIN_ARCHITECTURE_GUIDE.md |
| **Plugin code** | Node.js wrapper around camp |
| **Demo video** | Showing `hiero camp init`, `hiero camp status` |
| **Usage documentation** | README in the PR |

### 0G Track 2 (Inference) Submission

| Deliverable | Description |
|-------------|-------------|
| **Working inference pipeline** | Tasks → 0G Compute → results |
| **0G layer integration** | Compute + Storage + Chain + DA |
| **Composability demo** | Integration with Hedera coordination |

### 0G Track 3 (iNFT) Submission

| Deliverable | Description |
|-------------|-------------|
| **ERC-7857 contract** | Deployed on 0G Chain |
| **Dynamic metadata** | Agent intelligence updates as it learns |
| **TEE transfer demo** | Show encrypted metadata handling |

### Base (Self-Sustaining Agent) Submission

| Deliverable | Description |
|-------------|-------------|
| **Mainnet agent** | Running on Base mainnet (real transactions) |
| **ERC-8004 registration** | Identity + Reputation + Validation |
| **x402 payment flows** | Agent paying for compute via HTTP 402 |
| **ERC-8021 attribution** | Builder code on every transaction |
| **Performance dashboard** | Real-time P&L, trade history |

---

## Dashboard Design

### Layout

```
┌───────────────────────────────────────────────────────┐
│  OBEY AGENT ECONOMY          [Live] [Testnet] [Base]  │
├───────────┬───────────────────────────────────────────┤
│           │                                           │
│  FESTIVAL │         MAIN VIEW                         │
│  PROGRESS │                                           │
│           │  ┌─────────┐ ┌─────────┐ ┌─────────┐     │
│  Phase 1  │  │Coord    │ │Inference│ │DeFi     │     │
│  ██████── │  │Agent    │ │Agent    │ │Agent    │     │
│           │  │         │ │         │ │         │     │
│  Phase 2  │  │Hedera   │ │0G       │ │Base     │     │
│  ████──── │  │HCS: 47  │ │Jobs: 12 │ │P&L: +$X │     │
│           │  │HTS: $23 │ │Storage: │ │Trades:  │     │
│  Phase 3  │  │         │ │ 840MB   │ │  34     │     │
│  ──────── │  └─────────┘ └─────────┘ └─────────┘     │
│           │                                           │
├───────────┴───────────────────────────────────────────┤
│  HCS MESSAGE FEED                                     │
│  ┌─────────────────────────────────────────────────┐  │
│  │ 14:23:01 coordinator → inference: task_assign   │  │
│  │ 14:23:04 inference → coordinator: task_accept   │  │
│  │ 14:23:31 inference → coordinator: task_complete │  │
│  │ 14:23:32 coordinator → defi: task_assign        │  │
│  │ 14:23:33 coordinator: gate_check phase=1 PASS   │  │
│  └─────────────────────────────────────────────────┘  │
├───────────────────────────────────────────────────────┤
│  HTS PAYMENTS              │  BASE P&L               │
│  coord → inference: 5 AGT  │  Revenue:  $47.23       │
│  coord → defi: 3 AGT       │  Costs:    $18.91       │
│  Total settled: 142 AGT    │  Net:      +$28.32      │
└───────────────────────────────────────────────────────┘
```

### Key Dashboard Properties

- **Read-only**: Dashboard observes, never acts
- **Real-time**: WebSocket subscriptions to HCS mirror node + daemon status API
- **Multi-chain**: Single view across Hedera, 0G, and Base
- **Festival-native**: Progress visualization mirrors fest status output

---

## Risk Mitigation

### Demo Risks

| Risk | Mitigation |
|------|-----------|
| Agent crashes during demo | Daemon auto-restarts agents; also have pre-recorded fallback video |
| Hedera testnet slow/down | Cache recent HCS messages locally; dashboard works with stale data |
| Base mainnet trade fails | Agent has multiple strategy options; fallback to most conservative |
| 0G Compute unavailable | Local inference fallback; show 0G integration via recorded demo |
| Dashboard fails to load | Static backup deployed separately |

### Build Risks

| Risk | Mitigation |
|------|-----------|
| obey daemon not ready | Coordinator can run as a standalone process with daemon API contract |
| Too many bounties, spread thin | Priority system (P0 > P1 > P2); cut P2 if behind |
| Hedera SDK issues | Testnet is well-documented; Hedera DevDay (Feb 17) for support |
| 0G integration complexity | Start with Compute only, add Storage/Chain/DA incrementally |
| Base mainnet real money | Start with tiny amounts; Agentic Wallet has spend limits |

### Fallback Plan

If the daemon isn't ready for live orchestration:

1. Coordinator runs as a standalone Node.js/Go process (same API surface)
2. It still publishes to HCS, manages HTS, uses Schedule Service
3. The ARCHITECTURE is the same — only the runtime changes
4. This still satisfies all bounty requirements
5. We demonstrate the daemon's design and roadmap, even if the live version is simplified

The daemon's value isn't in the runtime — it's in the hierarchical execution model and festival-structured planning. Those concepts work regardless of whether the daemon binary or a standalone process runs the coordinator.
