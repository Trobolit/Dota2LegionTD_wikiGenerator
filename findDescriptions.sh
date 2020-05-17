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

getSkillDescription () { # Needs skill name
	cat $file | sed 's/\x0//g' | grep ability_${1}_Des \
		| sed 's/<[^>]*>//g' \
		| awk -F \" '{print $4}' # print $2 if you want name of desc tag
}


if [ "$#" == 1 ]; then
	npcs=`( cat ${builder}list.txt )`
	for npc in $npcs; do
		echo "::: $npc ::: "
		skills=`( getSkills $builder $npc )`

		for s in $skills; do
			echo " :: $s ::"
			echo -n "    "
			getSkillDescription $s
		done

		echo
	done
else
	npc=$2
	#echo "::: $npc ::: "
	skills=`( getSkills $builder $npc )`

	for s in $skills; do
		echo $s
		getSkillDescription $s
	done

	echo
fi
