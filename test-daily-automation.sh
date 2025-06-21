#!/bin/bash
# Test daily automation by temporarily changing the day of week check
set -euo pipefail

cd "/Users/satyamrastogi/manisha-cyber-intel"

echo "🧪 Testing daily automation (forcing weekday mode)..."

# Temporarily modify daily script to bypass weekend check
sed -i.backup 's/if \[\[ $DAY_OF_WEEK -ge 6 \]\]/if false/' daily-auto-commit.sh

# Run the automation
./daily-auto-commit.sh

# Restore original script
mv daily-auto-commit.sh.backup daily-auto-commit.sh

echo "✅ Daily automation test completed!"