rm -r ~/.local/share/Steam/SteamApps/common/GarrysMod/garrysmod/data/darkrpwiki
read -p "Enter darkrp_generatewiki in gmod console
"

rm -r pages
mkdir pages
cp -r ~/.local/share/Steam/SteamApps/common/GarrysMod/garrysmod/data/darkrpwiki/* pages

read -p "Press [Enter] to run the upload script
"
php DarkRPConvert.php