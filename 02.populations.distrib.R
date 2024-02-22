#why population disperse over the landscape in a certain manner?
#Jakub Nowosad GitHub account. 

library(sdm) #predictors
library(terra) #species
                                                                #once packages are installed in R we don't need quotes "" anymore
                                                                ##install.packages(""), library()

                                                                #"system.file" function is going to catch a file and name it in the R system
file <-system.file("external/species.shp", package="sdm")
                                                                #shp is an extension of a file from a famous company. 
                                                                ##package= from which we want to take the file

                                                                #we are going to use this file. this is called VECTOR FILE.vect(file)
                                                                ##there is a function in TERRA to pass from this vector file to functions

rana <- vect(file)                                              #gives us informations on the vector. WGS=world geodetic system
rana
                                                               

rana$Occurrence
                                                                #these are called PRESENCE-ABSENCE data (1,0). 
                                                                ##This demonstrates only if that animal is there
                                                                ##1 means a presence, 
                                                                ##the 0 is an absence and is an uncertain data, since the "rana" could be there

                                                                 #to see the data we have to plot(rana)
plot(rana)
plot(rana, cex=.5)

                                                                  #now we should select only absences or only presences
#selecting only presences from our data set:
rana                                                              #rana = our set

rana[rana$Occurrence==1,]                                         #single quadratic parenthesis are used
                                                                  ##since we are now dealing with points


pres <- rana[rana$Occurrence==1,]                                  #selecting presences
pres
pres$Occurrence

plot(pres)                                                        #this plot shows a lower amount of points since it shows only the presences

#exercise: select absence and call them 'abse':
abse <- rana[rana$Occurrence==0,]
abse
plot(abse)
                                                                  #another way to do it is:
abse <- rana[rana$Occurrence!=1,]
abse

                                                                  #we can plot one plot beside the other by the function par and inside mfrow
par(mfrow=c(1,2))                                                 #1 row, 2 columns
plot(abse,cex=.5)
plot(pres, cex=.5)

                                                                  
                                                                  #to plot in different colors; Exercise: 
                                                                  ## plot pres and abse altogether with two different colors

dev.off()                                                         #to close the multiframe we have to use the dev.off() 
                                                                  ##that causes graphical nulling

c1 <- colorRampPalette(c("cyan3"))
plot(pres, col=c1)
plot(abse, col="darkcyan")
points(abse, col="darkcyan")                                       #we first plot our pres with a color then we use the function
                                                                   ##points to add the points of abse plot on top of the pres one

plot(pres, col=c1)
                                                                  #PREDICTORS are environmental variables that describe 
                                                                  ##why the rana temp is not present 
                                                                  ##which occurs where there are no dots.

#### ELEVATION PREDICTOR ####
                                                                  #rasters are images and to import then we have to use system.file
                                                                  #.asc is a type of image file
elev <- system.file("external/elevation.asc", package="sdm")
elev

elev<- rast(elev)                                                 #from Terra package
plot(elev)
points(pres, cex=.5)


#### TEMPERATURE PREDICTOR ####
temp <- system.file("external/temperature.asc", package="sdm")
temp

tempmap <- rast(temp)                                              #also this is from Terra package
plot(tempmap)
points(pres, cex=.5)                                               #this permits us to see how the rana is mainly in high to 
                                                                   #warm temperatures but avoids cold temperatures


#### VEGETATION PREDICTOR ####
vege <- system.file("external/vegetation.asc", package="sdm")
vege

vegemap <- rast(vege)
plot(vegemap)
points(pres,cex=.5)

#PRECIPITATION PREDICTOR:
prec <- system.file("external/precipitation.asc", package="sdm")
prec

precmap <- rast(prec)
plot(precmap)
points(pres, cex=.5)                                              #shows that rana prefers high precipitation areas


#### FINAL MULTIFRAME WITH ALL THE PLOTS ####
par(mfrow=c(2,2))

plot(elev)
points(pres, cex=.5)
plot(tempmap)
points(pres, cex=.5)
plot(vegemap)
points(pres,cex=.5)
plot(precmap)
points(pres, cex=.5)


