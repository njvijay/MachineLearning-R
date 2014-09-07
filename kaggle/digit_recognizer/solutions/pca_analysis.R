library(caret)
library(RCurl)
library(doMC)

#Setting Parallelism
registerDoMC(cores = 3)

mycsv.connection <- getURL(url = "http://kaggle.sowmiyan.com/digit_recog/train.csv")
train.data <- read.csv(textConnection(object = mycsv.connection),header=TRUE)
train.data.label <- train.data[,1]
train.data.labelfactor <- factor(x = train.data.label,levels = 0:9)
train.data <- train.data[,-1]



mycsv.connection <- getURL(url = "http://kaggle.sowmiyan.com/digit_recog/test.csv")
test.data <- read.csv(textConnection(object = mycsv.connection),header=TRUE)


train.data.pca <- prcomp(train.data)
#Scaling throws back the error where scale=TRUE since it cannot rescale a constant/zero column to unit variance
#Ran PCA without scaling
summary(train.data.pca)
screeplot(train.data.pca)
screeplot(train.data.pca,type="l")


#Using caret package
#Want to take another approach by removing all zero variance
zerov <- nearZeroVar(train.data,saveMetrics = TRUE)
train.data.nozerovar <- train.data[,!zerov$zeroVar]
train.data.nozerovar.pca <- prcomp(train.data.nozerovar, scale=TRUE, center=TRUE)


train.data.nozerovar.caretpca <- preProcess(train.data.nozerovar,method = c("BoxCox","center","scale","pca"),verbose=T)
train.data.nozerovar.caretpcascore <- predict(train.data.nozerovar.caretpca,train.data.nozerovar)

#Model building and evaluations
#getting only 36 PCAs for model building
date()
rf.cross <- tune.randomForest(x = train.data.nozerovar.caretpcascore[,1:36], y = train.data.labelfactor,tuneControl = tune.control(sampling = "cross"), cross=10)
summary(rf.cross)
plot(rf.cross)
date()


