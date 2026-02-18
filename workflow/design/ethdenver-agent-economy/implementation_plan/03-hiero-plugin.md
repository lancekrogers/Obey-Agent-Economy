# Festival: hiero-plugin

## Goal

Build a Hiero CLI plugin that wraps the `camp` binary, giving Hedera
developers workspace management capabilities through `hiero camp` commands.
This is a standalone deliverable targeting Hedera Track 4.

## Scope

### Plugin Architecture (hiero-plugin project)
- Plugin manifest and registration with Hiero CLI
- `hiero camp init` — initialize a camp workspace for Hedera projects
- `hiero camp status` — show project status across the workspace
- `hiero camp navigate` — fuzzy-find navigation within camp
- Bundled templates for Hedera project scaffolding
- Documentation: README, usage guide, architecture overview

### Integration
- Plugin discovers and invokes the `camp` binary
- Handles camp not installed gracefully (error messages, install guidance)
- Works with existing Hiero CLI plugin system

## Key Deliverables

- Working `hiero camp` commands (init, status, navigate)
- Plugin installable via Hiero CLI plugin system
- Hedera project template bundled with the plugin
- PR-ready submission to Hiero CLI repo (or standalone submission)

## Dependencies

- None (can build in parallel with festival 1)
- Only dependency is understanding the Hiero CLI plugin API

## Projects Touched

- `hiero-plugin` (primary)

## Bounties

- Hedera Track 4 ($5k, 2 winners) — developer tooling

## Estimated Complexity

2-3 phases: Plan (plugin API research) → Implement → Submit
Smallest festival — focused scope, clear deliverable.
