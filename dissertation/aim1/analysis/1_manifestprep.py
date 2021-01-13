from IPython.display import display
import os.path
import yaml
import pandas as pd
import numpy as np
import glob

#update system
system_opt= 'm' #'w' or 'm'

config_loc = 'config.yaml'
with open(config_loc) as file:
    # The FullLoader parameter handles the conversion from YAML
    # scalar values to Python the dictionary format
    config_file = yaml.load(file, Loader=yaml.FullLoader)

#update dir and manifest info
git_dir=config_file['git_dir'][system_opt]
data_dir=config_file['data_dir'][system_opt]
analysis_dir=config_file['analysis_dir'][system_opt]
manifest_file=config_file['manifest_dir'][system_opt] + config_file['metadata_manifest']
variable_file=config_file['manifest_dir'][system_opt] + config_file['variable_manifest']
clean_manifest=config_file['manifest_dir'][system_opt] + config_file['clean_manifest']

#import manifest
manifest = pd.read_csv(manifest_file,sep='\t')
print(manifest.head())

#remove NAs
manifest = manifest.dropna(how='all', axis='columns')

#remove spaces
manifest.columns = manifest.columns.str.replace(' ', '')

#rename variables for simplification
df = pd.read_csv(variable_file,sep='\t',index_col=0)
for i in manifest['Run-ID'].unique():
    manifest.replace({i:df.loc[df.index==i, 'Identifier'].values[0]},inplace=True)
for i in manifest['Ext-Kit'].unique():
    manifest.replace({i:df.loc[df.index==i, 'Identifier'].values[0]},inplace=True)
for i in manifest['Subject-ID'].unique():
    manifest.replace({i:df.loc[df.index==i, 'Identifier'].values[0]},inplace=True)
    
#remove well location
manifest.replace({r'_._..': r''}, inplace=True, regex=True)

#replace _ with - for fastq matching
manifest['SampleID'].str.replace('_','-')

#set index
manifest.set_index('SampleID',inplace=True)

#Print the variables for the metadata
for i in manifest.drop(columns=['Source-PCR-Plate','CGR-Sample-ID']).columns:
    print(i)
    print(*manifest[i].unique(), sep = ", ")  
    print('\n')

#review receipts
def sort_list (m,col):
    sort_list = [x for x in m[col].unique() if str(x) != 'nan']
    sort_list.sort()
    return sort_list

print ("Receipt", "Ext Kit", "Homogenization Method", sep = " - ")
for i in sort_list(manifest,'Reciept'):
    temp = manifest[(manifest['Reciept'] == i)]
    col2 = temp['Ext-Kit'].unique()
    col3 = temp['Homo-Status'].unique()
    print (i, col2[0], col3[0],sep=" - ")

'''
Receipts were removed from the project for the following reasons:

- Receipts that failed sequencing: R-01*, R-04, R-012
- Receipts that were cancelled: R-23 to R-25*
- Receipts that contained residuals: R-13, R-14, R-17
- Receipts that contained altered homogenization: R-034, R-043 to R-055

*Not included in sequencing project, but found in LIMS
'''

#remove listed receipts
m_rec = manifest.copy()

recp_num = ['04','12','13','14','17','34','43','44','45','46','47','48','49','50','51','52','53','54','55']
drop_recp = []

for i in recp_num:
    drop_recp.append("sFEMB-001-R-0" + i)

m_rec = manifest[~manifest.Reciept.isin(drop_recp)]
m_rec_rm = manifest[manifest.Reciept.isin(drop_recp)]
print("\nThe original number of samples:", manifest.shape[0], "\nThe filtered number of samples:",m_rec.shape[0])

#remove samples
'''Samples were removed from the project for the following reasons:

- Samples of the typee Biocollective were not equally used by all extraction methods
'''

m_nonbio = m_rec[m_rec['Sample-Des']!="H02"]
print("\nThe original number of samples:", manifest.shape[0], "\nThe final filtered number of samples:",m_nonbio.shape[0])

#output clean manifest
m_nonbio.to_csv(clean_manifest,header = m_nonbio.columns, sep='\t')
m_save=m_nonbio.copy()

#review metadata
def metacount_all(df_in):
    #Print the counts for all of the metadata
    m = df_in.drop(columns=['ExternalID','Project-ID','ExtractionBatchID'],errors='ignore')

    for i in m.columns:
        display(m[i].value_counts().rename_axis(i).to_frame('Number of samples'))

def metacount_run_sub(df_in):
    tmp = df_in[['Run-ID','Subject-ID']].copy()
    tmp = tmp.groupby(['Subject-ID','Run-ID'])
    display(tmp.size().to_frame('Subject-ID').join(tmp.apply(list).apply(pd.Series)))

print(metacount_all(m_nonbio))