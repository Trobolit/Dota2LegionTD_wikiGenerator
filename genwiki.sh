#!/bin/bash

rm wiki.txt
touch wiki.txt

./genwikitable.sh assassin >> wiki.txt
./genwikitable.sh elemental >> wiki.txt
./genwikitable.sh human >> wiki.txt
./genwikitable.sh nature >> wiki.txt
./genwikitable.sh spirit >> wiki.txt
./genwikitable.sh undead >> wiki.txt

subl wiki.txt