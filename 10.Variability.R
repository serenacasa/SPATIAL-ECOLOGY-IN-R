measurement of RS based variability

library(imageRy)
library(terra)
library(viridis)

im.list()

sent<- im.import("sentinel.png")

im.plotRGB(sent,r=1, g=2, b=3)

#band 1 = NIR
#band 2 = red 
#band 3 = green

im.plotRGB(sent, r=2, g=1, b=3)
im.plotRGB(sent, r=3, g=2, b=1)

nir <- sent[[1]]
plot(nir)


#moving window
#focal function will make any type of calculation. in this case the standard deviation

sd3 <- focal(nir, matrix(1/9, 3, 3), fun=sd)
#don't use only sd as a name since in R sd means standard deviation
plot(sd3)

viridisc <- colorRampPalette(viridis(7)) (255)
viridis
plot(sd3, col=viridisc)
