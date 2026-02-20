install.packages("reshape2")
library(ggplot2)
library(reshape2)

## Task 1 ##

## A
rm(list = ls())
set.seed(32312873) # XXXXXXXX = your student ID
cvbase = read.csv("PsyCoronaBaselineExtract.csv")
cvbase <- cvbase[sample(nrow(cvbase), 40000), ] # 40000 rows
#viewing the dataset
View(cvbase)
# doing some analysis to find the dimension, structure etc of the dataset
dim(cvbase)
names(cvbase)
str(cvbase)
summary(cvbase) #finding distribution of all numerical values
#finding detailed distribution of education
education <- table(cvbase$edu)
barplot(education, col = "darkblue", xlab = "Education Level", ylab = "Number of Observations")
#finding detailed distribution of MLQ
MLQ <- table(cvbase$MLQ)
barplot(MLQ, col = "lightblue",xlab = "MLQ: Agree or Disagree", ylab = "Number of Observations"
)
#finding distribution of non-numerical values for rankorderlife
unique(cvbase$rankOrdLife_1)
# making table with all country names in codedcountry
unique_countries <- unique(cvbase$coded_country)
length(unique_countries) # finding length of table (number of countries)
#checking how many entries do not contain a country
sum(cvbase$coded_country == "")
#finding the most occurring and least occuring countries
table(cvbase$coded_country)
countryObs <- table(cvbase$coded_country)
#finding number of obs for most occurring country
max(countryObs)
#finding corresponding highest occurring country
names(which.max(countryObs))
#finding how many countries only had one observation
sum(countryObs==1)
#finding the number of missing values in the entire table
sum(is.na(cvbase))

## B
#replacing the N/A values in the employstatus attributes with 0
#updating the dataset to include this change
cvbase[1:10] <- replace(cvbase[1:10], is.na(cvbase[1:10]), 0)
#replacing the N/A values in the coronaClose attributes with 0
#updating the dataset to include this change
cvbase[39:44] <- replace(cvbase[39:44], is.na(cvbase[39:44]), 0)
#checking number of missing values after the change
sum(is.na(cvbase))
#get rid of all entries that do not contain a country name
#only the rows where the country field is not blank are selected
#the data set is updated to include only these rows
cvbase <- subset(cvbase, coded_country != "")
#conduct check to ensure there are no entries without country names
sum(cvbase$coded_country == "")
#changing characters to numbers in the rankOrderLife attributes
#a function is defined to map characters to numbers
mapping <- c("A" = 1, "B" = 2, "C" = 3, "D" = 4, "E" = 5, "F" = 6)
#iterating through the rankOrdLife categories 1-6
#if the value is non-numeric
#it is replaced with the corresponding number
for (x in colnames(cvbase)[27:32]) {
  if(!is.numeric(cvbase[[x]])) {
    cvbase[[x]] <- sapply(cvbase[[x]], function(y) {mapping[y]})
  }
}

## Task 2 ##

## A
#making a subset of the entries for china, omitting the coded_country column
china <- subset(cvbase, coded_country == "China", select = -coded_country)
#making a subset of all other entries
others <- subset(cvbase, coded_country != "China", select = -coded_country)
#viewing the china table
View(china)
#viewing the other countries table
View(others)
#investigating the difference in proportion of NA values for conspiracy attributes
#finding proportion of na values in china for consp01 - the sum of NA values is divided by the
number of entries
avg_china_consp01_na <- sum(is.na(china$consp01)) / nrow(china)
#finding proportion of na values in other countries
avg_others_consp01_na <- sum(is.na(others$consp01)) / nrow(others)
#creating data frame with statistics
averages <- data.frame(
  Country = c("China", "Other Countries"),
  Proportion_NA = c(avg_china_consp01_na, avg_others_consp01_na)
)
#creating ggplot for visual comparison
ggplot(averages, aes(x = Country, y = Proportion_NA, fill = Country)) +
  geom_bar(stat = "identity") +
  labs(
    x = "Country",
    y = "Proportion of NA Values",
    title = "Proportion of N/A's in Response to Conspiracy 1"
  ) +
  scale_fill_manual(values = c("China" = "lightblue2", "Other Countries" = "darkred"))
#testing to check whether the proportion is similar for the other conspiracies
sum(is.na(china$consp02)) / nrow(china)
sum(is.na(china$consp03)) / nrow(china)
#comparing the summary statistics
summary(china)
summary(others)
#checking gender split in china
barplot(table(china$gender), col = blues9, ylim = c(0,600), xlab = "Gender", ylab = "Number of
Observations", main = "China")
#checking gender split in other countries
barplot(table(others$gender), col = blues9, ylim = c(0,25000), xlab = "Gender", ylab = "Number of
Observations", main = "Other Countries")
#checking proportion of responses with "Other" gender in other countries
sum(others$gender == 3, na.rm = TRUE) / nrow(others)
#setting layout for the plots
par(mfrow = c(2, 1))
par(mar = c(4, 2, 2, 2))
par(mgp = c(3, 1, 0))
#comparing distribution of means for china between groups
barplot(round(colMeans(china, na.rm = TRUE), 2), col = "lightblue1", las = 2, cex.names = 0.6, ylim
        = c(0,8), cex.main = 0.8, main = "Mean Distribution for China")
barplot(round(colMeans(others, na.rm = TRUE), 2), col = "lavender", las = 2, cex.names = 0.6, ylim =
          c(0,8), cex.main = 0.8, main = "Mean Distribution for Others")
#comparing distribution of attributes between countries
boxplot(china, col = "lightblue1", las = 2, cex.axis = 0.5, main = "China")
boxplot(others, col = "lavender", las = 2, cex.axis = 0.5, main = "Others")
#conducting t-test to test hypothesis
## 1 ##
## H0 (null) : there is no significant difference in means for ranking of "Achievement"
## H1 : china achievement ranking < others achievement ranking (china has a lower mean/higher
ranking for achievement)
t.test(x = china$rankOrdLife_2,y = others$rankOrdLife_2, alternative = "less", conf.level = 0.95)
## 2 ##
## H0 (null) : there is no significant difference in means for ranking of "Empathy"
## H1 : china empathy ranking > others empathy ranking (china has a higher mean/lower ranking for
empathy)
t.test(x = china$rankOrdLife_6,y = others$rankOrdLife_6, alternative = "greater", conf.level = 0.95)

## B
install.packages("reshape2")
library(reshape2)
#finding the rounded correlation between all other attributes and the four prosocial attitudes for china
round(cor(china[1:47], china[48:51], use = "pairwise.complete.obs"), 2)
#melting values and converting to a data frame for further analysis
rounded_corr_china <- melt(round(cor(china[1:47], china[48:51], use = "pairwise.complete.obs"), 2))
#plotting a heatmap to visualise the correlations
ggplot(rounded_corr_china, aes(x = Var1, y = Var2, fill = value)) + geom_tile(color = "white") +
  scale_fill_gradient(high = "red", low = "blue") + theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Correlation Heatmap for China")
#running linear regression on the first pro-social attitude using the attributes that have the highest
correlations
ps01_fit = lm(c19ProSo01 ~ happy + lifeSat + MLQ + bor03 + c19perBeh01 + c19perBeh02 +
                c19perBeh03 + c19RCA01 + c19RCA02 + c19RCA03, data = china)
#viewing summary of the regression
summary(ps01_fit)
#running linear regression on the second pro-social attitude using the attributes that have the highest
correlations in the China group
ps02_fit = lm(c19ProSo02 ~ happy + lifeSat + MLQ + bor03 + c19perBeh01 + c19perBeh02 +
                c19perBeh03 + c19RCA01 + c19RCA02 + c19RCA03, data = china)
summary(ps02_fit)
#running linear regression on the third pro-social attitude using the attributes that have the highest
correlations in the China group
ps03_fit = lm(c19ProSo03 ~ happy + lifeSat + MLQ + bor03 + c19perBeh01 + c19perBeh02 +
                c19perBeh03 + c19RCA01 + c19RCA02 + c19RCA03, data = china)
summary(ps03_fit)
#running linear regression on the fourth pro-social attitude using the attributes that have the highest
correlations in the China group
ps04_fit = lm(c19ProSo04 ~ happy + lifeSat + MLQ + bor03 + c19perBeh01 + c19perBeh02 +
                c19perBeh03 + c19RCA01 + c19RCA02 + c19RCA03, data = china)
summary(ps04_fit)

## C
#finding the rounded correlation between all other attributes and the four prosocial attitudes for other
countries
rounded_corr_others <- melt(round(cor(others[1:47], others[48:51], use = "pairwise.complete.obs"),
                                  2))
#plotting a heatmap to visualise the correlations
ggplot(rounded_corr_others, aes(x = Var1, y = Var2, fill = value)) + geom_tile(color = "white") +
  scale_fill_gradient(high = "red", low = "blue") + theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Correlation Heatmap for Others")
#running linear regression on the first pro-social attitude using the attributes that have the highest
correlations in the Others group
ps01_fit = lm(c19ProSo01 ~ happy + lifeSat + MLQ + bor03 + c19perBeh01 + c19perBeh02 +
                c19perBeh03 + c19RCA01 + c19RCA02 + c19RCA03, data = others)
summary(ps01_fit)
#running linear regression on the second pro-social attitude using the attributes that have the highest
correlations in the Others group
ps02_fit = lm(c19ProSo02 ~ happy + lifeSat + MLQ + bor03 + c19perBeh01 + c19perBeh02 +
                c19perBeh03 + c19RCA01 + c19RCA02 + c19RCA03, data = others)
summary(ps02_fit)
#running linear regression on the third pro-social attitude using the attributes that have the highest
correlations in the Others group
ps03_fit = lm(c19ProSo03 ~ happy + lifeSat + MLQ + bor03 + c19perBeh01 + c19perBeh02 +
                c19perBeh03 + c19RCA01 + c19RCA02 + c19RCA03, data = others)
summary(ps03_fit)
#running linear regression on the fourth pro-social attitude using the attributes that have the highest
correlations in the Others group
ps04_fit = lm(c19ProSo04 ~ happy + lifeSat + MLQ + bor03 + c19perBeh01 + c19perBeh02 +
                c19perBeh03 + c19RCA01 + c19RCA02 + c19RCA03, data = others)
summary(ps04_fit)

## Task 3 ##

### A ###
#creating dataset with population density for all countries
pDensity <- read.csv("world-data-2023.csv")
pDensity <- pDensity[,c(1,2)]
names(pDensity) <- c("country", "p_density")
#creating dataset with gdp for all countries from external dataset - first four rows are skipped due to
being blank
gdp <- read.csv("GDPperCapita.csv", header = TRUE, skip = 4)
gdp <- gdp[,c(1,66)]
names(gdp) <- c("country", "gdp")
#creating dataset with life expectancy for all countries from external dataset
lifeExp <- read.csv("LifeExpectancy.csv", header = TRUE, skip = 4)
lifeExp <- lifeExp[,c(1,66)]
names(lifeExp) <- c("country", "life_expectancy")
#creating dataset with political stability for all countries from external dataset
poStab <- read.csv("PoStab.csv", header = TRUE, skip = 4)
poStab <- poStab[,c(1,66)]
names(poStab) <- c("country", "political_stability")
#creating dataset with mortality for all countries from external dataset
mortality <- read.csv("Mortality.csv", header = TRUE, skip = 4)
mortality <- mortality[,c(1,66)]
names(mortality) <- c("country", "mortality")
#creating dataset with % enrolled in tertiary education for all countries from external dataset
eduTertiary <- read.csv("world-data-2023.csv")
eduTertiary <- eduTertiary[,c(1,19)]
names(eduTertiary) <- c("country", "tertiary_edu")
#this dataset contains characters instead of numerical values (eg: "96%")
#this must be changed in order to merge datasets
#first the percentage sign is removed
eduTertiary$tertiary_edu <- gsub("%", "", eduTertiary$tertiary_edu)
#then the entries are converted to numeric
eduTertiary$tertiary_edu <- as.numeric(eduTertiary$tertiary_edu)
#extracting unique country names from cvbase data and placing in a data frame
countries_df <- as.data.frame(unique(cvbase$coded_country))
names(countries_df) <- c("country")
#merging all other datasets with the data frame by country name
countries_df <- merge(gdp, countries_df, by="country")
countries_df <- merge(lifeExp, countries_df, by="country")
countries_df <- merge(poStab, countries_df, by="country")
countries_df <- merge(mortality, countries_df, by="country")
countries_df <- merge(eduTertiary, countries_df, by="country")
countries_df <- merge(pDensity, countries_df, by="country")
#scaling all attributes in the data frame to ensure smooth comparison and increase accuracy
countries_df[,2:7]=scale(countries_df[,2:7])
#creating the hierarchical cluster model and plotting it
chfit = hclust(dist(countries_df[,2:7]), "ave")
plot(chfit, hang = -1, labels = countries_df[, 1], cex = 0.7)
#drawing rectangle to identify clusters, set to target 38 clusters in order to create an optimal group for
comparison
rect.hclust(chfit, k=38, border = "red")

### B ###
#making a subset of the similar countries
similar <- subset(cvbase, coded_country %in% c("Thailand", "Tunisia", "Ecuador", "Jordan",
                                               "Morocco"), select = -coded_country)
#upon trying to find the rounded correlation of variables there were some variables with sd = 0
#these were investigated
names(which(sapply(similar, sd, na.rm = TRUE) == 0))
#as these columns do not have deviation they are not useful in measuring correlation
#removing the columns
similar <- subset(similar, select = -c(employstatus_8, coronaClose_1))
#finding the rounded correlation between all other attributes and the four prosocial attitudes for
similar countries
rounded_corr_sim <- melt(round(cor(similar[1:45], similar[46:49], use = "pairwise.complete.obs"),
                               2))
#plotting a heatmap to visualise the correlations
ggplot(rounded_corr_sim, aes(x = Var1, y = Var2, fill = value)) + geom_tile(color = "white") +
  scale_fill_gradient(high = "red", low = "blue") + theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Correlation Heatmap for Similar Countries")
#running linear regression on the first pro-social attitude using the attributes that have the highest
correlations in the Similar group
ps01_fit = lm(c19ProSo01 ~ isoOthPpl_inPerson + isoFriends_online + MLQ + c19perBeh01 +
                c19perBeh02 + c19perBeh03 + c19RCA01 + c19RCA02 + c19RCA03, data = similar)
summary(ps01_fit)
#running linear regression on the second pro-social attitude using the attributes that have the highest
correlations in the Similar group
ps02_fit = lm(c19ProSo02 ~ isoOthPpl_inPerson + isoFriends_online + MLQ + c19perBeh01 +
                c19perBeh02 + c19perBeh03 + c19RCA01 + c19RCA02 + c19RCA03, data = similar)
summary(ps02_fit)
#running linear regression on the third pro-social attitude using the attributes that have the highest
correlations in the Similar group
ps03_fit = lm(c19ProSo03 ~ isoOthPpl_inPerson + isoFriends_online + MLQ + c19perBeh01 +
                c19perBeh02 + c19perBeh03 + c19RCA01 + c19RCA02 + c19RCA03, data = similar)
summary(ps03_fit)
#running linear regression on the fourth pro-social attitude using the attributes that have the highest
correlations in the Similar group
ps04_fit = lm(c19ProSo04 ~ isoOthPpl_inPerson + isoFriends_online + MLQ + c19perBeh01 +
                c19perBeh02 + c19perBeh03 + c19RCA01 + c19RCA02 + c19RCA03, data = similar)
summary(ps04_fit)
