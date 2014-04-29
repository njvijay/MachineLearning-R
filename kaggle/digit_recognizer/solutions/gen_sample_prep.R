library(RCurl)

setwd("/Users/njvijay/big_data/Github/MachineLearning-R/kaggle/digit_recognizer/solutions/")
mycsv.connection <- getURL(url = "http://kaggle.sowmiyan.com/digit_recog/train.csv")
train <- read.csv(textConnection(object = mycsv.connection),header=TRUE)

mycsv.connection <- getURL(url = "http://kaggle.sowmiyan.com/digit_recog/test.csv")
test <- read.csv(textConnection(object = mycsv.connection),header=TRUE)

#Checking number of records for each digits available in the training set
aggregate(pixel0~label, data=train, FUN = length)

#All digits are distributed equally almost
prop.table(table(train$label, train$pixel0))*100

df.sample <- data.frame()
for (i in 0:9) {
    sprintf("Sampling Digit %d",i)
    #Seeding required for reproducibility
    set.seed(i)
    temp.df <- train[train$label==i,]
    #Get 20% of the existing data for model evaluation
    temp.samp <- sample(nrow(temp.df),nrow(temp.df)*5/100,replace = FALSE)
    df.sample <- rbind(df.sample,as.data.frame(temp.df[temp.samp,]))
}

#Checking distribution of the sample on digit labels
aggregate(pixel10~label,data=df.sample, FUN=length)

write.csv(df.sample,file="sample/digit_train_sample_5per.csv",row.names=FALSE,quote=FALSE)

