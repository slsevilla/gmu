import pandas as pd
import sys

output = sys.argv[1]
file_list = [sys.argv[2],sys.argv[3]]

pass_flag = 1
for files in file_list:
    df_in = pd.read_csv(files,skiprows=1,delimiter='\t')
    
    if(pass_flag==1):
        df_final = df_in
        pass_flag = 2
    else:
        df_final = pd.merge(df_in,df_final, on = '#OTU ID', how='outer')

#print out
df_final.to_csv(output,sep='\t',mode='a',index=False)