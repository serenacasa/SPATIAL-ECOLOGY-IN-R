# Code related to population ecology

#a package is needed for point patern analysis
install.packages("spatstat")
library(statstat)

#let's use the bei data:
#data description
#http://CRAN.R-project.org/

bei

#plotting data
plot(bei)

#change the dimension (,cex=)
plot(bei, cex=.2)

#changing the symbol -pch
plot(bei, cex=.2, pch=19)

#additional dtasets
bei.extra
plot(bei.extra)

#let's use only part of the dataset: elev
plot(bei.extra$elev)
elevation <- bei.extra$elev
plot(elevation)

#second method to select elements
elevation2 <- bei.extra[[1]]
plot(elevation2)


