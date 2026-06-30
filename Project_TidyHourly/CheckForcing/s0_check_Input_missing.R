# %%
pacman::p_load(Ipaper, data.table, dplyr, stringr, matrixStats)
options(datatable.print.nrow = 31)

devtools::load_all()
miss_pct <- function(x) round(100 * mean(!is.finite(as.numeric(x))), 1)

outdir <- "Project_TidyHourly/CheckForcing"

# %% 
dir_root = "/mnt/z/GitHub/jl-pkgs/ChinaFlux2026"
# Met <- fread("data/BEPS/Forcing_Hourly_Met_sp31_v20260614.csv") # hourly
Met <- fread("data/BEPS/Forcing_Hourly_Met_sp31_v20260629.csv") # hourly
Met[, date := as.Date(substr(time, 1, 10))]

# Met[Rs > 1370, .N, site] # 风速不应为负
# Met[site == "SAV_荒漠草原_达茂" & WS_canopy > 100, ] 
FluxLAI <- fread("data/BEPS/Forcing_Daily_Flux_sp40_v20260615.csv") # daily

# %% 缺失率 + Prcp 全 0/全 NA 检查（miss_pct 把"全 0"误判为 0%）
met_agg <- Met[, c(
  .(n_hour = .N, nyear = round(.N / 8760, 1)),
  lapply(.SD, miss_pct),
  Prcp_flag = fifelse(sum(Prcp > 0, na.rm = TRUE) > 0, "ok", "no_precip")
), by = site, .SDcols = c("Ta", "RH", "WS", "Rs", "Rln_in", "Prcp")]

flux_agg <- FluxLAI[, c(.(n_day = .N), lapply(.SD, miss_pct)),
  by = site, .SDcols = c("GPP", "ET", "LAI_glass_G005")
]

tab <- merge(met_agg, flux_agg, by = "site", all.x = TRUE) %>%
  rename(LAI = LAI_glass_G005) %>%
  arrange(site)
fwrite(tab, file.path(outdir, "Table_missing_input_China_FluxALL.csv"), bom = TRUE)

cat("各变量平均缺失率 [%]:\n")
print(round(sapply(tab[, .(Ta, RH, WS, Rs, Rln_in, Prcp, GPP, ET, LAI)], mean, na.rm = TRUE), 1))

warn("无降水站点:")
np = which(tab$Prcp_flag == "no_precip")
tab[np, ] # 无降水

# %% 
perc_miss = select(tab, Ta:Prcp, -Rln_in) %>% as.matrix() %>% rowMaxs()
inds_bad = which(perc_miss > 10)
tab[inds_bad, ]
#   site                   year Prcp_h Prcp_d    ET ratio
#   <chr>                 <int>  <dbl>  <dbl> <dbl> <dbl>
# 1 CRO_制种玉米_临泽      2012      0      0  290.   NaN
# 2 CRO_制种玉米_临泽      2013      0      0  447.   NaN
# 3 CRO_制种玉米_临泽      2014      0      0  491.   NaN
# 4 CRO_制种玉米_临泽      2015      0      0  462.   NaN
# 5 ENF_北方林森林_呼中    2017      0      0  268.   NaN
# 6 ENF_北方林森林_呼中    2018      0      0  273.   NaN
# 7 GRA_典型草原_锡林浩特  2006      0      0  516.   NaN
# 8 GRA_典型草原_锡林浩特  2007      0      0  385.   NaN


# ---- 年总量单位自检: Met$Prcp=mm/hr, FluxLAI$Prcp/ET=mm/day ----
# 合理: Prcp∈[50,4000] ET∈[50,2000] mm/yr, Prcp_h/Prcp_d∈[0.7,1.3]
Met[, year := year(time)]
FluxLAI[, year := year(date)]
chk <- merge(
  Met[, .(Prcp_h = nansum(Prcp)), by = .(site, year)],
  FluxLAI[, .(Prcp_d = nansum(Prcp), ET = nansum(ET)), by = .(site, year)]
) %>% mutate(ratio = Prcp_h / Prcp_d) # 小时累加 / 日累加, 应∈[0.7,1.3]

warn("无降水站点年:")
chk[Prcp_h <= 1 | Prcp_d <= 1]
chk[Prcp_h <= 1 | Prcp_d <= 1, ]

ann <- chk[, .(
  Prcp_h = nanmean(Prcp_h), 
  Prcp_d = nanmean(Prcp_d),
  ratio = nanmean(ratio),
  ET = nanmean(ET), nyear = .N
), by = site] %>% .[order(-Prcp_d)] %>% dt_round(1)
ann[, c("ratio_OK") := list(between(ratio, 0.7, 1.3))]

# ann[, c("Prcp_h_OK", "Prcp_d_OK", "ratio_OK", "ET_OK") := list(
#   between(Prcp_h, 50, 4000), between(Prcp_d, 50, 4000),
#   between(ratio, 0.7, 1.3),  between(ET, 50, 2000)
# )]
fwrite(ann, file.path(outdir, "Table_annual_unit_check.csv"))

bad <- !with(ann, ratio_OK)
n_bad = sum(bad, na.rm = TRUE)
cat(if (any(bad)) sprintf("⚠ %d 站偏离合理范围\n", n_bad) else "✓ 单位检查通过\n")
print(ann)
