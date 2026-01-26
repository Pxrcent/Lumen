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
# checks if the data input matches the database, if so then confirm the registry  
if 
grep -Fqi "$FIELDOUT" /srv/lumen/db/users.csv; then

	echo -e  "$FIELDOUT \ $(date +%T)" >> "$MORNINGFILE" && zenity --info --title="Registered!" --text="you can close this window" 2> /dev/null
else
    zenity --error --title="User data not found!" --text="Please contact your supervisor" 2> /dev/null
fi
