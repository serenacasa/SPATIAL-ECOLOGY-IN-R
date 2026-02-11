# ===== CAMP FIRE REFORESTATION ANALYSIS - PARADISE, CALIFORNIA =====
# Remote Sensing Project using Sentinel-2 data to analyze the reforestation after the Camp Fire of November 8, 2018.

#### ----- LIBRARIES -----
library(terra)      # Spatial data analysis package
library(viridis)    # Color-blind friendly color palettes
library(fields)     # Spatial statistics and custom legend creation
library (imageRy)   # For satellite image processing


#### ----- SETUP -----
setwd("C:/Users/seren/Desktop/Spatial Ecology in R - PROJECT")
dir.create("processed_data", showWarnings = FALSE)
dir.create("Images", showWarnings = FALSE)
dir.create("temporary_files", showWarnings = FALSE)
terraOptions(tempdir = "temporary_files", memfrac = 0.8)


#### ----- FIRE PERIMETER POLYGON -----
# The fire perimeter (MTBS site) is imported and reprojected (to EPSG:32610, Sentinel-2 UTM)
fire_perimeter <- vect("Fire_data_bundles_ybTBYeqaFAKCq0BdnggL/mtbs/2018/ca3982012144020181108/ca3982012144020181108_20180719_20190722_burn_bndy.shp")
fire_perimeter.utm <- project(fire_perimeter, "EPSG:32610")
fire_perimeter.utm <- aggregate(fire_perimeter.utm)
fire_bbox <- ext(fire_perimeter.utm)


#### ----- FUNCTIONS -----
# Bands extraction function: to load B02, B03, B04, and B08 (10m) from each Sentinel-2 folder
s2_bands <- function(folder_name) {
  all_files <- list.files(folder_name, pattern = "\\.jp2$", recursive = TRUE, full.names = TRUE)
  band_files <- all_files[grep("B0[2348]_10m\\.jp2$", all_files)]
  rast(sort(band_files)) 
}

# Merge and Crop function: to crop before (saves memory) and then mosaic north and south tiles. 
merge_and_crop <- function(tile_north, tile_south, bbox) {
  mosaic(crop(tile_north, bbox), crop(tile_south, bbox), fun = "mean")
}

# NDVI: (NIR - Red) / (NIR + Red), layers: 3 = B04 (Red band), 4 = B08 (NIR band)
calc_ndvi <- function(img) { 
  (img[[4]] - img[[3]]) / (img[[4]] + img[[3]]) 
}

# Statistical analysis helper
gmean <- function(x) round(global(x, mean, na.rm = TRUE)[[1]], 3)
gmax <- function(x) round(global(x, max, na.rm = TRUE)[[1]], 3)


#### ----- LOADING SENTINEL-2 BANDS (B2, B3, B4, B8) -----
# The 10m resolution bands are loaded (Jul/Nov/Dec 2018, Jul 2019/2020/2022/2024/2025)
july.2018.10m <- merge_and_crop(
  s2_bands("S2B_MSIL2A_20180709T185019_N0500_R113_T10TFK_20230714T205329"),
  s2_bands("S2B_MSIL2A_20180709T185019_N0500_R113_T10SFJ_20230714T205329"), fire_bbox)

nov.2018.10m <- merge_and_crop(
  s2_bands("S2B_MSIL2A_20181106T185559_N0500_R113_T10TFK_20230709T125120"),
  s2_bands("S2B_MSIL2A_20181106T185559_N0500_R113_T10SFJ_20230709T125120"), fire_bbox)

dec.2018.10m <- merge_and_crop(
  s2_bands("S2B_MSIL2A_20181206T185749_N0500_R113_T10TFK_20230814T111111"),
  s2_bands("S2B_MSIL2A_20181206T185749_N0500_R113_T10SFJ_20230814T111111"), fire_bbox)

july.2019.10m <- merge_and_crop(
  s2_bands("S2B_MSIL2A_20190704T184929_N0500_R113_T10TFK_20230604T105720"),
  s2_bands("S2B_MSIL2A_20190704T184929_N0500_R113_T10SFJ_20230604T105720"), fire_bbox)

july.2020.10m <- merge_and_crop(
  s2_bands("S2A_MSIL2A_20200703T184921_N0500_R113_T10TFK_20230321T213111"),
  s2_bands("S2A_MSIL2A_20200703T184921_N0500_R113_T10SFJ_20230321T213111"), fire_bbox)

july.2022.10m <- merge_and_crop(
  s2_bands("S2B_MSIL2A_20220708T184919_N0510_R113_T10TFK_20240710T124449"),
  s2_bands("S2B_MSIL2A_20220708T184919_N0510_R113_T10SFJ_20240710T124449"), fire_bbox)

july.2024.10m <- merge_and_crop(
  s2_bands("S2A_MSIL2A_20240702T184921_N0510_R113_T10TFK_20240703T012344"),
  s2_bands("S2A_MSIL2A_20240702T184921_N0510_R113_T10SFJ_20240703T012344"), fire_bbox)

july.2025.10m <- merge_and_crop(
  s2_bands("S2B_MSIL2A_20250702T184919_N0511_R113_T10TFK_20250702T221755"),
  s2_bands("S2B_MSIL2A_20250702T184919_N0511_R113_T10SFJ_20250702T221755"), fire_bbox)


##### True Color Visualization -----
# RGB visualization (B04-B03-B02) of July 2018(pre-fire), Dec 2018(post-), and July 2025(current) 
true_color_plot <- function() {
  par(mfrow = c(1, 3), mar = c(1, 1, 3, 1))
  plotRGB(july.2018.10m, r = 3, g = 2, b = 1, 
          stretch = "lin", main = "Pre-fire RGB\n(July 2018)", cex.main = 2)
  plot(fire_perimeter.utm, add = TRUE, border = "red", lwd = 1.5)
  
  plotRGB(dec.2018.10m, r = 3, g = 2, b = 1, 
          stretch = "lin", main = "Post-fire RGB\n(Dec 2018)", cex.main = 2)
  plot(fire_perimeter.utm, add = TRUE, border = "red", lwd = 1.5)
  
  plotRGB(july.2025.10m, r = 3, g = 2, b = 1, 
          stretch = "lin", main = "Current RGB\n(July 2025)", cex.main = 2)
  plot(fire_perimeter.utm, add = TRUE, border = "red", lwd = 1.5)
}

png("Images/True_Color_Composite.png", width = 3200, height = 1300, res = 200)
true_color_plot()
dev.off()


##### Camp Fire Area Masking -----
# The Sentinel-2 images masking using fire perimeter polygon to focus the analysis on it
july.18.10m_fire <- mask(july.2018.10m, fire_perimeter.utm)
nov.18.10m_fire <- mask(nov.2018.10m, fire_perimeter.utm)
dec.18.10m_fire <- mask(dec.2018.10m, fire_perimeter.utm)
july.19.10m_fire <- mask(july.2019.10m, fire_perimeter.utm)
july.20.10m_fire <- mask(july.2020.10m, fire_perimeter.utm)
july.22.10m_fire <- mask(july.2022.10m, fire_perimeter.utm)
july.24.10m_fire <- mask(july.2024.10m, fire_perimeter.utm)
july.25.10m_fire <- mask(july.2025.10m, fire_perimeter.utm)


#### ----- NDVI CALCULATION ----- 
ndvi.july.2018 <- calc_ndvi(july.18.10m_fire)
ndvi.nov.2018 <- calc_ndvi(nov.18.10m_fire)
ndvi.dec.2018 <- calc_ndvi(dec.18.10m_fire)
ndvi.july.2019 <- calc_ndvi(july.19.10m_fire)
ndvi.july.2020 <- calc_ndvi(july.20.10m_fire)
ndvi.july.2022 <- calc_ndvi(july.22.10m_fire)
ndvi.july.2024 <- calc_ndvi(july.24.10m_fire)
ndvi.july.2025 <- calc_ndvi(july.25.10m_fire)

# Mean NDVI values calculated for all dates across entire burn perimeter
ndvi_list <- list(
  ndvi.july.2018, ndvi.nov.2018, ndvi.dec.2018, ndvi.july.2019, 
  ndvi.july.2020, ndvi.july.2022, ndvi.july.2024, ndvi.july.2025)
mean_ndvi <- sapply(ndvi_list, function(r) {global(r, "mean", na.rm = TRUE)[[1]]})


#### ----- 
dates <- c("Jul 2018", "Nov 2018", "Dec 2018", "Jul 2019", "Jul 2020", "Jul 2022", "Jul 2024", "Jul 2025")
mean_ndvi_values <- round(mean_ndvi, 3)

baseline <- mean_ndvi[1]
delta_baseline <- round((mean_ndvi - baseline) / baseline * 100, 1)
delta_baseline_f <- ifelse(delta_baseline == 0, "—", paste0(ifelse(
  delta_baseline > 0, "+", ""), delta_baseline, "%"))

time_intervals <- c(NA, NA, NA, 0.67, 1.00, 2.00, 2.00, 1.00)
ndvi_changes <- c(NA, NA, NA, diff(mean_ndvi[3:8]))
recovery_rates <- ndvi_changes / time_intervals

recovery_rates_f <- ifelse(is.na(recovery_rates), "—", paste0(ifelse(
  recovery_rates > 0, "+", ""), sprintf("%.3f", recovery_rates), "/yr"))

timeline_ds <- data.frame(
  Date = dates, Mean_NDVI = mean_ndvi_values,
  Delta_from_Baseline = delta_baseline_f, Recovery_Rate = recovery_rates_f,
  Notes = c("Pre-fire baseline", "Natural autumn decline", "Maximum fire impact", "First growing season",
            "Early recovery", "Mid-term recovery", "Late recovery", "Current condition")
)
timeline_ds


#### ----- BURN SEVERITY -----
# Fire damage severity is assessed by calculating dNDVI (pre - post) across the entire burn perimeter.
# Positive dNDVI = vegetation loss; Negative = vegetation increase
dNDVI.18 <- ndvi.nov.2018 - ndvi.dec.2018
mean_dNDVI <- round(global(dNDVI.18, mean, na.rm = TRUE)[[1]], 3)
mean_dNDVI


##### Camp Fire Impact Visualization -----
# Nov 2018 and Dec 2018 NDVIs are plotted with the dNDVI. The palette is range-limited for detail enhancement
ndvi_col <- viridis(255, begin = 0.05, end = 0.95)
fire.col <- colorRampPalette(c("royalblue4", "steelblue3", "lightblue", "lightyellow", "lightgoldenrod1", "coral", "red4"))(255)

fire_impact.plot <- function() {
  par(mfrow = c(1, 3), mar = c(0, 0, 1, 0))
  plot(ndvi.nov.2018, col = ndvi_col, range = c(-1, 1),
       main = "Pre-fire NDVI\nNov 6, 2018", cex.main = 2,
       legend = TRUE, axes = FALSE,
       plg = list(cex = 1.5))
  plot(fire_perimeter.utm, add = TRUE, border = "black", lwd = 1)
  
  plot(ndvi.dec.2018, col = ndvi_col, range = c(-1, 1),
       main = "Post-fire NDVI\nDec 6, 2018", cex.main = 2,
       legend = TRUE, axes = FALSE,
       plg = list(cex = 1.5))
  plot(fire_perimeter.utm, add = TRUE, border = "black", lwd = 1)
  
  plot(dNDVI.18, col = fire.col, range = c(-0.5, 0.5),
       main = "dNDVI\n(fire impact)", cex.main = 2,
       legend = TRUE, axes = FALSE,
       plg = list(at = c(-0.5, -0.25, 0, 0.25, 0.5),
                  labels = c("-0.5", "-0.25", "0", "0.25", "0.5"),
                  cex = 1.5))
  plot(fire_perimeter.utm, add = TRUE, border = "black", lwd = 1) 
}

png("Images/Camp_fire_impact.png", width = 3200, height = 1200, res = 200)
fire_impact.plot()
dev.off()


#### ----- TEMPORAL RECOVERY TRAJECTORY -----
# Line plot of the mean NDVI's trajectory across the investigated time period
dates <- c("Jul 2018","Nov 2018","Dec 2018","Jul 2019", "Jul 2020","Jul 2022","Jul 2024","Jul 2025")

temp_line_t <- function() {
  par(mar = c(6, 4, 3, 1))
  plot(1:8, mean_ndvi, type = "b", pch = 16, lwd = 2,
       col = viridis(10)[8], xaxt = "n", yaxt = "n",
       xlab = "Dates", 
       ylab = "Mean NDVI", ylim = c(0.15, 0.5),
       main = "NDVI Recovery Timeline - Camp Fire (2018-2025)", 
       cex.main = 1.3)
  axis(1, at = 1:8, labels = dates, las = 2, cex.axis = 0.8)
  axis(2, las = 1, cex.axis = 0.8)
  abline(v = 2.3, lty = 2, lwd = 1.8, col = "black")
  text(2.5, max(mean_ndvi), "Camp Fire\nNov 8, 2018", 
       adj = 0, font = 2, cex = 1)
  text(1:8, mean_ndvi, labels = round(mean_ndvi, 3), 
       pos = 3, cex = 1)
}

png("Images/Recovery_trajectory_line.png", width = 2400, height = 1700, res = 300)
temp_line_t()
dev.off()


#### ----- TEMPORAL RECOVERY MAPS -----
# July NDVI maps as time series to visualize spatial recovery patterns
ndvi_maps <- list(ndvi.july.2018, ndvi.july.2019, ndvi.july.2020, 
                  ndvi.july.2022, ndvi.july.2024, ndvi.july.2025)

titles <- c("Jul 2018 (- 4 mo)", "Jul 2019 (+ 8 mo)", "Jul 2020 (+ 1.5 yr)", 
            "Jul 2022 (+ 3.5 yr)", "Jul 2024 (+ 5.5 yr)", "Jul 2025 (+ 6.5 yr)")

temp.rec.maps <- function(){
  par(mfrow = c(2, 3), mar = c(1, 1, 3, 0), oma = c(0, 0, 0, 8))
  
  for (i in seq_along(ndvi_maps)) {
    plot(ndvi_maps[[i]], main = titles[i], cex.main = 1.8, col = viridis(255), 
         axes = FALSE, range = c(-1, 1), legend = FALSE)
    plot(fire_perimeter.utm, add = TRUE, border = "black", lwd = 1)
  }
  
  par(fig = c(0.98, 1.00, 0.3, 0.7), new = TRUE, mar = c(0, 0, 0, 0))
  image.plot(legend.only = TRUE, zlim = c(-1, 1), 
             col = viridis(255), legend.width = 15,
             axis.args = list(at = seq(-1, 1, 0.5), 
                              labels = seq(-1, 1, 0.5), cex.axis = 1.4),
             legend.args = list(text = 'NDVI', side = 3, line = 0.9, cex = 1.4)) 
}

png("Images/NDVIs_Temporal_Series.png", width = 2700, height = 1800, res = 200)
temp.rec.maps()
dev.off()


#### ----- SEVERITY AND RECOVERY ANALYSIS -----
# Burn severity and post-fire vegetation recovery are categorized and their relationship analysed.
# Total recovery = NDVI July 2025 (current situation) - NDVI July 2019 (first post-fire) 
total_recovery <- ndvi.july.2025 - ndvi.july.2019

# Categories thresholds are based on quantile distribution
dNDVI_q <- global(dNDVI.18, quantile, probs = c(0.25, 0.5, 0.75, 0.9, 0.95), 
                  na.rm = TRUE)
recovery_q <- global(total_recovery, quantile, probs = c(0.25, 0.5, 0.75, 0.9, 0.95), 
                     na.rm = TRUE)

# Severity classes: Unburned(<0), Low(0 - 0.15), Moderate(0.15 - 0.35), High(>0.35)
severity_classes <- classify(dNDVI.18,
                             rcl = matrix(c(
                               -Inf, 0,    1,
                               0,    0.15, 2,
                               0.15, 0.35, 3,
                               0.35, Inf,  4), 
                               ncol = 3, byrow = TRUE))

# Recovery classes: No/Negative(<0), Low(0 - 0.1), Moderate(0.1 - 0.25), High(>0.25)
recovery_classes <- classify(total_recovery,
                             rcl = matrix(c(
                               -Inf, 0,    1,
                               0,    0.1,  2,
                               0.1,  0.25, 3,
                               0.25, Inf,  4), 
                               ncol = 3, byrow = TRUE))

severity_labels <- c("Unburned", "Low", "Moderate", "High")
recovery_labels <- c("No/Negative", "Low", "Moderate", "High")

# Pivot table
severity_vals <- values(severity_classes, na.rm = TRUE)
recovery_vals <- values(recovery_classes, na.rm = TRUE)

pivot_table <- table(
  Severity = factor(severity_vals, levels = 1:4, labels = severity_labels),
  Recovery = factor(recovery_vals, levels = 1:4, labels = recovery_labels)
)
pivot_table_pct <- round(prop.table(pivot_table, margin = 1) * 100, 1)

# Correlation test using the Spearman method
sev_cont <- values(dNDVI.18, na.rm = TRUE)
rec_cont <- values(total_recovery, na.rm = TRUE)
cor_test <- cor.test(sev_cont, rec_cont, method = "spearman", exact = FALSE)

cor_test$estimate
cor_test$p.value

# Table export
write.csv(pivot_table_pct, "processed_data/Severity_Recovery_table.csv")

sev <- values(dNDVI.18, na.rm = TRUE)
rec <- values(total_recovery, na.rm = TRUE)

# assicurati stessa lunghezza e niente NA
ok <- is.finite(sev) & is.finite(rec)
cor_test <- cor.test(sev[ok], rec[ok], method = "spearman", exact = FALSE)

cor_test$estimate
cor_test$p.value

##### Severity x Recovery visualization -----
# A grouped barplot and a spatial map were used to visualize the Severity x Recovery relationship.
# The two use the same palette, an inverted "mako" palette, to distinguish categories easily
sev_rec_col <- viridis(4, option = "mako", direction = -1)

severity_recovery <- function() {
  layout(matrix(c(1, 2), nrow = 1), widths = c(1.1, 1))
  par(oma = c(0, 0, 3, 0))
  
  par(mar = c(5, 4, 3, 1))
  plot_data <- t(pivot_table_pct)
  rownames(plot_data) <- recovery_labels
  
  bp <- barplot(plot_data, beside = TRUE, col = sev_rec_col, border = "gray30", 
                ylab = "Area (%)", xlab = "Burn Severity", 
                ylim = c(0, 80), las = 1, 
                cex.names = 1, cex.axis = 1, cex.lab = 1.2)
  
  legend("topright", legend = recovery_labels, 
         fill = sev_rec_col, border = "gray30", 
         bty = "n", cex = 1.1, 
         title = "Recovery Level")
  title(main = "Recovery by Severity Classes", cex.main = 1.4)
  
  par(mar = c(2, 0, 3, 5))
  recovery_cat <- as.factor(recovery_classes)
  levels(recovery_cat) <- data.frame(value = 1:4, category = recovery_labels)
  
  plot(recovery_cat, main = "Spatial Recovery Pattern",
       col = sev_rec_col, axes = FALSE, 
       cex.main = 1.4, legend = FALSE)
  plot(fire_perimeter.utm, add = TRUE, border = "black", lwd = 1)
  mtext("Burn Severity × Recovery", side = 3, outer = TRUE, 
        line = 0.8, cex = 1.7, font = 2)
}

png("Images/Severity_x_Recovery.png", width = 3400, height = 1900, res = 250)
severity_recovery()
dev.off()


#### ----- SPATIAL VARIABILITY ANALYSIS -----
# Focal SD of total NDVI recovery to study the recovery variability at 3×3, 5×5, and 7×7 pixel scales
sd3_recovery <- focal(total_recovery, matrix(1/9, 3, 3), fun = sd, na.rm = TRUE)
sd5_recovery <- focal(total_recovery, matrix(1/25, 5, 5), fun = sd, na.rm = TRUE)
sd7_recovery <- focal(total_recovery, matrix(1/49, 7, 7), fun = sd, na.rm = TRUE)

##### Spatial variability visualization -----
# For Total NDVI recovery, the viridis palette was used. For the Focal SD panels, the palette 
# used is the cividis inverted, using a common SD range for comparability and more details
sd_col <- viridis(255, option = "cividis", direction = -1)

sd_variability <- function() {
  par(mfrow = c(2, 2), mar = c(1, 1, 3, 6), oma = c(0, 0, 3, 0))
  
  plot(total_recovery, main = "Total Recovery (Jul 2019 - Jul 2025)",
       col = viridis(255), range = c(-0.2, 0.5), 
       axes = FALSE, cex.main = 1.5)
  plot(fire_perimeter.utm, add = TRUE, border = "black", lwd = 1.5)
  
  sd_q99 <- max(
    global(sd3_recovery, quantile, probs = 0.99, na.rm = TRUE)[[1]],
    global(sd5_recovery, quantile, probs = 0.99, na.rm = TRUE)[[1]],
    global(sd7_recovery, quantile, probs = 0.99, na.rm = TRUE)[[1]])
  sd_range <- c(0, sd_q99)
  
  plot(sd3_recovery, main = "Local Variability (3×3)", col = sd_col, range = sd_range, 
       axes = FALSE, cex.main = 1.5)
  plot(fire_perimeter.utm, add = TRUE, border = "black", lwd = 1.5)
  
  plot(sd5_recovery, main = "Local Variability (5×5)", col = sd_col, range = sd_range, 
       axes = FALSE, cex.main = 1.5)
  plot(fire_perimeter.utm, add = TRUE, border = "black", lwd = 1.5)
  
  plot(sd7_recovery, main = "Local Variability (7×7)", col = sd_col, range = sd_range, 
       axes = FALSE, cex.main = 1.5)
  plot(fire_perimeter.utm, add = TRUE, border = "black", lwd = 1.5)
  mtext("Spatial Variability Analysis", side = 3, outer = TRUE, line = 0.8, cex = 2, 
        font = 2)
}

png("Images/SD_Recovery_Variability.png", width = 3000, height = 2400, res = 250)
sd_variability()
dev.off()

# Variability summary
sd_summary <- data.frame(Window = c("3x3 (30m)", "5x5 (50m)", "7x7 (70m)"),
                         Mean_SD = c(gmean(sd3_recovery), gmean(sd5_recovery), gmean(sd7_recovery)),
                         Max_SD = c(gmax(sd3_recovery), gmax(sd5_recovery), gmax(sd7_recovery))
)
write.csv(sd_summary, "processed_data/Spatial_variability_Stats.csv", row.names = FALSE)


