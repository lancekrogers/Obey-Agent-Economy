---
fest_type: task
fest_id: 01_audit_secrets
fest_name: audit-secrets
fest_parent: 01_repo_preparation
fest_order: 1
fest_status: completed
fest_autonomy: medium
fest_created: 2026-03-31T16:50:00-06:00
fest_updated: 2026-04-01T03:18:56.726144-06:00
fest_tracking: true
---



# Task: Audit Repos for Secrets

## Objective

Scan agent-inference, agent-defi, and contracts repos for secrets (API keys, private keys, .env files) in both current code and git history before making repos public.

## Requirements

- [ ] No .env files with real values committed
- [ ] No private keys or API keys in code or git history
- [ ] .gitignore properly configured for each repo
- [ ] If secrets found in history, use git filter-branch or BFG to clean

## Implementation

### Step 1: Check each repo for .env files

```bash
for repo in agent-inference agent-defi contracts; do
  echo "=== $repo ==="
  git -C projects/$repo log --all --diff-filter=A -- '*.env' '.env*'
  find projects/$repo -name '.env*' -not -path '*/.git/*'
done
```

### Step 2: Scan for common secret patterns

```bash
for repo in agent-inference agent-defi contracts; do
  echo "=== $repo ==="
  grep -rn 'PRIVATE_KEY=\|API_KEY=\|SECRET=' projects/$repo --include="*.go" --include="*.sol" --include="*.json" --include="*.toml" | grep -v '_test.go' | grep -v 'example'
done
```

### Step 3: Check .gitignore

Verify each repo's .gitignore excludes: `.env`, `.env.*`, `*.key`, `broadcast/`

## Done When

- [ ] All requirements met
- [ ] No secrets found in current code or git history across all 3 repos