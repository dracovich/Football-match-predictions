earnedHome<-function(data, limit){
    data$earned<-ifelse(data$HPotentialEarning>limit, data$HActualEarned,0) 
    
    earned<-sum(data$earned)
    return(earned)
}