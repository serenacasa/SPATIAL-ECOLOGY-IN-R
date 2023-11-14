#since this bands are all correlated with each other, we can build SPECTRAL INDICES.

#taking into consideration the reflectance of red and NIF bands from a tree. We are going to compare the NIF 
#and the red value (that is supposed to be lower)


library(imageRy)
library(terra)

im.list()
im.import("matogrosso_l5_1992219_lrg.jpg") #this gives directly the plot of the Mato 
#Grosso tree distribution in 1992. the bands here are three. the fisrt one is teh NIF, 
#the second is the red and the third the green.
#bands: 1=NIR, 2=RED, 3=GREEN

#then we must assign a name to this plot
m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")

im.plotRGB(m1992, r=1, g=2, b=3)
im.plotRGB(m1992, 1, 2, 3)

#to mount the NIR on top of the green, instead of on top of red:
im.plotRGB(m1992, r=2, g=1, b=3)
#to enhance the bare soil:
im.plotRGB(m1992, r=2, g=3, b=1)
#water usually in this kind of images should be black since it is absorbing all the bands

#import the recent image
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
im.plotRGB(m2006, r=2, g=3, b=1)
#the yellow color is catching our eyes more than other colors, so to attract 
#attention we should use the  yellow color.


