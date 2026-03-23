# Festival: chain-agents

## Goal

Build the two specialized chain agents — inference (0G) and DeFi (Base) —
so that all three agents form a working autonomous economy: coordinator
assigns tasks, inference agent executes AI work on decentralized compute,
DeFi agent trades autonomously, and both report back via HCS.

## Scope

Two parallel workstreams within one festival:

### Inference Agent (0G) — agent-inference project

- Connect to 0G Compute broker for decentralized GPU inference
- Store agent memory/results on 0G Storage
- Mint and maintain ERC-7857 iNFT with encrypted metadata on 0G Chain
- Use 0G DA (Data Availability) for audit trail
- Receive tasks from coordinator via HCS, return results

### DeFi Agent (Base) — agent-defi project

- Register agent identity via ERC-8004 (Agent Identity)
- Implement x402 payment protocol for compute costs
- Add ERC-8021 builder attribution codes to transactions
- Execute autonomous trading strategies on Base
- Report P&L back to coordinator via HCS
- Goal: revenue exceeds operational costs (self-sustaining)

Both agents share:

- Daemon client integration (same pattern as coordinator)
- HCS message subscribe/publish for task flow
- Health reporting to coordinator

## Key Deliverables

- Inference agent binary: receives task → runs inference on 0G Compute → stores result → reports via HCS
- DeFi agent binary: receives strategy → executes trades on Base → reports P&L via HCS
- iNFT minted on 0G Chain representing the inference agent
- At least one profitable trading cycle demonstrated
- All three agents communicating through HCS

## Dependencies

- Festival 1 (hedera-foundation): HCS messaging and HTS payments must be working

## Projects Touched

- `agent-inference` (primary)
- `agent-defi` (primary)

## Bounties

- 0G Track 2 ($7k) — decentralized GPU inference
- 0G Track 3 ($7k) — ERC-7857 iNFT with encrypted metadata
- Base ($3k+) — self-sustaining agent with ERC-8004 + x402 + ERC-8021

## Estimated Complexity

3 phases: Plan → Implement (two parallel sequence groups) → Integration verify
The two agents can be built in parallel within the implement phase.
