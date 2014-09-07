library(RCurl)

read_data <- function(URLparam, test=FALSE)
{ 
    
    url <- getURL(URLparam)
    missing.types <- c("NA", "")
    if (test)
        column.types <- c('integer',   # PassengerId
                            'factor',    # Pclass
                            'character', # Name
                            'factor',    # Sex
                            'numeric',   # Age
                            'integer',   # SibSp
                            'integer',   # Parch
                            'character', # Ticket
                            'numeric',   # Fare
                            'character', # Cabin
                            'factor'     # Embarked
                            ) else 
        column.types <- c('integer',   # PassengerId
                          'factor',    # Survived 
                                'factor',    # Pclass
                                'character', # Name
                                'factor',    # Sex
                                'numeric',   # Age
                                'integer',   # SibSp
                                'integer',   # Parch
                                'character', # Ticket
                                'numeric',   # Fare
                                'character', # Cabin
                                'factor'     # Embarked
                                )
    data.csv <- read.csv(textConnection(object = url),header = TRUE,colClasses = column.types, na.strings=missing.types)
    return (data.csv)
}

train <- read_data("http://kaggle.sowmiyan.com/titanic/train.csv")
test <- read_data("http://kaggle.sowmiyan.com/titanic/test.csv", test=TRUE)

summary(train)

#Trying to see NA's
require(Amelia)
par(mfrow = c(1,2))
missmap(obj = train,main = "Titanic training data-Missing Map",col=c("yellow","black"))
missmap(obj = test,main = "Titanic test data-Missing Map",col=c("yellow","black"))
par(mfrow=c(1,1))
