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

#functions
choosetype () {
	echo $basedir/abilities
	ls $basedir/abilities/ | grep [a-z]builder | sed 's/builder//g' | awk '{print NR,$1}'	# Show numbered list of choices for spawns
	echo -n "select one above: [number]:"							# Select a spawn
	read sel_type
	#sel_npc=1
	#echo 1
	buildertype=`(ls $basedir/abilities | grep [a-z]builder | sed 's/builder//g' | awk '{print $1}' | sed "${sel_npc}q;d")`
	echo $buildertype selected.
	echo 
	dir=$basedir/abilities/${buildertype}builder # Base directory for this builder
}
choosenpc () {
	#echo chjoosenpx: $dir
	echo Choose npc:
	ls $dir | grep spawn | sed 's/.*_spawn_//g' | sed 's/\.txt//g' | awk '{print NR,$1}'	# Show numbered list of choices for spawns
	echo -n "select one above: [number]:"							# Select a spawn
	read sel_npc
	#sel_npc=1
	#echo 1
	#npcname=`(ls $dir | grep spawn | sed 's/[_.]/ /g' | awk '{print $3}' | sed "${sel_npc}q;d")`
	npcname=`(ls $dir | grep spawn | sed 's/.*_spawn_//g' | sed 's/\.txt//g' | sed "${sel_npc}q;d")`
	echo -e "${YELLOW}${npcname}${NC}"
	#echo 
}
getstat () {
	grep $1 $dir/$filename | sed 's/"//g' | awk '{print $2}'
}
selectnpc () {
	filename=`(ls $dir/ | grep _$1)`
	#echo selectnpcfunc: filename $filename
}
getAllStats () {
	selectnpc $1
	stats[0]=`(getstat "AbilityGoldCost")`
	stats[1]=`(getstat "food_cost")`
	stats[2]=`(getstat "atk_damage")`
	stats[3]=`(getstat "atk_speed")`
	stats[4]=`(getstat "atk_range")`
	stats[5]=`(getstat "health_tooltip")`
}
printAllStats () {
	for j in {0..5}; do
		echo ${statnames[j]}: ${stats[j]}
	done
}
printUpgradeInfo () {
	#echo
	for i in "$@"; do # Loop through all inputs, ie possible upgrades
		for k in $( seq 1 $rlevel ); do
			echo -n "- "
		done
		echo -e "${GREEN}${i}${NC}"
		selectnpc $i
		getAllStats $i
		#printAllStats

		#Try to recurively list all upgrades
		getPossibleUpgrades $i
		
		#echo
	done
}
getPossibleUpgrades () {
	#Get possible upgrades
	rlevel=$((rlevel+1))
	#echo $rlevel
	towerdir=$basedir/units/${buildertype}builder
	filename=tower_${buildertype}builder_${1}.txt
	#echo getPossibleUpgrades: requested name: $1

	#echo ePU: $1
	#echo $towerdir
	#echo $filename
	#echo $type 
	#echo $buildertype
	# Extract upgrade entries, extract name of upgrade
	# need to separate sed since some _ shoulve be left in
	#at $towerdir/$filename | grep _upgrade_ | sed 's/["]/ /g' | sed "s/${type}builder_upgrade_//g"
	upgradenames=`(cat $towerdir/$filename | grep _upgrade_ | \
		 sed 's/["]/ /g' | sed "s/${buildertype}builder_upgrade_//g"| awk '{print $NF}')`
	if [ -z "$upgradenames" ]; then
		#echo No further upgrades available
		rlevel=$((rlevel-1))
	else
		#echo Possible upgrades:
		printUpgradeInfo $upgradenames
	fi
}

#Set some paths
basedir="game/dota_addons/legion_td/scripts/npc"
#type="human"
statnames=(goldcost foodcost damage atkspeed atkrange health)
rlevel=0

#Get list of possible builds
#if [ $1 == "1" ]
#then

	choosetype
	choosenpc
	#getPossibleUpgrades $npcname

	getPossibleUpgrades $npcname

#fi


