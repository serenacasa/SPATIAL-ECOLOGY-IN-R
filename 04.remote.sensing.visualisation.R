#remote sensing for ecosystem monitoring
library(devtools) #packages in R are also called libraries

#another method to install the package from the function in which it is inserted
devtools::install_github("ducciorocchini/imageRy")
library(imageRy) #pay attention to capital letters
library(terra)

im.list()

#importing data. the Blue band:
b2 <- im.import("sentinel.dolomites.b2.tif") #in order to use the band number of the sentinel


cl <- colorRampPalette(c("black", "grey", "lightgrey")) (100)
plot(b2, col=cl)


# import the green band from Sentinel-2 (band 3)
b3 <- im.import("sentinel.dolomites.b3.tif")
plot(b3, col=cl)

# import the red band from Sentinel-2 (band 4)
b4 <- im.import("sentinel.dolomites.b4.tif")
plot(b4, col=cl)

# import the NIR band from Sentinel-2 (band 8)
b8 <- im.import("sentinel.dolomites.b8.tif") 
plot(b8, col=cl)

# multiframe
par(mfrow=c(2,2))
plot(b2, col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)


# stack images
stacksent <- c(b2, b3, b4, b8)
dev.off() # it closes devices
plot(stacksent, col=cl)

plot(stacksent[[4]], col=cl)

# Exercise: plot in a multiframe the bands with different color ramps
par(mfrow=c(2,2))

clb <- colorRampPalette(c("darkblue", "blue", "lightblue")) (100)
plot(b2, col=clb) #the blue band is the band number 2 in sentinel

clg <- colorRampPalette(c("darkgreen", "green", "lightgreen")) (100)
plot(b3, col=clg) #the green band is the 3rd band in sentinel

clr <- colorRampPalette(c("darkred", "red", "pink")) (100)
plot(b4, col=clr) #the red band is the 4th one in sentinel

cln <- colorRampPalette(c("brown", "orange", "yellow")) (100)
plot(b8, col=cln) #the near infrared band is the number 8 in sentinel

# RGB space
# stacksent: 
# band2 blue element 1, stacksent[[1]] 
# band3 green element 2, stacksent[[2]]
# band4 red element 3, stacksent[[3]]
# band8 nir element 4, stacksent[[4]]
im.plotRGB(stacksent, r=3, g=2, b=1) #to put every single band on top of the component on a multiframe
im.plotRGB(stacksent, r=4, g=3, b=2) #red component on top of the grey one
im.plotRGB(stacksent, r=3, g=4, b=2) #green component on top of the grey one
im.plotRGB(stacksent, r=3, g=2, b=4) #this permits to put the blue component on top. 
#In this way all the vegetation is going to become blue, soil is going to become yellowish 
#(this can be used to highlight cities)

#to CORRELATE BANDS:
#we can compare bands together with a single function in R (differently from excel)
#graph with all the bands together --> it is called a SCATTERPLOT MATRIX
#this can be used with any kind of table and data
#when we have a lot of variables and a number of correlation between them we should use the function pairs()

pairs(stacksent)
#values of reflectance changed to only integer values.
#the first graph in the multiframe is representing the frequency of every value of reflectance



