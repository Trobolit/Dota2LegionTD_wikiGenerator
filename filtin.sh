#!/bin/bash

sed 's/[0-9]//g' $1 | sed 's/-//g' | sed 's/\.//g' | sed 's/ //g'
