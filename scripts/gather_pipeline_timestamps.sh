#!/bin/bash

data_source=$1
# data_source=/private/groups/treehouse/archive/projects/qc_paper/round3/downstream/

output_file_name=$(pwd)/data/pipeline_timestamps.txt

rm $output_file_name

fusion=secondary/ucsctreehouse-fusion-0.1.0-3faac56/methods.json 
var_call=secondary/ucsctreehouse-mini-var-call-0.0.1-1976429/methods.json 
expression=secondary/ucsc_cgl-rnaseq-cgl-pipeline-3.3.4-785eee9/methods.json 
umend_qc=secondary/ucsctreehouse-bam-umend-qc-1.1.1-5f286d7/methods.json 


cat data/subsample_ids.txt | grep -v sample_id | cut -f1 | while read i; do
echo -n $i expression " " ; cat ${data_source}${i}/$expression | grep \"start\"
echo -n $i expression " " ; cat ${data_source}${i}/$expression | grep \"end\"
echo -n $i umend_qc " " ; cat ${data_source}${i}/$umend_qc | grep \"start\"
echo -n $i umend_qc " " ; cat ${data_source}${i}/$umend_qc | grep \"end\"
echo -n $i fusion " " ; cat ${data_source}${i}/$fusion | grep \"start\"
echo -n $i fusion " " ; cat ${data_source}${i}/$fusion | grep \"end\"
echo -n $i var_call " " ; cat ${data_source}${i}/$var_call | grep \"start\"
echo -n $i var_call " " ; cat ${data_source}${i}/$var_call | grep \"end\"
done > ${output_file_name}.tmp


cat ${output_file_name}.tmp | tr -s " " | tr -d "\"" >  ${output_file_name}


rm ${output_file_name}.tmp


