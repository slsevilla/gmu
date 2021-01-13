output_dir="/data/sevillas2/gmu/aim3/"

#input_file="/home/sevillas2/git/gmu/dissertation/aim3/manifest/ftp_list.txt"
#slurm_file="/data/sevillas2/gmu/aim3/aim3_download_ftp.slurm"
#awk -v out_dir="$output_dir" '{ print "wget -P " out_dir " " $1 }' $input_file > $slurm_file

input_file="/home/sevillas2/git/gmu/dissertation/aim3/manifest/sid_list.txt"
slurm_file="/data/sevillas2/gmu/aim3/aim3_download_sra.slurm"
awk -v out_dir="$output_dir" '{ print "module load sratoolkit/2.10.8; fastq-dump -I --split-files " $1 " --outdir " out_dir }' $input_file > $slurm_file