# coronavirus period and how during that time the NO2 level decreased.

#### TIME SERIES ANALYSIS ####

library(terra)
library(imageRy)
install.packages("raster")
install.packages("rasterVis")
library(raster)
library(rasterVis)

im.list()

# import the data
EN01 <- im.import("EN_01.png")
EN13 <- im.import("EN_13.png")


# We plot them together to confront them better
par(mfrow = c(2, 1))
im.plotRGB.auto(EN01)
        im.plotRGB.auto(EN13)                               

        
# We can make the difference between two images or we can also take the first element of the two images 
# and compare the elements alone to take the first element of the first image (the first band) 
# and the one from the second image

dif = EN01[[1]] - EN13[[1]]                                 
# difference from january and march
dev.off()

plot(dif)                                                   
# 8 bit image, 256 is the highest level

# change the colorRamppalette of the difference 'dif'
cldif <- colorRampPalette(c("blue", "white", "red")) (100)  
# The colors blue and red are used together in this case, but only for the lesson purpose. Best to avoid.

plot(dif, col = cldif)

par(mfrow = c(3, 1))
im.plotRGB.auto(EN01)
im.plotRGB.auto(EN13)

dev.off()


# new example on the change of LST in greenland (LST = land surface temperature)
g2000 <- im.import("greenland.2000.tif")
g2000
clG <- colorRampPalette(c("blue", "white", "red")) (100)

plot(g2000, col = clg)                                        
# temperature in red are the higher temperatures and the blue the coldest

g2005 <- im.import("greenland.2005.tif")
g2010 <- im.import("greenland.2010.tif")
g2015 <- im.import("greenland.2015.tif")

clg <- colorRampPalette(c("black", "blue", "white", "red")) (100) 
# To make the difference more effective we can also use black

par(mfrow = c(2, 2))
plot(g2000, col = clg)
plot(g2015, col = clg)                
plot(g2010, col = clg)
plot(g2005, col = clg)

dev.off()

# use the "stack" function to stack them all together
stackg <- c(g2000, g2005, g2010, g2015)                    
plot(stackg, col = clg)


###exercise: make the difference between the g2000 and the g2015:
difG = g2000 - g2015
difG = stackg[[1]] - stackg[[4]]                          
# This is the second method to do the difference, taking the first element of the stackg and its fourth element

plot(difG, col = clG)


# Plot the first three elements to the RGB plot and see which one had the highest temperatures:
# high values in the g2000 will become red
# high values in the g2005 will become green
# high values in the g2010 will become blue
# we will know which one had the highest temperature by comparing them depending on the final color

# Exercise: make an RGB plot using different years

im.plotRGB(stackg, r = 1, g = 2, b = 3)                         
# r = 1 -> means that we plot the g2000 with the red                                                       
# g = 2 -> we plot the g2005 to the green
# b = 3 -> we plot the g2010 to the blue
# The results show that the hottest (darkest and mostly dark) was during the last g2010
