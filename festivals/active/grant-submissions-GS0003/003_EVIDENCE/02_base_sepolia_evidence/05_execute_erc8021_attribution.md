---
fest_type: task
fest_id: 05_execute_erc8021_attribution
fest_name: execute-erc8021-attribution
fest_parent: 02_base_sepolia_evidence
fest_order: 5
fest_status: completed
fest_autonomy: medium
fest_created: 2026-03-31T16:45:00-06:00
fest_updated: 2026-04-01T03:16:38.392137-06:00
fest_tracking: true
---



# Task: Capture ERC-8021 Attribution Transaction on Base Sepolia

## Objective

Capture a transaction on Base Sepolia whose calldata includes the 20-byte ERC-8021 builder code suffix, providing verifiable evidence of attribution protocol integration. ERC-8021 is a Base-native standard — demonstrating it strengthens the Base Builder Grant application.

## Requirements

- [ ] Base Sepolia wallet funded (01_fund_base_wallet completed)
- [ ] agent-defi built with ERC-8021 attribution module (`internal/base/attribution/`)
- [ ] At least one write transaction executed with attribution suffix appended
- [ ] Transaction hash recorded and calldata suffix verified on sepolia.basescan.org

## Implementation

### Step 1: Verify attribution code exists

```bash
cd projects/agent-defi
grep -r "8021\|attribution\|builder.code" internal/base/attribution/ --include="*.go" -l
```

The attribution module appends a 20-byte builder code to every transaction's calldata.

### Step 2: Execute an attributed transaction

Any write transaction through agent-defi's Base pipeline should automatically include the ERC-8021 suffix. The easiest approach is to use one of the other evidence transactions (swap, identity) and verify the suffix, OR execute a dedicated transaction:

```bash
go test -tags live -run TestLive_Attribution -v ./internal/base/attribution/
```

### Step 3: Verify attribution on block explorer

Open `https://sepolia.basescan.org/tx/<TX_HASH>` and:
1. View the "Input Data" field
2. Confirm the last 20 bytes match the configured builder code
3. Optionally verify via Base.dev analytics if available

### Step 4: Record evidence

Capture:
- **Tx hash**: The transaction hash
- **Builder code**: The 20-byte suffix value
- **Calldata verification**: Screenshot or hex proof showing the suffix in input data

## Done When

- [ ] All requirements met
- [ ] Transaction confirmed on sepolia.basescan.org with ERC-8021 builder code suffix visible in calldata