#/usr/bin/env bash
set -e
trap 'echo "❌ Error on line $LINENO: $BASH_COMMAND"' ERR
MAINDIR=/srv/lumen
TODAYS="users$(date +%F).csv"
SETUPFLAG="$MAINDIR/.flag/done.txt"
GREEN='\033[0;32m'
NC='\033[0m'

if
	[[ -f "$SETUPFLAG" ]]; then
	case "$1" in
	--database)
	echo "WIP" && exit 0
	;;
	--reset)
	read -p "this will delete EVERYTHING about lumen, do you wish to proceed?(y/n) > " delete
		case "$delete" in
	
			y|Y|yes|Yes|YES)
			bash /srv/cleaning && exit 5 
			;;
			*)
			echo "exiting!" && exit 1
			;;
		esac
		;;
		*)
		echo "Setup already ran! Run again with these flags to manage:"
		echo "--database: to view/edit the users.csv file" # WIP
		echo "--reset: to delete and recreate everything"  #WIP
			exit 0
			 ;;		
	esac
fi

sudo -v
sudo mkdir -p "$MAINDIR/db" && echo "creating lumen directory..."
sudo mkdir "$MAINDIR/backups"
sudo mkdir "$MAINDIR/.flag"
echo -e "${GREEN}done${NC}"
sleep 1
sudo groupadd lumen && echo "creating dedicated group..."
echo -e "${GREEN}done${NC}"
sudo useradd -g lumen -M -s /usr/bin/nologin lumen && echo "creating dedicated user..."
echo -e "${GREEN}done${NC}"
sleep 1
touch users.csv && sudo mv users.csv "$MAINDIR/db" && echo "creating database..."
echo -e "${GREEN}done${NC}"

echo "ID,Name,Profession" | sudo tee "$MAINDIR/db/users.csv" && echo "adding basic template to users.csv"
echo -e "${GREEN}done${NC}"

touch $TODAYS && sudo mv "$TODAYS" "$MAINDIR/backups"
sleep 1
sudo chown -R lumen:lumen /srv/lumen && echo "finishing config..."
touch "done.txt" && sudo mv "done.txt" "$SETUPFLAG"
echo -e "${GREEN}done${NC}"

read -p "setup finished! Type 'database' to manage users.  > " FLAVOUR # WIP

case $FLAVOUR in
	database|--database|Database|DATABASE)
	echo "work in progress, thank you for your time!"
;;
	*)
	echo "uh oh, option not found, exiting!"
	exit 1
;;
esac
