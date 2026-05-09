#!/bin/bash
# Cyber Daily Intel — Daily GitHub Activity Automation
# Runs via cron, randomly picks 2-3 actions per day
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.env"

cd "${REPO_DIR}"
git pull --rebase --quiet origin master 2>/dev/null || true

TODAY=$(date +%Y-%m-%d)
DAY_OF_WEEK=$(date +%u)  # 1=Mon, 7=Sun
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

log() { echo "[${TIMESTAMP}] $1"; }

# ─── Randomized Content Pools ────────────────────────────────────────

CATEGORIES=(
  "Vulnerability Disclosure"
  "Ransomware Update"
  "Data Breach"
  "Regulatory"
  "Tool Release"
  "Threat Intelligence"
  "Zero-Day Alert"
  "Supply Chain Attack"
  "APT Campaign"
  "Cloud Security"
  "IoT Security"
  "AI Security"
  "Malware Analysis"
  "Phishing Campaign"
  "Patch Tuesday"
)

COMPONENTS=(
  "Apache Struts" "Microsoft Exchange" "Fortinet FortiGate" "Cisco IOS XE"
  "VMware vCenter" "Palo Alto PAN-OS" "Citrix NetScaler" "SolarWinds Orion"
  "Ivanti Connect Secure" "F5 BIG-IP" "Atlassian Confluence" "Jenkins CI"
  "WordPress" "Kubernetes API" "OpenSSL" "Log4j" "Spring Framework"
  "Redis" "PostgreSQL" "Nginx" "Docker Engine" "GitLab CE"
  "Grafana" "Elasticsearch" "MongoDB" "RabbitMQ" "Terraform"
)

THREAT_GROUPS=(
  "Lazarus Group" "APT29 (Cozy Bear)" "APT28 (Fancy Bear)" "Conti"
  "REvil" "BlackCat/ALPHV" "LockBit 3.0" "Cl0p" "Royal Ransomware"
  "Scattered Spider" "Volt Typhoon" "Sandworm" "Turla" "Kimsuky"
  "FIN7" "TA505" "Mustang Panda" "OceanLotus" "Charming Kitten"
)

SECTORS=(
  "healthcare" "financial services" "critical infrastructure" "education"
  "government" "defense" "energy" "telecommunications" "retail"
  "manufacturing" "transportation" "technology" "media" "legal"
)

FRAMEWORKS=(
  "NIST CSF 2.0" "PCI DSS v4.0.1" "ISO 27001:2022" "SOC 2 Type II"
  "HIPAA" "GDPR" "CCPA" "DORA" "NIS2 Directive" "CIS Controls v8"
  "MITRE ATT&CK v14" "OWASP Top 10 2025" "FedRAMP Rev5" "CMMC 2.0"
)

TOOLS=(
  "Nuclei v4" "Burp Suite 2026" "Metasploit 7" "Nmap 8" "Wireshark 5"
  "Ghidra 12" "Volatility 4" "YARA 5" "Sigma Rules v2" "Trivy"
  "Falco" "Caldera 5" "BloodHound CE" "Velociraptor" "TheHive 6"
  "MISP" "OpenCTI" "Wazuh 5" "Suricata 8" "Zeek 7"
)

COMPANIES=(
  "Acme Corp" "GlobalTech Solutions" "MedSecure Health" "FinanceFirst Bank"
  "CloudNova Inc" "DataStream Analytics" "SecureNet Systems" "TechVault"
  "CyberShield Corp" "NexGen Telecom" "SmartGrid Energy" "EduConnect"
)

TAKEAWAYS=(
  "Patch management remains the #1 priority for reducing attack surface"
  "Zero-trust architecture adoption continues to accelerate across enterprises"
  "Supply chain attacks are becoming more sophisticated and harder to detect"
  "AI-powered threat detection is showing promising results in SOC operations"
  "Incident response plans should be tested quarterly at minimum"
  "MFA bypass techniques are evolving — consider phishing-resistant MFA"
  "Cloud misconfigurations remain a top cause of data breaches"
  "Ransomware groups are increasingly targeting backup infrastructure"
  "Threat intelligence sharing between organizations is critical"
  "Security awareness training should include deepfake and AI-generated content"
  "Network segmentation significantly reduces lateral movement risk"
  "Endpoint detection and response (EDR) coverage gaps are being exploited"
  "API security testing should be part of every CI/CD pipeline"
  "Identity is the new perimeter — invest in IAM solutions"
  "Regular purple team exercises improve detection capabilities"
)

# ─── Helper Functions ────────────────────────────────────────────────

rand_element() {
  local arr=("$@")
  echo "${arr[$((RANDOM % ${#arr[@]}))]}"
}

rand_range() {
  echo $(( $1 + RANDOM % ($2 - $1 + 1) ))
}

generate_news_file() {
  local date=$1
  local file="${REPO_DIR}/news/${date}.md"
  mkdir -p "${REPO_DIR}/news"

  local cat1=$(rand_element "${CATEGORIES[@]}")
  local cat2=$(rand_element "${CATEGORIES[@]}")
  local cat3=$(rand_element "${CATEGORIES[@]}")
  local cat4=$(rand_element "${CATEGORIES[@]}")
  local cat5=$(rand_element "${CATEGORIES[@]}")

  local comp=$(rand_element "${COMPONENTS[@]}")
  local group=$(rand_element "${THREAT_GROUPS[@]}")
  local sector=$(rand_element "${SECTORS[@]}")
  local company=$(rand_element "${COMPANIES[@]}")
  local framework=$(rand_element "${FRAMEWORKS[@]}")
  local tool=$(rand_element "${TOOLS[@]}")
  local num=$(rand_range 10000 5000000)

  local t1=$(rand_element "${TAKEAWAYS[@]}")
  local t2=$(rand_element "${TAKEAWAYS[@]}")
  local t3=$(rand_element "${TAKEAWAYS[@]}")

  cat > "${file}" <<EOF
# Cybersecurity Daily Brief — ${date}

## Top 5 News

1. **[${cat1}]** — A critical vulnerability was discovered in ${comp}, allowing remote code execution. CVSS score: $(rand_range 7 10).$(rand_range 0 9). Patches are available.
2. **[${cat2}]** — Threat group ${group} launched a targeted campaign against ${sector} organizations using novel TTPs mapped to MITRE ATT&CK.
3. **[${cat3}]** — ${company} disclosed a data breach affecting approximately ${num} user records. Investigation is ongoing with law enforcement involved.
4. **[${cat4}]** — New compliance guidance released under ${framework}. Organizations have 90 days to assess and align with updated requirements.
5. **[${cat5}]** — Security researchers released ${tool} with significant detection improvements. Community adoption is growing rapidly.

---

### Key Takeaways
- ${t1}
- ${t2}
- ${t3}

---
*Auto-generated by [cyber-daily-intel](https://github.com/hackersatyamrastogi/cyber-daily-intel) on ${date}*
EOF
  echo "${file}"
}

# ─── Action Functions ────────────────────────────────────────────────

action_commit() {
  log "ACTION: commit"
  local file=$(generate_news_file "${TODAY}")
  git add "${file}"
  # Handle re-runs: if file unchanged, nothing to commit
  if git diff --cached --quiet 2>/dev/null; then
    log "  No changes to commit (file already up-to-date)"
    return 0
  fi
  local hour=$(date +%H)
  local msgs=(
    "intel: daily cybersecurity brief for ${TODAY}"
    "intel: update threat intelligence — ${TODAY}"
    "intel: add security news digest ${TODAY}"
    "intel: cybersec brief ${TODAY} — evening update"
  )
  local msg=$(rand_element "${msgs[@]}")
  git commit -m "${msg}

- Top 5 security news and threat intelligence
- Key takeaways and recommendations"
  git push origin master
  log "  Committed and pushed ${file}"
}

action_pr() {
  log "ACTION: pull-request"
  local run_id=$((RANDOM % 9999))
  local branch="update/roundup-${TODAY}-${run_id}"
  git checkout -b "${branch}" 2>/dev/null || {
    log "  Branch collision — skipping PR"
    return 0
  }

  # Create a weekly summary file
  local week_num=$(date +%V)
  local summary_file="${REPO_DIR}/news/week-${week_num}-summary.md"
  cat > "${summary_file}" <<EOF
# Weekly Cybersecurity Roundup — Week ${week_num} (${TODAY})

## Overview
This week saw continued activity across multiple threat verticals.
Key themes include $(rand_element "${CATEGORIES[@]}") and $(rand_element "${CATEGORIES[@]}").

## Notable Threat Actors
- $(rand_element "${THREAT_GROUPS[@]}") — Active targeting of ${SECTORS[$((RANDOM % ${#SECTORS[@]}))]}
- $(rand_element "${THREAT_GROUPS[@]}") — New TTPs observed in the wild

## Recommendations
- $(rand_element "${TAKEAWAYS[@]}")
- $(rand_element "${TAKEAWAYS[@]}")

---
*Weekly roundup auto-generated on ${TODAY}*
EOF

  git add "${summary_file}"
  git commit -m "intel: weekly roundup for week ${week_num}"
  git push origin "${branch}"

  local pr_url
  pr_url=$(gh pr create \
    --title "Weekly Cybersecurity Roundup — Week ${week_num}" \
    --body "## Summary
- Aggregated threat intelligence for week ${week_num}
- Notable threat actor activity and TTPs
- Updated recommendations

*Auto-generated weekly roundup*" \
    --base master \
    --head "${branch}" 2>&1)

  log "  Created PR: ${pr_url}"

  # 50% chance to auto-merge
  if (( RANDOM % 2 == 0 )); then
    sleep 2
    gh pr merge "${pr_url}" --merge --delete-branch 2>/dev/null || true
    git checkout master
    git pull --rebase --quiet origin master 2>/dev/null || true
    log "  Auto-merged PR"
  else
    git checkout master
    log "  PR left open for review"
  fi
}

action_issue() {
  log "ACTION: issue"
  local component=$(rand_element "${COMPONENTS[@]}")
  local group=$(rand_element "${THREAT_GROUPS[@]}")
  local cvss="$(rand_range 7 10).$(rand_range 0 9)"

  local issue_url
  issue_url=$(gh issue create \
    --title "[${TODAY}] Threat Alert: ${component} vulnerability — CVSS ${cvss}" \
    --body "## Threat Summary

**Date:** ${TODAY}
**Component:** ${component}
**CVSS Score:** ${cvss}
**Threat Actor:** ${group} (suspected)

## Details
A critical vulnerability has been identified in ${component}. This issue tracks our assessment and response.

## Action Items
- [ ] Review vendor advisory
- [ ] Assess exposure in our environment
- [ ] Apply patches or mitigations
- [ ] Update threat intelligence feeds
- [ ] Monitor for exploitation attempts

## References
- MITRE ATT&CK mapping pending
- CVE assignment pending

---
*Auto-generated threat alert*" \
    --label "" 2>&1 || \
  gh issue create \
    --title "[${TODAY}] Threat Alert: ${component} vulnerability — CVSS ${cvss}" \
    --body "## Threat Summary

**Date:** ${TODAY}
**Component:** ${component}
**CVSS Score:** ${cvss}

## Action Items
- [ ] Review vendor advisory
- [ ] Assess exposure
- [ ] Apply patches

*Auto-generated threat alert*" 2>&1)

  log "  Created issue: ${issue_url}"
}

action_review() {
  log "ACTION: code-review"
  # Find the most recent open PR
  local pr_number
  pr_number=$(gh pr list --state open --limit 1 --json number --jq '.[0].number' 2>/dev/null)

  if [[ -z "${pr_number}" || "${pr_number}" == "null" ]]; then
    log "  No open PRs to review — skipping"
    return 0
  fi

  local review_comments=(
    "Looks good. The threat intelligence data aligns with current OSINT feeds. Consider adding STIX/TAXII format support in the future."
    "LGTM. The weekly aggregation captures the key themes. Suggest we cross-reference with our SIEM alert data next time."
    "Reviewed — content is accurate and well-structured. The MITRE ATT&CK mappings would be a valuable addition."
    "Approve. Good coverage of the threat landscape this week. Recommend we add severity ratings to the weekly format."
    "Solid roundup. The threat actor tracking is particularly useful. Consider adding IOC hashes in future briefs."
  )

  local comment=$(rand_element "${review_comments[@]}")

  gh pr review "${pr_number}" --approve --body "${comment}" 2>/dev/null || \
    gh pr comment "${pr_number}" --body "${comment}" 2>/dev/null || true

  log "  Reviewed PR #${pr_number}"
}

action_discussion() {
  log "ACTION: discussion"
  local group=$(rand_element "${THREAT_GROUPS[@]}")
  local sector=$(rand_element "${SECTORS[@]}")
  local category_id="${DISCUSSION_CATEGORY_GENERAL}"

  # Alternate between General and Ideas categories
  if (( RANDOM % 2 == 0 )); then
    category_id="${DISCUSSION_CATEGORY_IDEAS}"
  fi

  local title="[${TODAY}] Threat Intel Discussion: ${group} activity in ${sector}"
  local takeaway1=$(rand_element "${TAKEAWAYS[@]}")
  local takeaway2=$(rand_element "${TAKEAWAYS[@]}")
  local body="## Discussion Topic\n\nRecent intelligence suggests **${group}** has increased operations targeting the **${sector}** sector.\n\n### Key Observations\n- New TTPs observed that don't match previous campaigns\n- ${takeaway1}\n- ${takeaway2}\n\n### Questions for the Team\n1. Are we seeing similar indicators in our environment?\n2. Should we update our detection rules?\n3. What compensating controls should we prioritize?\n\n---\n*Auto-generated discussion prompt — ${TODAY}*"

  # Use -F for variables to avoid GraphQL string escaping issues
  gh api graphql \
    -F repositoryId="${REPO_NODE_ID}" \
    -F categoryId="${category_id}" \
    -F title="${title}" \
    -F body="${body}" \
    -f query='
    mutation($repositoryId: ID!, $categoryId: ID!, $title: String!, $body: String!) {
      createDiscussion(input: {
        repositoryId: $repositoryId,
        categoryId: $categoryId,
        title: $title,
        body: $body
      }) {
        discussion { url }
      }
    }' 2>/dev/null || log "  Discussion creation failed (may need write:discussion scope)"

  log "  Created discussion: ${title}"
}

# ─── Main: Random Action Selection ──────────────────────────────────

# Random jitter: sleep 0-MAX_JITTER_MINUTES before doing anything
if [[ "${1:-}" != "--no-jitter" ]]; then
  JITTER=$(( RANDOM % (MAX_JITTER_MINUTES * 60) ))
  log "=== Cyber Daily Intel — ${TODAY} === (sleeping ${JITTER}s jitter)"
  sleep "${JITTER}"
else
  log "=== Cyber Daily Intel — ${TODAY} === (no-jitter mode)"
fi

# Re-read time after jitter sleep
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Build weighted action pool
ACTIONS=()
(( RANDOM % 100 < COMMIT_WEIGHT )) && ACTIONS+=("commit")
(( RANDOM % 100 < PR_WEIGHT )) && ACTIONS+=("pr")
(( RANDOM % 100 < ISSUE_WEIGHT )) && ACTIONS+=("issue")
(( RANDOM % 100 < REVIEW_WEIGHT )) && ACTIONS+=("review")
(( RANDOM % 100 < DISCUSSION_WEIGHT )) && ACTIONS+=("discussion")

# Ensure at least MIN_ACTIONS
if (( ${#ACTIONS[@]} < MIN_ACTIONS )); then
  # Always include commit as fallback
  ACTIONS=("commit")
  # Add one more random action
  ALL=("pr" "issue" "review" "discussion")
  ACTIONS+=("$(rand_element "${ALL[@]}")")
fi

# Cap at MAX_ACTIONS
if (( ${#ACTIONS[@]} > MAX_ACTIONS )); then
  # Shuffle and take first MAX_ACTIONS
  ACTIONS=($(printf '%s\n' "${ACTIONS[@]}" | shuf | head -n "${MAX_ACTIONS}"))
fi

log "Selected actions: ${ACTIONS[*]}"

# Execute selected actions
for action in "${ACTIONS[@]}"; do
  case "${action}" in
    commit)     action_commit ;;
    pr)         action_pr ;;
    issue)      action_issue ;;
    review)     action_review ;;
    discussion) action_discussion ;;
  esac
done

log "=== Done ==="
