## 插值方法
# 1. na.approx，如果连续缺测少于6（3hour）
# 2. 其他的采用历史平均插值

na_approx <- function(y, maxgap = 12) {
  zoo::na.approx(y, x = seq_along(y), na.rm = TRUE, maxgap = maxgap)
}

build_hisavg <- function(dat_full) {
  dat_full[, lapply(.SD, \(x) mean(x, na.rm = TRUE)), 
    .(month = month(time), day = day(time))
  ]
}

na_hisavg <- function(varname, dat, dat_his) {
  y = dat[[varname]]
  inds <- which.na(y)

  d_his = select(dat_his, month, day, all_of(varname)) 
  d_raw = select(dat[inds, ], time, all_of(varname)) %>%
    mutate(month = month(time), day = day(time))
  d = merge(d_raw, d_his, by = c("month", "day"), suffixes = c("", "_his"), sort = FALSE)
  var_new = paste0(varname, "_his")
  y[inds] = d[[var_new]]
  y
}

na_ERA5 <- function(varname, dat) {
  y = dat[[varname]]
  inds <- which.na(y)
  var_era = paste0(varname, "_ERA")
  y[inds] = dat[[var_era]][inds]
  y
}

VPD2RH <- function(Ta, VPD) {
  es <- cal_es(Ta)
  ea <- es - VPD / 10 # [hPa] to [kPa]
  RH <- ea / es * 100
  RH 
}
