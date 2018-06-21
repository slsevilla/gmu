#   Graphics Designs for Two Factor Tables
#   Example: Race by Family Type
#   Table Values: family type percents
#                 for each race
#
#   Copyright By: Daniel B. Carr 2013, 2014, 2015, 2016, 2017
#   Class use permitted

#=====================================
#
# Items Due: 7 points
# Sections and items
#
# 2.  The plot  (1)
# 6.  The plot  (1)
# 7.3 The plot  (1)
# 8.3 The plot  (1)
# 8.4 The R script and the plot (3)

#====================================
#
# Sections
#
# 0.  Setup
# 1.  Entering data and making a matrix with
#     row and column labels
# 2.  Lattice dot plot arguments and panel layouts
# 2.1 Side comments on plot aspect ratio
#
# 3.  Different panel layouts
# 4.  Graph and Table convention for the y-axis.
# 5.  Putting similar rows together
#     and showing the dot to dot path
#
# 6.  Simplifying plot appearance
#     by sorting panels
# 7.  ggplot and using factors to control
#     row name order and panel order
# 7.1 Creating data.frame from a matrix
#     and include factors
# 7.2 Creat an indexed dat.frame that
#     stacked values from the race columns
# 7.3 Putting the race levels in the desired
#     order from Section
#
# 8.  Creating twe perceptual groups in eacn
#     panel
# 8.1 Order the dataframe rows
# 8.2 Add a factor to create 2 groups of 3
#     using cut
# 8.3 Make the perceptually grouped dot plot
# 8.4 Create 3 groups of size 2 using cut


#==================================================

# 0. Setup

library(lattice)
library(tidyverse)
source('hw.R')

# 1. Entering data and making a matrix with
#    row and column labels
#
# The basic data structure 6 x 4 table.
#
# The row and column labels are:
#   Family type:
#        Married with father working, Married with both working,
#        Divorced mother, Never-married mother,
#   Race and ethnicity: White, Black, Hispanic, and Asian
#
# For simplicity we uxd family for family type
# and race for race and ethnicity.

# 1.1 Entering the data in a matrix

# There are many options such as entering
# the data using Excel and readingthe file in
# R.
#
# For very small data sets direct entry into
# R is convenient.  The entry and storage
# is data structure such as a matrix can be
# done in different ways.
# Below, for each race, we enter the family percents
# Then we bind race vectors together
# as columns in a matrix. Finally we
# add the row and column labels.

# Entering data as four vectors.
White <- c(22, 50,  8,  2, 13,  6)
Black <- c(5, 24, 13, 24, 20, 15)
Hispanic <- c(21, 33,  9,  7, 20, 9)
Asian <- c(24, 53,  4,  1, 12,  5)

# cbind() binds vectors together as
# columns in a matrix.
mat <- cbind(White, Black, Hispanic, Asian)
mat

# Defining vectors of simplified labels
type <- c( "Married, Father Working", "Married, Both Working",
          "Divorced Mother","Never-married Mother",
          "Other", "Grandparents")
race <- c("White","Black","Hispanic","Asian")

# Labeling matrix rows and column
colnames(mat) <- race
rownames(mat) <- type
mat

# We can transpose a matrix using t()
# We can rearrange rows and column using the
# [,] notation and subscript vectors.

t(mat)

mat[6:1,] # reverses the rows
mat[,4:1] # reverses the columns
mat[6:1,4:1] # reverses both

# 2. Lattice dot plot arguments and panel layouts
#
# The lattice dotplot function has several
# arguments. Some apply to bar plots
# and other panel graphics.
#
# In the example below, the first argument
# is our matrix, mat.  (The first argument
# can be a data.frame.)
#
# We save the plot as an object
# in oneCol for latter plotting.

oneCol = dotplot(mat, groups=FALSE,
  layout=c(1,4),aspect=.7,
  origin=0,type=c("p","h"),
  main="Who is Raising the Children?",
  xlab="Race Rounded Percents\nMay Not Total 100",
  scales=list(x=list(tck=0, alternating=FALSE)),
  panel=function(...){
    panel.fill(rgb(.9,.9,.9))
    panel.grid(h=0,v=-1,col="white",lwd=2)
    panel.dotplot(col=rgb(0,.5,1),cex=1.1,...)
  }
)
oneCol

# Above, the layout argument, layout=c(1,4),
# specifies producing one column with
# four rows of panels.
#
# The argument, aspect=.7, sets the ratio of
# the panel width to height as .7.
#
# The type=c("p","h") argument
# specifies plotting points and
# horizontal lines. The
# The origin=0 argument starts
# the horizontal line at zero.

# We skip over the other arguments and
# focus on the panel layouts. If you
# have already looked at the arguments
# and, for example, have guessed that
# the grid lines will be white, you are
# right.

#-----------------------------------------

# 2.1 Side comments on plot aspect ratios
#
# The aspect ratio of time series plots
# can be particularly important. We
# more easily perceive differences in slopes
# when they are close to
# plus or minus 45 degrees then when they
# are nearly vertical or horizontal.
# By eye or algorithm we can set a plot aspect
# ratio so more of the ascending and descending
# line segments are close to the preferred angles.
#
# Common television screen aspect ratios are
# 4/3 and 16/9.

#=========================================

# 3. Different panel layouts

# In the dot plot produced above,
# we see there are four sets of row
# labels, one for each panel, and
# one set of grid line labels.

# What if we choose a two columns and two
# rows of layout for the panels?

dotplot(mat,groups=FALSE,
  layout=c(2,2),aspect=.7,
  origin=0,type=c("p","h"),
  main="Who is Raising the Children?",
  xlab="Race Rounded Percents\nMay Not Total 100",
  scales=list(x=list(tck=0, alternating=FALSE)),
  panel=function(...){
    panel.fill(rgb(.9,.9,.9))
    panel.grid(h=0,v=-1,col="white",lwd=2)
    panel.dotplot(col=rgb(0,.5,1),cex=1.1,...)
  }
)

# Now we see two sets of row labels and
# two sets of grid line labels.

# Another reasonable layout is
# four columns of panels in one row.

dotplot(mat,groups = FALSE,
  layout = c(4,1), aspect = .7,
  origin = 0,type = c("p","h"),
  main = "Who is Raising the Children?",
  xlab = "Race Rounded Percents\nMay Not Total 100",
  scales = list(x = list(tck = 0, alternating = FALSE)),
  panel = function(...){
    panel.fill(rgb(.9,.9,.9))
    panel.grid(h = 0,v = -1,col = "white",lwd = 2)
    panel.dotplot(col = rgb(0,.5,1),cex = 1.1,...)
  }
)

# Now we see one set of row labels and
# four sets of grid line labels.
# We return to this layout in a latter section.

# First we illustrate sorting and showing reference
# values in the one column layout.

#=================================================

# 4. Graph and Table convention for the y-axis

# Run the two lines below and look again at
# the matrix, mat, on the Console
# and at the 1 column panel layout

mat
oneCol   # Saved above

# It may be a surprise to see Married, Father working
# as the bottom row label and White as the bottom
# panel.
#
# These examples illustrate the conflict between
# the table reading convention, where the top row is 1,
# and the graph y-axis convention, where the
# bottom row is 1.
#
# Lattice uses the graph convention by default.
#
# With matrices we can easily reverse row order
# and the column order using subscripts.
# This will produce the table convention version
# for both row labels and panels.

mat
mat[6:1,4:1] # reverse both orders

dotplot(mat[6:1,4:1],groups = FALSE,
  layout = c(1,4),aspect = .7,
  origin = 0,type = c("p","h"),
  main = "Who is Raising the Children?",
  xlab = "Race Rounded Percents\nMay Not Total 100",
  scales = list(x = list(tck = 0, alternating = FALSE)),
  panel = function(...){
    panel.fill(rgb(.9,.9,.9))
    panel.grid(h = 0,v = -1,col = "white",lwd = 2)
    panel.dotplot(col = rgb(0,.5,1),cex = 1.1,...)
  }
)

# Now we see the table convention. However,
# the given type order and race order
# does not put similar rows close
# together and similar panels close together.

#=========================================
#
# 5.  Putting similar rows together
#     and showing the dot to dot path

# Look at matrix in the R console.

mat

# Consider each family type row as a case
# with four values,one for each race.
# When sorting cases with
# multivariate values in the same units
# (here percents) we can often compute a
# summary statistic for each case and use
# the vector of summary statistics to sort
# the cases.
#
# Below we use rowMeans () to compute
# the mean of each row.

typeMeans <- rowMeans(mat)
typeMeans

# Note that divorced-mother and never-married
# mother have tied values. We might want to use
# additional criteria to break ties.

# Below we use order() to obtain subscripts
# to put the rows in a decreasing (the default)
# or increasing sort order. We
# also make a larger matrix with typeMeans
# as new column to show that the reordering
# works.

typeOrd <- order(typeMeans)
cbind(mat,typeMeans)[typeOrd,]

# We use the typeOrd vector below
# We also  use
# type = c("p","l") to plot points
# and lines that connect the points.

dotplot(mat[typeOrd,4:1],groups = FALSE,
  layout = c(1,4),aspect = .7,
  type = c("p","l"),
  main = "Who is Raising the Children?",
  xlab = "Race Rounded Percents\nMay Not Total 100",
  scales = list(x = list(tck = 0, alternating =  FALSE)),
  panel = function(...){
    panel.fill(rgb(.9,.9,.9))
    panel.grid(h = 0,v = -1,col = "white",lwd=2)
    panel.dotplot(col = rgb(0,.5,1),cex = 1.1,...)
  }
)

# Now we explicity see the shapes produced
# by lines connecting the dots. No imagining
# is required. So what patterns do we notice?
#
# For starters we that the shapes in the
# White and Asian panels are very
# similar. The panels should be juxtaposed

#-------------------------------------

# 5.1 Side comment:  Eye traversal

# I suggest that a row labeled
# dot plot's complexity of appearance
# is an increasing function of the total
# length of line segments connecting
# the dots

# Since our eyes jump around a lot, our exact eye
# traversal path will be a lot longer than
# the dot to dot length even though we try
# to look from dot to dot.
#
# A testable conjecture is that the presence of
# lines will reduce the eye traversal length. In
# any case, putting similar things close together
# tends to simplify appearance, so we will
# sort family type rows.

#----------------------------------------

# 5.2 Side comment other row sorting crieria

# William Cleveland suggested using the
# median for sorting rows (or columns)
# when there are outliers.
#
# Data analytics contexts may motive
# using other summary statistic functions such as
# the min(), max() or standard deviation, sd().

# ==========================================

# 6. Simplifying plot appearance
#    by sorting panels

# We have already noticed that the
# White and Asian patterns are strikingly
# similar! To simplify appearance we could
# switch the positions of the Asian and
# Black panels. However there are merits
# to using a computational method for the
# task of reordering races.

# The sorting description below transposes
# data matrix to provide a discussion
# in terms of sorting rows as we did above.
# Now we are thinking of races as cases and
# familty types as variables

raceRow = t(mat)
raceRow
rowSums(raceRow)

# This time we used rowSums rather that rowMeans
# In the R console see that the sum
# across the family types for each
# race is either 101 or 99.
# In the study, family type counts for each race
# were converted to rounded percents.
# Technically the six percents for each race
# should sum to 100. (rowMeans should all
# be 100/6.)v We can't tied values
# as basis for sorting.

# There are two multivariate approaches
# to sorting rows that will work.
# These are principal components and
# classical multidimensional scaling.
#
# A later lecture addresses principal components,
# and the prcomp() function. We just use the
# results here.

firstPC <- prcomp(raceRow)$x[,1]
firstPC

raceOrd <- order(firstPC)
raceRow[raceOrd,]

# We see the order is Asian, White, Hispanic,
# and Black.  We can reverse the order based on
# what we want to appear or discuss first.
# When principal component values are multiplied
# by -1 that are still have all the properties of
# principal components. If we use different
# software the signs may be reversed and still
# valid.

# We now create a matrix with sorted rows and
# columns to use futher below. The ordering is
# chosen so the plot will follow the table
# convention.

matSorted <- mat[typeOrd,rev(raceOrd)]
matSorted

dotplot(matSorted,groups = FALSE,
  layout = c(1,4),aspect = .7,
  origin = 0,type = c("p","l"),  # changed "h", "l"
  main = "Who is Raising the Children?",
  xlab = "Race Rounded Percents\nMay Not Total 100",
  scales = list(x = list(tck = 0, alternating = FALSE)),
  panel = function(...){
    panel.fill(rgb(.9,.9,.9))
    panel.grid(h = 0,v = -1,col = "white",lwd = 2)
    panel.dotplot(col = rgb(0,.5,1),cex = 1.1,...)
  }
)

# The key fact used here is that the
# first principal component is the linear
# combination of variables that provides
# greatest variability. Flipping the points
# about zero doesn't change the variance.

#--------------------------------------
#
# 6.1 Side comment on classical multidimensional scaling
#
# You can skip this section. It is just
# for the curious and not likely to be discuss
# later in class.

# The multidimensional scaling approach
# treats the race cases as a 4 points in
# 6 dimensions. The first step
# computes the Euclidean distance
# matrix for the 4 choose 2 = 6 pairs
# of race points

EucDis <- dist(raceRow)
round(EucDis)

# The Console shows
# The smallest distance, 6, is between
#     Asian and White.
# The largest distance, 44, is between
#     Asian and Black.

# Given such distance matrix, classical (metric)
# multidimensional scaling creates new points,
# (here 4 points) in a chosen lower dimensional
# space.  The created point distance matrix
# minimize sum of squared differences between it
# an the distance matrix for the original
# data.
#
# Commonly we create case representative points
# to produce plot in 2D or 3D scatterplots when number of
# data variables is larger than 3.
#
# Here we have 6 variables and just want to plot
# points on a lines so they will have a sort order.
# Below the two arguments for the cmdscale() function
# are EucDis, the distance matrix computed above
# and k=1 which mean create 1D points.

racePoints <- cmdscale(EucDis,k = 1)
racePoints

# Up to multipling by -1, these are the same
# values as  the first principal component values
# obtained above.

# We can see the one dimensional
# distances between race points
# are only an approximation to
# the distance matrix.

round(dist(racePoints),1)
round(EucDis,1)

# Now, have heard a couple of lectures,
# you might think. He should show the
# differences.  Okay.

round(dist(racePoints),1) -
round(EucDis,1)

# 7. Family type bar plot panels
#    and adding value by including the
#    panel race mean reference line

typePanelSorted <- t(matSorted)
typePanelSorted
typeRaceMeans = colMeans(typePanelSorted)

# When the panels are family types we can
# make bar plots and include the average
# of the race percents as a reference mean
# for each panel.

barchart(typePanelSorted,groups=FALSE,
  layout=c(1,6),xlim=c(0,55),
  main="Who is Raising the Children?",
  xlab="Percent",
  scales=list(x=list(tck=0, alternating=FALSE)),
  typeRaceMeans= typeRaceMeans,
  panel=function(...){
    panel.fill(rgb(.9,.9,.9))
    panel.grid(h=0,v=-1,col="white",lwd=2)
    i <- panel.number()
    panel.abline(v=typeRaceMeans[i],col="red",lwd=3)
    panel.barchart(col=rgb(0,.5,1),cex=.95,...)
  }
)

# This may help communicate the basis
# for panel order.
#
# For panel layouts such a two rows and to
# columns, controlling the layout order
# and matching means to the correct
# seem a bit complicated.
#
# Showing the means opens the door to showing
# the deviations from means as bars or lines
# draw from the red mean line. This can save
# (or increase resolution)when none of the
# original bar are close to zero.
#
# The deviation can also be represented
# the negative and positive deviations
# from a zero line, when the focus is
# not longer on the means.


#==================================================
#
# 7. ggplot and using factors to control
#    row name order and panel order

# With the lattice package,
# we could reorder matrix rows and columns.
# This let us avoid the explicit
# modification of factor levels to control
# row name and the panel order.
#
# With ggplot2 we need a data.frame or tibbles with
# factors whose level control the row plotting order
# that the panel layout order.

#-----------------------------------------
#
# 7.1 Creating a data.frame from a matrix
#     and including factors

# We first created a data.frame from
# a sorted matrix above, then include the
# row.names as factors and finally use the
# gather function in the tidyr package
# to make it an indexed data.frame

famRace <- as.data.frame(matSorted) # make a data.frame
famRace

types = row.names(famRace)
famRace$Types = factor(types,levels=types)

#-----------------------------------------------
#
# 7.2 Make an indexed dataframe that stacks
#    the race column values

famRaceType <- gather(famRace,
  key=Race,value=Percent,Asian:Black,
  factor_key=TRUE)
famRaceType

# factor_key=TRUE kepts
# the level order specified
# that sorting in alphabet
# orde.

#--------------------------------------------
#
# 7.3 famRaceType used raceLevels from
#     section 5 so is ready to use.

ggplot(famRaceType, aes(x = Percent,y = Types)) +
  geom_point(fill = "blue", shape = 21, size = 2.8) +
  labs(x = "Percent",y = "",
  title = "Who's Raising the Children?") +
  facet_grid(.~Race) + hw

#================================================
#
# 8. Create two perceptual groups in each panel
#
#    We will use geom_path lines to connect
#    the top three dots and to connect the
#    bottom three dots.
#
#    geom_path connects the dot in a group using the
#    row order in the dataframe.
#    We need put the rows in the desired family
#    type order.

# 8.1 Order the data.frame rows so
#     so family factor numeric value varies within
#     each race factor numeric values

ord <- order(as.numeric(famRaceType$Race),
             as.numeric(famRaceType$Types))

famSorted <- famRaceType[ord,]
famSorted

# 8.2  Use family type numbers 1:6
#      and cut() to create
#      2 groups of 3 family types

# Family types with numbers
# 1:3 will be in the (0, 3.5] group
# 4:6 will be in the (3.5, 6] group

famSorted <- mutate(famSorted,
  G2=cut(as.numeric(Types),
         breaks=c(0, 3.5, 6))
)

famSorted

# Above can see the structure
# group of three in the G2 column

#The factor patterns may be easier to see
#when converted to integers.

cbind(as.numeric(famSorted$Race),
      as.numeric(famSorted$Types),
      as.numeric(famSorted$G2))

# 8.3 Use paths to link the
#     dots in each perceptual group

ggplot(famSorted,aes(x=Percent,y=Types,group=G2))+
  geom_path(color="blue",size=1)+
  geom_point(shape=21,fill="blue", color="black", size=2.7)+
  geom_point(shape=21,fill="white",color='white',size=1)+
  labs(x="Percent",y="",
       title="Who's Raising the Children?")+
  facet_grid(.~Race)+hw

# 8.4 Change the cut breaks in Section 8.2
#     to produce 3 perceptual groups of size 2.
#     Rerun the needed parts of the 8.2 and
#     8.3 script to produce the plot.

