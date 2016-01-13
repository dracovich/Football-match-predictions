library(nnet)
library(glmnet)
library(AppliedPredictiveModeling)
library(caret)
library(randomForest)
require(MASS)

source(file="Learning/earned.R")
source(file="Learning/interactionTerms.R")


## Load all the data
data_spain<-read.csv("Datamarts/SPD.csv")
data_england<-read.csv("Datamarts/EPL.csv")

data_combined<-rbind(data_spain,data_england)
data_combined<-data_combined[,-1,]

## Use the interactionTerms function to create extra variables
## Data must be without the results, so we remove it first, and then recombine
results<-as.data.frame(data_combined$results)
names(results)<-paste("results")

withInteractions<-interactionTerms(data_combined[-11], 2, 2)

data_interactions<-cbind(withInteractions,results)



set.seed(322)

## Split into training and learning (interaction terms)
trainIndex<- createDataPartition(data_interactions$results, p = 0.60,list=FALSE)
training_int<- data_interactions[trainIndex,]
testing_temp<- data_interactions[-trainIndex,]

## Now split the testing into actual testing and CV
testIndex<- createDataPartition(testing_temp$results, p = 0.50,list=FALSE)
testing_int<- testing_temp[testIndex,]
CV_int<- testing_temp[-testIndex,]

## Split into training and learning (no interaction)
trainIndex<- createDataPartition(data_combined$results, p = 0.60,list=FALSE)
training<- data_combined[trainIndex,]
testing_temp<- data_combined[-trainIndex,]

## Now split the testing into actual testing and CV
testIndex<- createDataPartition(testing_temp$results, p = 0.50,list=FALSE)
testing<- testing_temp[testIndex,]
CV_int<- testing_temp[-testIndex,]





## Do some basic neural network multinom analysis, must remove the league value since the neural network can't handle two factor variables.
nnFit<-multinom(results ~ ., data=training_int[,-1] )
nnPredictions<-predict(nnFit,testing_int)
nnMatrix<-confusionMatrix(nnPredictions,testing_int$results)
nnTrainPred<-as.data.frame(predict(nnFit,training_int))

## Attempt to do a random forest prediction now
rfFit<-randomForest(results ~ ., data=training)
rfPredictions<-predict(rfFit,testing)
rfMatrix<-confusionMatrix(rfPredictions,testing$results)
rfTrainPred<-as.data.frame(predict(rfFit,training))

## Regularized GLM regression (not working yet)
glmMatrix<-as.matrix(training_int[,c(-1,-47)])
glmFit<-glmnet(glmMatrix,training_int$results,family="multinomial")
glmPredictions<-predict(glmFit,testing_int,s=0.1)

## Combine RF and neural network using RF
newTraining<-cbind(rfTrainPred,nnTrainPred,training$results)
names(newTraining)<-c("rf","nn","results")
newRfFit<-randomForest(results~.,data=newTraining)

newTesting<-cbind(as.data.frame(rfPredictions),as.data.frame(nnPredictions),testing$results)
names(newTesting)<-c("rf","nn","results")
newRfPred<-predict(newRfFit,newTesting)
newRfMatrix<-confusionMatrix(newRfPred,newTesting$results)





## 

basicData<-withResults[c(1,2,12)]
withPredictions<-cbind(withResults[c(1,2,12)],predictions)
bettingData<-data[c(1,23,22,21)]

withBetting<-merge(withPredictions,bettingData,by=c("X"))
withBetting<-subset(withBetting,B365A>0)

## The potential earning calculated, probability of winning multiplied by the betting odds, and a 100$ bet. Anything below
## suggests we are losing money.
withBetting$APotentialEarning<-100*withBetting$A*withBetting$B365A-100
withBetting$DPotentialEarning<-100*withBetting$D*withBetting$B365D-100
withBetting$HPotentialEarning<-100*withBetting$H*withBetting$B365H-100

## Now calculate what we would have actually earned playing 100$ on that game.
withBetting$AActualEarned<-ifelse(withBetting$result=="A",withBetting$B365A*100-100,-100)
withBetting$DActualEarned<-ifelse(withBetting$result=="D",withBetting$B365D*100-100,-100)
withBetting$HActualEarned<-ifelse(withBetting$result=="H",withBetting$B365H*100-100,-100)


start<-c(-100)

for(j in 1:100) {
    calc_limit<-start+j*5
    earned_temp<-earnedHome(withBetting,calc_limit)
    
    if (j==1){
        earned_table<-as.data.frame(earned_temp)
        earned_table$limit<-calc_limit
    } else {
        earned_table_temp<-as.data.frame(earned_temp)
        earned_table_temp$limit<-calc_limit
        
        earned_table<-rbind(earned_table,earned_table_temp)
    }
}
