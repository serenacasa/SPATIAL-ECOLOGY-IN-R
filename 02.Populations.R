### Population ecology

# the package spatstat is needed for point pattern analysis

install.packages("spatstat")
library(statstat)

# let's use the bei data:
# data description
# http://CRAN.R-project.org/

bei

# plotting data using the "plot" function
plot(bei)

# (, cex = ) to change the dimension of the dots
plot(bei, cex = .2)

# (, pch = ) to change the symbol 
plot(bei, cex = .2, pch = 19)

# additional datasets
bei.extra
plot(bei.extra)

# to use only part of the dataset, we use $elev for the data regarding elevation:
plot(bei.extra$elev)
elevation <- bei.extra$elev

plot(elevation)

# second method to select elements
elevation2 <- bei.extra[[1]]
plot(elevation2)

# passing from points to a continuous surface
densitymap <- density(bei)
plot(densitymap)             

# this permits us to have the colored map


# the "points" function to insert the points in the bei dataset on top of the colored density map
points(bei, cex = .2)                                                                                                                                       

# avoid using maps with blue, green, and red together due to colorblindness

# change the color of the map by using the "colorRampPalette" function
colorRampPalette(c("black", "red", "orange", "yellow"))(100)


c1 <- colorRampPalette(c("black", "red", "orange", "yellow"))(100)
plot(densitymap, col = c1)
# the yellow color impacts our eyes the most, so it is to be used for the high part of the data


cl<- colorRampPalette(c("black", "red", "orange", "yellow"))(4)
plot(densitymap, col = cl)
                                                                       
# to see which colors can be used in R, we have to search on the internet

c2 <- colorRampPalette(c("black","darkcyan","cyan3","cyan1"))(50)
plot(densitymap, col = c2)
        
# never use the turbo color palette or the rainbow palette 

# more variables
plot(bei.extra)                                                        

# select the first element of bei.extra using double squared brackets [[1]]
elev<- bei.extra[[1]]
plot(elev)

# the dollar symbol $ is used to extract elements
elev <- bei.extra$elev 

plot(elev)


### Multiframes ###
# In constructing MULTIFRAMES (mf), we will have to specify the number of rows and columns we want    

# first create the multiframe with this command par(mfrow=)
par(mfrow = 1, 2)                                   

# then plot what we want inside the multiframe that we created
plot(densitymap)   

# elev also plotted to be inside our multiframe
plot(elev)    


# if we want the first plot on the top, and the second plot on the bottom 
# change the number of rows and columns

par(mfrow=c(2,1))
plot(densitymap)
plot(elev)

# since "elev" stands for elevation/altitude, plotting it in the same multiframe will permit us to see 
# the relationship between a high/low presence of trees and the different altitudes since we are using bei.


# Exercise regarding creation of multiframe:
par(mfrow=c(1,3))
plot(bei)
plot(densitymap)
plot(elev)
