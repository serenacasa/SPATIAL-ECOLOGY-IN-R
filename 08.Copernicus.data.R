#### EXAM - the Copernicus program ####

library(ncdf4)

# https://land.copernicus.vgt.vito.be/PDF/portal/Application.html the site. 
# There are four main variables: VEGETATION, ENERGY, WATER CYCLE, AND CRYOSPHERE

### VEGETATION:
# FAPAR -> fraction of absorbed photosynthetically active radiation. 
         # Related to the red band (used by plants for photosynthesis)
# NDVI  -> Normalized difference vegetation index
# VCI   -> vegetation condition index. It compares the current NDVI to the range of 
         # values observed during the same period in previous years
# VPI   -> vegetation productivity index. It assesses the vegetation condition by referencing the
         # current value of the NDVI with the long-term statistics for the same period.
# dry matter productivity -> represents the overall growth rate
# burnt area -> maps the burnt scars over the planet.
# surface soil moisture
# soil water index -> is the relative water content of the top few centimeters of soil.


### ENERGY:
# top of canopy reflectance -> the spectral reflectance by the fraction
## at the top of vegetation, soil, houses (or whatever)
# surface albedo 
# land surface temperature -> the radiative skin surface temperature of land


### WATER CYCLE:
# water temperatures of lakes LSWT 
# lake water quality -> monitoring water quality in lakes and reservoirs is key in maintaining safe water ...
# estimate of water bodies present in the whole planet
# water level


### CRYOSPHERE:
# Snow cover -> estimate of the amount of snow in a certain area
# lake ice extent
# snow water equivalence -> passage from solid (snow) to liquid (water) phase


library(ncdf4)
library(terra)

# now we have to explain to R where the data are going to be stored -> setting the WORKING DIRECTORY

setwd("C:/Users/seren/Desktop/SPATIAL ECOLOGY IN R")

fapar2020 <- rast("c_gls_FAPAR_202005240000_GLOBE_PROBAV_V1.5.1.nc")

fapar2020
plot(fapar2020)

# There are more elements, so we will use the first one
plot(fapar2020[[1]])


# then we have to change the colorRampPalette
cl <- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(fapar2020[[1]], col = cl)


# using the function "crop()" to pick only a single region of our interest
# determine the extent of the crop we want

ext <- c(-10, 40, 25, 75)                                      
# minlong, maxlong, minlat, maxlat. 
# Since here we are using numbers, we do not have to use quotes

# European crop
faparEU2020 <- crop(fapar2020, ext)
plot(faparEU2020[[1]], col = cl)                              


# Australian crop
ext2 <- c(110, 160, -50, -05)
faparAUS2020 <- crop(fapar2020, ext2)
plot(faparAUS2020[[1]], col = cl)                              



#### new image ####

soilm2023_24 <- rast("c_gls_SSM1km_202311250000_CEURO_S1CSAR_V1.2.1.nc")
plot(soilm2023_24)
