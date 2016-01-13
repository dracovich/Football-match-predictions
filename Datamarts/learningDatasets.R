## Load all the data
data_spain<-read.csv("Datamarts/SPD.csv")
data_england<-read.csv("Datamarts/EPL.csv")

data_combined<-rbind(data_spain,data_england)

set.seed(322)
## Now we split intot training, crossValidation and testing (60/20/20)
## We set seed earlier so the testing dataset is never touched until the very end
trainIndex = createDataPartition(data_combined$results, p = 0.60,list=FALSE)
training = data_combined[trainIndex,]
testingTemp = data_combined[-trainIndex,]

## Now split the temp into test and CV
testIndex = createDataPartition(testingTemp$results, p = 0.50,list=FALSE)
testing = testingTemp[testIndex,]
crossValidation = testingTemp[-testIndex,]

write.csv(training, file = "Datamarts/training.csv")
write.csv(crossValidation, file = "Datamarts/crossValidation.csv")
write.csv(testing, file = "Datamarts/testing.csv")