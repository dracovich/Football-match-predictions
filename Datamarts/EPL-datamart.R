library(zoo)
library(sqldf)
library(plyr)
library(reshape2)
library(ggplot2)


## Load the cleanup functions
source(file="Datamarts/teamCleanup.R") 
source(file="Datamarts/teamMerge.R") 
source(file="Datamarts/teamStanding.R")
source(file="Datamarts/tableStanding.R")

## Load the edited file and define the colClasses
col<-c("factor",rep("character",4),rep("numeric",2),"factor",rep("numeric",15))
data<-read.csv("Datafiles/England/all_seasons_england.csv", colClasses=col)

## We have to reformat the date variable from a string to a date
## Upon looking at data however, we see that tehre are two formats in data, so we need to split data first
## Then format, and subsequently rejoin them with the same date format
dateLengthLong<-nchar(as.character(data$Date))>8
dateLengthShort<-nchar(as.character(data$Date))<=8
dateLong<-data[dateLengthLong,]
dateShort<-data[dateLengthShort,]

dateShort$Date<-as.Date(dateShort$Date, "%d/%m/%y")
dateLong$Date<-as.Date(dateLong$Date, "%d/%m/%Y")

data<-rbind(dateShort,dateLong)

## Define home and away discipline points (HDP and ADP respectively), 10points for yellow, 25 for red.
data$ADP<-data$AY*10+data$AR*25
data$HDP<-data$HY*10+data$HR*25

## Incomplete dataset, missing half of 12-13 and nothing after that
seasons_wanted<-c("00-01",
                  "01-02",
                  "02-03",
                  "03-04",
                  "04-05",
                  "05-06",
                  "06-07",
                  "07-08",
                  "08-09",
                  "09-10",
                  "10-11",
                  "11-12",
                  "12-13",
                  "13-14",
                  "14-15")

selection_row<-data$season %in% seasons_wanted
data<-cbind(data,selection_row)

## Select the relevant seasons, and premier league (E0) only
data<-subset(data,selection_row==TRUE)

## Need to rename since "AS" messes with the SQL syntax if its a variable name.
data<-rename(data,c("AS"="AwayShots", "HS"="HomeShots"))

data<-data[order(data$Date),]

## We cycle through all games in all seasons, and create a rolling mean of the previous
## 3 games for all variables, in order to get predictive variables.
for(k in seasons_wanted){
      season_subset<-subset(data,season==k)
      teams<-unique(season_subset$HomeTeam)
      for (i in teams){
            team_subset<-subset(season_subset,(HomeTeam==i | AwayTeam==i))
            
            ## Run the cleanup on data for team i  
            team_cleaned<-teamCleanup(i,team_subset)
            
            ## If it's the first team, initiate the data-frame, if not just append it
            if(i==teams[1]){
                  combined<-team_cleaned
            } else {
                  combined<-rbind(combined,team_cleaned)
            }
      }
      cleanSeason<-season_subset[c(1,5,6,11)]                         
      
      ## Removing the first 5 games again (since they dont hvae rolling 5 data)
      combinedClean<-as.data.frame(combined[complete.cases(combined$mGoals),])
      
      ## Calculate the standing of each team before each game measured (using previously defined functions)
      indTeamStanding<-as.data.frame(apply(combinedClean[,c("season","Date","team")],1,function(x) teamStanding(x[1],x[2],x[3])))
      names(indTeamStanding)[1]<-"standing"  
      combinedFinal<-cbind(combinedClean,indTeamStanding)
      
      ## Load the team merger function, to create a dataset with one game per line
      teams_merged<-teamMerge(combinedFinal)
      
      if(k==seasons_wanted[1]){
            sCombined<-teams_merged
      } else {
            sCombined<-rbind(sCombined,teams_merged)
      }
}

## We do the analysis based on the assumption that the only relevant variables are interaction variables. We want to know how the comparative form
## from one team to the next compares. We divide each home variable with the away variable, and those are our predictors.

## In the cases where there number is literally zero, give a small but not impossible number (0.1 for example being half of the lowest possible
## non zero number). If we don¨t do this we risk a lot of dividing by zero.

newPredictors<-sCombined[c(1,2)]
newPredictors$league<-"EPL"
newPredictors$cumPoints<-sCombined$aCumPointsBefore/max(sCombined$hCumPointsBefore,1)
newPredictors$Goals<-sCombined$aGoals/max(sCombined$hGoals,0.1)
newPredictors$Points<-sCombined$aPoints/max(sCombined$hPoints,0.1)
newPredictors$Standing<-sCombined$aStanding/sCombined$hStanding
newPredictors$Shots<-sCombined$aShots/max(sCombined$hShots,0.1)
newPredictors$ShotsOnTarget<-sCombined$aShotsOnTarget/max(sCombined$hShotsOnTarget,0.1)
newPredictors$Corners<-sCombined$aCorners/max(sCombined$hCorners,0.1)
newPredictors$Fouls<-sCombined$aFouls/max(sCombined$hFouls,0.1)
newPredictors$DP<-sCombined$aDP/max(sCombined$hDP,1)
      
## Now we add the match results

results<-as.data.frame(data$X)
results$results<-data$FTR
results<-rename(results,c("data$X"="X"))
withResults<-merge(newPredictors,results,by=c("X"))

withResults2<-merge(withResults,data[,c(1,21:23)])

## Remove all but predictors and results
finalData<-withResults2[-c(1,2)]

write.csv(finalData, file = "Datamarts/EPL.csv")