# ── 标量转换 ──────────────────────────────────────────────────────────────────
hPa2kPa    <- \(x) x / 10
pct2m3m3   <- \(x) x / 100
K2degC     <- \(x) x - 273.15
umol2gC    <- \(x) x * 12 * 86400 / 1e6
mgCO2_2gC  <- \(x) x * 86400 / 1000 * 12 / 44
mgCO2_2umol <- \(x) x * 1000 / 44
gCO2_2gC   <- \(x) x / 44 * 12

# ── 通用内部工具 ───────────────────────────────────────────────────────────────
.find_vars <- function(l, unit_test) {
  names(which(unit_test(unlist(l$unit))))
}

.fix <- function(l, vars, data_fn, unit_str) {
  if (length(vars) == 0) return(l)
  l$data %<>% mutate(across(all_of(vars), data_fn))
  l$unit %<>% mutate(across(all_of(vars), \(.) unit_str))
  l
}

.fix_nota <- function(l, vars, unit_str) {   # 仅改写法，不改数值
  if (length(vars) == 0) return(l)
  l$unit %<>% mutate(across(all_of(vars), \(.) unit_str))
  l
}

# ── fix 函数：每个处理一个单位问题 ────────────────────────────────────────────
fix_GPP <- function(l) {
  if ("GEE" %in% names(l$data)) {
    l$data %<>% rename(GPP = GEE) %>% mutate(GPP = -GPP)
    l$unit %<>% rename(GPP = GEE)
  }
  if ("GEP" %in% names(l$data)) {
    l$data %<>% rename(GPP = GEP)
    l$unit %<>% rename(GPP = GEP)
  }
  if ("GPP" %in% names(l$data) && mean(l$data$GPP, na.rm = TRUE) < 0)
    l$data %<>% mutate(GPP = -GPP)
  l
}

fix_SM_pct <- function(l) {
  # [data]: [%] → [m3 m-3]
  vars <- .find_vars(l, \(u) u == "%" & startsWith(names(u), "SM"))
  .fix(l, vars, pct2m3m3, "m3 m-3")

  # [unit]: m3 m-3
  vars <- .find_vars(l, \(u) u == "m^3 m^-3")
  .fix_nota(l, vars, "m3 m-3")
}

fix_Pa <- function(l) {        # hPa/hpa → kPa
  # Pa
  vars <- .find_vars(l, \(u) u %in% c("hpa", "hPa") & names(u) == "Pa")
  .fix(l, vars, hPa2kPa, "kPa")

  # VPD
  vars <- .find_vars(l, \(u) u == "hPa" & startsWith(names(u), "VPD"))
  .fix(l, vars, hPa2kPa, "kPa")

  # [unit]: kPa
  vars <- .find_vars(l, \(u) u == "kpa")
  .fix_nota(l, vars, "kPa")
}


fix_temp_K <- function(l) {
  vars <- .find_vars(l, \(u) u == "K")
  .fix(l, vars, K2degC, "°C")
}


fix_radiation <- function(l) {
  vars <- .find_vars(l, \(u) u == "kJ m-2 d-1")
  l <- .fix(l, vars, \(x) x / 1000, "MJ m-2 d-1")
  vars <- .find_vars(l, \(u) u %in% c("MJ m-2 d-1", "MW m-2 d-1"))
  .fix(l, vars, MJ_2W, "W m-2")
}

# ── 碳通量模块（日 / 小时分离）────────────────────────────────────────────────
fix_carbon_daily <- function(l) {
  vars <- .find_vars(l, \(u) u == "gCO2 m-2 d-1")
  l <- .fix(l, vars, gCO2_2gC, "gC m-2 d-1")
  vars <- .find_vars(l, \(u) u %in% c("umol m-2 s-1", "umolm-2s-1", "umol·m-2·s-1", "umol/s/m2"))
  l <- .fix(l, vars, umol2gC, "gC m-2 d-1")
  vars <- .find_vars(l, \(u) u %in% c("mg CO2 m-2 s-1", "mg.CO2.m-2.s-1"))
  .fix(l, vars, mgCO2_2gC, "gC m-2 d-1")
}

fix_carbon_hourly <- function(l) {
  vars <- .find_vars(l, \(u) u %in% c("mg CO2 m-2 s-1", "mg.CO2.m-2.s-1"))
  l <- .fix(l, vars, mgCO2_2umol, "µmol CO2 m-2 s-1")
  vars <- .find_vars(l, \(u) u %in% c("umol m-2 s-1", "umolm-2s-1", "umol·m-2·s-1", "umol/s/m2"))
  .fix_nota(l, vars, "µmol CO2 m-2 s-1")
}

# ── 组合函数 ──────────────────────────────────────────────────────────────────
unify_unit_daily <- function(l) {
  l$data %<>% mutate(across(where(is.character), as.numeric))
  l |> fix_GPP() |> fix_radiation() |> fix_carbon_daily() |>
       fix_temp_K() |> fix_SM_pct() |> fix_Pa()
}

unify_unit_hourly <- function(l) {
  l$data %<>% mutate(across(where(is.character), as.numeric))
  l |> fix_GPP() |> fix_carbon_hourly() |>
       fix_temp_K() |> fix_SM_pct() |> fix_Pa()
}
