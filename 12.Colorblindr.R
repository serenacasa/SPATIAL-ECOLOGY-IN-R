# simulating colour blind vision

library(devtools)
devtools::install_github("clauswilke/colorblindr")
                                                              #then we can recall the package from the library function
library(colorblindr)
library(ggplot2)                                              #a library to build additional graphics

iris
                                                              #build a ggplot with the iris aestethics
fig <-ggplot(iris, aes(Sepal.Length, fill= Species)) + geom_density(alpha=0.7)
fig
                                                              #color vision deficiency
cvd_grid(fig)


