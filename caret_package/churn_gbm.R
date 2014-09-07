library(C50)
library(caret)
library(doMC)
data(churn)

registerDoMC(cores = 4)

predictors <- names(churnTrain)[names(churnTrain) != "churn"]

#Data preprocessing
numerics <- c("account_length","total_day_calls","total_night_calls")

procValues <- preProcess(churnTrain[,numerics], method = c("center","scale","YeoJohnson"))
trainScaled <- predict(procValues, churnTrain[,numerics])
testScaled <- predict(procValues, churnTest[,numerics])

#Applying GBM
#Setting grid for tuning parameters
grid <- expand.grid(interaction.depth = seq(1,7,by=2)
                    ,n.trees = seq(100,1000,by=50)
                    ,shrinkage = c(0.01,0.1))

ctrl <- trainControl(method = "repeatedCV", repeats = 5, summaryFunction = twoClassSummary, classProbs=TRUE)

set.seed(1244)

gbmTune <- train(x = churnTrain[,predictors],y = churnTrain$churn
                 , method = "gbm",metric="ROC",tuneGrid=grid, trControl=ctrl,verbose=FALSE)
plot(gbmTune)
#Also ggplot can be used
ggplot(gbmTune)

plot(gbmTune,metric="ROC")


save(gbmTune, file='/Users/njvijay/big_data/Github/MachineLearning-R/caret_package/churn_gbm_model.RData')

#Predict and get probs for model evaluation
gbmPred <- predict(gbmTune, newdata = churnTest[,predictors])

gbmProbs <- predict(gbmTune, churnTest[,predictors], type = "prob")

confusionMatrix(gbmPred, churnTest$churn)

#ROC curve
library(pROC)
rocCurve <- roc(response = churnTest$churn, predictor = gbmProbs[,"yes"], levels = rev(levels(churnTest$churn)))
plot(rocCurve)
