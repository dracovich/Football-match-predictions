library(randomForest)

## Load all the data
training<-read.csv("Datamarts/training.csv")
crossValidation<-read.csv("Datamarts/crossValidation.csv")
testing<-read.csv("Datamarts/testing.csv")

training<-training[,-c(1:2,14:16)]
crossValidation<-crossValidation[,-c(1:2,14:16)]
testing<-testing[,-c(1:2,14:16)]

## Start off by using the cross validation set to find optimal nodesize and tree size.
## This is a pretty small dataset, so we can allow ourselves to make many combiunations.

nodeSize<-c(5,10,20,40,100,200,400)
numberOfTrees<-c(100,200,400,600,800,1000)

results<-data.frame(nodeSize=integer(),
                    numberOfTrees=integer(),
                    accuracy=double())

for(i in nodeSize){
    for(d in numberOfTrees){
        rfFit<-randomForest(results~.,data=training,nodesize=i, ntree=d)
        rfPredictions<-predict(rfFit,newdata=crossValidation)
        rfMatrix<-confusionMatrix(rfPredictions,crossValidation$results)    
        
        tempVec<-c(i,d,rfMatrix$overall[1])
        
        results<-rbind(results,tempVec)
    }
    
}
colnames(results)<-c("nodeSize","treeNumber","accuracy")

bestResult<-results[which(results$accuracy==max(results$accuracy)),]

rfFit<-randomForest(results~.,data=training,nodesize=bestResult[1,1], ntree=bestResult[1,2])
rfPredictions<-predict(rfFit,newdata=training, type="prob")

rfCV<-predict(rfFit,newdata=crossValidation,type="prob")
rfTesting<-predict(rfFit,newdata=testing,type="prob")