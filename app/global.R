# packages ----
if (!require("librarian")){
  install.packages("librarian")
  library(librarian)
}
librarian::shelf(
  bslib, dplyr, fs, glue, here, leaflet, purrr, readr, sf, shiny, stringr,
  tidyr,
  calcofi/calcofi4r,   # the calcofi.io brand contract (cc_brand_head, cc_theme)
  quiet = T)
options(readr.show_col_types = F)

# the view is the URL: analyte class + analyte + map view live in the query
# string, so a link reproduces what its sender saw (ui.R is a function(request)
# for the same reason; server.R keeps the URL current and excludes the theme)
enableBookmarking(store = "url")

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
v_analyteclasses <- d_analytes %>% distinct(analyteclass) %>% pull(analyteclass)

# default view: the DDT family, and within it the parent compound. Of the seven
# DDT-family analytes in the Bight data (2,4'/4,4' -DDD, -DDE, -DDT, 4,4'-DDMU),
# 4,4'-DDT (p,p'-DDT) is the most acutely toxic to marine organisms — it is the
# compound EPA's aquatic-life criteria for the DDT group are keyed on; 4,4'-DDE
# is the more persistent metabolite (bird eggshell thinning) and DDD the least
# toxic. Both are guarded so a data refresh that renames one fails loudly here.
DEFAULT_ANALYTE_CLASS <- "Chlorinated Hydrocarbons"
DEFAULT_ANALYTE       <- "4,4'-DDT"
stopifnot(
  DEFAULT_ANALYTE_CLASS %in% v_analyteclasses,
  DEFAULT_ANALYTE %in% (d_analytes %>%
    filter(analyteclass == DEFAULT_ANALYTE_CLASS) %>% pull(analytename)))

analytes_for <- function(analyte_class)
  d_analytes %>% filter(analyteclass == analyte_class) %>% pull(analytename)
