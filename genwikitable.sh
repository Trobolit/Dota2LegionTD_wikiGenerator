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
BLUE='\034[0;32m
Y'ELLOW='\033[1;33m'
NC='\033[0m' # No Color

#functions
choosetype () {
	echo $basedir/abilities
	echo
	ls $basedir/abilities/ | grep [a-z]builder | sed 's/builder//g' | awk '{print NR,$1}'	# Show numbered list of choices for spawns
	echo
	echo -n "select one above: [number]:"							# Select a spawn
	read sel_type
	#sel_npc=1
	#echo 1
	#ls $basedir/abilities | grep [a-z]builder | sed 's/builder//g' | awk '{print $sel_type}' 
	
	buildertype=`(ls $basedir/abilities | grep [a-z]builder | sed 's/builder//g' | awk '{print $1}' | sed "${sel_type}q;d")`
	echo $buildertype selected.
	echo 
	dir=$basedir/abilities/${buildertype}builder # Base directory for this builder
}
settype () {

	buildertype=$1
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
setnumnpcs () {
	numnpcs=`(ls $dir | grep spawn | sed 's/.*_spawn_//g' | sed 's/\.txt//g' | wc -l )`	
}
iteratenpc () {
	setnumnpcs
	for n in $( seq 1 $numnpcs ); do
		rlevel=0
		ccost=0
		totcost=$ccost
		fcost=0
		totfcost=$fcost
		sel_npc=$n
		npcname=`(ls $dir | grep spawn | sed 's/.*_spawn_//g' | sed 's/\.txt//g' | sed "${sel_npc}q;d")`
		
		getAllStats $npcname
		ccost=${stats[0]}
		totcost=$ccost
		fcost=${stats[1]}
		totfcost=$fcost
		#let totcost=totcost+ccost

		#echo -e "${YELLOW}${npcname}${NC} $ccost"
		#echo -e "!rowspan=\"1\"|${YELLOW}${npcname}${NC}"
		echo "!rowspan=\"1\"|${npcname}"
		printAllStats
		getPossibleUpgrades $npcname
	done
}
getstat () {
	#echo "$1 --- $dir   /  $filename"
	grep $1 $dir/$filename | sed 's/"//g' | awk '{print $2}'
}
getstat2 () {
	grep $1 $dir/$filename | sed 's/"//g' | awk '{print $2}'
}
selectnpc () {
	#echo $1
	npcname=$1
	filename=`(ls $dir/ | grep -e upgrade_$1.txt -e spawn_$1.txt -- )` # the dot matches any character, but thats fine.
	#echo $filename
	#echo selectnpcfunc: filename: $filename
}
getAllStats () {
	#echo hey $1
	selectnpc $1
	# Something wierd is going on when saving to array, the sed remoes carriage return which eliminates the problem.
	stats[0]=`(getstat "AbilityGoldCost" | sed 's/\r//g')`
	stats[1]=`(getstat "food_cost" | sed 's/\r//g')`
	stats[2]=`(getstat "atk_damage" | sed 's/\r//g')`
	stats[3]=`(getstat "atk_speed" | sed 's/\r//g')`
	stats[4]=`(getstat "atk_range" | sed 's/\r//g')`
	stats[5]=`(getstat "health_tooltip" | sed 's/\r//g')`
	stats[6]=`(getstat "armor_tooltip" | sed 's/\r//g')`


	#for it in {0..5}; do
	#	echo ${stats[it]}
	#done
}
printAllStats () {
	#for j in {0..5}; do
	#	echo ${statnames[j]}: ${stats[j]}
	#done
	echo "| ${stats[0]}"	# Gold
	echo "| $totcost"		# acc gold
	echo "| ${stats[1]}"	# food
	echo "| $totfcost"		# acc food
	echo "| ${stats[5]}"	# hp
	echo "| ${stats[2]}"	# dmg
	echo "| ${stats[3]}"	# speed
	echo "| ${stats[4]}"	# range
	echo "| ${stats[6]}"	# armor
	echo "| "				# AOE
	echo "| "				# Healing
	./getabilities.sh $buildertype $npcname
	echo "|-"

}
printAllStatsPretty () {
	#for j in {0..5}; do
	#	echo ${statnames[j]}: ${stats[j]}
	#done
	echo ${statnames[0]}: ${stats[0]} 	# gold
	echo ${statnames[1]}: ${stats[1]} 	# food
	echo ${statnames[5]}: ${stats[5]} 	# HP
	echo ${statnames[2]}: ${stats[2]}	# DMG
	echo ${statnames[3]}: ${stats[3]}	# spd
	echo ${statnames[4]}: ${stats[4]}	# range
	echo ${statnames[6]}: ${stats[6]}	# armor
}
printStat () {
	#echo ${statnames[$1]}: ${stats[$1]}
	echo " ${stats[$1]}"
}
printUpgradeInfo () {
	#echo $@
	for i in "$@"; do # Loop through all inputs, ie possible upgrades
		#for k in $( seq 1 $rlevel ); do
		#	echo -n "- "
		#done

		selectnpc $i
		getAllStats $i
		
		ccost=${stats[0]}
		let totcost=totcost+ccost
		fcost=${stats[1]}
		let totfcost=totfcost+fcost
		#echo -e "|rowspan=\"1\"|${GREEN}${i}${NC} $ccost $totcost" 
		echo -n -e "|rowspan=\"1\"|"
		for k in $( seq 1 $rlevel ); do
			echo -n "- "
		done
		#echo -e "${GREEN}${i}${NC}" #$ccost $totcost" 
		echo "${i}" 
		
		printAllStats
		#printStat 2


		#echo -e "${i} $ccost $totcost"

		#Try to recurively list all upgrades
		getPossibleUpgrades $i
		
		#echo
	done
}
getPossibleUpgrades () {

	rlevel=$((rlevel+1))
	towerdir=$basedir/units/${buildertype}builder
	filename=tower_${buildertype}builder_${1}.txt

	upgradenames=`(cat $towerdir/$filename | sed 's/\r//g' | grep _upgrade_ | \
		 sed 's/["]/ /g' | sed "s/${buildertype}builder_upgrade_//g"| awk '{print $NF}')`
	if [ -z "$upgradenames" ]; then
		#echo No further upgrades available
		rlevel=$((rlevel-1))
		let totcost=totcost-ccost
	else
		#echo Possible upgrades:
		#echo $upgradenames
		printUpgradeInfo $upgradenames
	fi
}

#Set some paths
basedir="game/dota_addons/legion_td/scripts/npc"
#type="human"
statnames=(goldcost foodcost damage atkspeed atkrange health armor)

#Get list of possible builds
#if [ $1 == "1" ]
#then

	#choosetype
	settype $1
	echo "===$1==="
	echo "{| class="wikitable"
!rowspan="1"|Name
!Cost gold
!Accumulative gold cost
!Cost food
!Accumulative food cost
!Health
!Damage
!Attack speed
!Attack Range
!Armor physical
!AOE
!Healing
!Abilities
|-"
	#choosenpc
	iteratenpc
	#getPossibleUpgrades $npcname

	#getPossibleUpgrades $npcname

#fi


echo "
|}"


