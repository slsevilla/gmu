##Midterm Code
library(nortest)
library(MASS)
#Updated with answer key for comp exam

#Q1
  #A: Random seed =0, random sample size = 100, normal distribution mean=0, sd=1
    set.seed(0)
    rnorm(100)
  #B: create qqplot in a 1 by 2 matrix of above
    set.seed(0)
    x.rand <- rnorm(100)
    par(mfrow=c(1,2))
    qqnorm(x.rand,main="QQ Plot Random"); qqline(x.rand)
    
  #C: Repeat with uniform distribution
    set.seed(0)
    x.uni <- runif(100)
    par(mfrow=c(1,2))
    qqnorm(x.rand,main="QQ Plot Normal"); qqline(x.rand)
    qqnorm(x.uni, main="QQ Plot Uniform"); qqline(x.uni)

#Q2
  set.seed(0)
  par(mfrow=c(1,1))
  
  x.combo <- matrix(c(x.rand,x.uni),byrow=FALSE,ncol=2)
  boxplot(x.combo)
  #Visible that the quartiles are different between each plot
    
#Q3
  #A: Create data set, n=100. Col1=0,1 Col2=2,1 Col3=4,2 Col4=6,1
    set.seed(0)
    col_1 <- rnorm(100)
    col_2 <- rnorm(100,2,1)
    col_3 <- rnorm(100,4,2)
    col_4 <- rnorm(100,6,1)
  #B: Create matrix of historgrams 2X2 of data
    matrix_1 <- cbind(col_1,col_2,col_3,col_4)
    par(mfrow=c(2,2))
    hist(col_1)
    hist(col_2)
    hist(col_3)
    hist(col_4)
  #C: Perform transformation, repeat histograms
    scale_col_1 <- scale(col_1)
    scale_col_2 <- scale(col_2)
    scale_col_3 <- scale(col_3)
    scale_col_4 <- scale(col_4)
    par(mfrow=c(2,2))
    hist(scale_col_1)
    hist(scale_col_2)
    hist(scale_col_3)
    hist(scale_col_4)  
    
#Q4
  pnorm(110,100,10)-pnorm(90,100,10)

#Q5
  #A: Find the probability when X is greater than 7 (range 8:10)
    sum(dbinom(8:10,size=10,prob=.5))
  #B: find J that where x is less than or equal to J 
    qbinom(.5,size=10,prob=.5)

#Q6
  set.seed(0)
  random1 <- rnorm(1000,0,1)
  random2 <- rnorm(1000,1,1)
  variance1_2 <- var.test(random1,random2)
  variance1_2 #P value is >0.05 - variance is not significant
  t.test(random1,random2,var.equal = TRUE)

#Q7
  set.seed(0)
  random3 <- rnorm(1000,0,1)
  random4 <- rnorm(1000,1,3)
  variance3_4 <- var.test(random3,random4)
  variance3_4 #P value is <0.05 - variance is significant
  t.test(random3,random4)

#Q8
  binom.test(x=625,n=900,p=3/4)
  #P value indicates results are within expected range
  
#Q9
  set.seed(0)
  random_norm <- runif(1000)
  shapiro.test(random_norm)
  #p value is <0.5, reject the hypothesis that data comes from a normal distribution
  
#Q10
  Q10_data <- read.table("Q10.txt", header=TRUE)
  rnames <- c("Gene 1", "Gene 2", "Gene 3", "Gene 4", "Gene 5", "Gene 6", 
              "Gene 7", "Gene 8", "Gene 9", "Gene 10")
  row.names(Q10_data) <- rnames
  Q10_data
  control_exp <- c(Q10_data$c1, Q10_data$c2, Q10_data$c3, Q10_data$c4)
  t.test(control_exp,mu=2000)
  #Reject the null hypothesis that the mean is 2000, as the p value is <0.05
  
#Q11
  Q11_data <- read.table("Q11.txt", header=TRUE)
  wilcox.test(Q11_data[,3],0.5)
  #For a predictive median of 0.5 the p value is .7692. we accept the null hypothesis,
  #since the p >.05
    
#Q12
  Q12_data <- read.table("Q12.txt",header=TRUE)
  gene_1 <- Q12_data[,1]; gene_2 <- Q12_data[,2]
  cor.test(gene_1,gene_2)
  #The correlation between these two genes is 0.88 which is positive, 
  #means that it's highly corelated
  
#Q13
  Q12_LM<-lm(gene_2~gene_1)
  Q12_LM #Provides Y-intercept (Intercept) = -0.05; Slope = 0.97
  summary(Q12_LM) #Provides significance values
  
#Q14
  ppois(q=6,lambda=5.8,lower.tail=FALSE)
  #The value is not excessive for this data set
  
#Q15
  BW <- c(135, 120, 100, 105, 130, 125, 125,105, 120, 90, 120, 95, 120, 150, 160, 125)
  A <- c(3, 4, 3, 2, 4, 5, 2, 3, 5, 4, 2, 3, 3, 4, 3, 3)
  SBP <- c(89, 90, 83, 77, 92, 98, 82, 85, 96, 95, 80, 79, 86, 97, 92, 88)
  lm(SBP~BW+A) #Co-efficient is 0.126 (BW) and 5.89 (A)
  
#Q16
  #A
    #1-(1-alpha)^G
  #B
    #(alphaG)
  
#Q17
  Q17_data <- read.table("Q17.txt",header = TRUE)
  wilcox.test(Q17_data[,1],Q17_data[,2],paired=TRUE)
  #Calculated value is <0.05, reject null hypothesis
  t.test(Q17_data[,1],Q17_data[,2], paired =TRUE)
  #Calculated value is <0.05, reject null hypothesis
  #Both have the same final answer
  
#Q18
  #A: Sensitivity: (# of reactors that auto detected as reactor) / (all true reactors)
    Sensitivity = 6/15; Sensitivity
  #B: Specficity: (# of nonreactors that auto defined as nonreactors) / (all true nonreactors)
    Specificity = 51/66; Specificity
  #C: Predicitive Positive: (#of reactors that auto detected as reactors) / (all people)
  #   Predictive Negative: (# of nonreactors that auto defined as nonreactors) / (all people)
    PV_Pos = 6/(66+15);PV_Pos
    PV_Neg = 51/(66+15);PV_Neg

#Q19
  prob19.dat <- matrix(rnorm(800),ncol=4,byrow=T)
  prob19.dat[51:100,] <- prob19.dat[51:100,] + 4
  prob19.dat[101:150,] <- prob19.dat[101:150,] - 4
  prob19.dat[151:200,1:2] <- prob19.dat[151:200,1:2] - 8
  prob19.dat[151:200,3:4] <- prob19.dat[151:200,3:4] + 8
  rep_1 <- rep("red",50); rep_2 <- rep("blue",50)
  rep_3 <- rep("green",50); rep_4 <- rep("yellow",50)
  pairs(prob19.dat,col=c(rep_1,rep_2,rep_3,rep_4),main="Pair Plots")
  parcoord(prob19.dat,col=c(rep_1,rep_2,rep_3,rep_4),main="Parallel Coordinates")
  
#Q20
  prob20.dat <- matrix(rnorm(800), ncol=4,byrow=T)
  prob20.dat[198:200,] <- prob20.dat[198:200,] + 10
  mvoutlier::pcout(prob20.dat, makeplot=TRUE)
  #wfinal01 indicates multiple outliers, with the indications of "0"