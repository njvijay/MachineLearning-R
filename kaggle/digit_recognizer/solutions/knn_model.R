library(e1071)
library(class)

require(RCurl)

#Training data online - https://app.box.com/s/gkadabsw7s7qhkqhgvlx
#test data online - https://app.box.com/s/nqcnbv1qtdr4v181lcsd

setwd("/Users/njvijay/big_data/Github/MachineLearning-R/kaggle/digit_recognizer/solutions")
#train <- read.csv('../data/train.csv', header=TRUE)
train_url <- getURL("https://app.box.com/s/gkadabsw7s7qhkqhgvlx")
train <- read.csv(textConnection(train_url), header=TRUE)
test <- read.csv('../data/test.csv', header=TRUE)

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

summary(train_knn.cross)
plot(train_knn.cross)

