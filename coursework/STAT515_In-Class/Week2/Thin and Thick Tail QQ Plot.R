# Normal Q_Q Plots and Tail Thickness

# Due:
#
# Adapt the full script to use the
# t distribution with 3 degrees of freedom
# instead of the Weibull distribution.
#
# In 1.1 change distribution functions used to make
# the tibb;e. Include the R script.

# In 1.2 use the revised tibble and
# change the title and labels. Include the
# resulting plot.
#
# In 2. sample from the t distribution
# with 3 degrees of freedom and change
# the labels. Include the plot.
#
# In Section 3 to 5 make the all changes
# (values and labels) to make an appropriate
# the Enhance Q-Q plot.

# Submit
# 1)  Your script to produce
#     the t-distribution data.frame
#     in 1.1 and the plot in 1.2.
# 2) The plot from 1.2
# 3) The plot from 5.

# 3 points
#===================================

# R functions for the t-distribution
# are rt(n,df) pt(q,df) qt(p,df) and d(q,df)
# Note that the t-distribution with 1 degree
# freedom does not have a mean because
# the integral does not exist.
#
# Similarly the t-distribution with 2 degrees
# has mean but no variance because
# its tails are too thick.
#
# Commonly we compare tail thickness to
# Normal distribution

#===================================

# 0.  Setup

library(tidyverse)
source("hw.R")

# ==========================

# 1. A right-skewed distribution example

# 1.1 Cumulative probabilities, quantiles,
#     and density for a particular Weibull
#     distribution

# We start specifing increasing sequence of cumulative
# probabilities.
#
# One choice uses the ppoints() function.
# Its arguments specify the number of
# equally spaced points, n, in the interval
# [0 1] and an offset control parameter, a.

cumP <- ppoints(n = 20, a = .5)
cumP

# The cumulative probabilities generated
# are symmetric about .5, for all valid
# argument choices.

# Here is a symmetry test

cumP + rev(cumP)

cumP[1] == .5/20  # .025
cumP[20] == 1 - cumP[1]  # .975

# The offset is the clever function of
# the control parameter.
# offset = (1-a)/(n+1-2*a)
# For a=.5 and n = 20
# the offset is (1-.5)/(20 + 1 - 1) = .025
# as shown above.
#
# In this class we tend to use the R default
# for offset control parameter.  For
# n > 10 the default is a=.5.
# The argument,a, can be selected from [0 1].
# Some quantile approximation algorithms use
# the choice a = 1 so the offset is 0.

# Alternatively we could use the
# function seq() produce a sequence of
# increasing cumulative probabilities

offset = .025
cumPseq <- seq(from = offset,
               to = 1-offset, length.out=20)
cumPseq

# Now we put ppoints to work in the sequence
# cum_probs => quantiles => densities

n <- 4000 # More than we need for graphics
cumP <- ppoints(n)
q <- qweibull(cumP,shape = .9, scale = 2)
d <- dweibull(q,shape = .9, scale = 2)
dfDen <- tibble(q,d)

# 1.2 A density plot

title <- paste('Weibull: Shape=0.9 Scale=2',
         'Density Plot',sep = '\n')

ggplot(dfDen, aes(x = q, y = d)) +
  geom_area(color = "blue", fill = rgb(0,.5,1),alpha = .2) +
  labs(x = 'Quantiles',y = 'Density',title = title) + hw

# 2. A sample from the Weibull distribution

set.seed(37)
n <- 100
samp <- rweibull(n,shape = .9,scale = 2)

# Two location statistics
# and a scale statistic

sampMean <- mean(samp)
sampMedian <- median(samp)
sampSD <- sd(samp)

# The mean being larger the median suggests
# a skewed-right distribution
#
# The standard deviation will be
# used later

#==================================

# 3.  Pairing sample quantiles with
#     theoretical quantiles and making
#     a tibble.

# We pair empirical quantiles (sorted values)
# from the Weibull sample with theoretical
# quantiles from a normal distribution. This is
# based using the sample approximate cumulative
# probabilities as the theoretical normal distribution
# cumulative probabilities.

# Most R normal Q-Q plots use the
# standard normal distribution.
# Instead of using the standard normal distribution
# with mean = 0 an sd = 1,
# some software packages and the example
# below uses the normal distribution with the
# same mean and standard deviation as
# the sample.

# The shape of the normal Q-Q plot looks the same
# for any normal distribution due to the linear
# scaling into the graphics window.  It is the
# normal distribution axis tick mark or grid line
# labels the differ.

# The example below computes where to plot
# the annotation.  There may be data samples for
# which the placement is poor.  If so, the
# script could be revised to use a function,
# that provides a more sophisticated placement
# calculation.

# 3.1 Find approximate cumulative probabilities
#       for the sample size.

?ppoints
# When the ppoints argument is a vector
# as shown below, it uses the vector length
# as argument n.

cumP <- ppoints(samp)

# 3.2 Find normal distribution quantiles
#     to pair with the sorted sample values.
#
# Use the approximate cumulative probabilities
# for the sample quantiles (sorted values).
#
# Use the normal distribuion
# with same mean and standard deviation
# as the sample.

normQ <- qnorm(cumP,
  mean = sampMean, sd = sampSD)

# 3.3 Make a tibble of quantile pairs

dfQQ <- tibble(normQ,
        sampQ = sort(samp))

# 3.4 A primative Q-Q plot

ggplot(dfQQ,aes(x = normQ,y = sampQ)) +
  geom_path() +
  geom_point() +
  labs(x = "Normal Quantiles",
       y = "Weibull Sample Quantiles",
       title = "Normal Q - Q Plot") + hw

#==================================

# 4. Calculations and Labels for an
#    Enhanced Normal Q-Q plot

# 4.1 Compute the medians, 1st and 3rd quartiles
#     and other values to use in Q-Q plot
#     construction

sampMedian <- median(samp)
normMedian  <- mean(samp) # normal median = mean

probs =  c(.25,.75)
sampQuart13 <- quantile(samp,probs)
sampQuart13

normQuart13 <- quantile(normQ,probs)
normQuart13

# 4.2 Obtain the constant and slope
#     of the line through the 1st and 3rd
#     paired quantile points.
#
#     With two points the linear model
#     should fit the two points without error

coef <- lm(sampQuart13~normQuart13)$coef
coef

# 4.3  Compute text coordinates

xLeft <- (normMedian + min(normQ))/2
yLeft <- (sampMedian + max(samp))/2

xRight <- (normMedian + max(normQ))/2
yRight <- .3*sampMedian + .7*min(samp)

# 4.4 Better x and y axis labels

xlab <- paste0("Normal: Mean = ",
  round(sampMean,2),
  ", SD = ",round(sampSD,2))

ylab <- paste0("Weibull: Shape=0.9 Scale=2",
   "\nSample Size = 100")

#========================

# 5. Produce the plot

ggplot(dfQQ,aes(x = normQ,y = sampQ)) +
  geom_hline(yintercept = sampMedian,
    color  = "blue") +
  geom_vline(xintercept = sampMean,
    color = "blue") +
  geom_abline(intercept = coef[1],
    slope  =  coef[2],size = 1,col = "black") +
  geom_point(shape = 21,fill = "red",
    color = "black",size = 3.2) +
  labs(x = xlab, y = ylab,
    title = paste("Q-Q Plot","Blue Lines At Medians",
      "Black Line Thru 1st and 3rd Quartiles",
      sep = "\n")) +
  annotate("text",xLeft,yLeft,size = 4,
    label = paste("Left Column: Thin Left Tail ",
      "Lowest points above black line",sep = "\n")) +
  annotate("text", xRight, yRight, size = 4,
    label = paste("Right Column: Thick Right Tail",
      "Highest points above black line",
       sep = "\n")) + hw




