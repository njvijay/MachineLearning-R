library(e1071)
library(class)
library(RCurl)

#setwd("/home/njvijay/machinelearning/kaggle/digit_recog")
#train <- read.csv('./data/train.csv', header=TRUE)
#test <- read.csv('./data/test.csv', header=TRUE)

#Dataset is huge. They cannot be stored locally for github. Going to pull both training and test
#dataset from a website
mycsv.connection <- getURL(url = "http://kaggle.sowmiyan.com/digit_recog/train.csv")
train <- read.csv(textConnection(object = mycsv.connection),header=TRUE)

mycsv.connection <- getURL(url = "http://kaggle.sowmiyan.com/digit_recog/test.csv")
test <- read.csv(textConnection(object = mycsv.connection),header=TRUE)


train_knn.pixel <- train[,-1]
train_knn.digit <- train[,1]
train_knn.digitfactor <- factor(x = train_knn.digit,levels = 0:9)

date()
#I don't think normalization is required for the columns here
# I could not do the cross validation which is taking exceptionally long time
#train_knn.cross <- tune.knn(x = train_knn.pixel, y = train_knn.digitfactor,k = 1:5,
#                            tunecontrol = tune.control(sampling = "cross"), cross=2)
knn.pred <- knn(train = train_knn.pixel, test = test,cl = train_knn.digit,k = 10)

date()

results <- (0:9)[knn.pred]

rownum <- 1:length(results)

results.df <- data.frame(ImageId = rownum,Label = results)

#write(x=results,file="./results/knn_model.csv",ncolumns=1)
write.table(x=results.df,file="./results/knn_model.csv",sep=",",col.names=TRUE, row.names=FALSE,quote=FALSE)

#summary(train_knn.cross)
#plot(train_knn.cross)