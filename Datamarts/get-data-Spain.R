## Downloading files for each season from 00-01 season to 14-15 season

download.file("https://raw.githubusercontent.com/jokecamp/FootballData/master/football-data.co.uk/spain/SP1%20(8).csv",
              destfile="C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2005-2006.csv")

download.file("https://raw.githubusercontent.com/jokecamp/FootballData/master/football-data.co.uk/spain/SP1%20(7).csv",
              destfile="C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2006-2007.csv")

download.file("https://raw.githubusercontent.com/jokecamp/FootballData/master/football-data.co.uk/spain/SP1%20(6).csv",
              destfile="C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2007-2008.csv")

download.file("https://raw.githubusercontent.com/jokecamp/FootballData/master/football-data.co.uk/spain/SP1%20(5).csv",
              destfile="C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2008-2009.csv")

download.file("https://raw.githubusercontent.com/jokecamp/FootballData/master/football-data.co.uk/spain/SP1%20(4).csv",
              destfile="C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2009-2010.csv")

download.file("https://raw.githubusercontent.com/jokecamp/FootballData/master/football-data.co.uk/spain/SP1%20(3).csv",
              destfile="C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2010-2011.csv")

download.file("https://raw.githubusercontent.com/jokecamp/FootballData/master/football-data.co.uk/spain/SP1%20(2).csv",
              destfile="C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2011-2012.csv")

download.file("https://raw.githubusercontent.com/jokecamp/FootballData/master/football-data.co.uk/spain/SP1%20(1).csv",
              destfile="C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2012-2013.csv")

## Load the data 
data_0506<-read.csv("C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2005-2006.csv")
data_0506$season<-"05-06"
clean_0506<-na.omit(subset(data_0506,select=c(season,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HS,AS,HST,AST,HC,AC,HF,AF,HY,AY,HR,AR,B365H,B365D,B365A)))

data_0607<-read.csv("C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2006-2007.csv")
data_0607$season<-"06-07"
clean_0607<-na.omit(subset(data_0607,select=c(season,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HS,AS,HST,AST,HC,AC,HF,AF,HY,AY,HR,AR,B365H,B365D,B365A)))

data_0708<-read.csv("C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2007-2008.csv")
data_0708$season<-"07-08"
clean_0708<-na.omit(subset(data_0708,select=c(season,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HS,AS,HST,AST,HC,AC,HF,AF,HY,AY,HR,AR,B365H,B365D,B365A)))

data_0809<-read.csv("C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2008-2009.csv")
data_0809$season<-"08-09"
clean_0809<-na.omit(subset(data_0809,select=c(season,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HS,AS,HST,AST,HC,AC,HF,AF,HY,AY,HR,AR,B365H,B365D,B365A)))

data_0910<-read.csv("C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2009-2010.csv")
data_0910$season<-"09-10"
clean_0910<-na.omit(subset(data_0910,select=c(season,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HS,AS,HST,AST,HC,AC,HF,AF,HY,AY,HR,AR,B365H,B365D,B365A)))

data_1011<-read.csv("C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2010-2011.csv")
data_1011$season<-"10-11"
clean_1011<-na.omit(subset(data_1011,select=c(season,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HS,AS,HST,AST,HC,AC,HF,AF,HY,AY,HR,AR,B365H,B365D,B365A)))

data_1112<-read.csv("C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2011-2012.csv")
data_1112$season<-"11-12"
clean_1112<-na.omit(subset(data_1112,select=c(season,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HS,AS,HST,AST,HC,AC,HF,AF,HY,AY,HR,AR,B365H,B365D,B365A)))

data_1213<-read.csv("C:/Users/dracovich/Documents/football-predictor/Datafiles/Spain/2012-2013.csv")
data_1213$season<-"12-13"
clean_1213<-na.omit(subset(data_1213,select=c(season,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HS,AS,HST,AST,HC,AC,HF,AF,HY,AY,HR,AR,B365H,B365D,B365A)))
                   
all_seasons<-rbind(clean_0506,
                   clean_0607,
                   clean_0708,
                   clean_0809,
                   clean_0910,
                   clean_1011,
                   clean_1112,
                   clean_1213)

write.csv(all_seasons, file = "C:/Users/dracovich/Documents/football-predictor/all_seasons_spain.csv")