#!/bin/bash

data_source=$1

output_file_name=data/read_counts.txt

rm $output_file_name

fastqc="/secondary/ucsc_cgl-rnaseq-cgl-pipeline-3.3.4-785eee9/QC/fastQC/R1_fastqc.html"
star_log="/secondary/ucsc_cgl-rnaseq-cgl-pipeline-3.3.4-785eee9/QC/STAR/Log.final.out"
mend="/secondary/ucsctreehouse-bam-umend-qc-1.1.1-5f286d7/bam_umend_qc.tsv"

cat data/subsample_ids.txt | grep -v sample_id | cut -f1 | while read SAMPLE_ID; do

# get total_sequences from fastqc
fastqc_file=${data_source}${SAMPLE_ID}${fastqc}
total_sequences=$( cat $fastqc_file |   grep "Total Sequences" | sed 's/^.*<td>Total/Total/' | sed 's/<\/td><\/tr><tr><td>Sequences flagged.*$//' | sed 's/^.*>\([^<]\)/\1/' ); 
echo -e ${SAMPLE_ID}'\ttotal_sequences\t'${total_sequences} >> $output_file_name ; 

# get uniquely mapped read count from  star
star_file=${data_source}${SAMPLE_ID}${star_log}
Uniquely_mapped_read_count=$( cat $star_file | grep "Uniquely mapped reads number"  | cut -f2 -d"|" | tr -d '[:blank:]' )
echo -e ${SAMPLE_ID}'\tUniquely_mapped_read_count\t'${Uniquely_mapped_read_count} >> $output_file_name 
Multi_mapped_read_count=$( cat $star_file | grep "Number of reads mapped to multiple loci"  | cut -f2 -d"|" | tr -d '[:blank:]' )
echo -e ${SAMPLE_ID}'\tMultimapped_read_count\t'${Multi_mapped_read_count} >> $output_file_name 


# get MND and MEND from RSeQC
mend_file=${data_source}${SAMPLE_ID}${mend}
MappedNonDupeReadCount=$( cat $mend_file | cut -f2 | tail -1 )
MEND=$( cat $mend_file | cut -f3 | tail -1)
echo -e ${SAMPLE_ID}'\tUniquely_mapped_non_duplicate_read_count\t'${MappedNonDupeReadCount}'\n'${SAMPLE_ID}'\tMEND\t'${MEND} >> $output_file_name 

done


