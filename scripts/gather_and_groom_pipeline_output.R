
library(tidyverse)
library(jsonlite)

this_dir="/private/groups/treehouse/archive/projects/qc_paper/scratch/umend_qc_publication"
setwd(this_dir)

samples <- read_tsv("data/subsample_ids.txt")

base_dir="/private/groups/treehouse/archive/projects/qc_paper/round3/downstream/"

# define file locations

json20="/tertiary/treehouse-protocol-14.0.1-765565a/compendium-TreehousePEDv9/2.0.json"
outlier_results="/tertiary/treehouse-protocol-14.0.1-765565a/compendium-TreehousePEDv9/outlier_results_"
gene_lengths_path <- "/secondary/ucsc_cgl-rnaseq-cgl-pipeline-3.3.4-785eee9/RSEM/Hugo/"



# Correlated samples
correlated_samples <- lapply(samples$sample_id, function(sample_id) {
	# sample_id = samples$sample_id[1]
	json20_object=fromJSON(paste0(base_dir, sample_id, json20))
	tumormap_results <- tibble(
		parent_sample=gsub("_est.*$", "", sample_id),
		focus_sample= sample_id,
		first_degree_neighbor_sample=json20_object $first_degree_mcs_cohort
		)
	}) 

bind_rows(correlated_samples) %>% write_tsv("data/correlated_samples.txt")
	

### EXPRESSION VALUES

col_spec=cols(
  Gene = col_character(),
  sample = col_double(),
  is_top_5 = col_character(),
  pc_low = col_double(),
  pc_median = col_double(),
  pc_high = col_double(),
  pc_outlier = col_character(),
  pc_is_filtered = col_character(),
  pd_low = col_character(),
  pd_median = col_character(),
  pd_high = col_character(),
  pd_outlier = col_character(),
  pc_percentile = col_integer()
)

expression_data_raw <- lapply(samples$sample_id, function(sample_id) {
	raw_outlier_candidates <- read_tsv(paste0(base_dir, sample_id, outlier_results, sample_id), col_types=col_spec) %>%
	rename(expression_in_log2tpm1 =sample, gene=Gene) %>%
	mutate(
		parent_sample=gsub("_est.*$", "", sample_id),
		sample_id= sample_id
	) 
	}) 

expression_data<-lapply(expression_data_raw, function(x) {
	# x= expression_data_raw[[1]]
	this_expression=select(x, expression_in_log2tpm1)
	colnames(this_expression)=x$sample_id[1]
	return(this_expression)
	}) %>%
	bind_cols %>%
	add_column(gene= expression_data_raw[[1]]$gene, .before=1)
expression_data %>% write_tsv("data/expression_log2tpm1.txt.gz")

### GENE LENGTHS

rsem_col_defs <- cols_only(
  gene_name = col_character(),
  effective_length = col_double()
  )

gene_lengths <-  lapply(samples$sample_id, function(sample_id) {
  raw_gene_lengths <- read_tsv(paste0(base_dir, sample_id, gene_lengths_path, "/rsem_genes.hugo.results"), col_types=rsem_col_defs) %>%
    rename(effective_gene_length = effective_length, gene = gene_name) %>%
    mutate(
      parent_sample=gsub("_est.*$", "", sample_id),
      sample_id= sample_id
    ) 
})  %>% bind_rows

write_tsv(gene_lengths, "data/gene_lengths.txt")

### OUTLIERS
outliers <- lapply(expression_data_raw, function(expression_matrix){
	expression_matrix  %>%
	dplyr::filter(pc_outlier=="pc_up") %>% 
	select(parent_sample, sample_id, gene)
	}) %>% bind_rows

write_tsv(outliers, "data/outliers.txt")

system(paste("./scripts/gather_read_counts_from_pipeline_output.sh", base_dir))
system(paste("bash ./scripts/gather_pipeline_timestamps.sh", base_dir))







