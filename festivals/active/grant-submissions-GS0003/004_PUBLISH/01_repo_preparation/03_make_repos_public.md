---
fest_type: task
fest_id: 03_make_repos_public
fest_name: make-repos-public
fest_parent: 01_repo_preparation
fest_order: 3
fest_status: completed
fest_autonomy: low
fest_created: 2026-03-31T16:50:00-06:00
fest_updated: 2026-04-01T03:20:10.941413-06:00
fest_tracking: true
---


# Task: Make Repos Public on GitHub

## Objective

Change visibility of agent-inference, agent-defi, and contracts repos from private to public on GitHub under the Blockhead-Consulting organization.

## Requirements

- [ ] Secret audit completed (01_audit_secrets)
- [ ] READMEs updated (02_update_readmes)
- [ ] Repos changed to public visibility on GitHub
- [ ] Verified accessible in incognito browser

## Implementation

### Step 1: Make repos public via GitHub

For each repo (agent-inference, agent-defi, contracts):
1. Go to `github.com/Blockhead-Consulting/<repo>/settings`
2. Scroll to "Danger Zone"
3. Click "Change visibility" → Public
4. Confirm

### Step 2: Verify in incognito

Open each URL in an incognito/private browser window:
- `https://github.com/Blockhead-Consulting/agent-inference`
- `https://github.com/Blockhead-Consulting/agent-defi`
- `https://github.com/Blockhead-Consulting/contracts`

## Done When

- [ ] All requirements met
- [ ] All 3 repos publicly accessible (verified in incognito browser)