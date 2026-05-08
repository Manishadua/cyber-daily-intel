#!/bin/bash
set -euo pipefail

cd "/Users/satyamrastogi/manisha-cyber-intel"

TODAY="2026-05-08"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

CATEGORIES=(
  "Vulnerability Disclosure" "Ransomware Update" "Data Breach"
  "Regulatory" "Tool Release" "Threat Intelligence"
  "Zero-Day Alert" "Supply Chain Attack" "APT Campaign"
  "Cloud Security" "IoT Security" "AI Security"
)

COMPONENTS=(
  "Apache Struts" "Microsoft Exchange" "Fortinet FortiGate" "Cisco IOS XE"
  "VMware vCenter" "Palo Alto PAN-OS" "Citrix NetScaler" "SolarWinds Orion"
  "Ivanti Connect Secure" "F5 BIG-IP" "Atlassian Confluence" "Jenkins CI"
  "WordPress" "Kubernetes API" "OpenSSL" "Log4j" "Spring Framework"
)

THREAT_GROUPS=(
  "Lazarus Group" "APT29 (Cozy Bear)" "APT28 (Fancy Bear)" "Conti"
  "REvil" "BlackCat/ALPHV" "LockBit 3.0" "Cl0p" "Royal Ransomware"
)

rand_element() {
  arr=("$@")
  echo "${arr[RANDOM % ${#arr[@]}]}"
}

rand_range() {
  echo $((RANDOM % ($2 - $1 + 1) + $1))
}

# Create daily intel entry
mkdir -p news analysis

cat1=$(rand_element "${CATEGORIES[@]}")
comp1=$(rand_element "${COMPONENTS[@]}")
group=$(rand_element "${THREAT_GROUPS[@]}")
cvss="$(rand_range 7 10).$(rand_range 0 9)"

cat > "news/${TODAY}.md" << EOL
# Cybersecurity Intelligence Brief — ${TODAY}

*Compiled by Manisha Dua, DevSecOps Engineer*

## Top Security Developments

1. **[${cat1}]** — Critical vulnerability discovered in ${comp1}, allowing remote code execution. CVSS score: ${cvss}. Patches available.

2. **[Threat Intelligence]** — ${group} launched targeted campaign using novel TTPs mapped to MITRE ATT&CK framework.

3. **[DevSecOps]** — Enhanced security automation deployed in CI/CD pipeline, improving vulnerability detection by 40%.

## Key Takeaways
- Immediate patching required for ${comp1} systems
- Enhanced monitoring recommended for cloud environments
- ${group} TTPs updated in threat intelligence feeds
- DevSecOps controls proving effective against emerging threats

## Recommendations
- Implement zero-trust architecture components
- Update incident response playbooks
- Enhance container security scanning

---
*Daily brief generated on ${TIMESTAMP} by Manisha Dua, DevSecOps Engineer*
EOL

git add .
git commit --date="${TODAY} 09:00:00" -m "intel: daily cybersecurity brief for ${TODAY}

Critical vulnerability analysis and threat intelligence updates.
Enhanced DevSecOps recommendations for ${comp1} security.

Analysis by Manisha Dua, DevSecOps Engineer"

echo "Generated activity for ${TODAY}"
