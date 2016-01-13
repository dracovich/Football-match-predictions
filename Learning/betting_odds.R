source(file="Learning/uplowEarned.R")

withBetting<-read.csv("Datamarts/predictedTesting.csv")

## The potential earning calculated, probability of winning multiplied by the betting odds, and a 100$ bet. Anything below
## suggests we are losing money.
withBetting$APotentialEarning<-100*withBetting$A*withBetting$B365A-100
withBetting$DPotentialEarning<-100*withBetting$D*withBetting$B365D-100
withBetting$HPotentialEarning<-100*withBetting$H*withBetting$B365H-100

## Now calculate what we would have actually earned playing 100$ on that game.
withBetting$AActualEarned<-ifelse(withBetting$result=="A",withBetting$B365A*100-100,-100)
withBetting$DActualEarned<-ifelse(withBetting$result=="D",withBetting$B365D*100-100,-100)
withBetting$HActualEarned<-ifelse(withBetting$result=="H",withBetting$B365H*100-100,-100)

## Calculate hypothetical earned.
lower<-c(-30,-10,1,10,30)
upper<-c(50,100,150,200,250,300,350,400,450,500)

results<-data.frame(upper=integer(),
                    lower=integer(),
                    earned=double())

for(i in lower){
    for(d in upper){
        earned<-uplowEarned(withBetting,i,d)
        
        tempEarned<-c(i,d,earned)
        
        results<-rbind(results,tempEarned)
    }
}
colnames(results)<-c("lower","upper","earned")

## Create plot of the outcome
library(scatterplot3d)

wireframe(earned ~ lower*upper, data = results,
          xlab = "Lower limit", ylab = "Upper limit",
          main = "Surface elevation data",
          drape = TRUE,
          colorkey = TRUE,
)

bestResult<-results[which(results$earned==max(results$earned)),]