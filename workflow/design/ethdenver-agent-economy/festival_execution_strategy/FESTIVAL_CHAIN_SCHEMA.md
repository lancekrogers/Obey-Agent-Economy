# Festival Chain Schema — Design Document

## Problem Statement

The Festival Methodology handles **intra-festival** orchestration well: phases, sequences, tasks, quality gates, lifecycle states. But it has no formal mechanism for **inter-festival** orchestration — expressing that festival B depends on festival A, that festivals C and D can run in parallel after A completes, or that a final festival E gates on everything else.

Today this is handled with prose documentation (this directory's README.md). That works for humans reading a design doc but is:

- Not machine-parseable by `fest` or agents
- Not enforceable (nothing prevents activating a festival before its dependencies are met)
- Not portable across campaigns (every campaign re-invents the dependency story)
- Disconnected from the lifecycle states (`planning` → `active` → `dungeon/completed`)

## Design Goals

1. **Human-readable**: A person should be able to open the file and understand the dependency graph in seconds
2. **Agent-readable**: `fest` and AI agents should parse it to determine what's unblocked
3. **Minimal**: Don't over-engineer; add only what's needed to fill the gap
4. **Non-breaking**: Existing festivals and `fest.yaml` files don't need to change (chain is additive)
5. **Campaign-scoped**: One chain file per campaign (not per-festival)

## Proposed Schema: `chain.yaml`

### Location

```
festivals/
├── chain.yaml              <── NEW: the inter-festival dependency graph
├── planning/
├── active/
├── ready/
├── dungeon/
├── .festival/
└── README.md
```

Lives at the **festivals root**, alongside the lifecycle directories. One file, one campaign.

### Schema Definition

```yaml
# festivals/chain.yaml
# Festival Chain — inter-festival dependency graph
#
# This file defines execution order, dependencies, and wave groupings
# for festivals within this campaign. It is read by `fest` and AI agents
# to determine which festivals are unblocked and ready to activate.

chain_version: "1.0"

# ─── Campaign Metadata ───────────────────────────────────────────
campaign:
  name: ethdenver2026
  goal: "Build a 3-agent autonomous economy on Hedera + 0G + Base for ETHDenver 2026"

# ─── Festival Nodes ──────────────────────────────────────────────
# Each festival that participates in this chain.
# `id` must match the fest.yaml metadata.id field.
# `ref` is a short alias used in dependency edges below.

festivals:
  - ref: hf
    id: HF0001
    name: hedera-foundation
    projects: [agent-coordinator]

  - ref: ca
    id: CA0001
    name: chain-agents
    projects: [agent-inference, agent-defi, agent-coordinator]

  - ref: hp
    id: HP0001
    name: hiero-plugin
    projects: [hiero-plugin]

  - ref: da
    id: DA0001
    name: dashboard
    projects: [dashboard]

  - ref: sp
    id: SP0001
    name: submission-and-polish
    projects: [agent-coordinator, agent-inference, agent-defi, hiero-plugin, dashboard, contracts]

# ─── Dependency Edges ────────────────────────────────────────────
# Each edge: `from` must complete (or reach a gate) before `to` can activate.
#
# type:
#   hard  — `to` cannot start ANY work until `from` completes
#   soft  — `to` can start with mocks/stubs; full integration needs `from`
#
# gate (optional):
#   If set, `to` unblocks when `from` passes this specific quality gate
#   rather than requiring full festival completion.
#   Format: "sequence_name/gate_id" or "completed" (default)
#
# note (optional):
#   Human-readable explanation of WHY this dependency exists.

edges:
  - from: hf
    to: ca
    type: hard
    note: "chain-agents need HCS topics, HTS tokens, coordinator engine, daemon client from hedera-foundation"

  - from: hf
    to: da
    type: soft
    note: "dashboard can scaffold with mock data; live panels need HCS/HTS/daemon APIs"

  - from: ca
    to: sp
    type: hard
    note: "submission needs working agents for E2E testing and demo"

  - from: da
    to: sp
    type: hard
    note: "submission needs dashboard for demo video and deployment"

  - from: hp
    to: sp
    type: hard
    note: "submission packages all tracks including hiero-plugin"

  # hp has NO incoming edges — it's fully independent

# ─── Waves ───────────────────────────────────────────────────────
# Waves group festivals that can execute in parallel.
# Each wave has an `unlock` condition: what must be true before
# this wave's festivals can activate.
#
# This section is DERIVED from edges above but stated explicitly
# for human readability and agent planning.

waves:
  - id: 1
    name: "Foundation + Independent"
    unlock: "none"  # Start immediately
    festivals: [hf, hp]
    notes: "hf and hp have no incoming edges; start both immediately"

  - id: 2
    name: "Agents + Dashboard"
    unlock: "hf:completed"
    festivals: [ca, da]
    notes: "da can start early with mocks (soft dep) but full activation waits for hf"

  - id: 3
    name: "Final Assembly"
    unlock: "ca:completed AND da:completed AND hp:completed"
    festivals: [sp]
    notes: "sp gates on ALL other festivals completing"

# ─── Sequence-Level Cross-Dependencies (optional) ────────────────
# For soft dependencies, you can specify which sequences in the
# downstream festival can start early vs which need the upstream.
#
# This is optional granularity — omit if the edge-level type
# (hard/soft) is sufficient.

sequence_hints:
  - festival: da
    early_start:
      sequences: [01_data_layer, 02_festival_view, 03_hcs_feed]
      condition: "Can begin with mock data before hf completes"
    needs_upstream:
      sequences: [04_agent_activity, 05_defi_pnl, 06_inference_metrics, 07_demo_polish]
      condition: "Requires live agent data from ca"

  - festival: ca
    parallel_sequences:
      - [01_inference_zerog, 02_defi_base]  # These run in parallel
    serial_after:
      - 03_integration_verify  # Waits for both above
```

### Schema Field Reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `chain_version` | yes | string | Schema version for forward compatibility |
| `campaign.name` | yes | string | Campaign identifier |
| `campaign.goal` | no | string | Human-readable campaign objective |
| `festivals[]` | yes | list | Festival nodes in the chain |
| `festivals[].ref` | yes | string | Short alias (used in edges/waves) |
| `festivals[].id` | yes | string | Must match `fest.yaml` `metadata.id` |
| `festivals[].name` | yes | string | Must match `fest.yaml` `metadata.name` |
| `festivals[].projects` | no | list | Projects this festival touches |
| `edges[]` | yes | list | Dependency relationships |
| `edges[].from` | yes | ref | Upstream festival ref |
| `edges[].to` | yes | ref | Downstream festival ref |
| `edges[].type` | yes | enum | `hard` or `soft` |
| `edges[].gate` | no | string | Specific gate that unblocks (default: `completed`) |
| `edges[].note` | no | string | Why this dependency exists |
| `waves[]` | no | list | Parallel execution groups (derived from edges) |
| `waves[].unlock` | yes | string | Condition expression using `ref:status` |
| `sequence_hints[]` | no | list | Optional intra-festival parallelism notes |

### Edge Type Semantics

| Type | Meaning | Agent Behavior |
|------|---------|----------------|
| `hard` | Downstream cannot start ANY work | Agent must wait; `fest promote` blocked |
| `soft` | Downstream can start with mocks | Agent may activate but must track upstream completion for integration |

## Integration with `fest` CLI

### New Commands (future)

```bash
# Validate chain.yaml against actual fest.yaml files
fest chain validate

# Show what's currently unblocked based on festival statuses
fest chain status

# ASCII/mermaid rendering of the dependency graph
fest chain graph
fest chain graph --mermaid

# Check if a specific festival is ready to activate
fest chain check <festival-ref>
# → "ca (CA0001) is BLOCKED by: hf (HF0001) [status: active, needs: completed]"
# → "hp (HP0001) is UNBLOCKED — no incoming dependencies"
```

### Integration with `fest promote`

When promoting a festival (`fest promote` or `fest flow advance`), the CLI could:

1. Read `chain.yaml`
2. Check if the festival being promoted has unmet hard dependencies
3. Warn or block if upstream festivals haven't completed
4. After completion, report which downstream festivals are now unblocked

### Integration with `fest.yaml` (Minimal, Optional)

A single optional field could be added to individual `fest.yaml` files to create a bidirectional link:

```yaml
# In fest.yaml (optional addition)
metadata:
  id: CA0001
  name: chain-agents
  chain:
    ref: ca              # My alias in chain.yaml
    depends_on: [hf]     # Shorthand — canonical deps live in chain.yaml
```

This is **not required** — `chain.yaml` is the source of truth. But having a `chain.ref` in `fest.yaml` lets an agent reading a single festival quickly know it's part of a chain without reading the full chain file.

## Integration with `festivals/` Directory

### No Structural Changes Required

The chain file is purely additive:

```
festivals/
├── chain.yaml              <── New file
├── planning/               # Unchanged
│   └── submission-and-polish-SP0001/
├── active/                 # Unchanged
│   ├── hedera-foundation-HF0001/
│   ├── chain-agents-CA0001/
│   ├── dashboard-DA0001/
│   └── hiero-plugin-HP0001/
├── ready/                  # Unchanged
├── dungeon/                # Unchanged
├── .festival/              # Unchanged
└── README.md               # Unchanged
```

### Chain-Aware Lifecycle

The chain file enriches the existing lifecycle without changing it:

```
                    chain.yaml says:
                    "ca depends on hf (hard)"
                           │
planning/ ──► ready/ ──► active/ ──► dungeon/completed/
                         │
                    fest chain check ca
                    → BLOCKED (hf still active)
                         │
                    hf moves to dungeon/completed/
                         │
                    fest chain check ca
                    → UNBLOCKED
                         │
                    fest promote ca → active/
```

### Agent Workflow

An AI agent running a campaign would:

1. Read `chain.yaml` to understand the full graph
2. Call `fest chain status` (or parse statuses manually) to find unblocked festivals
3. Activate and execute unblocked festivals
4. After completing a festival, check what's newly unblocked
5. Repeat until the chain is fully resolved

## Example: This Campaign's `chain.yaml`

See the full schema example above — it directly models the ETHDenver 2026 dependency chain that was previously only documented in prose in this directory's README.md.

## Open Questions

1. **Multiple chains per campaign?** Current design is one `chain.yaml`. If a campaign has independent workstreams, they could be separate chains in a `chains/` directory. Premature to add now.

2. **Cross-campaign chains?** Out of scope. Each campaign owns its chain. If campaigns depend on each other, that's a higher-level orchestration problem.

3. **Gate-level unlocking?** The `gate` field on edges allows specifying "unblock when sequence X passes its testing gate" rather than waiting for full completion. Useful but adds complexity — keep optional.

4. **Validation strictness?** Should `fest chain validate` be a hard gate on `fest promote`, or advisory? Suggest advisory first, opt-in enforcement later.

5. **Wave auto-derivation?** Waves can be computed from edges (topological sort). Should `fest` auto-derive them or require explicit declaration? Suggest: explicit in the file for human readability, but `fest chain validate` should verify waves match the edge graph.
