import os
import pandas as pd
import yaml
from pathlib import Path
os.system('ls -l')

def ERR_ids(data,computer,out_dir):
    if computer=="w":
        ena_load = "python enaBrowserTools/python3/enaDataGet.py"
    else:
        ena_load = "~/miniconda2/lib/enaBrowserTools/python3/enaDataGet"

    for index,row in data.iterrows():
        ERR_dl = ena_load + " " + row[0] + " -f fastq -d " + out_dir
        print (ERR_dl)
        os.system(ERR_dl)

def ERR_wget(data,out_dir):
    for index,row in data.iterrows():
        if computer=="w":
            wget_loc = code_dir + 'wget.exe'
            ERR_dl = wget_loc + " ftp://" + row[0] + " -P " + out_dir
        else:
            ERR_dl = "wget ftp://" + row[0] + " -P " + out_dir
        print (ERR_dl)
        os.system(ERR_dl)

def ERR_ftp(data):
    '''
    ftp ftp.sra.ebi.ac.uk
    Name: anonymous
    ftp> cd vol1/fastq/ERR164/ERR164407
    ftp> get ERR164407.fastq.gz
    '''

    #open ftp
    os.system("ftp ftp.sra.ebi.ac.uk")
    os.system("anonymous")

    for index,row in data.iterrows():
        sample_loc = row[0].split("/",1)[1]
        sample_search = "get " + sample_loc
        #print(sample_search)
        os.system(sample_search)

def ERR_run(option, file_in,output_dir):
    ERR_file = manifest_dir + file_in
    data = pd.read_csv(ERR_file,header=None)
    if option==1:
        ERR_ids(data,output_dir)
    elif option==2:
        ERR_wget(data,output_dir)
    elif option==3:
        ERR_ftp(data)

#################################################################
#aim data
aim = '3'

#read in and set dir from yml
yml_path = '/Users/slsevilla/Google Drive/MyDocuments_Current/Education/George Mason University/Dissertation/Analysis/config_all.yml'
with open(yml_path) as file:
    dir_list = yaml.load(file, Loader=yaml.FullLoader)

aim_search = 'aim_dir' + aim
proj_dir = dir_list[aim_search].replace('\\','')
data_dir = dir_list[aim_search + '_q'] + dir_list['data_dir']

manifest_dir = dir_list[aim_search].replace('\\','') + dir_list['manifest_dir']
notebook_dir = dir_list[aim_search] + dir_list['notebook_dir']
img_dir = dir_list[aim_search] + dir_list['img_dir']
stats_dir = dir_list[aim_search] + dir_list['stats_dir']
code_dir = dir_list['analysis_dir'] + dir_list['code_dir']
#################################################################
#updates to dir_list
backup_dir = dir_list['backup_dir']
#################################################################
#run 1 = by IDS, 2 = by FTP
computer = "w" #windows = w or linux = l
file_in = "ftp_list.txt"
#1 "sid_list_subset.txt"
#2,3 "ftp_list_subset.txt"

#run download`                                                                                                                                        b    h
ERR_run(2,file_in,backup_dir)
