library(vegan) 

data(dune)
head(dune)

ord <- decorana(dune)

ldc1 =  3.7004 
ldc2 =  3.1166 
ldc3 = 1.30055
ldc4 = 1.47888

total = ldc1 + ldc2 + ldc3 + ldc4

pldc1 = ldc1 * 100 / total
pldc2 = ldc2 * 100 / total
pldc3 = ldc3 * 100 / total
pldc4 = ldc4 * 100 / total

pldc1
pldc2

pldc1 + pldc2
plot(ord) 

#### Relation among species in time ####
library(overlap)

data(kerinci)
summary(kerinci)

kerinci$timeRad <- kerinci$Time * 2 * pi

tiger <- kerinci[kerinci$Sps=="tiger",]

timetig <- tiger$timeRad
densityPlot(timetig, rug=TRUE)

# Exercise: to select only the data on macaque individuals:
macaque <- kerinci[kerinci$Sps=="macaque",]
head(macaque)

timemac <- macaque$timeRad
densityPlot(timemac, rug=TRUE)
overlapPlot(timetig, timemac)

