# PMM Agent

When a PR opens, a GitHub Action runs a Claude agent that:
1. reads the PR diff and works out what changed for customers,
2. triages it into a tier (T0 no impact → T3 major launch),
3. compares against the live Mixpanel website,
4. writes a report row to a Notion database for the product marketing manager.

`app/` is a tiny fake codebase so PRs have something to change. The tier rubric lives in `agent/prompt.md`; edit it to change behavior.

## Setup
1. Create a Notion database with properties: `Name` (title), `Tier` (select: T0–T3), `PR URL` (url), `Status` (select: New, ...).
   Create a Notion integration and share the database with it.
2. Create a GitHub repo and push this folder to `main`.
3. In repo settings, add secrets `ANTHROPIC_API_KEY` and `NOTION_TOKEN`, and variable `NOTION_DATABASE_ID`.
4. Run `demo/make_prs.sh` to open three sample PRs (T0 color change, T2 new feature, T3 pricing change).
