# Cyber Daily Intel

Automated daily cybersecurity intelligence briefings.

## What This Does

Every day, this automation generates a cybersecurity news briefing and contributes it to this repository through various GitHub activities:

- **Commits** — Daily markdown files with top 5 cybersecurity news
- **Pull Requests** — Feature branches with weekly roundups
- **Issues** — Tracking emerging threats and vulnerabilities
- **Code Reviews** — Reviewing and discussing daily briefs
- **Discussions** — Community-style threat intelligence sharing

## Structure

```
news/
  2026-04-03.md    # Daily briefing files
  ...
templates/
  daily-news.md    # Template for daily files
```

## Automation

Runs daily via cron on a remote server. Actions are randomly selected each day to simulate organic contribution patterns.
