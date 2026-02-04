#!/usr/bin/env bash

#####
#fieldout -> stdout of a GUI asking for data
#todays -> the file of the day
#morningfile -> the path to the file of the day	
#####
FIELDOUT=$(zenity --forms --title="Registro de chegada" --add-entry="ID" --add-entry="First Name" --add-entry="Profession" --separator="," 2> /dev/null) 
TODAYS="users$(date +%F).csv"
MORNINGFILE="/srv/lumen/backups/$TODAYS"

# conditition to check if the GUI has been canceled
if
 [[ -z "$FIELDOUT" ]]; then
 zenity --error --text="Operation cancelled!" 2> /dev/null
 exit 1
fi

# Extract ID (everything before first comma)
ID="${FIELDOUT%%,*}"
# Extract rest (everything after first comma)
REST="${FIELDOUT#*,}"
# Hash only the ID
HASH=$(printf '%s' "$ID" | openssl dgst -sha256 | awk '{print $2}')
# Rebuild line in CSV format
CHECKLINE="$HASH,$REST"

# Compare whole line
if grep -Fqi "$CHECKLINE" /srv/lumen/db/users.csv; then
  echo "$CHECKLINE \ $(date +%T)" >> "$MORNINGFILE"
  zenity --info --title="Registered!" --text="you can close this window" 2> /dev/null
else
  zenity --error --title="User data not found!" --text="Please contact your supervisor" 2> /dev/null
fi
