library(readr)
library(dplyr)
library(tidyr)
library(lubridate)

date_and_chip <- read_delim("~/for_folk/geno/Paolo/summarize_rawdata/date_and_chip.txt", 
                            "\t", escape_double = FALSE, col_names = FALSE)
date_and_chip_sep <- tidyr::separate(date_and_chip, col = X1, into = c("file_path", "info"), sep = ":")

# Separate info about date and chip into it’s own columns
date_and_chip_sep <-   tidyr::spread(date_and_chip_sep, key = info, value = X2)

# Parse date to proper format.
date_and_chip_sep_2 <-   mutate(date_and_chip_sep, 
                            processing_date = mdy_hm(`Processing Date`),
                            chip = gsub("_C\\.bpm", "", Content))

# Read sample info.
# First determine max col nr,  and use fill = TRUE to read uneven number of cols.
max_coln <- system("awk '{print NF}' \\
       ~tikn/for_folk/geno/Paolo/summarize_rawdata/file_and_samples.txt \\
      | sort -n | tail -1", intern = TRUE) %>% as.integer()
file_and_samples <- read.table("~/for_folk/geno/Paolo/summarize_rawdata/file_and_samples.txt", 
                               header = F, na.strings = "", fill = T, stringsAsFactors = F,
                               col.names = paste0("col_", 1:max_coln))
# Transpose and gather to tidy.
file_and_samples_t <- data.frame(t(file_and_samples), stringsAsFactors = F) %>% 
  tbl_df() %>% slice(2:ncol(file_and_samples)) 
names(file_and_samples_t) <- file_and_samples$col_1
# Tidy and remove NAs.
file_and_samples_tidy <-    tidyr::gather(file_and_samples_t, key = file, value = sample) %>% 
  filter(!is.na(sample)) %>% 
  mutate(file_path = paste0("edited_FinalReport_54kV2_collection_ed1/", file)) 

# Join with date and chip on file_path
final_table <- inner_join(file_and_samples_tidy, date_and_chip_sep_2) %>% 
  select(sample_id = sample, processing_date, chip, file_path, file) %>% 
  arrange(processing_date)

rm(list=ls(pattern="file"))
rm(list=ls(pattern="date"))

# # Join in Paolos info -----------------------------------------------------
# head(final_table) %>% knitr::kable()
# count(final_table, sample_id, sort = T) %>% 
#   count(n)
# 
# arrange(final_table, sample_id, processing_date) %>% 
#   cigeneR::show_duplicates("sample_id") %>% select(1:2) %>% 
#   group_by(sample_id) %>% 
#   mutate(ranking = min_rank(processing_date)) %>% 
#   mutate(max = max(ranking)) %>% 
#   filter(ranking == max)
