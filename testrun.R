#this is a comment 
#library(help='stats')

# Basic R Operations

1+1

2+3*4

3^2

exp(1)

sqrt(10)

pi

2 + pi * 43

#<- #alt + -

x <- 1

y <- 3

z <- 4

x*y*x

x*y*z
#X will replace 1 with 3

x <- 3

x == 1

x == 3

#Making vectors

myvector <- c(10,20,30,40,50)

myvector + 1

myvector + myvector

length(myvector)

bigvector <- c(myvector,myvector)

autovector <- 1:10

autovector[9]

items <- c("spam", "eggs", "beans", "bacon", "sausage")

items[2:4]

#Plotting

plot(autovector, autovector^2)

#Working with Tidyverse
install.packages("tidyverse")

library(tidyverse)

#opening the file

geo <- read_csv('geo.csv')

geo

nrow(geo)

ncol(geo)

colnames(geo)

summary(geo)

#Indexing

geo[4,2] #First row, then column

geo[5,"region"]

geo[90, ] #Selecting only one row

head(geo[, "region"]) #selecting all observations for one column

geo[c(1,50,180), ] #select rows 1, 50, 180

top8 <- geo[2:8, ]

top8

filter(geo, lat < 0)

filter(geo, income2017 == 'lower_mid', lat < 0)

#Making Plots

gapminder <- read.csv('gapminder.csv')
head(gapminder)

ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_point()

ggplot(gapminder, aes(x = year, y = lifeExp, color = continent, size = pop)) + geom_point()

ggplot(gapminder, aes(x = year, y = lifeExp, color = continent, group = year)) + geom_boxplot()

