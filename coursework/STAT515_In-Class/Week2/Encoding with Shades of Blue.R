# 0. Setup

library(tidyverse)
source('hw.R')

n <-10
set.seed(37)
x <- runif(10,min = 1,max = 10)
y <- 2*x^2 - 10*x - 15

# 1 Two plots for comparison

xy <- tibble(x,y)

ggplot(xy,aes(x=x,color=y)) +
  geom_point(y = 0,shape = 19,size = 4) +
  ylim(-.5,.5) +
  labs(Y ='',title="Encoding Comparison: Y Encoded Using Shades of Blue") +
  hw

# What are the y values of the 2nd, 5th and 6th points
# reading from left to right?

ggplot(xy, aes(x = x, y = y)) +
  geom_point(shape = 21, fill = 'cyan',size = 4, color = 'black')  +
  labs(title = "Encoding Comparison: Y Encoded Using Position Along a Scale") +
  hw

# What are the y values of the 2nd, 5th and 6th points
# reading from left to right?


