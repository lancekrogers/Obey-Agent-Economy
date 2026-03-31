# 2nd Place Winners -- Chainlink Convergence Hackathon 2026

Our peers. These are the projects that placed alongside CRE Risk Router.

---

## AI Financial Workspace Legos + Ghost Privacy (CRE & AI)

**GitHub:** [tcxcx/cre-escrow-ghost](https://github.com/tcxcx/cre-escrow-ghost)
**Creator:** Tomas Cordero

BUFI -- a financial OS for distributed B2B teams. Ghost Mode (private stablecoin issuance via Chainlink ACE), AI Contract Builder with drag-and-drop escrow, and a 5-LLM AI Tribunal for dispute resolution with on-chain attestations. 3000+ app integrations via Pipedream.

**Standout:** The AI Tribunal -- five independent LLMs vote on disputes, eliminating legal costs. Chainlink ACE for private, compliant transfers.

---

## Ghost Finance (DeFi & Tokenization)

**GitHub:** [snehendu098/ghost](https://github.com/snehendu098/ghost)
**Team:** Snehendu Roy, Debanjan Mondal, Abhirup Banerjee

Private P2P lending with sealed bid rate discovery in CRE Confidential Runtime. Three stateless workflows (loan matching 30s, fund transfers 15s, collateral health 60s). Discriminatory pricing auction -- each lender earns their individual bid rate. Credit tiers from Bronze (2x collateral) to Platinum (1.2x).

**Standout:** Deepest CRE integration among 2nd place winners. The sealed-bid discriminatory pricing model is genuinely novel for DeFi lending.

---

## Memepull Arena (Prediction Markets)

**GitHub:** [github.com/MemePull](https://github.com/MemePull) (org: `fe`, `orchestrator`, `sc`)
**Team:** Fawwaz Naufal, Ini Ferdin

Gamified liquidity warfare for meme coin communities. Winner-takes-all PvP battles with 30-minute TWAP windows to block manipulation. World ID identity tiers with deposit caps. CRE automates auditing, settlement, and resolution with zero manual intervention.

**Standout:** TWAP-based manipulation prevention. World ID identity tiers. Multi-repo org architecture.

---

## TACIT (Privacy)

**GitHub:** [DavidZapataOh/tacit-protocol](https://github.com/DavidZapataOh/tacit-protocol)
**Creator:** David Zapata
**Live:** [tacit-protocol.vercel.app](https://tacit-protocol.vercel.app)

Private, compliant, atomic OTC settlement targeting $39B+ daily volume. CRE TEE decrypts trade parameters, verifies bilateral matching, runs OFAC/KYC via Confidential HTTP, executes atomic DvP settlement. Cross-chain via CCIP (Sepolia to Arbitrum Sepolia). Failed compliance triggers automatic refunds.

**Standout:** Cleanest institutional-grade architecture. Delivery-vs-Payment eliminates counterparty risk.

---

## ACE Sandbox (Risk & Compliance)

**GitHub:** [magiodev/chainlink-convergence-ace-sandbox](https://github.com/magiodev/chainlink-convergence-ace-sandbox)
**Creator:** Stefano Magini

Compliant tokenization sandbox. ERC-3643 compliance tokens + ERC-7540 async vault. Base Sepolia hub + Ethereum Sepolia satellite. On-chain compliance enforcement at mint/transfer time. CCIP for cross-chain treasury operations.

**Standout:** Standards-first approach (ERC-3643, ERC-7540). Simplified KYC with ACE credentials. Audit-ready.

---

## Worldyield (World ID)

**GitHub:** [Suganthan96/Worldyield](https://github.com/Suganthan96/Worldyield)
**Team:** Suganthan T S, Sylesh, Austin Jeremiah J

Trust-optimized DeFi yield aggregator. World ID iris scanning for sybil-resistant participation (+1.4% verified boost). AI analyzes Aave v3 and Compound v3 yields. CRE checks every 5 minutes across Ethereum and Base Sepolia. Mastra AI agent for natural language transaction execution.

**Standout:** Human consensus scoring -- verified humans "vote" on protocol trustworthiness, creating yield boosts.

---

## OneShot (World Mini App)

**GitHub:** [RamonLiao/OneShot](https://github.com/RamonLiao/OneShot)
**Creator:** Yu-Cheng Liao

Sybil-resistant prediction market with "one person, one vote" via World ID. RSA-OAEP encrypted predictions, CRE TEE decrypts upon closure, multi-chain payouts (Base, Arbitrum, Optimism, World Chain). True democratic predictions -- one verified human, one position per market.

**Standout:** Privacy-preserving prediction markets without capital determinism.

---

## ApprovalGuardian (Tenderly)

**GitHub:** [sairammr/Convergence-Chainlink-Hackathon](https://github.com/sairammr/Convergence-Chainlink-Hackathon)
**Team:** Romario Kavin, Sairam

Autonomous DeFi protection. Three sequential CRE workflows: monitoring (cron), detection (exploit signals + DefiLlama TVL + BFT median consensus), execution (DON-signed RevocationReport). Multi-chain (Ethereum, Arbitrum, Base). Telegram alerts. "CRE is the only reason this project is possible."

**Standout:** Most practical immediate utility. Fully autonomous post-registration. Configurable sensitivity levels.

---

## 2nd Place Patterns

| Capability | Ghost Finance | TACIT | ApprovalGuardian | CRE Risk Router |
|------------|:---:|:---:|:---:|:---:|
| CRE TEE/Confidential | Yes | Yes | No | No |
| Multiple workflows | 3 | 1+ | 3 | 1 |
| Frontend | No | Yes (Vercel) | Yes | No |
| Cross-chain | No | Yes (CCIP) | Yes (3 chains) | No |
| Real data | Yes | Yes | Yes (DefiLlama) | No (mocked) |
| Live demo URL | No | Yes | Yes | No |

CRE Risk Router is the only 2nd place winner with (a) no frontend, (b) mocked data, and (c) single-chain operation.
