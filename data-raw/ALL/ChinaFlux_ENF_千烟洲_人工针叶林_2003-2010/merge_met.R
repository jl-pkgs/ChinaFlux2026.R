library(Ipaper)

# dir("./ChinaFlux/data-raw/ChinaFlux_ENF_千烟洲_人工针叶林_2003-2010/", "*.csv")
f1 = "./ChinaFlux/data-raw/ChinaFlux_ENF_千烟洲_人工针叶林_2003-2010/千烟洲_Met_日_2003_2010.csv"
f2 = "./ChinaFlux/data-raw/ChinaFlux_ENF_千烟洲_人工针叶林_2003-2010/千烟洲_Met_日_2011-2015.csv"

d1 = read_ufile(f1)$data
d2 = read_ufile(f2)$data

d = rbindlist(list(d1, d2), fill = TRUE)
fout = "./ChinaFlux/data-raw/ChinaFlux_ENF_千烟洲_人工针叶林_2003-2010/千烟洲_Met_Day_2003-2015.csv"
fwrite(d, fout)


d_flux = read_ufile("./千烟洲_Flux_Day_2003_2015.csv")
d_met = read_ufile("./千烟洲_Met_Day_2003-2015.csv")

merge.unit_df <- function(l_flux, l_met) {
  ncol = ncol(l_met$data)
  data = cbind(l_flux$data, l_met$data[, 4:ncol])
  unit = cbind(l_flux$unit, l_met$unit[, 4:ncol])
  listk(data, unit) %>% set_class("unit_df")
}

l = merge(d_flux, d_met)
write_ufile(l, "ENF_FluxMet_千烟洲-人工针叶林_2003-2015.csv")
