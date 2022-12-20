# packages ----
if (!require("librarian")){
  install.packages("librarian")
  library(librarian)
}
librarian::shelf(
  bslib, dplyr, DT, fs, glue, here, leaflet, purrr, readr, sf, shiny, stringr,
  tidyr,
  quiet = T)
options(readr.show_col_types = F)

# paths ----
p_sta_geo  <- here("data/stations.geojson")
d_smpl_csv <- here("data/samples.csv")
d_res_csv  <- here("data/results.csv")

# read geo & csv ----
p_sta  <- read_sf(p_sta_geo)
d_smpl <- read_csv(d_smpl_csv)
d_res  <- read_csv(d_res_csv)

# summarize analyte options
d_analytes <- d_res %>%
  distinct(analyteclass, analytename, units) %>%
  arrange(analyteclass, analytename, units)
v_analyteclasses = distinct(d_analytes, analyteclass)
