library(caret)
library(RCurl)
library(doMC)

#Setting Parallelism
registerDoMC(cores = 6)

mycsv.connection <- getURL(url = "http://kaggle.sowmiyan.com/digit_recog/train.csv")
alldata <- read.csv(textConnection(object = mycsv.connection),header=TRUE)

set.seed(987)
trainIndx <- createDataPartition(y = alldata$label,p = 0.05,list = FALSE)
train <- alldata[trainIndx,]

#Random forest

trnctl <- trainControl(method = "repeatedcv",number = 2,classProbs = TRUE)
digitizerModel <- train(label ~ ., data=train,method = "rf",trControl = trnctl,tuneLength = 785)


