#!/bin/bash

#types available:
# ability_building.txt
# assassinbuilder
# builder_invulnerable.txt
# elementalbuilder
# food_building
# humanbuilder
# main_building
# naturebuilder
# randombuilder
# spiritbuilder
# undeadbuilder

# Variables of Interest
# Gold cost
# Food cost
# attack damage
# attack rate
# attack range
# health
# armor

# possible upgrades
# dps

# Colors
#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

#Definitions
GREEN='\033[0;32m'
BLUE='\034[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


basedir=infofiles
spawndir=$basedir/unitinfo
npcdir=$basedir/upgradeinfo

builder=$1

if [ "$#" == 2 ]; then
	npc=$2
	#echo "$npc ::: "
	echo -n "| "
	grep bility[0-9]. $npcdir/${builder}builder/tower_${builder}builder_${npc}.txt \
		| grep -v sell | grep -v _upgrade_ | grep -v _empty_ \
		| awk '{print $2}' | sed 's/"//g' | tr '\n' ' '
	echo
else
	npcs=`( cat ${builder}list.txt )`
	#echo $npcs

	for npc in $npcs; do
		echo "$npc ::: "
		echo -n "| "
		grep bility[0-9]. $npcdir/${builder}builder/tower_${builder}builder_${npc}.txt \
			| grep -v sell | grep -v _upgrade_ | grep -v _empty_ \
			| awk '{print $2}' | sed 's/"//g' | tr '\n' ' '
		echo
	done
fi
#list above finds eg agressive_boar_nethertoxin

#	echo -n "| "
#	grep bility[1-4] $npcdir/${builder}builder/tower_${builder}builder_${npc}.txt \
#		| grep -v sell | grep -v _upgrade_ | grep -v _empty_ \
#		| awk '{print $2}' | sed 's/"//g' | tr '\n' ' '
#	echo