#  Title                    ggplot2 examples

# Due======================================
#
# Convert the R script to R and markdown script
# produce a word document to submit, with your
# name in the title.
#
# 5 points
#========================================

# Sections===========================================

# 0. Setup

# 1 Histograms
# 2 Kernel Density plots
# 3 Superposed Density Plot
# 4 Scatterplots and smooths
# 5 Superposed scatterplot
#      with point color encoding diamond color
# 6 Juxtaposed scatterplots using facet_wrap
# 7 Two-way juxtaposed superposed scatterplots
#   using facet_grid
# 7.1 Restricting the x-axis scale and better axes labels

# 8. A quick modeling example


# 0. Setup===================================

library(tidyverse)
source('hw.R')
source('hw2.R')

# 1 Histograms

ggplot(data = diamonds, aes(x = carat)) +
  geom_histogram(fill = "cyan",color = "black") + hw

# Increase the number of x-axis bins

ggplot(data = diamonds, aes(x = carat)) +
  geom_histogram(fill="cyan",color = "black",bin = 50) + hw

# Zoom in on a lower x-axis interval

ggplot(data = diamonds, aes(x = carat)) +
  geom_histogram(fill = "cyan",color = "black",bins = 50) +
  xlim(0,3.5) +  hw

# 2 Kernel Density plots

ggplot(data=diamonds, aes(x=carat)) +
  geom_density(fill = "cyan", color = "black") + hw

# Change the kernel width

ggplot(data=diamonds, aes(x = carat)) +
  geom_density(fill = "cyan",color = "black",adjust = 2) + hw

# Change the kernal shape
# See ?density for options

ggplot(data = diamonds, aes(x = carat, color = cut)) +
  geom_density(fill = "cyan", color = "black",
  kernel="epanechnikov", adjust = 2) + hw

# 3 Superposed Density Plots

# Superposed density plots for each level
# of the factor cut, also use this
# as the density fill color
# The group argument groups data by level of cut
# so there is density plot for each level.
# Set the transparency to .2. The transparency scale
# from 0 (transparent) to 1 (no color mixing).

ggplot(data = diamonds, aes( x = carat, group = cut, fill = cut)) +
  geom_density( color = "black", adjust = 2, alpha = .2) +
  scale_fill_manual(
     values = c("red", "yellow", "green","cyan", "violet"),
     na.value="grey70") + hw

# The mixing of multiple colors is hard to decode.
# Note that with alpha blending one color plot on a gray and
# on a white background will have a different appearance.
# One could switch to a white plot background with gray grid lines
# so the color in plot and the legend would be the same.

# Omit some high carat outliers using xlim() for a better
# resolution view of the densities

ggplot(data = diamonds, aes(x = carat,group = cut,fill = cut)) +
  geom_density(color = "black",adjust = 2,alpha = .2) +
  xlim(0,3.5)

# 4 Scatterplots and smooths
#    see R For Everyone 7.7.2

# Saving the plot setup

scat <- ggplot(diamonds, aes( x = carat, y = price) )

# Show the points

scat + geom_point() + stat_smooth() + hw

# 5 Superposed scatterplot
#      with point color encoding diamond color

scat + geom_point( aes( color = color) ) + hw

# 6 Juxtaposed scatterplots using facet_wrap

scat + geom_point(aes(color = color)) +
  facet_wrap(~color) + hw +
  theme(legend.position = 'none')

# Yellow has little constrast to the
# light gray background

# 7 Two-way juxtaposed scatterplots
#     using facet_grid

scat + geom_point(aes(color = color)) +
  facet_grid(clarity~color) + hw2


# 7.1  Restricting the x-axis scale and better labeling for axes

scat2 <- ggplot(diamonds, aes( x = carat, y = price/1000) )
scat2 + geom_point(aes( color = color)) +
  facet_grid( clarity~cut ) +
  xlim(0,3.5) +
  labs(x = "Carats, 9 Diamonds With Carats > 3.5 removed",
  y = "Price in $1000",
  title = paste("Diamonds: Row Panels for Clarity Classes",
    "Column Panels for Cut Classes",sep = "\n"),
  color = "Color") + hw2

# 8. A quick modeling example

# The scatterplot smooths clearly show price increasing with Carats.
# Models can help bring out price modifications related to
# factor levels of Cut and Clarity.

# Separate smooths for the cut classes

ggplot(diamonds,aes(x = carat,y = price/1000,
  group = cut, color = cut)) +
  geom_point() + stat_smooth(size = 2) + hw +
 scale_color_manual(
     values = c("red", "yellow", "green","cyan", "violet"),
     na.value = "grey70") + hw +
 labs(x = "Carats",
   y = "Price in $1000",
   title = "Price to Carat Relationship Varies with Cut",
   color = "Cut") + ylim(0,20)

# The Fair cut smooth shows lower prices for the same carat
# up to around 3.2 but extends to very large carats diamonds.
# Perhaps the other cuts are problematic with larger carat
# diamonds. The down turn for the Ideal cut suggests difficulties.

#In Class
####################################################################################
#Basic Graph
ggplot(diamonds , aes(x = cut)) + 
 geom_bar() + labs(x = "Cut Classes",y = "Count", title = "Diamond Data Set")

#Add Color
ggplot(diamonds , aes(x = cut, fill = cut)) +
 geom_bar(color = 'black') +
 labs(x = "Cut Classes", y = "Count", title = "Diamond Data Set") +
 hw

#Remove the Legend
ggplot(diamonds, aes(x = cut, fill = cut)) +
 geom_bar(color = "black") + # adds black outline 
 labs(x = "Cut Classes", y = "Count", title = "Diamond Data Set") + 
 hw + 
 theme(legend.position = 'none')

#Define the color using RGB number scheme
vert <- ggplot(diamonds, aes(x = cut, fill = cut)) +
 geom_bar(color = gray(.25)) +
 labs(x = "Cut Classes",
      y = "Count",
      title = "Diamond Data Set",
      fill = "Cut") + hw +
 scale_fill_manual(
  values = c("red", "orange", rgb(.90, .90, 0), rgb(0, .75, 0), 'blue'),
  na.value = "grey30") +
 theme(legend.position = 'none')

#Flip the graph by adding in dimension
vert + coord_flip()

#Add additional color information within the classes
ggplot(diamonds, aes(x = cut, fill = color)) +
 geom_bar(color = "black") +
 labs(x = "Cut Classes",
      y = "Count",
      title = "Diamond Data",
      fill = "Color") + hw

#Flip the Cut vs Color variable positions
twoway <- ggplot(diamonds, aes(x = color, fill = cut)) +
 geom_bar(color = "black") +
 labs(x = "Color Classes",
      y = "Count",
      title = "Diamond Data",
      fill = "Cut") + hw +
 scale_fill_manual(
  values = c("red", "orange", rgb(.90, .90, 0), rgb(0, .75, 0), 'blue'),
  na.value = "grey30")
twoway

#Flip the graph and move the legend to the top of the graph, adding description to the
#legend
twoway + 
 theme(legend.position = 'top') + 
 guides(fill = guide_legend(reverse = TRUE, 
                            title.position = 'left', title = "Cut Classes:", 
                            title.hjust = .5, title.vjust = 1, 
                            legend.margin = unit(c(0,0,0,0),"cm"), 
                            label.position = "bottom", label.hjust = .5, 
                            label.theme = element_text(color = 'black', angle = 0, 
                                                       size = 11), keywidth = 2, 
                            keyheight = 0.8)) + coord_flip()

#Create histogram
ggplot(data=diamonds, aes(x=carat)) +
 geom_histogram(fill="cyan", color = "black") +
 hw

#Increase the bin size - gives you an error
ggplot(data=diamonds, aes(x=carat)) +
 geom_histogram(fill="cyan", color = "black", bin=10) +
 hw

#Lower the x-axis
ggplot(data=diamonds, aes(x=carat)) +
 geom_histogram(fill="cyan", color = "black",bin=50) +
 xlim(0,3.5)+
 hw

#Kernal Density - gives a sense of the distribution of the data; finds a curve that fits
ggplot(data=diamonds, aes(x=carat)) +
 geom_density(fill="cyan", color = "black") +
 hw