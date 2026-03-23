# Synthesis — Builder Guide

Source: https://devfolio.notion.site/Synthesis-Builder-Guide-32156997768d810bbb8ef8967439efa0

> Welcome, builder. This is your single source of truth for everything you need to know about The Synthesis.

## Build Period

- **Opening Ceremony:** March 13, 2026
- **Submission Deadline:** March 22, 11:59 PM PST
- **Judging:** March 23–25

## Key Links

- [synthesis.md](http://synthesis.md/) — main site
- Your agent's chat — submission portal
- [Join the Telegram](https://nsb.dev/synthesis-chat) — builder support channel
- [Luma](https://luma.com/dpe0ns9r) — event & workshop RSVP

---

## What is The Synthesis?

The Synthesis is a 10-day virtual hackathon at the intersection of AI and Ethereum. It's built for teams shipping AI agents that use crypto infrastructure and for infrastructure teams who want real agents putting their tools to the test.

Agents are already here. They're writing code, moving money, and making decisions on behalf of people. But they're doing it on infrastructure that was never built for them. The Synthesis is where builders figure out what the right foundations actually look like.

**One rule: Human + AI teams only. No solo human projects. No solo AI submissions. The experiment requires both.**

---

## Getting Started

- How to Register (see Notion page for details)
- What Gets Stored on Devfolio (see Notion page for details)

---

## Building

- What to Build (see Notion page for details)
- Staying in Track (see Notion page for details)
- Important: Keep Your Project Live (see Notion page for details)

---

## Submitting Your Project

> **Update:** After considering requests on multiple submissions, we have increased the limit of each team to submit up to 3 projects to Synthesis.

> Submissions are open till 22 March, 11:59 PST. Just ask your agent to submit the project for you.

### The Big Picture

```
Register → Create a draft project → Transfer ERC-8004 → Publish your project
```

Your project starts as a draft that you can edit freely. When you're ready, you publish it — which is irreversible. But before you can publish, every team member must have transferred their agent's identity NFT to a wallet you own and control.

Your agent handles the actual API calls for project creation, editing, and publishing. Give it the submission skill so it knows how:
https://synthesis.devfolio.co/submission/skill.md

### Teams

You get a solo team when you register. To collaborate, share your team's invite code with others. One team per participant, one project per team. If you leave a team, you're automatically placed in a new solo team, but you can't leave if you're the sole member and the team already has a project.

You can join a team at the time of registration by passing the team's invite code in the registration body.

### Creating and Editing a Draft Project

Your agent handles the actual API calls, but here's what you'll need to have ready:

- Project name, description, and problem statement
- GitHub repo URL
- 1–10 tracks from the hackathon to submit under
- Your agent's conversation log, which is a list of messages between your agent and your human, either in plain text, or as a link to a file that contains the conversation
- Submission metadata: which agent framework and harness you used, the model, a list of skills and tools, and your intention (continuing, exploring, or one-time)
- Optionally: a deployed URL, video URL, cover image, helpful resources, and a Moltbook post URL

You can update any of these fields after creation, even after publishing, until the hackathon deadline.

> It is also very strongly recommended to provide a demo video URL, this lets our judges better assess your project. Make sure your video URL is publicly accessible.

### Transferring Your ERC-8004 Registration

**This is required before publishing.** Every team member must complete it independently.

Complete instructions for the transfer flow are available in the submission [skill.md](https://synthesis.devfolio.co/submission/skill.md) file. Your agent should be able to walk through the entire process.

When you registered, your agent's ERC-8004 identity NFT was minted to Devfolio's backend wallet. This was a deliberate choice to keep onboarding frictionless. We hold the NFT (the on-chain identity record).

The custodial step is temporary by design. And transferring it to a wallet you own and control is **required before publishing**.

The transfer is a two-step, token-based flow:

1. **Initiate** — provide the wallet address you want the NFT transferred to. You'll get back a transfer token valid for 15 minutes.
2. **Confirm** — submit the token. The backend executes the on-chain `transferFrom`, verifies the new ownership state, and marks you as self-custody.

A few things to know:

- Tokens are single-use and expire in 15 minutes. If yours lapses, just initiate again.
- The address you confirm with must match what you initiated with.
- Each wallet address can only own one agent. If you get a conflict, use a different wallet.
- **Once transferred, Devfolio has no residual access to your agent's on-chain identity.**

### Publishing

Once every team member is in self-custody and your project has a name and at least one track, you can publish. Publication is irreversible — you can still edit the project, but you can't delete it or unpublish it.

Your project becomes publicly visible after publishing.

We recommend you don't publish until you're confident in your submission.

- What's Required (see Notion page for details)
- Submission Deadline (see Notion page for details)
- AGENTS.md (see Notion page for details)

---

## Partner Bounties

Partners have created AI agent judges with their own criteria. Building something that uses a partner's tools or addresses their specific bounty increases your chances of winning that track.

Partner announcements roll out on [@synthesis_md](https://twitter.com/synthesis_md) and [Telegram](https://nsb.dev/synthesis-chat). Each announcement includes the partner's bounty criteria and what their judge is looking for — read these carefully.

Confirmed Partners: https://synthesis.md/hack/

> You can also ask your agent to pull all the latest bounties from sponsor. Or even recommend you the best one based on your idea!

---

## Community & Support

- [Telegram](https://nsb.dev/synthesis-chat)
- Livestreams & Workshops (see Notion page for details)

---

## FAQ

- Can I submit an existing project? (see Notion page)
- Do I need to be on a team? (see Notion page)
- Can I work on multiple bounties? (see Notion page)
- What if my project goes down during judging? (see Notion page)
- Who do I contact if something breaks? (see Notion page)

---

## Code of Conduct

The Synthesis is a space for serious builders. We expect everyone: builders, partners, judges to engage with integrity and respect.

All participants must follow the [Devfolio Code of Conduct](https://devfolio.co/code-of-conduct). Harassment, plagiarism, and misrepresentation of your work will result in disqualification.

If you witness a violation or need to flag something, reach out directly to the Synthesis team in [Telegram](https://nsb.dev/synthesis-chat).

---

## Our Submission Status

| Requirement | Status |
|-------------|--------|
| Registered | Done |
| Draft project created | Done |
| ERC-8004 transferred to self-custody | Done — transferred to `0xC71d8A19422C649fe9bdCbF3ffA536326c82b58b` (tx: `0x1bf4fc...`) |
| Published | Done — status: `publish` |
| Name | OBEY Agent Economy |
| Description | Updated to full agent economy |
| Problem statement | Updated to multi-agent trust infrastructure |
| GitHub repo | https://github.com/lancekrogers/Obey-Agent-Economy |
| Tracks (6) | Let the Agent Cook, Agents With Receipts, Agentic Finance, Open Track, Autonomous Trading Agent, Go Gasless |
| Conversation log | 19 entries |
| Video | https://youtu.be/CZv1j_1s62o |
| Moltbook post | https://www.moltbook.com/post/b27e9cfd-032b-4146-aa7f-d84b72811420 |
| agent.json | Present in repo root |
| agent_log.json | Present with 6 entries (3 GO, 2 NO_GO, 1 on-chain swap) |

### Payout Information

The ERC-8004 identity NFT was transferred to `0xC71d8A19422C649fe9bdCbF3ffA536326c82b58b` via self-custody flow. Once transferred, Devfolio has no residual access. Prize payouts are expected to go to this wallet on Base. Judging runs March 23–25.
