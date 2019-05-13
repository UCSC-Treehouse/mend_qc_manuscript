# setwd("notebooks")
# setwd("/data/projects/gitCode/umend_qc_publication/notebooks")
setwd( "/Users/hbeale/Documents/Dropbox/ucsc/projects/gitCode/umend_qc_publication/notebooks")

f_include_early_stage_munging <- TRUE # FALSE

this_truth_definition <- "found_in_3_of_4_biggest_subsets" # we've settled on this one
truth_definitions <- c("found_in_at_least_half_the_subsets",
                       "found_in_the_deepest_subset",
                       "found_in_3_of_4_biggest_subsets")

## PICK SAMPLES TO ANALYZE
if (f_include_early_stage_munging) rmarkdown::render(
  input = "01_select_subsamples_by_UMEND_depth.Rmd", 
  output_file = paste0("../markdown_output/01_select_subsamples_by_UMEND_depth-", Sys.Date(), ".html"))

## SUMMARIZE EXPRESSION
if (f_include_early_stage_munging) rmarkdown::render(
  input = "02_summarize_expression.Rmd", 
  output_file = paste0("../markdown_output/02_summarize_expression-", Sys.Date(), ".html"))

## EXPRESSION
rmarkdown::render(input = "10_plot_expression.Rmd", 
                  output_file = paste0("../markdown_output/10_plot_expression-", Sys.Date(), ".html"))

## SAMPLE INFO TABLE
rmarkdown::render(input = "11_make_parent_sample_tables.Rmd", 
                 output_file = paste0("../markdown_output/11_make_parent_sample_tables-", Sys.Date(), ".html"))

## READ TYPES
rmarkdown::render(input = "12_Read_types_survey_of_RNA-Seq_samples.Rmd",
                  output_file = paste0("../markdown_output/12_Read_types_survey_of_RNA-Seq_samples-", Sys.Date(), ".html"))

## OUTLIERS
outfile <- paste0("../markdown_output/13_plot_outliers-", Sys.Date(), ".html")
  rmarkdown::render(input = "13_plot_outliers.Rmd",
                    output_file = outfile)

## NEIGHBORS
outfile <- paste0("../markdown_output/14_plot_similar_samples-", Sys.Date(), ".html")
rmarkdown::render(input = "14_plot_similar_samples.Rmd",
                  output_file = outfile)

## SENSITIVITY SPECIFICITY TABLE
rmarkdown::render(input = "15_make_sensitivity_specificity_table.Rmd", 
                  output_file = paste0("../markdown_output/15_make_sensitivity_specificity_table-", Sys.Date(), ".html"))

## support_for_statements_in_text
rmarkdown::render(input = "16_support_for_statements_in_text.Rmd",
                  output_file = paste0("../markdown_output/16_support_for_statements_in_text-", Sys.Date(), ".html"))

## supplemental subsample table
rmarkdown::render(input = "20_make_supplemental_subsample_table.Rmd",
                  output_file = paste0("../markdown_output/20_make_supplemental_subsample_table-", Sys.Date(), ".html"))

