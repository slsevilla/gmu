# Sample quantiles and cumulative probabilities
# for continuous data

# 0. Setup

library(tidyverse)
source('hw.R')

# 1. Generate a random sample to
#    emulate a real world sample

set.seed(37)
samp <- rnorm(5,mean=5,sd=2)
samp


# 2. Produce an empirical cumulative
#    distribution plot
sampDf <- data.frame(Sample=samp)
ggplot(sampDf,aes(x=Sample))+
  stat_ecdf(col='blue',size=2)+
  labs(x= "Vertical Jumps At Sample Values",
       y="Cumulative Probability",
       title="Empirical Cumulative Distribution Plot")+hw

# 4. Create a Quantile plot

# 4.1 Sort the sample values to obtain
#    the sample order statistics

orderStats <- sort(samp)
orderStats

# The order statistics are used
# as quantiles.

quants <- orderStats

# 4.2 Associate counting numbers (ranks)
#     with the ordered quantiles
#
#    Two R methods appear below

cnt <-  1:length(quants)
cnt

cnt2 <- rank(quants)
cnt2

# With no ties, no problem.

# 4.3 Compute cumulative probabilities
#     to pair with the quantiles
#
# There are many algorithms for this.
# They produce very fairly similar results
# for large sample sizes.
#
# A general formula for computing
# cumulative probabilities is
# (r-a)/(n+1-2*a) where
# r is the integer rank, numbers 1 to n
# a is chosen from the interval [0 1] and
# n the number of quantiles ranked

# Using a=.5 for samples of size 5 or 10
# makes hand calculations easy
# Note: n+1-2*.5 = n

n <- 5
(1:n-.5)/n

# Using a=1 samples size 6 or 11
# make hand calucutions easy
# Note: n+1-2*1 = n-1

n <- 11
(1:n-1)/(n-1)


# Return to the samp quantiles

a <- .5
n <- length(cnt)

cumProbs = (cnt -a)/(n+1-2*a)
cumProbs


# 4.4 Put the auantiels and cumProbs in a data.frame.
#     then make a Cumulative Probabilty and a Quantile Plots.

myDf <- data.frame(Quantiles=orderStats,
                   CumProbs=cumProbs)

# 4.5 Make the Quantile plot

ggplot(myDf,aes(x=CumProbs,y=Quantiles))+
geom_line()+
geom_point(shape=21,size=4,color="black",fill="red")+
labs(x="Cumulative Probabilities",
     y="Quantiles", title="Quantile Plot") + hw

# 5. Make a Cumulative probability plot

ggplot(myDf,aes(x=orderStats,y=CumProbs))+
geom_line()+
geom_point(shape=21,size=4,color="black",fill="cyan")
labs(x="Quanties",
     y="Cumulative Probabilities",
     title="Cumulative Probability Plot") + hw

# 6. Using linear interpolation to obtain intermediate
#    approximate quantiles

# Currently we are already drawing the line between points.
# We can obtain quantiles on the line for specified
# probabilities using approx()

# 7. using the R function approx() for linear interpolation.

cumProbs <- myDf$CumProbs
quants <- myDf$Quantiles
# For continuous data more

newCumProbs <- seq(min(cumProbs),max(cumProbs),length.out=20)
newQuants <- approx(x=cumProbs,quants,xout=newCumProbs)$y
newQuants

newDf <- data.frame(newCumProbs,newQuants)

ggplot(newDf,aes(x=newCumProbs,y=newQuants))+
geom_line()+
geom_point(shape=21,size=4,color="black",fill="cyan")+
labs(title="Quantile Plot")+hw

# 8. The quantile function
#    This takes a sample as input
#    and approximates quantiles for
#    specified cumulative probabilities
#    The default method, type=7,
#    is like use a=1 above.

set.seed(37)
samp1 <- rweibull(n=100,shape=.8,scale=2)
cumProbs <- seq(0,1,length.out=51)
quantsWeib <- quantile(samp1,probs=cumProbs)

# 9. Compare the quantiles of two samples
#    in a Q-Q plot

# Generate sample of size 200 from
# normal distribution.  Obtain
# quantiles for same cumulative
# probabilities used for Weibull sample
# quantiles. Pair theequantiles and
# from the Weibull sample quantiles
# above plotting points and pairs,

set.seed(41)
samp2 <- rnorm(n=200,mean=10,sd=12)
quantsNorm <- quantile(samp2,probs=cumProbs)

compDf <- data.frame(Weibull=quantsWeib,
                     Normal=quantsNorm)
ggplot(compDf,aes(x=Normal,y=Weibull))+
  geom_line() +
  geom_point(size=2,fill='cyan',color='black')+
  labs(title="Empirical Q-Q Plot") + hw





