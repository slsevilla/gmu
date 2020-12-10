pipeline=$1
output_dir='/data/sevillas2/gmu/log'

#submit job to cluster
sbatch --job-name="aim1" --gres=lscratch:200 --time=120:00:00 --mail-type=BEGIN,END,FAIL \
snakemake --latency-wait 120  -s snakefile_ref \
--printshellcmds --cluster-config cluster_config.yml --keep-going \
--restart-times 1 --cluster "sbatch --gres {cluster.gres} --cpus-per-task {cluster.threads} \
-p {cluster.partition} -t {cluster.time} --mem {cluster.mem} --cores {cluster.cores} \
--job-name={params.rname} --output=${output_dir}/{params.rname}.out" -j 500 --rerun-incomplete
