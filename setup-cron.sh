#!/bin/bash
# Alternative cron setup if launchd doesn't work

echo "Setting up cron job for daily contributions..."

# Create cron entry
(crontab -l 2>/dev/null; echo "0 10 * * * cd /Users/satyamrastogi/manisha-cyber-intel && ./daily-auto-commit.sh >> automation.log 2>&1") | crontab -

echo "✅ Cron job installed - daily execution at 10 AM"
echo "🔍 Check with: crontab -l"
echo "📋 Remove with: crontab -r"
