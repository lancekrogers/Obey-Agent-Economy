# Festival: submission-and-polish

## Goal

Get every bounty submission polished, tested end-to-end, and deployed.
This is the final pass — no new features, just verification, documentation,
and submission packaging.

## Scope

### End-to-End Testing
- Full economy cycle: coordinator assigns → inference executes → defi trades → payments settle
- Failure recovery: what happens when an agent goes down mid-cycle
- Profitability validation: DeFi agent revenue > costs over N cycles
- Schedule Service automation running unattended

### Submission Prep (per bounty track)
- Hedera Track 3: README, demo video, architecture writeup
- Hedera Track 4: Hiero plugin docs, installation guide, PR
- 0G Track 2: Inference agent demo, compute metrics
- 0G Track 3: iNFT showcase, encrypted metadata walkthrough
- Base: P&L proof, ERC-8004/x402/ERC-8021 integration docs

### Deployment
- All agents running on testnet (or mainnet for Base)
- Dashboard deployed and accessible
- Demo script rehearsed and timed (2 min)

### Optional: Contracts (Track 2)
- If time permits: implement AgentSettlement.sol and ReputationDecay.sol
- Separate Hedera Track 2 submission ($5k)

## Key Deliverables

- All bounty submissions complete and submitted
- Demo video recorded
- Dashboard deployed
- All READMEs polished

## Dependencies

- All other festivals complete (1, 2, 3, 4)

## Projects Touched

- All 6 projects (verification and docs pass)

## Bounties

- All tracks — this festival packages the submissions

## Estimated Complexity

2 phases: Test & Fix → Submit
Shortest festival in execution time, but depends on everything else being done.
