#!/bin/bash
cd /e/My\ Files/My\ Files/Dissertation/Analysis/Aim3/data/gunzip_files/

#for each file
for f in *
do
  SPLIT_LOC=/e/My\ Files/My\ Files/Dissertation/Analysis/Aim3/data/split_files
  SPLIT_FILE="${SPLIT_LOC}/${f}"

  #copy file, unzip
  cp "$f" "$SPLIT_FILE"
  gunzip "$SPLIT_FILE"
  FILE_NAME=(${f//./ })

  #split into R1
  awk 'NR%2==1 { print $0 "/1" } ; NR%2==0 { print substr($0,0,length($0)/2) }' "${SPLIT_LOC}/${FILE_NAME}".fastq > "${SPLIT_LOC}/${FILE_NAME}"_R1.fastq

  #split into R2
  awk 'NR%2==1 { print $0 "/2" } ; NR%2==0 { print substr($0,length($0)/2+1) }' "${SPLIT_LOC}/${FILE_NAME}".fastq > "${SPLIT_LOC}/${FILE_NAME}"_R2.fastq

  #remove copied file
  rm "${SPLIT_LOC}/${FILE_NAME}".fastq
done
