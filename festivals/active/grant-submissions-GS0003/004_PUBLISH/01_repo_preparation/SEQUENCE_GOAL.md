---
fest_type: sequence
fest_id: 01_repo_preparation
fest_name: repo-preparation
fest_parent: 004_PUBLISH
fest_order: 1
fest_status: completed
fest_created: 2026-03-31T16:50:00-06:00
fest_updated: 2026-04-01T03:20:10.941993-06:00
fest_tracking: true
---


# Sequence Goal: 01_repo_preparation

**Sequence:** 01_repo_preparation | **Phase:** 004_PUBLISH | **Status:** Pending

## Sequence Objective

**Primary Goal:** Audit repos for secrets, update READMEs, and make repos public on GitHub so grant reviewers can inspect the code.

**Contribution to Phase Goal:** Grant applications require public repos with accurate documentation. This sequence prepares the repos before any application is submitted.

## Success Criteria

- [ ] Secret audit passed (no .env files, API keys, or private keys in git history)
- [ ] READMEs updated and accurate for agent-inference, agent-defi, and contracts
- [ ] All 3 repos made public on GitHub (Blockhead-Consulting org)
- [ ] Repos accessible in incognito browser

## Task Alignment

| Task | Objective | Status |
|------|-----------|--------|
| 01_audit_secrets | Scan repos for secrets in code and git history | TODO |
| 02_update_readmes | Ensure READMEs are accurate and presentable | TODO |
| 03_make_repos_public | Change visibility to public on GitHub | TODO |