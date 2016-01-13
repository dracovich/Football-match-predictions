# EPL and SPD football match predictions

Playing around with R working with data i find interesting, i've downloaded the match data from football-data.co.uk, and worked it into a datamart that averages the results of the past 5 games  for each team, and then creates variables that are the ratio of the hometeam to the awayteam. These variables are then used to try and create prediction algorithms.

The specific club is not taken into account, in order to try and give a larger amount of data, rather we only look at things such as average shots on goal, shots on target, yellow cards, goals, points, league position etc.

In the end the predictions are given in probabilities, and these are compared to the betting odds from Bet365, the results are quite similar to their odds, but unfortunately for my wallet, it didn't seem to give any edge over the odds. There is a file (Learning/betting_odds.R) that goes through the odds and cycles through a few variations to see if a betting scheme could be found that yielded positive results, which it does on the training and cross validation data, but when the same is run on the testing data, we always see a net negative effect no matter what betting pattern we try.
