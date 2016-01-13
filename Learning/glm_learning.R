library(caret)
library(glmnet)

source(file="Learning/interactionTerms.R")

## Load all the data
training<-read.csv("Datamarts/training.csv")
crossValidation<-read.csv("Datamarts/crossValidation.csv")
testing<-read.csv("Datamarts/testing.csv")


## Use the interactionTerms function to create extra variables
## Data must be without the results, so we remove it first, and then recombine
trainingResults<-as.data.frame(training$results)
names(trainingResults)<-paste("results")

crossValidationResults<-as.data.frame(crossValidation$results)
names(crossValidationResults)<-paste("results")

testingResults<-as.data.frame(testing$results)
names(testingResults)<-paste("results")

## Create the interacions and rebind the results
trainingInteractions<-interactionTerms(training[,-c(1:3,13:16)], 2, 2)
glmTraining<-cbind(trainingInteractions,trainingResults)

cvInteractions<-interactionTerms(crossValidation[,-c(1:3,13:16)], 2, 2)
glmCV<-cbind(cvInteractions,crossValidationResults)

testingInteractions<-interactionTerms(testing[,-c(1:3,13:16)], 2, 2)
glmTesting<-cbind(testingInteractions,testingResults)


## Need to create a mtrix for it to fit the format that GLMnet needs
tempGLMtraining<-as.matrix(glmTraining[,1:37])
tempGLMTesting<-as.matrix(glmTesting[,1:37])
tempGLMcrossValidation<-as.matrix(glmCV[,1:37])

## Away Win
y1<-ifelse(training$results=="A",1,0)
cvFit1<-cv.glmnet(tempGLMtraining,y1,family="binomial")
glmTrainingA<-as.data.frame(predict(cvFit1, tempGLMtraining, s= "lambda.min",type="response"))
colnames(glmTrainingA)<-c("cv1")

## Home Win
y2<-ifelse(training$results=="H",1,0)
cvFit2<-cv.glmnet(tempGLMtraining,y2,family="binomial")
glmTrainingH<-as.data.frame(predict(cvFit2, tempGLMtraining, s= "lambda.min",type="response"))
colnames(glmTrainingH)<-c("cv2")

## Draw
y3<-ifelse(training$results=="D",1,0)
cvFit3<-cv.glmnet(tempGLMtraining,y3,family="binomial")
glmTrainingD<-as.matrix(predict(cvFit3, tempGLMtraining, s= "lambda.min",type="response"))
colnames(glmTrainingD)<-c("cv3")

## Create datasets for the testing as well so we can test the accuracy of the combined model
glmCVA<-as.data.frame(predict(cvFit1, tempGLMcrossValidation, s= "lambda.min",type="response"))
glmCVH<-as.data.frame(predict(cvFit2, tempGLMcrossValidation, s= "lambda.min",type="response"))
glmCVD<-as.data.frame(predict(cvFit3, tempGLMcrossValidation, s= "lambda.min",type="response"))

glmTestingA<-as.data.frame(predict(cvFit1, tempGLMTesting, s= "lambda.min",type="response"))
glmTestingH<-as.data.frame(predict(cvFit2, tempGLMTesting, s= "lambda.min",type="response"))
glmTestingD<-as.data.frame(predict(cvFit3, tempGLMTesting, s= "lambda.min",type="response"))
