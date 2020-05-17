#!/bin/bash

builder=$1
npc=$2
pf=game/dota_addons/legion_td

if [ "$builder" == "assassin" ]; then
	#echo This should be part of getabilities.sh but I was lazy
	basedir=infofiles
	spawndir=$basedir/unitinfo
	npcdir=$basedir/upgradeinfo

	skills=`( grep bility[0-9]. $npcdir/${builder}builder/tower_${builder}builder_${npc}.txt \
	| grep -v sell | grep -v _upgrade_ | grep -v _empty_ \
	| awk '{print $2}' | sed 's/"//g' )` #| tr '\n' ' '

	echo $skills

	subl -n
	for s in $skills; do
		subl /home/robert/LegionTD-Reborn/game/dota_addons/legion_td/scripts/npc/abilities/assassinbuilder/skills/${s}.txt
	done
else
	#This will not work for assassin since its skillfolder is different.
	subl -n ${pf}/resource/addon_english.txt \
		${pf}/scripts/npc/abilities/${builder}builder/skills/${npc}_*.txt \
		${pf}/scripts/npc/abilities/${builder}builder/*${npc}.txt \
		${pf}/scripts/npc/units/${builder}builder/tower_${builder}builder_${npc}.txt 
fi
