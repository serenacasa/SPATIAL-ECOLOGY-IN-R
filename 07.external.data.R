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

