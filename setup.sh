#/usr/bin/env bash
set -e
trap 'echo "❌ Error on line $LINENO: $BASH_COMMAND"' ERR
MAINDIR=/srv/lumen
TODAYS="users$(date +%F).csv"
SETUPFLAG="$MAINDIR/.flag/done.txt"
GN='\033[0;32m'
YW='\033[0;33m'
CN='\033[0;36m'
PP='\033[0;35m'
NC='\033[0m'
######################################################################################
if
	[[ -f "$SETUPFLAG" ]]; then
	case "$1" in
	--database)
	printf "%b\n" "${PP}WIP${NC}" && exit 0
	;;
	--reset)
	read -p "this will delete EVERYTHING about lumen, do you wish to proceed?(y/N) > " delete
		case "$delete" in	
			y|Y|yes|Yes|YES)
			sudo -v
			 sudo rm -rf /srv/lumen && echo "directory removed"
			 sudo userdel Lumen && echo "user and group deleted"
			 sudo groupdel lumain 2> /dev/null
			 sudo groupdel lumuser 2> /dev/null 
			 echo "cleaning finished"
			 exit 5 
			;;
			*)
			printf "%b\n" "${PP}exiting!${NC}" && exit 1
			;;
		esac
		;;
		*)
		printf "%b\n" "${PP}Setup already ran! Run again with these flags to manage:${NC}"
		printf "%b\n" "${YW}--database: to view/edit the users.csv file${NC}" # WIP
		printf "%b\n" "${YW}--reset: to delete and recreate everything${NC}"  #WIP
			exit 0
			 ;;		
	esac
fi
######################################################################################
sudo -v
sudo mkdir -p "$MAINDIR/db" && printf "%b\n" "${CN}creating lumen directory...${NC}"
sudo mkdir "$MAINDIR/backups"
sudo mkdir "$MAINDIR/.flag"
touch "$HOME/done.txt" && echo "#" > "$HOME/done.txt" && sudo mv "$HOME/done.txt" "$SETUPFLAG"
printf "%b\n" "${GN}done${NC}"
sleep 1
######################################################################################
sudo groupadd lumuser
sudo groupadd lumain && printf "%b\n" "${CN}creating dedicated group...${NC}"
sleep 1
printf "%b\n" "${GN}done${NC}"
######################################################################################
sudo useradd -g lumain -M -s /usr/bin/nologin Lumen && printf "%b\n" "${CN}creating dedicated user...${NC}"
printf "%b\n" "${GN}done${NC}"
sleep 1
######################################################################################
touch users.csv && sudo mv users.csv "$MAINDIR/db" && printf "%b\n" "${CN}creating database...${NC}"
sleep 1
printf "%b\n" "${GN}done${NC}"
######################################################################################
echo "ID,Name,Profession" | sudo tee "$MAINDIR/db/users.csv" && printf "%b\n" "${CN}adding basic template to users.csv ${NC}"
touch "$TODAYS" && sudo mv "$TODAYS" "$MAINDIR/backups"
sleep 1
printf "%b\n" "${GN}done${NC}"
######################################################################################
sudo cp "auth.sh" "$MAINDIR"										# fix later
sudo cp "setup.sh" "$MAINDIR" && printf "%b\n" "${CN}moving files to lumen directory...${NC}" # fix later
sudo cp "project.json" "$MAINDIR"									# fix later
sleep 2
printf "%b\n" "${GN}done${NC}"
######################################################################################
 sudo chmod 750 "$MAINDIR/auth.sh" && echo "setting permissions..."	# r-x
 sudo chmod 770 "$MAINDIR/setup.sh"									# r-w-x
 sudo chmod 770 "$MAINDIR/project.json"								# r-w-x
 sudo chmod 710 "$MAINDIR/db"											# x
 sudo chmod +w "$MAINDIR/db/users.csv"									# w
 sudo chmod 730 "$MAINDIR/backups"										# w-x
 sudo chown Lumen:lumuser "$MAINDIR/db"								# user-able
 sudo chown Lumen:lumain "$MAINDIR/db/users.csv"						# adm-owned
 printf "%b\n" "${GREEN}done${NC}"
sleep 1
######################################################################################
read -p "do you wish to add $USER to the LUMUSER(user) group? Y/n > " PERM
case "$PERM" in
	n|N|no|No|NO)
	printf "%b\n" "${YW}skipping...${NC}" ;;
	*)
	sudo usermod -aG lumuser $USER && printf "%b\n" "${YW}added successfuly${NC}";;
esac
read -p "do you wish to add $USER to the LUMAIN(admin) group? y/N > " SPERM
case "$SPERM" in
	y|Y|yes|Yes|YES)
	sudo usermod -aG lumain $USER && printf "%b\n" "${YW}added successfuly${NC}" ;;
	*)
	printf "%b\n" "${YW}NO ADMIN USER SET!!!${NC}"
	printf "%b\n" "${YW}skipping...${NC}" ;;
esac	
sleep 2
######################################################################################
echo " "
sudo chown -R Lumen:lumain "$MAINDIR" && echo "finishing config..."
sudo chown Lumen:lumuser "$MAINDIR/auth.sh"
sudo chown Lumen:lumuser "$MAINDIR/db/users.csv" 
sleep 2
printf "%b\n" "${GN}done${NC}"
######################################################################################
read -p "setup finished! A reboot is recommended. Type 'database' to manage users.  > " FLAVOUR # WIP
case $FLAVOUR in
	database|--database|Database|DATABASE)
	printf "%b\n" "${PP}work in progress, thank you for your time!${NC}"
;;
	sybau|--sybau)
	printf "%b\n" "${YW}NUKING!!!!!!!!!!!${NC}" && bash "/srv/cleaning"
;;
	*)
	printf "%b\n" "${YW}uh oh, option not found, exiting!${NC}"
	exit 1
;;
esac
######################################################################################
