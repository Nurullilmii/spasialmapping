##Spatial data and R packages for mapping

##Types of spatial data 
==================================================
library(sf)
library(ggplot2)
library(viridis)
nc <- st_read(system.file("shape/nc.shp", package = "sf"),quiet = TRUE)
ggplot(data = nc, aes(fill = SID74)) + geom_sf() + scale_fill_viridis() + theme_bw()
library(geoR)
ggplot(data.frame(cbind(parana$coords, Rainfall = parana$data)))+
  geom_point(aes(east, north, color = Rainfall), size = 2) +
  coord_fixed(ratio = 1) +
  scale_color_gradient(low = "blue", high = "orange") +
  geom_path(data = data.frame(parana$border), aes(east, north)) +
  theme_bw()
library(cholera)
rng <- mapRange()
plot(fatalities[, c("x", "y")],pch = 15, col = "black",cex = 0.5, xlim = rng$x, ylim = rng$y, asp = 1,frame.plot = FALSE, axes = FALSE, xlab = "", ylab = "")
addRoads()

##Coordinate reference systems
=======================================================
  proj4string(d) <- CRS(projection)
library(rgdal)

# create data with coordinates given by longitude and latitude
d <- data.frame(long = rnorm(100, 0, 1), lat = rnorm(100, 0, 1))
coordinates(d) <- c("long", "lat")

# assign CRS WGS84 longitude/latitude
proj4string(d) <- CRS("+proj=longlat +ellps=WGS84
                      +datum=WGS84 +no_defs")

# reproject data from longitude/latitude to UTM zone 35 south
d_new <- spTransform(d, CRS("+proj=utm +zone=35 +ellps=WGS84
                            +datum=WGS84 +units=m +no_defs +south"))

# add columns UTMx and UTMy
d_new$UTMx <- coordinates(d_new)[, 1]
d_new$UTMy <- coordinates(d_new)[, 2]

##Shapefiles
=====================================================
  # name of the shapefile of North Carolina of the sf package
  nameshp <- system.file("shape/nc.shp", package = "sf")
# read shapefile with readOGR()
library(rgdal)
map <- readOGR(nameshp, verbose = FALSE)

class(map)
head(map@data)
plot(map)

# read shapefile with st_read()
library(sf)
map <- st_read(nameshp, quiet = TRUE)

class(map)
head(map)
plot(map)

##Making maps with R
=========================================================
  library(ggplot2)
map <- st_as_sf(map)
ggplot(map) + geom_sf(aes(fill = SID74)) + theme_bw()

library(viridis)
map <- st_as_sf(map)
ggplot(map) + geom_sf(aes(fill = SID74)) +
  scale_fill_viridis() + theme_bw()
png("plot.png")
ggplot(map) + geom_sf(aes(fill = SID74)) +
  scale_fill_viridis() + theme_bw()
dev.off()

st_crs(map)
map <- st_transform(map, 4326)
library(leaflet)

pal <- colorNumeric("YlOrRd", domain = map$SID74)

leaflet(map) %>%
  addTiles() %>%
  addPolygons(
    color = "white", fillColor = ~ pal(SID74),
    fillOpacity = 1
  ) %>%
  addLegend(pal = pal, values = ~SID74, opacity = 1)
library(mapview)
mapview(map, zcol = "SID74")
library(RColorBrewer)
pal <- colorRampPalette(brewer.pal(9, "YlOrRd"))
mapview(map,
        zcol = "SID74",
        map.types = "CartoDB.DarkMatter",
        col.regions = pal)
library(RColorBrewer)
pal <- colorRampPalette(brewer.pal(9, "YlOrRd"))
mapview(map,
        zcol = "SID74",
        map.types = "CartoDB.DarkMatter",
        col.regions = pal)
m74 <- mapview(map, zcol = "SID74")
m79 <- mapview(map, zcol = "SID79")
m <- sync(m74, m79)
m
library(tmap)
tmap_mode("view")
tm_shape(map) + tm_polygons("SID74")