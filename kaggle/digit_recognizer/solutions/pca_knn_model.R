#Try this for best models : http://rodrigob.github.io/are_we_there_yet/build/classification_datasets_results.html#4d4e495354
library(caret)
library(RCurl)
library(doMC)
library(e1071)
library(class)

#Setting Parallelism
registerDoMC(cores = 3)

#Preprocessing
#Dimensonality reduction using PCA
mycsv.connection <- getURL(url = "http://kaggle.sowmiyan.com/digit_recog/train.csv")
train <- read.csv(textConnection(object = mycsv.connection),header=TRUE)
train.temp <- train
train.temp$type <- "train"

mycsv.connection <- getURL(url = "http://kaggle.sowmiyan.com/digit_recog/test.csv")
test <- read.csv(textConnection(object = mycsv.connection),header=TRUE)
test.temp <- test
test.temp$type <- "test"

all <- rbind(train.temp[,-1], test.temp)

all.pca <- prcomp(all[,-match(c("type"),names(all))], center = TRUE,scale = FALSE)

summary(all.pca)
screeplot(all.pca,type="l")

#Model building

train.pca <- as.data.frame(all.pca$x[1:42000,])
test.pca <- as.data.frame(all.pca$x[42001:70000,])
train.pca.label <- factor(train$label,levels = 0:9)

date()
#Choosing K value using cross validation using caret package
#Full Data set can be used for cross validation
#Following cross validation took about 2 hours to complete ("Sun Jul  6 21:00:53 2014" to "Sun Jul  6 22:59:37 2014")
knn.cross <- tune.knn(x = train.pca[,1:60], y = train.pca.label, k = 1:15 ,tunecontrol=tune.control(sampling = "cross"), cross=10)

summary(knn.cross)
#Plot the error rate 
plot(knn.cross)
date()
#Result of above cross validation - Best paramater was chosen was k=3 

date()
knn.pred <- knn(train = train.pca[,1:60], test = test.pca[,1:60],cl = train.pca.label,k = 3)
date()

results <- (0:9)[knn.pred]

rownum <- 1:length(results)

results.df <- data.frame(ImageId = rownum,Label = results)

#First try with 60 principal component - Best submission in kaggle
#Second try with 155 principal component - Not best
#Third try with 60 PCs with k=3 after using cross validation.
#write(x=results,file="./results/knn_model.csv",ncolumns=1)
write.table(x=results.df,file="/Users/njvijay/temp/pca_knn_model_60var_k_3.csv",sep=",",col.names=TRUE, row.names=FALSE,quote=FALSE)

###########
# Idea is to use regularized random forrest