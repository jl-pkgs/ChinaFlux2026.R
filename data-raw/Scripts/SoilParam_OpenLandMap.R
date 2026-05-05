pacman::p_load(
  Ipaper, data.table, dplyr, lubridate, 
  rgee, rgeeLite, sf
)
ee_Initialize()

ee_proj <- function(img) {
  proj <- ee$Image$projection(img)$getInfo()
  proj$transform <- unlist(proj$transform)
  return(proj)
}

ee_scale <- function(img) {
  proj <- ee_proj(img)
  proj$transform[1] * 120 * 1000 # 1/120 degree = 1km
}

df2sf <- function(d, coords = c("lon", "lat"), crs = 4326, ...) {
  sf::st_as_sf(d, coords = coords, crs = crs, ...)
}

st <- data.table::fread("Z:/Researches/ET_ModelDev/data/st_flux341.csv")
sp <- df2sf(st[, .(site, lon, lat)])

img = ee$Image("OpenLandMap/SOL/SOL_CLAY-WFRACTION_USDA-3A1A1A_M/v02")
col <- ee$ImageCollection(img)

scale = ee_scale(img)
scale = 250

images <- list(
  CI = "users/kongdd/BEPS/CI_240X_1Y_V1",
  texture = "OpenLandMap/SOL/SOL_TEXTURE-CLASS_USDA-TT_M/v02",      # USGA
  rho = "OpenLandMap/SOL/SOL_BULKDENS-FINEEARTH_USDA-4A1H_M/v02",   # ! 10 kg / m3
  V_vfc = "OpenLandMap/SOL/SOL_WATERCONTENT-33KPA_USDA-4B1C_M/v01", # ! %, 
  M_SOM = "OpenLandMap/SOL/SOL_ORGANIC-CARBON_USDA-6A1C_M/v02",     # ! (5g/ kg)
  M_clay = "OpenLandMap/SOL/SOL_CLAY-WFRACTION_USDA-3A1A1A_M/v02",  # % (kg / kg)
  M_sand = "OpenLandMap/SOL/SOL_SAND-WFRACTION_USDA-3A1A1A_M/v02"   # % (kg / kg)
  # soil_pH = "OpenLandMap/SOL/SOL_PH-H2O_USDA-4C1A2A_M/v02",
)

lst = foreach(str_img = images, i = icount()) %do% {
  runningId(i)
  img = ee$Image(str_img)
  r <- ee_extract(img, sp, via = "getInfo", lazy = FALSE, scale = scale)
}

CI = lst[[1]]
lst2 = lst[-1] %>% map(\(d) relocate(d, site, c("b0", "b10", "b30", "b60")))

saveRDS(lst2, "ParamSoil_st341_OpenLandMap.rds")
write_list2xlsx(lst2, "ParamSoil_st341_OpenLandMap.xlsx")

# lst[-1] %>% purrr::transpose() %>% map(as.data.table)
# img = ee$Image(images$V_sand)
# img$get("system:description") %>% getInfo()
