
library(tidyverse)
library(jsonlite)

this_dir="/private/groups/treehouse/archive/projects/qc_paper/scratch/umend_qc_publication"
setwd(this_dir)

samples <- read_tsv("data/subsample_ids.txt")

base_dir="/private/groups/treehouse/archive/projects/qc_paper/round3/downstream/"

# define file locations

outlier_results="/tertiary/treehouse-protocol-14.0.1-765565a/compendium-TreehousePEDv9/outlier_results_"


# outliers and expression values


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


# specific genes that had t-test support
genes_of_interest <- c("DACH1", "DUSP26", "NRXN1", "PDZD4", "RNF165", "RP1-310O13.13", 
"SNORA4", "SNORA47", "AP000783.1", "SNORA61", "SNORA8", "CBLN1", 
"EBF1", "ANO2", "CSPG5", "MYT1", "ACTL6B", "AP3B2", "ATP1A3", 
"BRSK2", "C1orf61", "CA4", "CACNA1G", "CADM3", "CADPS", "CELF3", 
"CHGA", "CHGB", "CPLX3", "CRMP1", "DRAXIN", "EPHA8", "FAM57B", 
"FNDC5", "GABRB3", "GABRG2", "GDAP1L1", "GFAP", "GNB3", "GPM6A", 
"GRAMD1B", "HES6", "HMP19", "HPCA", "IGSF21", "INSM1", "KCNQ2", 
"KIF21B", "KIF5C", "KLHDC8A", "LHX2", "LINC00599", "LPPR4", "MAB21L1", 
"MAST1", "MCC", "MYT1L", "NEUROD1", "NEUROD2", "NFIB", "NNAT", 
"NPTX1", "NRN1", "OTX2", "PHYHIPL", "PTPRN", "RNU11", "RUNDC3A", 
"SCG3", "SEZ6", "SEZ6L", "SLC17A7", "SNAP25", "SPTBN4", "STMN2", 
"SYP", "TBR1", "TMEM145", "TUBB2B", "WASF3", "ZDHHC22")


parent_sample_of_interest <- "TH_Eval_016"

# 81 outliers at random
this_seed = 10
set.seed(this_seed)
genes_of_interest <- lapply(expression_data_raw, function(x) 
  filter(x, pc_outlier == "pc_up" & grepl(parent_sample_of_interest, sample_id))) %>%
bind_rows %>%
select(gene) %>% 
distinct %>%
sample_n(size = 81) %>%
pull(gene)
 


some_outlier_results <-lapply(expression_data_raw, function(x) {
	# x= expression_data_raw[[1]]
	if ( grepl(parent_sample_of_interest, x$sample_id[1])) {
		subset(x, gene %in% genes_of_interest)
	}
	}) %>%
	bind_rows 
	
# write_tsv(some_outlier_results, "data/some_outlier_results.txt")
write_tsv(some_outlier_results, paste0("data/outlier_results_for_81_random_upoutliers_seed_", this_seed, ".txt"))






