#Website for reference - http://bayesianbiologist.com/2012/08/13/the-essence-of-a-handwritten-digit/
library(caret)
library(RCurl)
library(doMC)

#Setting Parallelism
registerDoMC(cores = 3)

mycsv.connection <- getURL(url = "http://kaggle.sowmiyan.com/digit_recog/train.csv")
train.data <- read.csv(textConnection(object = mycsv.connection),header=TRUE)
train.data <- as.matrix(train.data)

##Color ramp def.
colors<-c('white','black')
cus_col<-colorRampPalette(colors=colors)
## Plot the average image of each digit
par(mfrow=c(4,3),pty='s',mar=c(1,1,1,1),xaxt='n',yaxt='n')
all_img<-array(dim=c(10,28*28))

for(i in 0:9)
{
  z<-array(train.data[i,-1],dim=c(28,28))
  z<-z[,28:1] ##right side up
  image(1:28,1:28,z,main=train.data[i,1],col=cus_col(256))
  print(i)
}