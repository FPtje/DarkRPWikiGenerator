#!/bin/bash
rm -r ~/.steam/steam/SteamApps/common/GarrysMod/garrysmod/data/darkrpwiki
read -p "Enter darkrp_generatewiki in gmod console
"

rm -r pages
mkdir pages
cp -r ~/.steam/steam/SteamApps/common/GarrysMod/garrysmod/data/darkrpwiki/* pages


php DarkRPConvert.php
