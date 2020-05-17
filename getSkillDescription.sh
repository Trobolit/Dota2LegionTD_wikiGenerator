#!/bin/bash

file=game/dota_addons/legion_td/resource/addon_english.txt
# file is really in utf16 and so every other character is null byte...


cat $file | sed 's/\x0//g' | grep ability_${1}_Des \
	| sed 's/<[^>]*>//g' \
	| awk -F \" '{print $4}' # print $2 if you want name of desc tag






