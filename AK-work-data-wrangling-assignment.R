#Data Wrangling Tutorial AK work
mysleep <- sleep
head(mysleep) #to look at the data, use head()
summary(mysleep) #shows all the rows, rather than just the first 6, 
#gives quartiles and means for each column
install.packages("R.matlab")
library(R.matlab)
library(tidyverse)
#Side note: whenever you load a package, it’s possible that some of the objects in the package (functions, data)mayhavethesamenamesasotherobjectsyouhaveloaded. Thisiscalled“masking" (same name for multiple different functions)
#For example, it’s telling us that if we use the function filter(), 
#it’s going to default to the function from the dplyr package, 
#which is masking the function called filter() from the stats package. 
#So if we actually want to use the stats version, we need to call it with stats::filter() instead of just filter(). And so on

ggplot(data = mysleep, aes(x = extra))
# For a histogram, we really only have one variable, mapped to the x dimension.
#The aes() function stands for “aesthetics,” 
#and this is the crux of the design of ggplot2: 
#a plot is a mapping between data and aesthetics, 
#which are physical properties of a plot. 
#But in order to actually plot something, 
#we need to not only map variables to aesthetics, 
#but we need to specify what kinds of shapes – or “geoms” – we want to use to display the data.

ggplot(mysleep,aes(extra)) + geom_histogram()
## error - 'stat_bin()' using 'bins = 30'. Pick better value with 'binwidth'
#thewarningislettingusknowthatadefaultvalueforthebinwidthofthehistogramissetinorder to produce 30 bins, but that may or may not be a good choice

ggplot(mysleep,aes(extra)) + geom_histogram(binwidth = 2)
ggplot(mysleep,aes(extra)) + geom_histogram(binwidth = 1.5)
ggplot(mysleep,aes(extra)) + geom_histogram(binwidth = 1)
ggplot(mysleep,aes(extra)) + geom_histogram(binwidth = 0.5)
ggplot(mysleep,aes(extra)) + geom_histogram(binwidth = 0.05)

#ggplot(dataset,aes(Variable)) + geom_histogram(options)


#Importing matlab data
data <- readMat('ExampleSpikeData.mat')
summary(data)
str(data)
ggplot(data) #can't plot because data is a list
DFdata <- as.data.frame(matrix(unlist(data)))
ggplot(DFdata,aes(DFdata))
# can't figure out how to make it into a dataframe, still thinks there's no type
data1 <- readMat('ExampleSpikeData_CellArray.mat')


#Standardizing or normalizing data using scale, mean = 0 and standard deviation is 1
mean(scale(mysleep$extra))
sd(scale(mysleep$extra))
summary(mysleep$extra)
summary(scale(mysleep$extra))
class(mysleep$extra)
class(scale(mysleep$extra)) #becomes matrix when you scale it
str(scale(mysleep$extra))
#What this means is that depending on what we’re doing, 
#we may need to explicitly convert the result of scale() to a vector. 
#In some contexts it gets coerced into a vector structure, but to be safe, we will often want to 
#wrap the result of scale() in as.numeric(). For example: 
summary(as.numeric(scale(mysleep$extra)))
class(as.numeric(scale(mysleep$extra)))

#You might only want standard deviation to be 1, OR the 
# mean to = 0, but scale() does both. Use center and scale arguments,
# which are both true by default. Centered = mean is 0
# scale = standard deviation
test <- as.numeric(scale(mysleep$extra,scale = FALSE))

mysleep$extra_std <- as.numeric(scale(mysleep$extra)) #creates another column of variable that's standardized
# Above line ^ can do this same exact thing using tidyverse:
mysleep <- mysleep %>% mutate(extra_std_tidy = as.numeric(scale(extra)))
#don't need to do mysleep$extra, instead just say 'extra' because mysleep is called before the %>% symbol



summary(mysleep)


#The idea is that in R we very frequently work with data.frame objects, so the tidyverse often focuses on manipulating and enhancing these objects. What’s happening in this case is that we start with the data.frame called mysleep and then the %>% operator “passes” the value of the object on its left (i.e., mysleep) to the first argument of the function on its right. In other words, these two lines are doing the same thing: 
#these 2 lines are exactly the same:
mysleep <- mysleep %>% mutate(extra_std_tidy = as.numeric(scale(extra)))
mysleep <- mutate(mysleep, extra_std_tidy2 = as.numeric(scale(extra)))
identical(mysleep$extra_std_tidy, mysleep$extra_std_tidy2)
#Automatically adds these things to the column of the dataframe
# dataframe <- dataframe %>% mutate(NewVar = function(VariableOfDataframe))
# dataframe <- mutate(dataframe, NewVar = VariableOfDataframe)

#the %>% operator passes the mysleep data frame to the first argument of mutate().

#Practice Exercise #2, #1:
mysleep <- mysleep %>% mutate(sqrt(abs(extra)))
#2b:
mysleep <- mutate(mysleep,extra_something = ifelse(mysleep$extra>0,"low","high"))


mysleep <- mutate(mysleep,extra_something = ifelse(mysleep$extra<=0,"low",
                                                   ifelse(mysleep$extra<3,"medium",
                                                          ifelse(mysleep$extra>=3,"high",NA))))


try1 = scale(try)
summary(try1)
mysleep$LogTransformed= log10(abs(mysleep$extra))
ggplot(mysleep,aes(log10(extra)))+ geom_histogram(binwidth = 0.05)
# 2. Use ifelse() and mutate() to create a categorical “re-coding” of a numeric variable
ggplot(mysleep,aes(extra)) + geom_histogram(binwidth = 2)
