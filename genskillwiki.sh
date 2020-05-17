#!/bin/bash

rm skillwiki.txt
touch skillwiki.txt

./genskillwikitable.sh assassin >> skillwiki.txt
./genskillwikitable.sh elemental >> skillwiki.txt
./genskillwikitable.sh human >> skillwiki.txt
./genskillwikitable.sh nature >> skillwiki.txt
./genskillwikitable.sh spirit >> skillwiki.txt
./genskillwikitable.sh undead >> skillwiki.txt

subl skillwiki.txt