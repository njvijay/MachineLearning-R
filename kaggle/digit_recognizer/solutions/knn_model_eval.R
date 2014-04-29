library(e1071)
library(class)


setwd("/Users/njvijay/big_data/Github/MachineLearning-R/kaggle/digit_recognizer/solutions/")
train <- read.csv('sample/digit_train_sample_5per.csv', header=TRUE)

train_knn.pixel <- train[,-1]
train_knn.digit <- train[,1]
train_knn.digitfactor <- factor(x = train_knn.digit,levels = 0:9)

#Full Data set can be used for cross validation
knn.cross <- tune.knn(x = train_knn.pixel, y = train_knn.digitfactor, k = 1:5
                      ,tunecontrol=tune.control(sampling = "cross"), cross=10)
#Summarize the resampling results set
knn.boot <- tune.knn(x = train_knn.pixel, y = train_knn.digitfactor, k = 1:10
                     , tunecontrol=tune.control(sampling = "boot"))
summary(knn.cross)
#Plot the error rate 
plot(knn.cross)

summary(knn.boot)
#Plot the error rate 
plot(knn.boot)

#8% error estimation random forrests with no parameter tuning
rf.cross <- tune.randomForest(x = train_knn.pixel, y = train_knn.digitfactor
                              ,tuneControl = tune.control(sampling = "cross"), ntree= cross=10)
rf.boot <- tune.randomForest(x = train_knn.pixel, y = train_knn.digitfactor
                              ,tuneControl = tune.control(sampling = "boot"))
summary(rf.cross)
summary(rf.boot)

plot(rf.cross)


#Seeding for reproducibility
set.seed(100)
test_indx <- sample(nrow(train), nrow(train)*30/100, replace=FALSE)
test.all <- train[test_indx,]

test.data <- test.all[,-1]
test.direction <- factor(test.all[,1], levels=0:9)

#Prep. training data  which is noting but remaing test data
train.all <- train[-test_indx,]
train.data <- train.all[,-1]
train.direction <- factor(train.all[,1], levels=0:9)

weka_train <- train[,-1]
weka_train$level <- factor(train[,1], levels=0:9)

rf_model <- randomForest(x = train.data,y = train.direction, ntree=500)

library(RWeka)
write.arff(weka_train,"sample/digit_train_sample_5per.arff")

