#remote sensing for ecosystem monitoring
library(devtools) #packages in R are also called libraries

#another method to install the package from the function in which it is inserted
devtools::install_github("ducciorocchini/imageRy")
library(imageRy) #pay attention to capital letters

im.list()

#importing data. the Blue band:
b2 <- im.import("sentinel.dolomites.b2.tif") #in order to use the band number of the sentinel
