#### CLASSIFICATION OF PIXELS for Remote Sensing Data ####
                                      
# grouping pixels can be used to represent the final class on a graph with red, infrared and so on on the axes.
# The amount of pixels and the amount of proportion related to that.
# Vegetation area are reflective a lot in the infrared area (not in the red since they are doing photosynthesis)
# Water absorbs all the infrared light and may reflect red.
# These pixels are called TRAINING SITES, something that can explain to the software which clusters (or classes) are present.
# If we want to classify a pixel, without knowing its class, we must use the reflectance of the pixel
# and use the SMALLEST DISTANCE FROM THE NEAREST CLASS, to estimate to which class the pixel is most probable to be part of.
# This way, we can classify every pixel in the image by class.

# classifying satellite images performed with the function im.classify()


library(imageRy)
library(terra)

im.list()                                                                  
# we are going to list all the files we have from ImageRy                                                                            
# The image of the sun comes from the ESA

# we chose the image of the sun from ESA
sun <- im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")      


# we estimate the level of colors that are present in the image, 
# then we are going to explain to the software the number of the clusters in the image
                                                                            
# im.classify(name of the image(sun in this case), number of clusters (num_clusters =) we want)
sunC <- im.classify(sun, num_clusters = 3)

plot(sunC[[1]])


#### classify satellite data.MATO ####
# then we apply the same technique to the forest of Matogrosso.

im.list()

m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")                         
# water is going to appear black as it absorbs the infrared

m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")                        
# we are going to use only 2 clusters

m1992C <- im.classify(m1992, num_clusters = 2)
plot(m1992C[[1]])

plotRGB(m1992)
m1992C <- im.classify(m1992, num_clusters = 2)
plot(m1992C[[1]])
# classes: forest = 1, human = 2

m2006C <- im.classify(m2006, num_clusters = 2)
plot(m2006C[[1]])
# forest = 1 (much less now), human = 2 in green

# compare the two images using a multiframe
par(mfrow=c(1,2))                  
plot(m1992C[[1]])
plot(m2006C[[1]])


# to count the frequency of each class of pixels we use the function freq()
f1992 <- freq(m1992C[[1]])
f1992                                                                      
# 3 sets of the same values since we have three levels in the image

# calculates the number of pixels in an image
tot1992 <- ncell(m1992C[[1]])                                              
tot1992

#### percentage of 1992 ####

p1992 <- f1992 * 100 / tot1992
p1992                                                                       

# the count section gives us the percentage, 
# with the forest covers the 83%,                                                             
# and the human the 16.91%

f2006 <- freq(m2006C[[1]])
f1992

tot2006 <- ncell(m2006C[[1]])
tot2006

#### Percentage of 2006 ####
p2006 <- f2006 * 100 / tot2006
p2006                                                                      
# the count tells us that the forest now covers the 45%, and the human he 54.7.%, so 55%

#### GRAPHIC ####

# To make a graph of this, we should:
# 1. build the columns of the dataframe, using class()
# 2. build a dataframe with the function data.frame

class <- c("forest", "human")
y1992 <- c(83, 17)                                                           
# y axis m1992 values obtained from the image percentage to have our data on the graph
y2006 <- c(45, 55)

tab <- data.frame(class, y1992, y2006)
tab

# 3. build a graph we need the ggplot2 function
library(ggplot2)                                                             

# aes = aestetics that manages the formation of the graph, values on the x axis, y axis and the color

p1 <- ggplot(tab, aes(x = class, y = y1992, color = class)) + geom_bar(stat = "identity", fill = "white")
plot(p1)                                                                     
# or also only by writing p1

p2 <- ggplot(tab, aes(x = class, y = y2006, color = class)) + geom_bar(stat = "identity", fill = "white")
plot(p2) 
                                                              

library(ggplot2)
install.packages("patchwork")
library(patchwork)
# To merge them, we have to use the function patchwork()

#### final output ####

p1 <- ggplot(tab, aes(x = class, y = y1992, color = class)) + geom_bar(stat = "identity", fill = "white")
p2 <- ggplot(tab, aes(x = class, y = y2006, color = class)) + geom_bar(stat = "identity", fill = "white")
p1 + p2

# plot p1 related to the 1992 and p2 related to the 2006 image. 


# we have the problem of having two different scales in the two different images.
# To have the same scale in each image graph we have to use add the specification to each line --> + ylim(c(0, 100))
# In this way, the range in the y-axis will be the same.

#### final output, RESCALED ####

p1 <- ggplot(tab, aes(x = class, y = y1992, color = class)) + geom_bar(stat = "identity", fill = "white") + ylim(c(0, 100))
p2 <- ggplot(tab, aes(x = class, y = y2006, color = class)) + geom_bar(stat = "identity", fill = "white") + ylim(c(0, 100))
p1 + p2
