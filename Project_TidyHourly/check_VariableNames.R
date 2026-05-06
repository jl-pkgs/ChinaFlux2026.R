# %%
pacman::p_load(
  Ipaper, data.table, dplyr, lubridate,
  jsonlite,
  ggplot2, gg.layers, patchwork
)

str_site <- function(f) {
  str_extract(basename(f), ".*(?=_30min)")
}

tidy_unit <- function(d) {
  data.table(
    name = names(d), name_new = NA_character_,
    unit = unlist(d), unit_new = NA_character_, comment = ""
  )
}


# %% 
fs <- dir2("data-raw/Hourly/", "*.csv")
sites <- str_site(fs)
names(fs) <- sites
# fs

lst <- map(fs, \(f) read_ufile(f, nrows = 10))
lst_unit <- map(lst, "unit")

sites_bad = c("DBF_温带落叶阔叶林_帽儿山", "EBF_亚热带常绿阔叶林_哀牢山")
inds_bad = match(sites_bad, sites)
inds <- grep("EBF|ENF|MF|DBF", sites) %>% setdiff(inds_bad)

write_json(lst_unit[inds], "data/Unit/ChinaFlux_Variable_Info_Forest_Hourly.json", pretty = TRUE)
# write_json(info, "./ChinaFlux_Variable_Info_Hourly.json", pretty = TRUE)
# write_json(info[inds], "./ChinaFlux_Variable_Info_Forest_Hourly.json", pretty = TRUE)

# %% 
res = map(lst_unit[inds], tidy_unit)
r = melt_list(res, "site")
fwrite(r, "data/Unit/ChinaFlux_Variable_Info_Forest_Hourly.csv", bom = TRUE)
# write_list2xlsx(list(unit = r), "data/Unit/ChinaFlux_Variable_Info_Forest_Hourly.xlsx")
# write_json(res, "./ChinaFlux_Variable_Info_Forest_Hourly.json", pretty = TRUE)


# %% 
vars_need = c("Ta_canopy", "RH_canopy", "WS_canopy", "Rs", "Rln_in", "Prcp", "WS_canopy")

res = lst_unit[inds] %>% map(function(d) {
  select(d, any_of(vars_need))
})

nvar = sapply(res, ncol)
table(nvar)
res[nvar == 5]

# %% 余下12个站点。
