#!/usr/bin/env bash

# This script ensures that a daily cron job exists
# to export the current VSCode extensions list to your repo.

CRON_JOB="0 9 * * * /usr/local/bin/code --list-extensions > ~/my-setup/vscode/extensions.txt"

# Get current crontab (if any)
CURRENT_CRON=$(crontab -l 2>/dev/null)

# Check if our job is already in the crontab
if echo "$CURRENT_CRON" | grep -Fq "$CRON_JOB"; then
  echo "✅ VSCode extensions export cron job already exists."
else
  # Append the job to the existing crontab
  (echo "$CURRENT_CRON"; echo "$CRON_JOB") | crontab -
  echo "🕘 Added daily VSCode extensions export cron job (runs at 9:00 AM)."
fi
