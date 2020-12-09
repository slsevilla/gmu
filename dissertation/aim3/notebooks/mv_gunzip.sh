#!/bin/bash
cd /e/My\ Files/My\ Files/Dissertation/Analysis/Aim3/data/gunzip_files/

#for each file
for f in *
do
  SPLIT_LOC=/e/My\ Files/My\ Files/Dissertation/Analysis/Aim3/data/fastq
  SPLIT_FILE="${SPLIT_LOC}/${f}"

  #copy file, unzip
  cp "$f" "$SPLIT_FILE"
  gunzip "$SPLIT_FILE"
done
