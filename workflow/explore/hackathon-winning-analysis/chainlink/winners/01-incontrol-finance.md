# InControl.finance -- 1st Place, Autonomous Agents

**Our direct competitor. This is what beat us.**

---

## Quick Facts

| Field | Detail |
|-------|--------|
| **Project** | InControl.finance |
| **Placement** | 1st Place, Autonomous Agents |
| **Creator** | Nick Zwaneveld ([Knickend](https://github.com/Knickend)), Rotterdam |
| **GitHub** | [Knickend/Chainlink_Hackaton_2026](https://github.com/Knickend/Chainlink_Hackaton_2026) |
| **Live Demo** | [incontrol.finance](https://www.incontrol.finance) |
| **Winner Page** | [chain.link/hackathon/winners/incontrol-finance](https://chain.link/hackathon/winners/incontrol-finance) |
| **Contract** | [0xB60D27f47155446783Ee52C743Af78B3996817a5](https://sepolia.etherscan.io/address/0xB60D27f47155446783Ee52C743Af78B3996817a5) (Sepolia) |
| **Stack** | TypeScript, React 19, Supabase, Chainlink CRE SDK v1.2.0, Solidity 0.8.26+ |
| **Scaffolding** | Lovable (1,181 of ~1,300 commits from lovable-dev bot) |

## About the Creator

Nick Zwaneveld is the Founder/CEO of [Coorest](https://coorest.io), a **Chainlink BUILD program member** and previous Chainlink grant recipient for carbon offset tech. Deep Chainlink ecosystem experience -- not a first-time participant.

- [Chainlink Today interview](https://chainlinktoday.com/coorest-ceo-nick-zwaneveld-illustrates-tokenized-green-assets-global-impact/)
- [LinkedIn](https://www.linkedin.com/in/nickzwaneveld/)

## What It Does

A personal finance dashboard tracking crypto, stocks, real estate, banking, and commodities. The key differentiator: it serves **both humans (polished UI) and AI agents (MCP server + x402 micropayments)** with CRE-verified data.

### Human-Facing
- Multi-asset portfolio tracking with live Chainlink price feeds
- P&L tracking, debt management, automated DCA with dip-buy detection
- AI Financial Advisor (chat + voice via Gemini 3 Flash)
- Net worth charts, portfolio history, investment strategy recommendations
- Customizable drag-to-reorder dashboard

### Agent-Facing
- **MCP Server** -- 5 tools exposed for Claude, Cursor, and custom agents
- **x402 micropayments** -- pay-per-request USDC on Base ($0.005-$0.02/call)
- **CRE-verified responses** -- multi-node consensus before serving data
- **Moltbook integration** -- registered as `incontrol-finance` agent

## CRE Usage -- 5 Distinct Workflows

This is the critical differentiator. InControl uses 5 CRE workflows, each demonstrating different capabilities.

### Workflow 1: x402-cre-verified-ts (Price Attestation)
- `HTTPClient.sendRequest()` -> `consensusIdenticalAggregation` -> `EVMClient.writeReport()`
- `runtime.getSecret()` for API keys, `runtime.runInNodeMode()` for per-node execution
- ABI-encodes `(priceHash, priceCount, timestamp)` -> PriceAttestationReceiver on Sepolia
- Cron: every 5 minutes

### Workflow 2: portfolio-summary-ts (Multi-Asset Aggregation)
- Batch fetch by asset type with market-hours awareness
- `consensusMedianAggregation` (not identical -- median across nodes)
- Portfolio snapshot attestation on-chain
- Chunk-based processing (10 symbols per chunk)

### Workflow 3: dca-trigger-ts (Automated DCA Execution)
- 5 HTTP calls per tick (CRE limit): fetch strategies, prices, last executions, execute orders
- Dip detection with configurable multiplier
- Budget tracking with auto-deactivation
- Both `consensusIdenticalAggregation` and `consensusMedianAggregation`

### Workflow 4: conf-http-ts (Confidential HTTP)
- `HTTPClient` in confidential mode -- request details private per node
- Demonstrates CRE's confidential capability

### Workflow 5: privacy-vault-ts (Address Shielding)
- `HTTPCapability` trigger (HTTP-triggered, not cron)
- Privacy Vault API integration with EIP-712 signature validation
- Actions: generate-shielded-address, private-transfer, balances, transactions, withdraw

### CRE SDK Capabilities Demonstrated
`runInNodeMode`, `consensusIdenticalAggregation`, `consensusMedianAggregation`, `EVMClient.writeReport`, `runtime.getSecret`, `runtime.report`, `getNetwork`, `CronCapability`, `HTTPCapability`, `ConfidentialHTTPClient`

## Smart Contract: PriceAttestationReceiver.sol

```solidity
contract PriceAttestationReceiver is IReceiver, Ownable {
    struct Attestation {
        uint256 priceHash;
        uint256 priceCount;
        uint256 timestamp;
        uint256 blockNumber;
    }
    Attestation public latestAttestation;
    uint256 public attestationCount;
    // Implements IReceiver for KeystoneForwarder
    // Confirmed TX: 0x18773e2a89aeef8c28c8d5e504a8a54a3ace0759a6f47ff845e2a2ab2900da3b
}
```

## MCP Server -- Agent Economy

| Tool | Description | x402 Cost |
|------|-------------|-----------|
| `get_price_feed` | Live crypto/forex/commodity prices | $0.005 |
| `get_portfolio_summary` | Aggregated market insights | $0.01 |
| `get_yield_analysis` | Yield optimization strategies | $0.02 |
| `get_debt_strategy` | Debt payoff recommendations | $0.02 |
| `get_dca_strategies` | DCA configs and execution history | $0.01 |

This is the "agentic economy" infrastructure the hackathon was looking for -- AI agents paying for CRE-verified data.

## Backend: Supabase

- PostgreSQL with Row-Level Security
- 30+ Edge Functions
- 54 database migrations
- Agent wallet via Coinbase CDP (Ed25519, EIP-1559, spending limits)
- CI/CD: GitHub Actions (Bun, TypeScript, ESLint, Vitest)

## Why It Won Over Us

| Dimension | InControl.finance (1st) | CRE Risk Router (2nd) |
|-----------|------------------------|----------------------|
| **CRE workflows** | 5 distinct workflows | 1 single pipeline |
| **CRE capabilities** | 10+ (consensus, confidential, privacy vault, secrets, HTTP trigger) | 4 (cron, compute, report, evm-write) |
| **Frontend** | Full React dashboard, charts, DCA, AI advisor | None (CLI only) |
| **Agent interface** | MCP server + x402 micropayments | HTTP bridge (no agent protocol) |
| **Live demo** | incontrol.finance accessible to judges | CLI commands only |
| **Data** | Real API data through Supabase | Mocked oracle + nil market data |
| **Ecosystem** | Moltbook agent + MCP + Coinbase CDP | Standalone |
| **Business model** | x402 pay-per-request ($0.005-$0.02) | None demonstrated |
| **Code quality** | Lovable-scaffolded, functional | Hand-written, clean, idiomatic Go |
| **Tests** | CI pipeline (Vitest) | 39 hand-written tests (Go + Solidity) |
| **Language** | TypeScript (ecosystem default) | Go (unique, but less accessible) |

## Weaknesses We Could Have Exploited

1. **1,181/1,300 commits from Lovable bot** -- heavily AI-scaffolded, not hand-written
2. **Solo project** with one human contributor
3. **Testnet only** -- no mainnet deployment
4. **0 stars, 0 forks** on GitHub
5. **Financial advisor uses Gemini 3 Flash** via Lovable gateway, not Chainlink-native
6. **Moltbook agent profile returns 404** -- integration may be superficial
7. **Contract is simpler than ours** -- just stores attestation hashes, no risk evaluation logic

---

*The lesson: breadth of CRE integration + visible demo + agent economy narrative > deep single-purpose engineering.*
