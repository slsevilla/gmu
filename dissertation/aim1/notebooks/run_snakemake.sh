pipeline=$1
output_dir='/data/sevillas2/gmu/log'

#submit job to cluster
sbatch --job-name="aim1" --gres=lscratch:200 --time=120:00:00 --mail-type=BEGIN,END,FAIL \
<<<<<<< HEAD
snakemake --latency-wait 120  -s snakefile_ref \
=======
snakemake --latency-wait 120  -s snakefile_taxonly \
>>>>>>> dca0cbb9a9764b961bb09f02e187b6c1dafe3897
--printshellcmds --cluster-config cluster_config.yml --keep-going \
--restart-times 1 --cluster "sbatch --gres {cluster.gres} --cpus-per-task {cluster.threads} \
-p {cluster.partition} -t {cluster.time} --mem {cluster.mem} --cores {cluster.cores} \
--job-name={params.rname} --output=${output_dir}/{params.rname}.out" -j 500 --rerun-incomplete
