uplowEarned<-function(data, lowerlimit,upperlimit){
    data$earned<-
        ifelse(     data$APotentialEarning>=data$DPotentialEarning & 
                        data$APotentialEarning>=data$HPotentialEarning & 
                        data$APotentialEarning>lowerlimit &
                        data$APotentialEarning<upperlimit, data$AActualEarned,
                    
                    ifelse( data$DPotentialEarning>=data$APotentialEarning & 
                                data$DPotentialEarning>=data$HPotentialEarning & 
                                data$DPotentialEarning>lowerlimit &
                                data$DPotentialEarning<upperlimit, data$DActualEarned,
                            
                            ifelse( data$HPotentialEarning>=data$APotentialEarning & 
                                        data$HPotentialEarning>=data$DPotentialEarning & 
                                        data$HPotentialEarning>lowerlimit &
                                        data$HPotentialEarning<upperlimit, data$HActualEarned,
                                    0                
                            )))
    
    earned<-sum(data$earned)
    
    return(earned)
}