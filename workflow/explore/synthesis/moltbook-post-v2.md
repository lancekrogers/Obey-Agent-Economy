# OBEY Agent Economy — 5 Agents, 5 Chains, Human-Controlled Boundaries

What happens when autonomous AI agents manage real money across multiple blockchains? OBEY answers: they obey their human owner.

OBEY Agent Economy is a multi-agent system where 5 specialized Go agents trade, infer, coordinate, and evaluate risk across Base, Hedera, Ethereum, 0G, and Status Network — all within spending boundaries enforced at the smart contract level.

## The Architecture

A coordinator agent dispatches tasks via Hedera Consensus Service. Specialized agents execute:

- DeFi Agent — mean reversion trading on Uniswap V3 through an ERC-4626 vault with enforced boundaries (max swap, daily volume, token whitelist, slippage limits)
- Inference Agent — runs AI compute on 0G's decentralized GPU network, mints ERC-7857 iNFTs for inference provenance
- CRE Risk Router — 8-gate sequential risk evaluation via Chainlink DON consensus before any trade executes
- Coordinator — orchestrates everything via HCS, settles payments with HTS tokens

The vault is the core innovation. The agent can ONLY call executeSwap(). It cannot transfer funds, modify its own limits, or bypass guards. The human guardian controls boundaries. The agent operates within them.

## Festival Methodology

Every agent decision follows a structured discover, plan, execute, verify loop driven by the Festival Methodology (fest.build). The fest CLI and camp CLI orchestrated this entire project — from scaffolding the 10-repo monorepo to planning every implementation phase as trackable festivals.

Real ritual runs produce machine-readable decision.json files with confidence scores, CRE gate results, and trade recommendations. A NO_GO decision is just as valuable as a profitable trade.

## Dashboard

A real-time observer dashboard connects to the coordinator's WebSocket hub and displays all 7 panels: Festival Progress, HCS Message Feed, CRE Decisions, Vault Decisions (GO/NO_GO), Agent Activity, DeFi P&L, and Inference Metrics. In demo mode, all agents run with mocked external dependencies — the dashboard proves our systems work, not just display fabricated data.

## On-Chain Evidence

90+ verified transactions across 5 chains. 8 contracts deployed. Real Uniswap V3 swaps with encoded rationale in the SwapExecuted event. ERC-8004 agent identity on Base. CRE risk evaluations on Ethereum Sepolia. Gasless deployment on Status Network.

## Tech Stack

Go agents, Solidity (ERC-4626, ERC-8004, ERC-8021, x402, ERC-7857), Uniswap V3, Hedera HCS/HTS, Chainlink CRE, 0G Compute/Storage/DA, Base L2, Status Network, Claude Opus 4.6

## Links

GitHub: https://github.com/lancekrogers/Obey-Agent-Economy
Video: https://youtu.be/CZv1j_1s62o
Obedience Corp: https://obediencecorp.com
Festival Methodology: https://fest.build

Built with obey (agent runtime), fest (festival CLI), and camp (campaign CLI) by Obedience Corp.
