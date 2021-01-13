for f in /data/sevillas2/gmu/aim3/input/*.fastq; do gzip "$f"; done

for f in /data/sevillas2/gmu/aim3/input/*.fastq.gz; do mv "$f" "$(echo "$f" | sed s/_1//)"; done
