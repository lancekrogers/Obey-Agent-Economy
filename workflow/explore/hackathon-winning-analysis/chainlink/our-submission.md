# CRE Risk Router -- Self-Assessment

**Placement:** 2nd Place, Autonomous Agents category
**GitHub:** [lancekrogers/cre-risk-router](https://github.com/lancekrogers/cre-risk-router)
**Contract:** [0x9C7Aa5502ad229c80894E272Be6d697Fd02001d7](https://sepolia.etherscan.io/address/0x9C7Aa5502ad229c80894E272Be6d697Fd02001d7) (Sepolia)

---

## What We Built

A Chainlink Runtime Environment (CRE) workflow that evaluates AI-agent trade signals through 8 sequential risk gates and writes immutable decision receipts on-chain to Ethereum Sepolia. Compiles to WASM (`wasip1`) for deterministic CRE execution. Includes an HTTP bridge for coordinator integration.

## Lines of Code

| Category | Lines | Notes |
|----------|------:|-------|
| Hand-written Go | ~1,339 | Core logic, tests, bridge, workflow |
| Generated Go bindings | ~1,222 | `RiskDecisionReceipt.go` + mock |
| Solidity | ~222 | Contract, interfaces, tests, deploy |
| Config/infra | ~177 | yaml, json, justfile, toml, sh |
| Scenarios | ~78 | 5 pre-built test fixtures |
| **Total hand-written** | **~1,816** | |

## Architecture Strengths

- **Clean separation**: `pkg/riskeval/` is a pure Go library with zero CRE dependencies. The CRE integration is confined to `workflow.go` and `main.go`.
- **8-gate pipeline**: Sequential risk evaluation with short-circuit denial. Each gate is a pure function: Hold Signal Filter, Signal Confidence, Risk Score Ceiling, Signal Staleness, Oracle Health, Price Deviation, Position Sizing, Agent Heartbeat.
- **Real CRE execution path**: trigger -> compute -> ABI encode -> DON report -> on-chain write. Not mocked.
- **IReceiver contract**: Implements CRE's `onReport(bytes,bytes)` for DON-forwarded writes. Duplicate prevention, TTL-based expiry, on-chain counters, ERC165 detection.
- **HTTP bridge**: Production-quality Go server with graceful shutdown, proper timeouts, health endpoint. Fail-closed design -- unreachable bridge = task rejected.

## Test Coverage

| Test File | Count | Coverage |
|-----------|------:|---------|
| `pkg/riskeval/risk_test.go` | 30 | All 8 gates + 8 integration + helpers |
| `cmd/bridge/bridge_test.go` | 4 | HTTP handler paths |
| `workflow_test.go` | 1 | Config field validation |
| `test/RiskDecisionReceipt.t.sol` | 4 | Contract: record, duplicate, TTL |
| **Total** | **39** | |

**What's tested well:** Every gate with boundary conditions, concurrency (100-goroutine RunID uniqueness), table-driven slippage tests, Solidity `vm.warp` for TTL testing.

**Gaps:** `executeRiskPipeline` untested (the workflow-level integration). ABI encoding path untested (Go <-> Solidity type alignment). `hashDecision` cross-language consistency untested. Market data paths always nil.

## CRE Features Used

| CRE Feature | Used | Notes |
|-------------|:----:|-------|
| `cron-trigger@1.0.0` | Yes | 5-minute periodic sweeps |
| WASM (`wasip1`) | Yes | Deterministic execution |
| `cre.Workflow` + Handler | Yes | Registers cron handler |
| `cre.Runtime.Logger()` | Yes | Structured logging |
| `GenerateReport()` | Yes | DON consensus on payload |
| `evm.Client` / ChainSelector | Yes | Chain targeting |
| CRE Go bindings | Yes | Contract interaction + WriteReport |
| `IReceiver.onReport()` | Yes | Contract implements receiver |
| Config parsing | Yes | `cre.ParseJSON` for gate thresholds |
| `SecretsProvider` | Declared | Accepted but unused |
| HTTP fetch | **No** | Market data mocked (SDK limitation) |
| EVM read | **No** | Oracle data mocked |
| Multiple triggers | **No** | Cron only |
| ConfidentialHTTP | **No** | Not used |
| Cross-chain | **No** | Sepolia only |

**Assessment:** The CRE integration is genuine and functional but operates at single-pipeline depth. One trigger, one capability chain (cron -> compute -> evm-write), no capability composition.

## On-Chain Evidence

- CRE broadcast: [`0xea6784a...`](https://sepolia.etherscan.io/tx/0xea6784a79fd108cfb4fc07127ab19b2c9f2a90867fcccc47b339e685fe3169c4)
- Direct recordDecision: [`0x0c72922...`](https://sepolia.etherscan.io/tx/0x0c72922fd8e31f859dc5ce30364d87e86c939f7c2a2282899db11b65242dabd1)
- On-chain state: `getRunCount() = 1`, `totalApproved() = 1`

Real transactions. A judge can verify on Etherscan.

## Contract Weaknesses

- No access control on `recordDecision()` -- anyone can write arbitrary decisions
- No access control on `onReport()` -- forwarder address stored but never checked
- No reentrancy guard
- No upgradability

## What a Judge Saw

**Impressive:**
- Genuine CRE integration with real on-chain proof
- Well-designed risk evaluation engine (8 gates, short-circuit, volatility-adjusted sizing)
- Clean, idiomatic Go code with thorough tests
- Professional README with Mermaid architecture diagram, full API docs
- Keccak256 decision hashing for trustless verification

**Lacking:**
- **No frontend/UI** -- CLI only. Nothing visual to demo.
- **Mocked data** -- Gates 4 and 5 are effectively decorative (hardcoded oracle, nil market data)
- **Single trigger, single pipeline** -- narrow CRE feature breadth
- **Demo shows only approved path** -- 5 scenario files exist but aren't exercised
- **No multi-agent support** -- evaluates one synthetic agent despite being framed as "for autonomous agents"
- **Identical staging/production configs** -- environment separation is aspirational

---

*This is the honest assessment. The code is strong but the hackathon presentation was weak.*
