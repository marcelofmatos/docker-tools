#!/bin/bash
FILTER=${1:-filter}
FILE=${2:-filename}
cat $FILE | grep $FILTER | awk '{ print $NF"\t"$1"\t"$4 $5"\t"$9"\t"$6"\t"$7"\t"$(NF-1)"\t"$NF-2 }' | sort -n