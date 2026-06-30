# 检查 Hourly 强迫数据值域异常
# 输入：data-raw/Forcing_Hourly_Met_sp31_v20260614.csv（Forcing_Hourly_Met_ALL.Rmd 产出）
# 流程：hourly → daily（气象取均值、Prcp 取累加）→ 逐站绘图 → 值域统计 → 标记异常站点
# 参考：data-raw/Figure1_Day_FluxALL_核验.typ、Project_TidyHourly/Forcing_Daily_Met_ALL.Rmd

# %%
pacman::p_load(
  Ipaper, data.table, dplyr, lubridate, stringr,
  ggplot2, gg.layers
)
vars_met <- c("Ta_canopy", "RH_canopy", "WS_canopy", "Rs", "Rln_in", "Prcp")
vars_met <- c("Ta", "RH", "WS", "Rs", "Rln_in", "Prcp")

# %% 1. 读取 hourly，对原数据做小时尺度值域检查后聚合为 daily
f = "data/BEPS/Forcing_Hourly_Met_sp31_v20260629.csv"
df <- fread(f)
df <- check_bounds(df, scale = "hourly") # 瞬时越界值置 NA（见 R/check_bounds.R）
df[, date := as.Date(substr(time, 1, 10))]

d_day <- df[, c(
  lapply(.SD, \(x) mean(x, na.rm = TRUE)),
  Prcp = sum(Prcp, na.rm = TRUE)
), by = .(site, date), .SDcols = setdiff(vars_met, "Prcp")]

fout = gsub("Hourly", "Daily", f)
fwrite(d_day, fout, bom = TRUE)

# %%
info <- select(df, -time, -date) %>%
  .[, lapply(.SD, \(x) sum(!is.na(x)) / length(x)), site] # perc_valid

info[(Ta + WS + Rs + Prcp) / 4 <= 0.8, ]
## 4个站点存在变量缺失，余27
#   site                      Ta RH WS    Rs Rln_in  Prcp
#   <chr>                         <dbl>     <dbl>     <dbl> <dbl>  <dbl> <dbl>
# 1 CRO_制种玉米_临泽                1     1.000     1     0          0     1
# 2 GRA_高寒草甸_海北                1     1         0     0.543      0     1
# 3 GRA_高寒草甸_若尔盖              0     0.965     0.790 0          0     1
# 4 GRA_人工垂穗披碱草_三江源         1     1         0     0          0     1

# %% 2. 逐站点绘图
outdir <- "data/BEPS/_MetCheck_Daily"
sites <- sort(unique(d_day$site))

for (s in sites) {
  fprintf("[绘图中] %s ...\n", s)

  d2 <- d_day[site == s, .(date, Ta, RH, WS, Rs, Rln_in, Prcp)]
  fout <- glue("{outdir}/{s}_Daily_Met.pdf")
  plot_variables(d2, fout, show = FALSE)
}

# %% 2b. 逐站点直接绘 hourly（不聚合，保留瞬时值域）
# df[, time := as.POSIXct(time, format = "%Y-%m-%dT%H:%M:%S", tz = "UTC")]
outdir_h <- "data/BEPS/_MetCheck_Hourly"

for (s in sites) {
  fprintf("[绘图中] %s ...\n", s)

  d2 <- df[site == s, .(time, Ta, RH, WS, Rs, Rln_in, Prcp)]
  fout <- glue("{outdir_h}/{s}_Hourly_Met.png")
  plot_variables(d2, fout, show = FALSE)
}
