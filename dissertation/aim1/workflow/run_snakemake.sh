pipeline=$1
snakefile=$2
output_dir='/data/sevillas2/gmu/log'
home_dir='/home/sevillas2/git/gmu/dissertation/aim1/workflow'

log_time=`date +"%Y%m%d_%H%M"`

#if pipeline to run on cluster or locally
if [[ $pipeline = "cluster" ]] || [[ $pipeline = "local" ]]; then

  #if cluster - submit job
  if [[ $pipeline = "cluster" ]]; then
    #submit job to cluster
    sbatch --job-name="gm" --gres=lscratch:200 --time=120:00:00 --mail-pipeline=BEGIN,END,FAIL \
    snakemake --latency-wait 120  -s ${home_dir}/$snakefile \
    --printshellcmds --cluster-config ${home_dir}/cluster_config.yml --keep-going \
    --restart-times 1 --cluster "sbatch --gres {cluster.gres} --cpus-per-task {cluster.threads} \
    -p {cluster.partition} -t {cluster.time} --mem {cluster.mem} --cores {cluster.cores} \
    --job-name={params.rname} --output=${output_dir}/log/${log_time}_{params.rname}.out" -j 500 --rerun-incomplete

  #otherwise submit job locally
  else
    snakemake -s ${home_dir}/$snakefile \
    --printshellcmds --cluster-config ${home_dir}/cluster_config.yml --cores 8
  fi
elif [[ $pipeline = "unlock" ]]; then
  snakemake -s ${home_dir}/$snakefile --unlock --cores 8
else
  #run snakemake
  snakemake -s ${home_dir}/$snakefile \
  --printshellcmds --cluster-config ${home_dir}/cluster_config.yml -npr
fi
