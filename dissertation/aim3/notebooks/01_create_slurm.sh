input_file="/home/sevillas2/git/gmu/dissertation/aim3/manifest/ftp_list.txt"
slurm_file="/data/sevillas2/gmu/aim3/aim3_download.slurm"
output_dir="/data/sevillas2/gmu/aim3/"

awk -v out_dir="$output_dir" '{ print "wget -P " out_dir " " $1 }' $input_file > $slurm_file
