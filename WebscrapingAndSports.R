#Testing for correlation between wage bills and league standings of teams in English Premier League


```{r}
install.packages("foreign", repos="http://cran.rstudio.com/")
install.packages("haven", repos="http://cran.rstudio.com/")
install.packages("xlsx", repos="http://cran.rstudio.com/")
install.packages("XML", repos="http://cran.rstudio.com/")

library(foreign)
library(haven)
library(xlsx)



#Testing for correlation between wage bills and league standings of teams in English Premier League
getwd()
library(XML)
junk <- readHTMLTable("http://www.totalsportek.com/money/english-premier-league-wage-bills-club-by-club/", stringsAsFactors=FALSE)
standings2013 <- data.frame(readHTMLTable("http://www.espnfc.us/barclays-premier-league/23/table?season=2013", stringAsFactors= FALSE, header = TRUE))

names(standings2013)[2] <- c("TEAM")
standings2013[2] <- as.vector(standings2013$TEAM)
standings2013 <- na.omit(standings2013)
standings2013 <- standings2013[order(standings2013$TEAM),]
standings2013 <- standings2013[c(1:17,19,20,21),1:24]

EPLwageBills <- data.frame(junk[[1]][-1,-1]) 
names(EPLwageBills) <- c("Club","2013-2014","2014-2015","2015-2016")
EPLwageBills[c(16,17,18,19,20),c(2)] <- c(46,53,54,43,69)
EPLwageBills <- EPLwageBills[order(EPLwageBills$Club),]

test2 <- EPLwageBills[,c(1,2)]
test2[3] <- test2[2]
test2[,1:2] <- standings2013[,2:1]

test2[,c(3)] <- gsub("m","",test2[,c(3)])
test2[,c(3)] <- gsub("£","",test2[,c(3)])
test2[,c(3)] <- as.numeric(test2[,c(3)])

test2014 <- test2

top2014 <- test2014[1:10,c(3)]
bot2014 <- test2014[11:20,c(3)]

var.test(top2014,bot2014)
t.test(top2014,bot2014, alternative = "greater", var.equal = TRUE)
```
#The t-statistic is -2.9608 and the p-value is very high, indicating that the NULL hypothesis is probably True--true difference in means in less than 0. However, the league standards are in a counterintuitive order--finishing with a lower numeral actually means finishing in a higher position. So a negative t-statistic means that the teams with the highest ten wages, earn a positions of lower numerals but of greater success. Therefore, there is strong evidence of a correlation between (suprise) paying your players more, and winning more

#Ran another test for this year's data, just because the league standings seemed remarkably counterintuitive this year. There's still a correlation, but by less.
```{r}
test <- EPLwageBills[,c(1,4)]

test[,c(2)] <- gsub("m","",test[,c(2)])
test[,c(2)] <- gsub("£","",test[,c(2)])
test[,c(2)] <- as.numeric(test[,c(2)])
test$finalPosition <- c(10,5,4,2,8,3,18,11,9,17,7,20,14,6,12,15,1,19,13,16)

top2016 <- test[1:10,c(3)]
bot2016 <- test[11:20,c(3)]

var.test(top2016,bot2016)
t.test(top2016,bot2016, alternative = "greater", var.equal = TRUE)
```


#Let's find out how many goals, on average, were scored off of corner kicks by a team in the 2011-2012 season
```{r}
EPLgoals <- read.csv("https://raw.githubusercontent.com/soccermetrics/project-data/master/english-premier-league-2011-2012/Goals.csv", stringsAsFactors = FALSE)
                 
goalTypes <- unique(EPLgoals$Event)    

##Use tapply to see how many of each type of goal each team had
teamGoals <- tapply(EPLgoals$Event, EPLgoals$Team, table)

##Used sapply to extract the first component (Goals from Corner Kick Crosses) of each list element. Two teams had none so I set their values equal to 0 manually. Then found the mean corner kick goals of the teams
corners <- sapply(teamGoals,function(x) x[1])
corners[c(2,19)] <- 0
mean(corners)
```

#Which baseball manager has the most wins with any active franchise? The most losses? The most games? Which team has the most wins between 2001 and 2015?
```{r}
library(rvest)
library(dplyr)
## Loading required package: xml2
# starting page
teampage <- read_html("http://www.baseball-reference.com/teams/")

# write your r code here
# create a table called baseball that contains all of the teams' franchise histories

scrape <- function(x){
  team <- read_html(x)
  teamHistory <- html_table(html_nodes(team, "table"))
  teamHistory <- as.data.frame(teamHistory)
  teamHistory$'Current Name' <- teamHistory[1,3]
  y <- teamHistory
  return(y)
}

ATL <- scrape('http://www.baseball-reference.com/teams/ATL/')
ANA <- scrape('http://www.baseball-reference.com/teams/ANA/')
ARI <- scrape('http://www.baseball-reference.com/teams/ARI/')
BAL <- scrape('http://www.baseball-reference.com/teams/BAL/')
BOS <- scrape('http://www.baseball-reference.com/teams/BOS/')
CHC <- scrape('http://www.baseball-reference.com/teams/CHC/')
CHW <- scrape('http://www.baseball-reference.com/teams/CHW/')
CIN <- scrape('http://www.baseball-reference.com/teams/CIN/')
CLE <- scrape('http://www.baseball-reference.com/teams/CLE/')
COL <- scrape('http://www.baseball-reference.com/teams/COL/')
DET <- scrape('http://www.baseball-reference.com/teams/DET/')
FLA <- scrape('http://www.baseball-reference.com/teams/FLA/')
HOU <- scrape('http://www.baseball-reference.com/teams/HOU/')
KC <- scrape('http://www.baseball-reference.com/teams/KC/')
LAD <- scrape('http://www.baseball-reference.com/teams/LAD/')
MIL <- scrape('http://www.baseball-reference.com/teams/MIL/')
MIN <- scrape('http://www.baseball-reference.com/teams/MIN/')
WSN <- scrape('http://www.baseball-reference.com/teams/WSN/')
NYM <- scrape('http://www.baseball-reference.com/teams/NYM/')
NYY <- scrape('http://www.baseball-reference.com/teams/NYY/')
OAK <- scrape('http://www.baseball-reference.com/teams/OAK/')
PHI <- scrape('http://www.baseball-reference.com/teams/PHI/')
SD <- scrape('http://www.baseball-reference.com/teams/SD/')
PIT <- scrape('http://www.baseball-reference.com/teams/PIT/')
SEA <- scrape('http://www.baseball-reference.com/teams/SEA/')
SF <- scrape('http://www.baseball-reference.com/teams/SF/')
STL <- scrape('http://www.baseball-reference.com/teams/STL/')
TB <- scrape('http://www.baseball-reference.com/teams/TB/')
TEX <- scrape('http://www.baseball-reference.com/teams/TEX/')
TOR <- scrape('http://www.baseball-reference.com/teams/TOR/')

baseball <- rbind(ARI,ATL,ANA,BAL,BOS,CHC,CHW,CIN,CLE,COL,DET,FLA,HOU,KC,LAD,MIL,MIN,NYM,NYY,OAK,PHI,PIT,SD,SEA,SF,STL,TB,TEX,TOR,WSN)

# at the end, be sure to print out the dimensions of your baseball table.
dim(baseball)



library(stringr)
# This code checks to see if text in table has regular space character
# Because the text from the web uses a non-breaking space, we expect there to be a mismatch
# I'm converting to raw because when displayed on screen, we cannot see the difference between
# a regular breaking space and a non-breaking space.
all.equal(charToRaw(baseball$Tm[1]), charToRaw("Arizona Diamondbacks"))

?all.equal
# identify which columns are character columns
char_cols <- which(lapply(baseball, typeof) == "character")

# for each character column, convert to UTF-8
# then replace the non-breaking space with a regular space
for(i in char_cols){
    baseball[[i]] <- str_conv(baseball[[i]], "UTF-8")
    baseball[[i]] <- str_replace_all(baseball[[i]],"\\s"," ")
    baseball[[i]] <- str_replace_all(baseball[[i]],"[:space:]"," ")  # you might have to use this depending on your operating system and which meta characters it recognizes
}

# check to see if the conversion worked
## should now be TRUE
all.equal(charToRaw(baseball$Tm[1]), charToRaw("Arizona Diamondbacks"))



# enter your r code here
# your final line of code here should print the summary table in the report

baseball15 <- baseball %>% filter(Year >= 2001 & Year <= 2015) %>% group_by(`Current Name`) 

baseball15sum <- summarise(baseball15,'W' = sum(W, na.rm = TRUE), 'L' = sum(L, na.rm = TRUE), 'R' = sum(R), 'RA' = sum(RA), 'WPer' = round(sum(W)/(sum(W) + sum(L)),digits = 4), 'PythPer' = round(1/(1 + (sum(R)/sum(RA))^2), digits = 4))

baseball15sum <- baseball15sum %>% arrange(desc(baseball15sum$'WPer'))

baseball15sum[1:30,1:7]

# enter your r code here

# your final line of code here should print the first 10 rows of 
# the summary table in the report

noNames <- gsub("([a-z])", "", baseball[,22], ignore.case = TRUE)
noPeriodsNoNames <- gsub("^.","",noNames[1:2594])
noPeriodsNoNamesNoSpace <- gsub("^ ","",noPeriodsNoNames[1:2594])
noPeriodsNoNamesNoSpaceNoParenthesis <- gsub("\\(","",noPeriodsNoNamesNoSpace[1:2594])
noPeriodsNoNamesNoSpaceNoParenthesis1 <- gsub("\\)","",noPeriodsNoNamesNoSpaceNoParenthesis[1:2594])
aLotGone <- gsub("\\)","",noPeriodsNoNamesNoSpaceNoParenthesis[1:2594])
aLotGone <- gsub("\\.","",aLotGone[1:2594])
aLotGone <- gsub("\\,","",aLotGone[1:2594])

winLoss <- gsub("-"," ",aLotGone)

winLoss1 <- str_split(winLoss, boundary("word"))

library(stringr)

winLossPerManagerStorage <- matrix(nrow = 2594, ncol = 480)

for (i in 1:2594) {
  winLossPerManagerStorage[i,] <- as.numeric(winLoss1[i][[1]])
}

##got win loss storage in numeric form for each year's seperate managers. now need to find years with matching managers. 

##strip numeric and special characters from manager column

nameMatch <- gsub("(\\d)", "", baseball[,22], ignore.case = TRUE)
nameMatch <- gsub("\\(","",nameMatch[1:2594])
nameMatch <- gsub("\\)","",nameMatch[1:2594])
nameMatch <- gsub("-","",nameMatch[1:2594])
nameMatch <- gsub(" $","",nameMatch[1:2594])
nameMatch <- gsub(" and","",nameMatch[1:2594])
nameMatch <- gsub("T.La Russa","T.LaRussa",nameMatch[1:2594])
nameMatch <- gsub("C.Von Der Ahe","C.VonDerAhe",nameMatch[1:2594])

indivNames <- str_split(nameMatch, boundary("word"))

indivManagerStorage <- matrix(nrow = 2594, ncol = 5)
for (i in 1:2594) {
  indivManagerStorage[i,1:length(indivNames[i][[1]])] <- (indivNames[i][[1]])
}

indivManagerDF <- as.data.frame(indivManagerStorage)
winLossDF <- winLossPerManagerStorage

a <- matrix(winLoss1)
b <- matrix()

ok <- str_match_all("\\d+", baseball$Managers)
for(i in 1:2594){
  b[i] <- ncol(ok[[i]])
}
most <- max(b)

#max 5 five managers in a year

##refer to winLossPerManagerStorageCopy if you mess up
winLossPerManagerStorage <- as.data.frame(winLossPerManagerStorage)
winLossPerManagerStorageCopy <- winLossPerManagerStorage
winLossPerManagerStorage <- winLossPerManagerStorageCopy[,1:12]

for(i in 1:2594){
  if(b[i] == 2){
    winLossPerManagerStorage[i,(3:12)] <- 0
  }
  if(b[i] == 3){
    winLossPerManagerStorage[i,(5:12)] <- 0
  }
    if(b[i] == 4){
    winLossPerManagerStorage[i,(7:12)] <- 0
    }
    if(b[i] == 5){
    winLossPerManagerStorage[i,(9:12)] <- 0
    }
    if(b[i] == 6){
    winLossPerManagerStorage[i,(11:12)] <- 0
  }
}

indivManagerDF <- indivManagerDF[,1:5]
indivManagerDFcopy <- indivManagerDF

winLossPerManager <- cbind(indivManagerDF[,1:5], winLossDF[,1:10])

colnames(winLossPerManager) <- c("Manager1","Manager2","Manager3","Manager4","Manager5","W1","L1","W2","L2","W3","L3","W4","L4","W5","L5")

winLossPerManager[,1:5] <- lapply(winLossPerManager[,1:5], as.character)

winLossPerManagerDF <- winLossPerManager %>% group_by(Manager1)
winLossPerManager1 <- summarise(winLossPerManagerDF, totalWins = sum(W1), totalLosses = sum(L1))


winLossPerManagerDF <- winLossPerManager %>% group_by(Manager2)
winLossPerManager2 <- summarise(winLossPerManagerDF, totalWins = sum(W2), totalLosses = sum(L2))

winLossPerManagerDF <- winLossPerManager %>% group_by(Manager3)
winLossPerManager3 <- summarise(winLossPerManagerDF, totalWins = sum(W3), totalLosses = sum(L3))

winLossPerManagerDF <- winLossPerManager %>% group_by(Manager4)
winLossPerManager4 <- summarise(winLossPerManagerDF, totalWins = sum(W4), totalLosses = sum(L4))

winLossPerManagerDF <- winLossPerManager %>% group_by(Manager5)
winLossPerManager5 <- summarise(winLossPerManagerDF, totalWins = sum(W5), totalLosses = sum(L5))

names(winLossPerManager2) <- names(winLossPerManager1)
names(winLossPerManager3) <- names(winLossPerManager1)
names(winLossPerManager4) <- names(winLossPerManager1)
names(winLossPerManager5) <- names(winLossPerManager1)


coach <- rbind(winLossPerManager1,winLossPerManager2,winLossPerManager3,winLossPerManager4,winLossPerManager5)

coach <- coach %>% group_by(Manager1)

winLossPerManager5 <- summarise(winLossPerManagerDF, totalWins = sum(W5), totalLosses = sum(L5))

coachTotal <- summarise(coach, totalWins = sum(totalWins), totalLosses = sum(totalLosses))

coachTotal$'TotalGames' <- coachTotal$totalWins + coachTotal$totalLosses
coachTotal$'Total Win Percentage' <- coachTotal$totalWins/coachTotal$TotalGames

coachTotal <- coachTotal %>% arrange(desc(coachTotal$'TotalGames'))
coachTotal <- coachTotal[-c(1),]




coachTotal[1:10,]

cat("The manager with most wins, losses, and games with any active MLB franchise is", as.character(coachTotal[1,1]))

cat("The team with most wins from 2001 until 2015 are the", as.character(baseball15sum[1,1]))
```
cat("The manager with most wins, losses, and games with any active MLB franchise is", as.character(coachTotal[1,1]))

cat("The team with most wins from 2001 until 2015 are the", as.character(baseball15sum[1,1]))


