---
fest_type: task
fest_id: 04_execute_x402_payment
fest_name: execute-x402-payment
fest_parent: 02_base_sepolia_evidence
fest_order: 4
fest_status: pending
fest_autonomy: medium
fest_created: 2026-03-31T16:45:00-06:00
fest_tracking: true
---

# Task: Execute x402 Payment on Base Sepolia

## Objective

Execute an x402 payment protocol transaction on Base Sepolia to generate verifiable on-chain evidence of the payment integration. x402 is a Base-native standard — demonstrating it strengthens the Base Builder Grant application.

## Requirements

- [ ] Base Sepolia wallet funded with USDC for payment (01_fund_base_wallet completed)
- [ ] agent-defi built with x402 payment module (`internal/base/payment/x402.go`)
- [ ] A service endpoint accepting x402 payments OR a minimal proof flow
- [ ] Transaction hash recorded and verified on sepolia.basescan.org

## Implementation

### Step 1: Verify x402 payment code exists

```bash
cd projects/agent-defi
grep -r "x402" internal/base/payment/ --include="*.go" -l
```

The x402 module (`internal/base/payment/x402.go`, ~445 lines) implements the full HTTP 402 handshake with on-chain USDC payment and receipt verification.

### Step 2: Execute x402 payment

Using agent-defi's x402 payment flow:

```bash
go test -tags live -run TestLive_X402Payment -v ./internal/base/payment/
```

If no live test exists, execute via the agent-defi CLI or create a minimal script that triggers the 402 handshake → USDC transfer → receipt flow.

### Step 3: Record transaction details

Capture from the output:
- **Tx hash**: The USDC transfer transaction hash
- **Payment amount**: USDC amount transferred
- **Recipient**: The service address that received payment

### Step 4: Verify on block explorer

Open `https://sepolia.basescan.org/tx/<TX_HASH>` and confirm:
- Transaction status is "Success"
- USDC transfer event is visible
- Payment recipient matches expected address

## Done When

- [ ] All requirements met
- [ ] x402 payment transaction confirmed on sepolia.basescan.org with USDC transfer event visible
