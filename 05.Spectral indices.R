##### SPECTRAL INDICES ####

                                                                      # since this bands are all correlated with each other, 
                                                                      ## we can build SPECTRAL INDICES.

                                                                      # taking into consideration the reflectance of red 
                                                                      ## and NIR bands from a tree. We are going to compare the NIR
                                                                      ## and the red value (that is supposed to be lower)
library(imageRy)
library(terra)

im.list()
im.import("matogrosso_l5_1992219_lrg.jpg")                            # This gives directly the plot of the Mato Grosso 
                                                                      ## tree distribution in 1992. 
                                                                      ## The bands here are three: 
                                                                        ### The first one is the NIR, 
                                                                        ### the second is the red and 
                                                                        ### the third the green.
                                                                      ## bands: 1=NIR, 2=RED, 3=GREEN


m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")                  # we assign a name to this plot (m1992)

im.plotRGB(m1992, r=1, g=2, b=3)
im.plotRGB(m1992, 1, 2, 3)


im.plotRGB(m1992, r=2, g=1, b=3)                                      # In this way, we can to mount the NIR on top of the green, 
                                                                      ## instead of on top of red.

                                                                     
im.plotRGB(m1992, r=2, g=3, b=1)                                      # to enhance the BARE SOIL.
                                                                      # WATER usually in this kind of images should be black 
                                                                      ## since it is absorbing all the bands

                                                                      # then we import the recent image
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
im.plotRGB(m2006, r=2, g=3, b=1)
                                                                      #The yellow color is catching our eyes more than other colors, 
                                                                      ## so to attract attention we should use the  yellow color.



                                                                      #Then we build a multiframe with 1992 and 2006 images
par(mfrow=c(1,2))
im.plotRGB(m1992, r=2, g=3, b=1) 
im.plotRGB(m2006, r=2, g=3, b=1)
dev.off()


#### VEGETATION INDICES ####
#let's create vegetation indices to visualize and measure the health of the vegetation situation.

plot(m1992[[1]])
                                                                      # The RANGE OF REFLECTANCE is from 0 to 255
                                                                      ## because reflectance is the ratio between the incident flux of energy and the reflected flux.

                                                                      # We want to avoid float numbers because they require space in our computer
                                                                      ## to avoid them we should use bits: 1 bit = or 0 or 1 -> the BINARY CODE
                                                                      ## The binary code can be used to build every information in the computer
                                                                      ## (1 bit = 2 information: 0 or 1; 2 bits= 4 information: 00, 01, 10, 11; 3 bits= 8 info and so on)
                                                                      # Most of the images are storaged in 8 BIT -> it permits to store a lot of information 
                                                                      ## but reducing the storaging space that is required

                                                                      # DVI = DIFFERENCE VEGETATIO INDEX -> the difference between the total bits and the REDs 
                                                                      # DVI = difference between NIR and RED

dvi1992 = m1992[[1]] - m1992[[2]]                                     # the equal "=" is used and and not the assign since it is an operation
plot(dvi1992)
                                                                      # we have only one layer because it is a difference between the two

cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)
plot(dvi1992, col=cl)

#### DVI #### 

# Exercise: calculate the dvi of 2006:

dvi2006 = m2006[[1]] - m2006[[2]]
plot(dvi2006, col=cl)
                                                                      # the healthy vegetation is a small amount of the total 

#### NDVI ####
                                                                      # we can standardize the DVI: Normalization 
                                                                      ## -> performed to compare data
                                                                      # DVI = NIR - RED
                                                                      # NDVI = (NIR - RED)/(NIR+RED)

                                                                      # The ranges of the indexes are the same
                                                                      # NDVI is always ranging from -1 to +1 since -1 =(0-255)/(0+255) and +1 =(255-0)/(255+0)
                                                                      # DVI's range depends on the amount of data
                                                                      # calculation is done pixel by pixel

ndvi1992 = (m1992[[1]] - m1992[[2]]) / (m1992[[1]] + m1992[[2]])
ndvi1992 = dvi1992 / (m1992[[1]] + m1992[[2]])
plot(ndvi1992, col=cl)
                                                                      # Since the new range is from -1 to 1, it can be compared to any kind of image
                                                                      ## the dark red parts indicate the healthy vegetation

ndvi2006 = (m2006[[1]] - m2006[[2]]) / (m2006[[1]] + m2006[[2]])
ndvi2006 = dvi2006 / (m2006[[1]] + m2006[[2]])
plot(ndvi2006, col=cl)

                                                                      # to plot them we use this function par()
par(mfrow=c(1,2))
plot(ndvi1992, col=cl)
plot(ndvi2006, col=cl)

                                                                     
clvir <- colorRampPalette(c("violet", "dark blue", "blue", "green", "yellow"))(100) 
                                                                      # we change the color palette, specifying a color scheme
                                                            
par(mfrow=c(1,2))
plot(ndvi1992, col=clvir)
plot(ndvi2006, col=clvir)

dev.off()

#### speeding up calculation #####
                                                                      # there is a funtion from the imageRy package that can compute directly the NDVI
ndvi2006a <- im.ndvi(m2006, 1, 2)
plot(ndvi2006a, col=cl)
