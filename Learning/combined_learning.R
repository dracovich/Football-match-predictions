## Load all the data

source(file="Learning/rf_learning.R")
source(file="Learning/glm_learning.R")
source(file="Learning/nn_learning.R")

## create the combined dataset
combined_training<-cbind(rfPredictions,nnPredictions,glmTrainingA,glmTrainingH,glmTrainingD,training$results)
colnames(combined_training)<-c("rfA","rfD","rfH","nnA","nnD","nnH","glmA","glmH","glmD","results")

combined_cv<-cbind(rfCV,nnCV,glmCVA,glmCVH,glmCVD,crossValidation$results)
colnames(combined_cv)<-c("rfA","rfD","rfH","nnA","nnD","nnH","glmA","glmH","glmD","results")

combined_testing<-cbind(rfTesting,nnTesting,glmTestingA,glmTestingH,glmTestingD,testing$results)
colnames(combined_testing)<-c("rfA","rfD","rfH","nnA","nnD","nnH","glmA","glmH","glmD","results")

## Fit a random forest to the combined results of all 3 types of learning
nodeSize<-c(5,10,20,40,100,200,400)
numberOfTrees<-c(100,200,400,600,800,1000)

results<-data.frame(nodeSize=integer(),
                    numberOfTrees=integer(),
                    accuracy=double())

for(i in nodeSize){
    for(d in numberOfTrees){
        rfFit<-randomForest(results~.,data=combined_training,nodesize=i, ntree=d)
        rfPredictions<-predict(rfFit,newdata=combined_cv)
        rfMatrix<-confusionMatrix(rfPredictions,combined_cv$results)    
        
        tempVec<-c(i,d,rfMatrix$overall[1])
        
        results<-rbind(results,tempVec)
    }
    
}
colnames(results)<-c("nodeSize","treeNumber","accuracy")

bestResult<-results[which(results$accuracy==max(results$accuracy)),]

rfFit<-randomForest(results~.,data=combined_training,nodesize=bestResult[1,1], ntree=bestResult[1,2])
rfPredictions<-predict(rfFit,newdata=combined_testing)
rfMatrix<-confusionMatrix(rfPredictions,combined_testing$results)

rfMatrix

## Combine entire dataset so we can work on the odds
totalCombined<-rbind(combined_training,combined_testing,combined_cv)
totalPrediction<-as.data.frame(predict(rfFit,newdata=totalCombined, type="prob"))

training<-read.csv("Datamarts/training.csv")
crossValidation<-read.csv("Datamarts/crossValidation.csv")
testing<-read.csv("Datamarts/testing.csv")

totalData<-rbind(training,testing,crossValidation)
bettingData<-totalData[,13:16]

final<-cbind(totalPrediction,bettingData)
finalTesting<-final[4544:6056,]

write.csv(final, file = "Datamarts/predictedData.csv")
write.csv(finalTesting, file = "Datamarts/predictedTesting.csv")