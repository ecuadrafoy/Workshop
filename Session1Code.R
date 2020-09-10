library(help = "stats")
# Simple Operations

1+1

2 + 3 * 4 

3 ^ 2

exp(1)

sqrt(10)

pi 

2+pi*40 

x <- 1
y <- 3
z <- 4 

x*x*y

x*y*z


myvector <- c(10, 20, 30, 40 ,50)
myvector

myvector + 1

myvector + myvector

length(myvector)

double_vector <- c(myvector, myvector)

autovector <- 1:10
autovector

autovector[1]
autovector[6]

items <- c("spam", "eggs", "beans", "bacon", "sausage")
items[1]
items[-1]
items[1:4]

plot(autovector, autovector ^2)

install.packages("tidyverse")

library(tidyverse)

#Opening a file

geo <- read_csv("geo.csv")

nrow(geo)

ncol(geo)

colnames(geo)

summary(geo)


filter(geo, lat < 0)

filter(geo, income2017 == 'lower_mid', lat < 0)

#Making Plots

gapminder <- read.csv('gapminder.csv')
head(gapminder)

ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_point()

ggplot(gapminder, aes(x = year, y = lifeExp, color = continent, size = pop)) + geom_point()

ggplot(gapminder, aes(x = year, y = lifeExp, color = continent, group = year)) + geom_boxplot()
