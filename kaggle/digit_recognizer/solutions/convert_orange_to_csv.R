setwd("/Users/njvijay/big_data/Orange/Kaggle/digit_recog")
neural.data <- read.csv("digit_recog_neuralnet_prediction.csv")

rownum <- 1:length(neural.data$m.Neural.Network)

results.df <- data.frame(ImageId = rownum,Label = neural.data$m.Neural.Network)

write.table(x=results.df,file="/Users/njvijay/temp/neural_network_digit_recog.csv",sep=",",col.names=TRUE, row.names=FALSE,quote=FALSE)
