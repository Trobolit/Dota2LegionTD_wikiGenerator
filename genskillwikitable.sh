#!/bin/bash
file=game/dota_addons/legion_td/resource/addon_english.txt
# file is really in utf16 and so every other character is null byte...

basedir=infofiles
spawndir=$basedir/unitinfo
npcdir=$basedir/upgradeinfo
builder=$1

getSkills () { # needs inputs $builder $npc
	grep bility[0-9]. $npcdir/${1}builder/tower_${1}builder_${2}.txt \
		| grep -v sell | grep -v _upgrade_ | grep -v _empty_ \
		| awk '{print $2 }' | sed 's/"//g'
}




#choosetype
settype $1
echo "===$1==="
echo "{| class="wikitable"
!rowspan="1"|NPC
!Skill name
!Description"


npcs=`( cat ${builder}list.txt )`
#echo $npcs
#npcsname=`( cat ${builder}in.txt | awk -F [0-9] '{ print $1 }' )`

#TODO: handle 0 skills without adding row
for npc in $npcs; do
	echo "|-"
	#echo " :::: $npc"

	#we want those -- in front of the name, this is a crude way of doing it.
	npcname=`( cat ${builder}in.txt | awk -F "[0-9][0-9]" '{ print $1 }' | sed 's/ \t//' | grep -E "^[- ]*${npc}[ ]?$" )`
	basenametest=`( echo $npcname | awk '{print $1}' )`
	#echo ":::: $npcname :::::"

	if [ "$basenametest" = "-" ]; then
		#echo "not basename!"
		echo -n "| "
	else
		#echo "Base name!"
		echo -n "! "
	fi
	echo $npcname

	skills=`( getSkills $builder $npc )`
	#echo "::::: $skills ::::::"
	numskills=`( echo $skills | wc -w )`
	#echo ":::: num=$numskills ::::"
	
	if [ "$numskills" -gt "1" ]; then
		
		skill1=`( echo $skills | awk '{print $1}' )`
		
		echo "| $skill1"
		echo -n "|"
		./getSkillDescription.sh $skill1
		echo

		#remove first skill from list
		skills=`( echo $skills | awk '{for (i=2; i<=NF; i++) print $i}' )`

		for s in $skills; do
			echo "|-" # new row for every skill
			echo "|" # Empty name row since not first skill for npc
			echo "| $s"
			echo -n "|"
			./getSkillDescription.sh $s
			echo
		done
	else
		echo "| $skills"
		#echo " :::::::: "
		echo -n "|"
		./getSkillDescription.sh $skills
		echo

	fi
done



echo "
|}"