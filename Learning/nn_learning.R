library(nnet)

## Load all the data
training<-read.csv("Datamarts/training.csv")
crossValidation<-read.csv("Datamarts/crossValidation.csv")
testing<-read.csv("Datamarts/testing.csv")

training<-training[,-c(1:2,14:16)]
crossValidation<-crossValidation[,-c(1:2,14:16)]
testing<-testing[,-c(1:2,14:16)]

nnFit<-multinom(results~., data=training[,-1])
nnPredictions<-predict(nnFit,training, type="probs")
colnames(nnPredictions)<-c("nnA","nnD","nnH")

nnTesting<-predict(nnFit,testing, type="probs")
nnCV<-predict(nnFit,crossValidation, type="probs")