library(terra)
library(ncdf4)
library(ggplot2)
library(sf)
library(sp)
library(raster)
library(rasterVis)
library(imageRy)
im.list()
library(ggplot2)
library(viridisLite)
library(viridis)
library(patchwork)

#the working directory was set using the function setwd():
setwd("C:/Users/seren/Desktop/R PROJECT SPATIAL ECO")

#the two images are imported through the function rast()
iberic22 <- rast("iberian_tmo_2022130_lrg.jpg")
iberic23 <- rast("iberian_tmo_2023131_lrg.jpg")
plot(iberic22)
plot(iberic23)
str(iberic22)
summary(iberic22)

#using the function plotRGB, the two images are plotted:
plotRGB(iberic22, r=1, g=2, b=3)
plotRGB(iberic22, r=2, g=3, b=1)

plotRGB(iberic23, r=1, g=2, b=3)
plotRGB(iberic23, r=2, g=3, b=1)


par(mfrow=c(1,2))
plotRGB(iberic22, r=1, g=2, b=3)
plotRGB(iberic23, r=1, g=2, b=3)
dev.off()

#the color palette was changed:
cl <- colorRampPalette(c("black","grey","white")) (100)
plot(iberic23[[2]], col=cl)

#The two images must be cropped to eliminate as much as possible the influence of clouds
ext <- c(250,1000,300,800)
iberic22C<- crop(iberic22, ext)
iberic23C<- crop(iberic23, ext)
plot(iberic22C)
plot(iberic23C)

#MULTITEMPORAL CHANGE DETECTION
#the amount of change in the drough was performed making the difference between the two images:
dif= iberic22C[[1]]-iberic23C[[1]]
plot(dif)

#a palette that is accessible even to colorblind people was chosen:
clDIF <- colorRampPalette(c("blue4","white","orange")) (100)
plot(dif, col=clDIF)
dev.off()

par(mfrow=c(3,1))
plot(iberic22C[[1]], col=clDIF)
plot(iberic23C[[1]], col=clDIF)
plot(dif, col=clDIF)
dev.off()

#DVI was calculated:
#bands: 1=NIR, 2=RED, 3=GREEN
#DVI =NIR - RED
dvi2022 = iberic22C[[1]] - iberic22C[[2]]
plot(dvi2022)

cl2 <- colorRampPalette(c("blue3","white","darkorange2","black")) (100)
plot(dvi2022, col=cl2)

dvi2023 = iberic23C[[1]] - iberic23C[[2]]
plot(dvi2023, col=cl2)

par(mfrow=c(2,1))
plot(dvi2022, col=cl2)
plot(dvi2023, col=cl2)


#NDVI was calculated using the NDVI = (NIR-RED)/(NIR+RED)
ndvi2022 =(iberic22C[[1]]-iberic22C[[2]])/(iberic22C[[1]]+iberic22C[[2]])
ndvi2023 =(iberic23C[[1]]-iberic23C[[2]])/(iberic23C[[1]]+iberic23C[[2]])
cl3 <- colorRampPalette(c("darkblue","blue", "white","darkorange2")) (100)
par(mfrow=c(2,1))
plot(ndvi2022, col=cl3)
plot(ndvi2023, col=cl3)
ndvi2022
ndvi2023



##CLASSIFICATION OF PIXELS 
#layer1 = soil
#layer2 = vegetation
iberic22Cc<- im.classify(iberic22C, num_clusters = 2) 
iberic23Cc<- im.classify(iberic23C, num_clusters = 2)

par(mfrow=c(2,2))
plot(iberic22C)
plot(iberic23C)
plot(iberic22Cc[[1]])
plot(iberic23Cc[[1]])

#the frequency of each layer was calculated:
f2022 <- freq(iberic22Cc[[1]])
f2022
f2023 <- freq(iberic23Cc[[1]])
f2023

#to calculate the number of total pixels in the 2022 and 2023 images
tot2022 <-ncell(iberic22Cc[[1]])
tot2023 <-ncell(iberic23Cc[[1]])

#finally, the percentage of vegetation change between the 2022 and 2023 was determined:
p2022 <- f2022*100/tot2022
p2022
p2023 <- f2023*100/tot2023
p2023                             ###the percentage of vegetation goes from a 
                                  ###value of 66% to a 43% the following year.



#building the final table.
class <- c("Bare soil", "Vegetation")
y2022 <- c(34, 66)
y2023 <- c(57, 43)

table1 <- data.frame(class, y2022, y2023)
table1

g2022 <- ggplot(table1, aes(x=class, y=y2022, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))
g2023 <- ggplot(table1, aes(x=class, y=y2023, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))
g2022 + g2023
dev.off()

#principal component analysis on iberic22C
pairs(iberic22C)
iberic2022pc <- prcomp(iberic22C)
summary(iberic2022pc)
str(iberic2022pc)

pairs(iberic23C)
iberic2023pc <- prcomp(iberic23C)
summary(iberic2023pc)
#the principal components for both the images is PC1

#measuring RS variability using the first layer of iberic22C and iberic23C.
nir2022 <- iberic22C[[1]]
plot(nir2022, col=virSD)
#calculating the standard deviation for iberic2022C.

sd3.22 <- focal(nir2022, matrix(1/9, 3, 3), fun=sd)
plot(sd3.22)

virSD <- colorRampPalette(viridis(7))(255)
plot(sd3.22, col=virSD)

sd5.22 <- focal(nir2022, matrix(1/25, 5, 5), fun=sd)
plot(sd5.22)
plot(sd5.22, col=virSD)

sd9.22 <- focal(nir2022, matrix(1/81, 9, 9), fun=sd)
plot(sd9.22, col=virSD)

#we stack all the layers of standard deviation
sdstack <- c(sd3.22, sd5.22, sd9.22)
names(sdstack) <- c("sd3_2022", "sd5_2022", "sd9_2022")

plot(sdstack, col=virSD)

#calculating the standard deviation for iberic2023C.
nir2023 <- iberic23C[[1]]
plot(nir2023, col=virSD)

sd3.23 <- focal(nir2023, matrix(1/9, 3, 3), fun=sd)
plot(sd3.23, col=virSD)

sd5.23 <- focal(nir2023, matrix(1/25, 5, 5), fun=sd)
plot(sd5.23, col=virSD)

sd9.23 <- focal(nir2023, matrix(1/81, 9, 9), fun=sd)
plot(sd9.23, col=virSD)

sdstack23 <- c(sd3.23, sd5.23, sd9.23)
names(sdstack23) <- c("sd3_2023", "sd5_2023", "sd9_2023")
plot(sdstack23, col=virSD)

#we plot the 3 variability of the two years together together with nir2022 and nir2023
par(mfrow=c(2,4))
plot(nir2022, col=virSD)
plot(sd3.22, col=virSD)
plot(sd5.22, col=virSD)
plot(sd9.22, col=virSD)
plot(nir2023, col=virSD)
plot(sd3.23, col=virSD)
plot(sd5.23, col=virSD)
plot(sd9.23, col=virSD)

