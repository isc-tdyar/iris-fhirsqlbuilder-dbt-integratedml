library(h2o)
library(readr)
library(fs)

#synthea_pt30k_lc_data_sel_convert <- read_csv("Downloads/synthea-pt30k-lc-data-sel-convert.csv")
#synthea_pt30k_lc_data_sel_convert$data_types <- dtypes

#install.packages(c("h2o", "h2o4gpu", "h2otools"))


h2o.init()
# H2O needs the full path for some reason
trframe <- h2o.importFile(path = path(getwd(),'data/synthea-pt30k-lc-data-sel-convert.csv'))
# convert label to factor to indicate categorization problem
trframe$label <- as.factor(trframe$label)
h20model = h2o.automl(y = 'label', training_frame = trframe)
