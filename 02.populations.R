# Code related to population ecology

#a package is needed for point pattern analysis
install.packages("spatstat")
library(statstat)

#let's use the bei data:
#data description
#http://CRAN.R-project.org/

bei

#plotting data
plot(bei)

#change the dimension (,cex=)
plot(bei, cex=.2)

#changing the symbol -pch
plot(bei, cex=.2, pch=19)

#additional dtasets
bei.extra
plot(bei.extra)

#let's use only part of the dataset: elev
plot(bei.extra$elev)
elevation <- bei.extra$elev
plot(elevation)

#second method to select elements
elevation2 <- bei.extra[[1]]
plot(elevation2)

#passing from points to a continuous surface
densitymap <- density(bei)
plot(densitymap) #this permits us to have the colored map

#the function POINTS to insert the points in the bei dataset on top of the colored density map
#avoid using maps with blue, green and red together due to colorblindness
points(bei, cex=.2)

#to change the color of the map by using "colorRampPalette":
colorRampPalette(c("black", "red", "orange", "yellow"))(100)

c1 <- colorRampPalette(c("black", "red", "orange", "yellow"))(100)
plot(densitymap, col=c1)

#the yellow color is the color that impacts the most our eye, 
#so it is to be used for the high part of the data
cl<- colorRampPalette(c("black","red", "orange", "yellow"))(4)
plot(densitymap, col=cl)

#to see which colors can be used in R we just have to search it on the internet

c2 <- colorRampPalette(c("black","darkcyan","cyan3","cyan1"))(50)
plot(densitymap, col=c2)
#NEVER USE TURBO COLOR PALETTE/RAINBOW PALETTE 

plot(bei.extra) #these are more variables
#to select the first element of bei.extra
elev<- bei.extra[[1]]
plot(elev)


 #the dollar symbol $ is used to extract elements like:
elev <- bei.extra$elev
plot(elev)

#MULTIFRAMES mf in which we will have to state how many rows and columns we want.
par(mfrow=1,2) #first create the multiframe with this command
plot(densitymap) #then plot what we want inside the multiframe that we created
plot(elev) #also plotted to be inside our multiframe

#if we want the first plot on the top, and the second plot on the bottom (it changes the number of rows and column)

par(mfrow=c(2,1))
plot(densitymap)
plot(elev)
#elev states for elevation/altitude. then plotting it in the same multiframe will permit use to see the 
#relationship between an high/low presence of trees and the different altitudes since we are using bei.


#exercise regarding creation of multiframe
par(mfrow=c(1,3))
plot(bei)
plot(densitymap)
plot(elev)
