pacman::p_load(
  Ipaper, data.table, dplyr, lubridate, 
  stringr,
  terra, exactextractr, sf
)

select_layer <- function(lst2, i) {
  map(lst2, \(d) d[, ..i]) %>% as.data.table() %>% 
    cbind(st, .)
}

st <- data.table::fread("Z:/Researches/ET_ModelDev/data/st_flux341.csv") %>% 
  cbind(I = 1:nrow(.), .)
sp = sf2::df2sf(st)
# "frac_sand", "Ksat", "VGM_n", "VGM_α", "VGM_θres"  "θsat", "λ", "ψsat"

files = dir("Z:/GitHub/GlobalHydroPub/Dai_GlobalSoil", "*.nc", full.names = TRUE)
vars = str_extract(basename(files), "(?<=_).*(?=_)")

lst_fs = split(files, vars)

lst = foreach(fs = lst_fs, i = icount()) %do% {
  runningId(i)
  ra = rast(fs)
  extracted = terra::extract(ra, sp)
}

lst2 <- map(lst, \(d) as.data.table(d[, -1]))

# fs = lst_fs[["V_SOM"]]
# ra <- rast(fs)
# lst[[4]] = terra::extract(ra, sp)
# select_layer(lst2, 6)
res = map(1:6, \(i) select_layer(lst2, i))
save(res, file = "SoilParam_st341_Dai2019.rda")
write_list2xlsx(res, "SoilParam_st341_Dai2019.xlsx")

# %>% purrr::transpose() #%>% map(as.data.table)
# d = map(lst2, \(d) d[, 1]) %>% as.data.table()
# save(lst, file = "SoilParam_st341.rda")
# res[[1]]$V_SOM %>% summary()

# st[site == "FI-Hyy"]
# .fs = lst_fs[[1]]
# 需要记录这些变量的单位
# ra = rast(.fs)
# ra = rast("./Dai_GlobalSoil/Ksat_l1.nc")
# extracted = terra::extract(ra, sp)
