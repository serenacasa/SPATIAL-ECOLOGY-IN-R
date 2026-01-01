#### VARIABILITY ####
# Measurement of RS based variability

library(imageRy)
library(terra)
library(viridis)

im.list()

sent <- im.import("sentinel.png")

im.plotRGB(sent, r = 1, g = 2, b = 3)

# band 1 = NIR
# band 2 = red 
# band 3 = green

im.plotRGB(sent, r = 2, g = 1, b = 3)
im.plotRGB(sent, r = 3, g = 2, b = 1)

nir <- sent[[1]]
plot(nir)


#### Moving window ####
# focal function will make any type of calculation. 
# In this case the standard deviation

sd3 <- focal(nir, matrix(1/9, 3, 3), fun = sd)
# don't use only "sd" as a name since in R it means standard deviation

plot(sd3)

viridisc <- colorRampPalette(viridis(7)) (255)
viridis
plot(sd3, col = viridisc)

im.list()
sent <- im.import("sentinel.png")

im.plotRGB(sent, 1, 2, 3)
im.plotRGB(sent, 2, 1, 3)

#### Exercise 1: calculate the variability in 7x7 moving window ####
#focal

sd7 <- focal(nir, matrix(1/49, 7, 7), fun = sd)
plot(sd7, col = viridisc)


#### Exercise 2: plot via par(mfrow()) the 3x3 and the 7x7 standard deviation ####

par(mfrow = c(1, 2))
plot(sd3, col = viridisc)
plot(sd7, col = viridisc)

# When enlarging the moving window we will obtain more pixels (49 in the second case), 
# in this way, we can obtain more variability (increasing the variability). 
# In the first case we only have 9 pixel per time (decreased variability)

# original image plus the 7x7 sd
im.plotRGB(sent, 2, 1, 3)
plot(sd7, col = viridisc)

# how to chose the layer to which apply the sd calculation
# method to pass from the whole image to the layer we want => MULTIVARIATE ANALYSIS

