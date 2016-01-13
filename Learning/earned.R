earned<-function(data, limit){
    data$earned<-
    ifelse(     data$APotentialEarning>=data$DPotentialEarning & 
                data$APotentialEarning>=data$HPotentialEarning & 
                data$APotentialEarning>limit, data$AActualEarned,
                
        ifelse( data$DPotentialEarning>=data$APotentialEarning & 
                data$DPotentialEarning>=data$HPotentialEarning & 
                data$DPotentialEarning>limit, data$DActualEarned,

        ifelse( data$HPotentialEarning>=data$APotentialEarning & 
                data$HPotentialEarning>=data$DPotentialEarning & 
                data$HPotentialEarning>limit, data$HActualEarned,
        0                
            )))
    
    earned<-sum(data$earned)
    
    return(earned)
}