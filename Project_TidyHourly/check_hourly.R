# 检查 Hourly 强迫数据值域异常
# 输入：data-raw/Forcing_Hourly_Met_sp31_v20260614.csv（Forcing_Hourly_Met_ALL.Rmd 产出）
# 流程：hourly → daily（气象取均值、Prcp 取累加）→ 逐站绘图 → 值域统计 → 标记异常站点
# 参考：data-raw/Figure1_Day_FluxALL_核验.typ、Project_TidyHourly/Forcing_Daily_Met_ALL.Rmd

# %%
pacman::p_load(
  Ipaper, data.table, dplyr, lubridate, stringr,
  ggplot2, gg.layers
)

vars <- c("Ta_canopy", "RH_canopy", "WS_canopy", "Rs", "Rln_in", "Prcp")

plot_variables <- function(d, fout, ..., show = FALSE) {
  vars_common <- intersect(names(d), c("site", "name", "time", "date"))
  dat <- melt(d, vars_common)

  xvar <- if ("date" %in% names(d)) "date" else "time" # 日尺度用 date，小时用 time
  p <- ggplot(dat, aes(.data[[xvar]], value)) +
    geom_line() +
    facet_wrap(~variable, scales = "free", ncol = 2) +
    labs(x = NULL, y = NULL) +
    theme_bw()
  write_fig(p, fout, 10, 7, show = show)
}


# %% 1. 读取 hourly，对原数据做小时尺度值域检查后聚合为 daily
df <- fread("data-raw/Forcing_Hourly_Met_sp31_v20260614.csv")
df <- check_bounds(df, scale = "hourly") # 瞬时越界值置 NA（见 R/check_bounds.R）
df[, date := as.Date(substr(time, 1, 10))]

# 气象变量取日均，Prcp 取日累加
vars_mean <- setdiff(vars, "Prcp")
d_day <- df[
  , c(lapply(.SD, \(x) mean(x, na.rm = TRUE)), Prcp = sum(Prcp, na.rm = TRUE)),
  by = .(site, date), .SDcols = vars_mean
]

fwrite(d_day, "data-raw/Forcing_Daily_Met_sp31_v20260614.csv", bom = TRUE)

# %% 
info = df %>% select(-time, -date) %>% 
  .[, lapply(.SD, \(x) sum(!is.na(x))/length(x)), site]
info[(Ta_canopy + WS_canopy + Rs)/3 <= 0.8, ]
## 5个站点存在变量缺失
#   site                      Ta_canopy RH_canopy WS_canopy    Rs Rln_in  Prcp
#   <chr>                         <dbl>     <dbl>     <dbl> <dbl>  <dbl> <dbl>
# 1 CRO_水稻_句容                    1     1         1     0          0     1
# 2 CRO_制种玉米_临泽                1     1.000     1     0          0     1
# 3 GRA_高寒草甸_海北                1     1         0     0.543      0     1
# 4 GRA_高寒草甸_若尔盖               0     0.965     0.790 0          0     1
# 5 GRA_人工垂穗披碱草_三江源         1     1         0     0          0     1

# %% 2. 逐站点绘图
outdir <- "data-raw/Daily_Met_check"
sites <- sort(unique(d_day$site))

for (s in sites) {
  d2 <- d_day[site == s, .(date, Ta_canopy, RH_canopy, WS_canopy, Rs, Rln_in, Prcp)]
  fout <- glue("{outdir}/{s}_Daily_Met.pdf")
  plot_variables(d2, fout, show = FALSE)
}

# %% 2b. 逐站点直接绘 hourly（不聚合，保留瞬时值域）
# df[, time := as.POSIXct(time, format = "%Y-%m-%dT%H:%M:%S", tz = "UTC")]
outdir_h <- "data-raw/Hourly_Met_check"

for (s in sites) {
  d2 <- df[site == s, .(time, Ta_canopy, RH_canopy, WS_canopy, Rs, Rln_in, Prcp)]
  fout <- glue("{outdir_h}/{s}_Hourly_Met.png")
  plot_variables(d2, fout, show = FALSE)
}

# %% 3. 值域统计 + 物理合理边界，标记异常
bounds <- list(
  Ta_canopy = c(-50, 50),    # 气温 ℃
  RH_canopy = c(0, 100),     # 相对湿度 %
  WS_canopy = c(0, 40),      # 风速 m/s
  Rs        = c(-20, 1400),  # 短波辐射 W/m2
  Rln_in    = c(50, 500),    # 长波辐射 W/m2
  Prcp      = c(0, 250)      # 日降水 mm
)

# 用 hourly 原始数据统计值域（更敏感）
stat <- df[, {
  res <- list()
  for (v in vars) {
    x <- get(v)
    res[[paste0(v, "_min")]] <- round(suppressWarnings(min(x, na.rm = TRUE)), 2)
    res[[paste0(v, "_max")]] <- round(suppressWarnings(max(x, na.rm = TRUE)), 2)
    res[[paste0(v, "_pNA")]] <- round(mean(is.na(x)) * 100, 1)
  }
  res
}, by = site]

# 标记每站每变量是否越界
flag <- df[, {
  msg <- c()
  for (v in vars) {
    x <- get(v)
    pna <- mean(is.na(x)) * 100
    if (pna == 100) { msg <- c(msg, sprintf("%s:全NA", v)); next }
    lo <- bounds[[v]][1]; hi <- bounds[[v]][2]
    mn <- suppressWarnings(min(x, na.rm = TRUE))
    mx <- suppressWarnings(max(x, na.rm = TRUE))
    bad <- c()
    if (mn < lo) bad <- c(bad, sprintf("min=%.1f", mn))
    if (mx > hi) bad <- c(bad, sprintf("max=%.1f", mx))
    if (pna > 90) bad <- c(bad, sprintf("NA=%.0f%%", pna))
    if (length(bad)) msg <- c(msg, sprintf("%s[%s]", v, paste(bad, collapse = ",")))
  }
  .(issues = paste(msg, collapse = "; "))
}, by = site]

flag_bad <- flag[issues != ""][order(site)]
fwrite(flag_bad, "data-raw/Daily_Met_check/_anomaly_report.csv", bom = TRUE)
print(flag_bad)
