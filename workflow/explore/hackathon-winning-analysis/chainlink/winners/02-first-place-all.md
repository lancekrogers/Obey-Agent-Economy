# All 1st Place Winners -- Chainlink Convergence Hackathon 2026

Cross-category analysis of what 1st place looks like.

---

## SentinelCRE (1st, CRE & AI)

**GitHub:** [ProjectWaja/SentinelCRE](https://github.com/ProjectWaja/SentinelCRE)
**Creator:** Willis Tang (solo)
**Live:** [dashboard-dun-alpha-96.vercel.app](https://dashboard-dun-alpha-96.vercel.app)
**Demo:** [youtu.be/YAdYsDABZ78](https://youtu.be/YAdYsDABZ78)

3-layer risk monitoring: compliance pre-check (on-chain policy), behavioral scoring (7 dimensions, 0-155 range), dual-AI consensus (Claude + GPT-4 in TEE via `ConfidentialHTTPClient`). Uses **8 CRE primitives** -- the deepest CRE integration of any submission. 90 Foundry tests. 14 attack scenario demos referencing real exploits ($3.4B+ stolen: Ronin, Wormhole, Bybit). Next.js dashboard with live Tenderly transaction feed.

**Why it won:** Most technically deep submission. 8 CRE primitives, 3 trigger types (HTTP + Cron + Log), 90 tests, polished presentation with live attack demos.

---

## FlowVault (1st, DeFi & Tokenization)

**GitHub:** [AreeGuptaji/FlowVault](https://github.com/AreeGuptaji/FlowVault)
**Creator:** Aman Gupta (solo)

Autonomous capital allocation ERC-4626 vault targeting 18-28% uncorrelated APY. **5 parallel CRE workflows** running every 30s: cross-chain stablecoin spread, perpetual funding rate arb, bridge flow front-running (Stargate >$500K transfers), liquidation + RWA yield (Aave health factors + Ondo OUSG), orchestrator (reads all scores, applies 4 risk gates, executes best). Multi-chain EVM reads (Arbitrum, Base, Ethereum).

**Why it won:** Predictive (not reactive) vault design. 5 parallel CRE workflows with event-driven triggers. Multi-chain. The "airport analogy" README was effective.

---

## TAPL (1st, Prediction Markets)

**GitHub:** [tapl-chainlink](https://github.com/tapl-chainlink) (org: smart-contracts-cre, backend, frontend)
**Team:** "Sniper Man" + 1 contributor

Tap-to-predict trading for BTC/USDT with 5-second windows and $20 grid bands. **5 CRE workflows:** Price Integrity (15m), Settlement (merkle roots), Pool Solvency PoR (daily), LP Distribution (daily), Strategy Rebalance (HTTP trigger). Production-grade backend: NestJS, Kafka, PostgreSQL, Redis, worker processes. 6 smart contracts including `PriceIntegrity.sol`, `Settlement.sol`, `PoolReserve.sol`.

**Why it won:** Most production-ready backend infrastructure. 5 CRE workflows with verifiable settlement. Multi-repo org structure.

---

## SSL -- Stealth Settlement Layer (1st, Privacy)

**GitHub:** [furqaannabi/ssl](https://github.com/furqaannabi/ssl)
**Team:** Furqaan Nabi, Chukwunonso Ikeji (2 devs)

Institutional dark pool for tokenized RWAs (equities, ETFs, fixed income). ECIES-encrypted orders decrypted only inside CRE TEE. Price-time priority matching with 5% slippage guard via `ConfidentialHTTPClient`. Shield addresses for settlement. `encryptOutput: true` for AES-GCM encrypted callbacks. World ID ZK proofs validated in TEE. AI chatbot (Gemini) for natural language orders and portfolio advice.

**Why it won:** True dark-pool mechanics with full privacy stack. ECIES + TEE + shield addresses + encrypted callbacks. Complete product with AI chatbot UX.

---

## Aegis-Gate (1st, Risk & Compliance)

**GitHub:** [Abbas-Dev-786/aegis-gate](https://github.com/Abbas-Dev-786/aegis-gate)
**Creator:** Abbas Bhanpura wala (solo)

Privacy-preserving KYC/AML bridge: World ID scan + Plaid bank connect -> CRE TEE processes -> boolean `isCompliant(wallet)` on-chain. Any DeFi protocol calls `isCompliant()`. Sensitive data (bank balances, identity docs) destroyed after use inside TEE. Next.js frontend with World ID QR scan and Plaid Link integration.

**Why it won:** Elegant single-purpose tool solving a real problem. The "impossible tension" framing (compliance vs privacy vs decentralization) was effective. World ID + Plaid + CRE TEE = complete solution.

---

## Creble (1st, World ID)

**GitHub:** [Rakesh-sahoo07/cre-ai-flow](https://github.com/Rakesh-sahoo07/cre-ai-flow)
**Creator:** Rakesh Sahoo (solo)

"Lovable for CRE workflows" -- AI-powered code generator that converts natural language to production-ready CRE TypeScript/Go code. Uses Groq API (llama-3.3-70b). React Flow diagram visualization. World ID for authentication. Built with Lovable.

**Why it won:** Developer tooling for CRE ecosystem growth. Lightest CRE runtime usage (generates workflows rather than running them). Concept compelling despite shallow technical depth.

---

## Cervile Finance (1st, World Mini App)

**GitLab:** [gitlab.com/cervile](https://gitlab.com/cervile) (4 repos: smart-contract, cre, backend, frontend)
**Team:** Oktavianus Bima Jadiva, Harun Al Rasyid (2 devs)

Tokenized stock repo market on World Chain. Users deposit USDC -> auto-bridge to Ethereum via CCIP -> swap for stock tokens (TSLAon, AAPLon, GOOGon, NVDAon via Ondo) -> supply to lending pools for yield. 30s cron vault rebalancing. 89 Foundry tests. Deployed on Ethereum Sepolia + World Chain Mainnet.

**Why it won:** Multi-chain (World Chain + Ethereum), multi-Chainlink-service (CRE + CCIP + Data Feeds). 89 tests. Real Ondo tokenized stocks. Complete product with World Mini App integration.

---

## MaskBid -- The Dark Auction (1st, Tenderly)

**GitHub:** [UyLeQuoc/MaskBid](https://github.com/UyLeQuoc/MaskBid)
**Team:** Uy Le, Nikola Le (2 devs)

Sealed-bid auctions for RWAs (watches, art, gold, real estate). RSA-OAEP encrypted bids, World ID 1-human-1-bid, CRE TEE decrypts all bids simultaneously. **4 CRE workflows:** auction solver (ConfidentialHTTPClient + VaultDON), 2 blockchain log triggers (sync events to Supabase), KYC verification. ERC-1155 RWA tokenization. Turborepo + Bun monorepo.

**Why it won:** Clean privacy architecture. 4 CRE workflows including log triggers. Perfect Tenderly integration (Virtual TestNet + time manipulation for auction testing).

---

## Cross-Winner Patterns

| Pattern | Projects Using It | Count |
|---------|-------------------|:-----:|
| **5+ CRE workflows** | InControl, FlowVault, TAPL | 3 |
| **ConfidentialHTTPClient** | SentinelCRE, SSL, Aegis-Gate, MaskBid | 4 |
| **Frontend/dashboard** | All except CRE Risk Router | 8/9 |
| **Multiple trigger types** | SentinelCRE, FlowVault, TAPL, MaskBid | 4 |
| **90+ tests** | SentinelCRE (90), Cervile (89) | 2 |
| **Multi-chain** | FlowVault, Cervile, TAPL | 3 |
| **World ID** | SSL, Aegis-Gate, Creble, Cervile, MaskBid | 5 |
| **AI integration** | SentinelCRE, SSL, InControl, Creble | 4 |
| **Solo developer** | SentinelCRE, FlowVault, Aegis-Gate, Creble | 4 |
| **Live demo URL** | SentinelCRE, InControl, Aegis-Gate | 3 |

### Key Takeaway

Every 1st place winner except Creble has:
1. A visible frontend or demo
2. Multiple CRE capabilities (not just cron + evm-write)
3. Real data flowing through the system (not mocked)
4. A clear narrative beyond "it works technically"
