library(dplyr)

# join loinc_codes.csv with synthea-lc-dataset-codes.csv
loinc_codes_gpt <- read.csv('data/loinc_codes.csv')
synthea_lc_dataset_codes <- read.csv('data/synthea-lc-dataset-codes.csv')

# fix codes in gpt file
loinc_codes_gpt <- loinc_codes_gpt %>% mutate(code = paste0('C-',code))

joined_codes <- left_join(synthea_lc_dataset_codes,loinc_codes_gpt)
