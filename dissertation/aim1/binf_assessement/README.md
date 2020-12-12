#create reference databases
run 01_snakefile_ref
output: refdb_tax_gg.qza, refdb_tax_silva.qza

#use input from demux of cgr pipeline
QZA files (4)
180112_M01354_0104_000000000-BFN3F.qza
180112_M03599_0134_000000000-BFD9Y.qza
180328_M01354_0106_000000000-BFMHC.qz
190617_M01354_0118_000000000-CHFG3.qza



#unused

"""
unused code
rule feature_filt:
   """Filter features that have less than 32 reads
   VSEARCH will automatically remove features with <32 reads, however, QIIME2 does not do this. When the results are returned to Q2 without these reads, a KEYERROR is received.
   In order to determine which features, use the TABLE QZV and determine which features meet this requirement. Then create a TSV file with these features to pass through as a parameter of exclusion.
   NOTE: Removing features by count (<2 for example) would eliminate too many features that do not meet this criterion and may not even eliminate all of the targeted features.
   """
   input:
       tab_in = table_dir,
       f_list = filt_file
   output:
       tab_filt = out_dir + "filt_tab.qza"
   run:
       shell('qiime feature-table filter-features \
       --i-table {input.tab_in} \
       --m-metadata-file {input.f_list} \
       --p-exclude-ids \
       --o-filtered-table {output.tab_filt}')

rule seq_filt:
   """
   Rep-seqs must match features with the feature-table. Since features were filtered with rule above, this rule will remove those features from the rep-seq list.
   """
   input:
       tab_filt = out_dir + "filt_tab.qza",
       rep_in = repseq_dir
   output:
       rep_filt = out_dir + "filt_seq.qza"
   run:
       shell('qiime feature-table filter-seqs \
       --i-data {input.rep_in} \
       --i-table {input.tab_filt} \
       --o-filtered-data {output.rep_filt}')

rule create_ref_seq:
   """ Create the reference database to be used for taxonomic_classification
   used unaligned reads for this - creates ''FeatureData[Sequence]''
   """
   input:
       ref_raw = get_rawref_full_path
   output:
       out_dir + 'refdb_seq_{ref_raw}.qza'
   run:
       shell('qiime tools import \
       --type ''FeatureData[Sequence]'' \
       --input-path {input.ref_raw} \
       --output-path {output}')
