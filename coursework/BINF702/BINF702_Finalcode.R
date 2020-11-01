##BINF702 Final Exam Spring 2017

#################################################Question 1#################################################
  library(MASS)
  library(ggplot2)
  set.seed(0)
  
  #Set Data and data frames
  dat1 <- mvrnorm(n=100,mu=c(-3,-3),Sigma = matrix(c(1,.8,.8,1),ncol=2,byrow=TRUE))
  dat2 <- mvrnorm(n=100,mu=c(3,3),Sigma = matrix(c(1,0,0,1),ncol=2,byrow=TRUE))
  dat <- rbind(dat1,dat2)
  X1 <- dat[,1]
  X2 <- dat[,2]
  d.frame <- data.frame(X1, X2)
  
  #Set classes for analysis
  d.class <- as.factor(rep(c("a","b"),each=100))
  
  #Run QDA
  d.qda <- qda(d.frame, d.class)
  d.pred.q <- predict(d.qda, d.frame)
  d.frame$pred.SC <- predict(lm(X2 ~ X1, data = d.frame))
  
  #Set limits for decision boundry
  GS=300
  XLIM <- range(X1)
  tmpx <- seq(XLIM[1], XLIM[2], len=GS)
  YLIM <- range(X2)
  tmpy <- seq(YLIM[1], YLIM[2], len=GS)
  newx <- as.matrix(expand.grid(tmpx,tmpy))
  
  #Create boundry line
  Ghat <- as.numeric(predict(d.qda, newdata=data.frame(X1=newx[,1],X2=newx[,2]))$class)
  
  #Create the plot
  filled.contour(tmpx,tmpy,matrix(Ghat,GS,GS), col=c("red","green"),
                 plot.axes = {
                   points(X1,X2,cex=1,pch=3); axis(1); axis(2); title(xlab="X",ylab="Y",main="QDA"); 
                   contour(tmpx,tmpy,matrix(Ghat,GS,GS),add=T,drawlabels= FALSE); 
                   contour(tmpx,tmpy,matrix(Ghat,GS,GS), nlevels = 1, level = 0, add = T, drawlabels = FALSE)
                   }
                 ) 

#################################################Question 2#################################################
  library(class)
  library(ISLR)
  data(Khan)
  
  #Set seed to 0
  set.seed(0)
  
  #Create test and training sets, with groupings
  test.X = Khan$xtest
  train.X = Khan$xtrain
  grp.train=Khan$ytrain
  grp.test=Khan$ytest
  
  #Perform KNN, Create confusion matrix for K=1
  knn.pred <- knn(train.X,test.X,grp.train,k=1)
  table(knn.pred,grp.test)

  #Perform KNN, Create confusion matrix for K=3
  knn.pred <- knn(train.X,test.X,grp.train,k=3)
  table(knn.pred,grp.test)

#################################################Question 3#################################################
  nci.labs = NCI60$labs
  nci.data = NCI60$data
  pr.out = prcomp(nci.data, scale = T)
  Cols = function(vec) {
    cols = rainbow(length(unique(vec)))
    return(cols[as.numeric(as.factor(vec))])
  }
  par(xpd=TRUE)
  plot(pr.out$x[, 1:2], col = Cols(nci.labs), pch = 19, xlab = "Z1", 
       ylab = "Z2")
  legend(60,-35, col=unique(Cols(nci.labs)), legend = unique(nci.labs),
         pch = 19, cex=.5)

#################################################Question 4#################################################
  km.out = kmeans(pr.out$x[, 1:2], 14, nstart=20)
  par(xpd=TRUE)
  
  #Plot data with legend, colored by type
  plot(pr.out$x[, 1:2], col = Cols(nci.labs), pch = 19, xlab = "Z1", 
       ylab = "Z2")
  legend(60,-35, col=unique(Cols(nci.labs)), legend = unique(nci.labs),
         pch = 19, cex=.5)
  
  #Add text of cluster numbers
  text(km.out$center)

#################################################Question 5#################################################
  library(rpart);   library(rpart.plot);   library(multtest)
  data(golub)
 
  #Read in the gene names to identify 'best' classifying gene
  row.names(golub)<- paste("gene", 1:3051, sep = "")
  
  #Create data frame
  goldata <- data.frame(t(golub[1:3051,]))
  
  #Assign factor labels
  gol.fac <- factor(golub.cl,levels=0:1, labels= c("ALL","AML"))
  
  #Run regression, and plot data
  gol.rp <- rpart(gol.fac~., data=goldata, method="class", cp=0.001)
  plot(gol.rp, branch=0,margin=0.1); text(gol.rp, digits=3, use.n=TRUE)
  
  #Determine which gene was classified
  golub.gnames[896,]
  
#################################################Question 6#################################################
  library(e1071)
  library(ISLR)
  
  #Training on training data, testing on training data
  dat=data.frame(x=Khan$xtrain, y=as.factor(Khan$ytrain))
  out=svm(y~.,data=dat,kernel="linear",cost=10)
  
  data.te=data.frame(data.frame(x=Khan$xtrain, y=as.factor(Khan$ytrain)))
  pred.te=predict(out,newdata=data.te)
  table(pred.te, data.te$y) #As expected, no errors
  
  #Training on training data, testing on testing data
  dat=data.frame(x=Khan$xtrain, y=as.factor(Khan$ytrain))
  out=svm(y~.,data=dat,kernel="linear",cost=10)
  
  data.te=data.frame(data.frame(x=Khan$xtest, y=as.factor(Khan$ytest)))
  pred.te=predict(out,newdata=data.te)
  table(pred.te, data.te$y) #two misclassifications

#################################################Question 7#################################################
  install.packages("randomForest")
  library(randomForest)
  rm(list = ls())
  set.seed(0)
  
  #Create random data
  dat <- matrix(rnorm(400*10),ncol=10,byrow=TRUE)
  dat[1:100,1] <- dat[1:100,1] - 4
  dat[1:100,2] <- dat[1:100,2] - 4
  dat[101:200,3] <- dat[101:200,3] + 4
  dat[101:200,4] <- dat[101:200,4] + 4
  dat[201:300,6] <- dat[201:300,6] - 4
  dat[201:300,7] <- dat[201:300,7] - 4
  dat[301:400,10] <- dat[301:400,10] + 6
  colnames(dat) <-c(1:10)
  
  #Assign classifiers
  color.labs <- c(rep("red",100),rep("green",100),rep("blue",100),rep("black",100))  
  Y <- factor(color.labs)
  data <- data.frame(Y,dat)
  
  #Run random forest
  rf.data <- randomForest(Y~., data,importance=TRUE)
  importance(rf.data)
  
  #create pairs plot with varying colors by 100 observances
  pairs(data,col=Y)
  
  #Plot variable importance
  varImpPlot(rf.data)
  
  #Groupings are indiciative of matrix creation. 
  ##Column 10 was created using the same parameters.
  ##Columns 1/2/6/7 were created using the same parameters and are grouped with 3/4, created similiarly.
  ##Columns 5,8,9 were not altered, and group together, and with the least accuracy.
  
#################################################Question 8################################################# 
  set.seed(0)
  
  #Create random data
  dat <- matrix(rnorm(400*10),ncol=10,byrow=TRUE)
  dat[1:100,1] <- dat[1:100,1] - 4
  dat[1:100,2] <- dat[1:100,2] - 4
  dat[101:200,3] <- dat[101:200,3] + 4
  dat[101:200,4] <- dat[101:200,4] + 4
  dat[201:300,6] <- dat[201:300,6] - 4
  dat[201:300,7] <- dat[201:300,7] - 4
  dat[301:400,10] <- dat[301:400,10] + 6
  
  #Find Euclidean distance and Average distance
  hc.comp = hclust(dist(dat),method="complete")
  hc.avg = hclust(dist(dat),method="average")
  
  #Plot Graphs
  plot(hc.comp,main="Euclidean")
  plot(hc.avg,main="Average")
  
  #Cut trees into 4 clusters
  cut.comp <- cutree(hc.comp,4)
  cut.avg <- cutree(hc.avg,4)
  
  #Create Confusion Matrix
  rownames(dat) <- c(rep(1,100),rep(2,100),rep(3,100),rep(4,100))  
  fin.comp <- c("1","2","3","4")[cut.comp]
  fin.avg <- c("1","2","3","4")[cut.avg]
  table(true=rownames(dat),pred=fin.comp)
  table(true=rownames(dat),pred=fin.avg)
  
#################################################Question 9#################################################
  set.seed(0)
  library(nnet)
  
  #Create random data
  dat <- matrix(rnorm(400*10),ncol=10,byrow=TRUE)
  dat[1:100,1] <- dat[1:100,1] - 4
  dat[1:100,2] <- dat[1:100,2] - 4
  dat[101:200,3] <- dat[101:200,3] + 4
  dat[101:200,4] <- dat[101:200,4] + 4
  dat[201:300,6] <- dat[201:300,6] - 4
  dat[201:300,7] <- dat[201:300,7] - 4
  dat[301:400,10] <- dat[301:400,10] + 6
  
  #Create class color labels, add to data frame
  color.labs <- c(rep("red",100),rep("green",100),rep("blue",100),rep("black",100))  
  Y <- factor(color.labs)
  df <- data.frame(Y=Y,X=dat)
  
  
  #ANN
  nnest <- nnet(Y~ ., data=df,size=5,maxit=500,decay=0.01,MaxNWts=5000)
  
  #Confusion Matrix
  pred <- predict(nnest, type="class")
  table(pred,Y) #Correctly classifies each
  
#################################################Question 10################################################
  library(MASS)
  library(mclust)
  set.seed(0)
  
  #Create data tables
  dat1 <- mvrnorm(n=100,mu=c(-3,-3),Sigma = matrix(c(1,.8,.8,1),ncol=2,byrow=TRUE))
  dat2 <- mvrnorm(n=100,mu=c(3,3),Sigma = matrix(c(1,0,0,1),ncol=2,byrow=TRUE))
  dat3 <- mvrnorm(n=100,mu=c(-3,3),Sigma = matrix(c(1,-.8,-.8,1),ncol=2,byrow=TRUE))
  dat <- rbind(dat1,dat2,dat3)
  color.labs <- c(rep("red",100),rep("green",100),rep("blue",100))  
  Y <- factor(color.labs)

  #Plot data
  par(pty='s')
  plot(dat)
  
  #Run Mixture-based clustering -  MC and BIC
  clust <- Mclust(dat)
  BIC <- mclustBIC(dat)
  
  #Run Summary
  summary(clust)
  summary(BIC)
  
  #Plot mixture
  clPairs(dat,Y)
  plot(BIC)
  
  #Model clearly differntiates each data set from one another in obvious clusters.
  clust$G #additionaly, $G identifies the opitmal number of clusters, 3, which is correct to observed