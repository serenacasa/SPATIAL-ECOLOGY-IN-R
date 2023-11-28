#external data
library(terra)
              #always put the packages we are going to use on top (in this case terra).

              #first of all, we downloaded the image in our computer from the Earth Observatory page
              #then we have to let R access to our image. We have to explain to R the directory to find 
              #the image in our computer, so we have to set the working directory depending on our path:
                  ##For Windows users we have to change the slashes since usually 
                  ##it is written with the back slash, and R works with the foreward slash

setwd("C:/Users/seren/Desktop/SPATIAL ECOLOGY IN R") #"setwd"= SET WORKING DIRECTORY,
                                                     #this function to direct R in the right location 
                                                     #were we stored our image

naja<- rast("najafiraq_etm_2003140_lrg.jpg")         #using function "rast" as we already used im.import()
                                                     #remember to check the right name from the properties
                                                    #remember to put the EXTENSION AT THE END (.jpg in this case)

#then we have to plot the image, using a function directly from Terra called "plotRGB":
plotRGB(naja,r=1, g=2, b=3)


###EXERCISE:
                                                #after we downloaded the second image from the same site, we import it in R
najaaug <- rast("najafiraq_oli_2023219_lrg.jpg")

plotRGB(najaaug, r=1, g=2, b=3)                 #in this way we plot the second image as 
                                                #we did for the first one

par(mfrow=c(2,1))                               #then we plot the two in the same multiframe
plotRGB(naja, r=1, g=2, b=3)                    #im-plotRGB
plotRGB(najaaug, r=1, g=2, b=3)

#### MULTITEMPORAL CHANGE DETECTION#####
                                                #in this way we can detect the changes between 
                                                #the two images:
najadif = naja[[1]] - najaaug[[1]] 
cl <- colorRampPalette(c("brown", "grey", "orange")) (100)
plot(najadif, col=cl)


###Exercise with OUR OWN IMAGE####
setwd("C:/Users/seren/Desktop/SPATIAL ECOLOGY IN R")

qcap88 <- rast("quelccaya_tm_1988246_lrg.jpg")   #remember to PUT THE EXTENSION .jpg AT THE END
                                                 #and to set the working directory in the files commands

plotRGB(qcap88, r=1, g=2, b=3) #red 
plotRGB(qcap88, r=2, g=1, b=3) #green
plotRGB(qcap88, r=3, g=2, b=1) #blue

qcap23 <- rast("quelccaya_oli_2023295_lrg.jpg")  #import the second image from 2023 for comparison

plotRGB(qcap23, r=1, g=2, b=3)                   #plot in red predominant of the second image

par(mfrow=c(2,1))                                #plot the two images in the same multi-frame

plotRGB(qcap88, r=1, g=2, b=3)
plotRGB(qcap23, r=1, g=2, b=3)
    
#to have the MULTITEMPORAL CHANGE DETECTION in the change of the ice cap:

qcapdif = qcap88[[1]] - qcap23[[1]]
clcap <-colorRampPalette(c("blue4","grey90","grey20")) (100) #we change the color palette

dev.off()
plot(qcapdif, col=clcap)


#Exercise with The Mato Grosso image. It can be downloaded directly from EO-NASA site.
mato <- rast("matogrosso_l5_1992219_lrg.jpg")

plotRGB(mato, r=1, g=2, b=3) 
plotRGB(mato, r=2, g=1, b=3) 



