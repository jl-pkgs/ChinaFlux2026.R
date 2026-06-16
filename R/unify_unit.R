# ── 标量转换 ──────────────────────────────────────────────────────────────────
# styler: off
hPa2kPa      <- \(x) x / 10
pct2m3m3     <- \(x) x / 100
K2degC       <- \(x) x - 273.15
umol_s_2gC_d <- \(x) x * 12 * 86400 / 1e6
gC_d_2umol_s <- \(x) x / 12 * 1e6 / 86400
mgCO2_2gC    <- \(x) x * 86400 / 1000 * 12 / 44
mgCO2_2umol  <- \(x) x * 1000 / 44
gCO2_2gC     <- \(x) x / 44 * 12
gCO2_s_2umol_s <- \(x) x * 1e6 / 44
MJ_2W        <- \(x) x * 1e6 / 86400
# styler: on

# ── 通用内部工具 ───────────────────────────────────────────────────────────────
.find_vars <- function(l, unit_test) {
  unit <- unlist(l$unit)
  names(unit)[which(unit_test(unit))]
}

.fix <- function(l, unit_test, data_fn, unit_str) {
  vars <- .find_vars(l, unit_test)
  if (length(vars) == 0) {
    return(l)
  }
  l$data %<>% mutate(across(all_of(vars), data_fn))
  l$unit %<>% mutate(across(all_of(vars), \(.) unit_str))
  l
}

.fix_nota_replacement <- function(l, replacement) {
  for (unit_str in names(replacement)) {
    rule <- replacement[[unit_str]]
    vars <- if (is.function(rule)) {
      .find_vars(l, rule)
    } else {
      .find_vars(l, \(u) u %in% rule)
    }
    if (length(vars) > 0) {
      l$unit %<>% mutate(across(all_of(vars), \(.) unit_str))
    }
  }
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
  if ("GPP" %in% names(l$data) && mean(l$data$GPP, na.rm = TRUE) < 0) {
    l$data %<>% mutate(GPP = -GPP)
  }
  l
}

fix_soilT_names <- function(l) {
  # 土壤温度统一为 TS_**cm：把小写前缀 Ts_ 改成大写 TS_
  # （Ts_5cm→TS_5cm；Ts_TCAV/Ts_0_1 等非标准深度也随之大写，由下游 select 统一剔除）。
  # 无深度信息的 Ts/Ts1/Ts2/TS 因无法确定 **cm，不在此处理（见站点说明）。
  names(l$data) <- sub("^Ts_", "TS_", names(l$data))
  names(l$unit) <- sub("^Ts_", "TS_", names(l$unit))
  l
}

fix_flux_names <- function(l) {
  # 统一通量变量名：显热 H→Hs；生态系统呼吸 Reco/ER→RE。
  # 仅当目标名尚不存在时改名，避免覆盖已有列。
  .rn <- function(l, from, to) {
    if (from %in% names(l$data) && !(to %in% names(l$data))) {
      names(l$data)[match(from, names(l$data))] <- to
      names(l$unit)[match(from, names(l$unit))] <- to
    }
    l
  }
  l <- .rn(l, "H", "Hs")
  l <- .rn(l, "Reco", "RE")
  l <- .rn(l, "ER", "RE")
  # 地热通量板 Gs_1/2/3（盘锦水稻，源自原始 G1/G2/G3，经判断为同一深度的重复板）
  # 统一为 G_1/2/3，便于 avg_layer("G") 自动捕获合成。
  names(l$data) <- sub("^Gs_", "G_", names(l$data))
  names(l$unit) <- sub("^Gs_", "G_", names(l$unit))
  l
}

fix_SM_pct <- function(l) {
  # [%] → [m3 m-3]，但仅当数值确为百分数时才 ÷100。
  # 95% 分位 > 1.5 视为百分数（m3 m-3 物理上 < 1）→ ÷100；否则仅改标签。
  unit <- unlist(l$unit)
  cand <- names(unit)[unit == "%" & startsWith(names(unit), "SM")]
  for (v in cand) {
    x <- l$data[[v]]
    if (!is.numeric(x)) next
    if (quantile(x, 0.95, na.rm = TRUE) > 1.5) {
      l$data[[v]] <- pct2m3m3(x)
    }
    l$unit[[v]] <- "m3 m-3"
  }
  l
}

# hPa → kPa
fix_Pa <- function(l) {
  # Pa, VPD, ea
  l <- .fix(l, \(u) u == "hPa" & names(u) == "Pa", hPa2kPa, "kPa")
  l <- .fix(l, \(u) u == "hPa" & startsWith(names(u), "VPD"), hPa2kPa, "kPa")
  l <- .fix(l, \(u) u == "hPa" & startsWith(names(u), "ea"), hPa2kPa, "kPa")
}


fix_temp_K <- function(l) {
  .fix(l, \(u) u == "K", K2degC, "°C")
}

fix_unit_notation <- function(l) {
  replacement <- list(
    "kPa" = "kpa",
    "hPa" = "hpa",
    "m3 m-3" = c("m^3 m^-3", "m3/m3"),
    "W m-2" = c("W/m^2", "W/m2", "W·m-2", "Wm-2", "W.m-2"),
    "m s-1" = c("m·s-1", "m/s", "\tm s-1"),
    "g m-2 s-1" = c("g·m-2·s-1", "g/m-2s-1", "gm-2s-1", "g H2O m-2 s-1"),
    "gC m-2 d-1" = "g C m-2 d-1",
    "μmol m-2 s-1" = \(u) {
      u %in% c("μmol/m2/s", "umol/m2/s", "umol/s/m2", "umol/(m^2 s)", "umol·m-2·s-1", "umol m-2 s-1", "umol m-2", "µmol m-2 s-1") &
        (startsWith(names(u), "PAR") | startsWith(names(u), "PPFD"))
    },
    "Deg" = \(u) {
      u %in% c("degree", "degrees", "°", "-") & startsWith(names(u), "WD")
    },
    "µmol CO2 m-2 s-1" = \(u) {
      u %in% c(
        "umol m-2 s-1",
        "umolm-2s-1",
        "umol·m-2·s-1",
        "umolCO2 m-2 s-1",
        "umol/s/m2",
        "µmol m-2 s-1",
        "μmol m-2 s-1",
        "μmol/m2/s"
      ) & !startsWith(names(u), "PAR") & !startsWith(names(u), "PPFD")
    },
    "°C" = \(u) {
      u %in% c("℃", "C", "Deg C", "°") &
        (startsWith(names(u), "Ta") |
          startsWith(names(u), "TA") |
          startsWith(names(u), "T_canopy") |
          startsWith(names(u), "TS_") |
          startsWith(names(u), "Ts_") |
          names(u) %in% c("TS", "T", "Ts") |
          startsWith(names(u), "IRCT"))
    }
  )
  .fix_nota_replacement(l, replacement)
}


fix_radiation <- function(l) {
  l <- .fix(l, \(u) u == "kJ m-2 d-1", \(x) x / 1000, "MJ m-2 d-1")
  .fix(l, \(u) u %in% c("MJ m-2 d-1", "MW m-2 d-1"), MJ_2W, "W m-2")
}

fix_radiation_daily <- function(l) {
  l <- fix_radiation(l)
  # Daily LE/H(s) metadata sometimes omits d-1, or writes MW where MJ is meant.
  # `H` 前缀同时覆盖 H / Hs / Hs_raw（盘锦、长岭的显热标成 MW m-2）。
  .fix(
    l, \(u) u %in% c("MJ m-2", "MW m-2") &
      (startsWith(names(u), "LE") | startsWith(names(u), "H")),
    MJ_2W, "W m-2"
  )
}

fix_PAR_daily <- function(l) {
  # 日尺度 PAR 偶尔以「日积分」存储，统一换算为日均速率 μmol m-2 s-1：
  #   句容  mol m-2 (d-1)  → ×1e6/86400
  #   若尔盖 umol m-2 d-1  → /86400
  # 崇明东滩 PAR 误标为碳通量单位 gC m-2 d-1，但数值本身已是 μmol m-2 s-1，仅改标签。
  is_par <- \(u) startsWith(names(u), "PAR") | startsWith(names(u), "PPFD")
  l <- .fix(l, \(u) u == "mol m-2" & is_par(u), \(x) x * 1e6 / 86400, "μmol m-2 s-1")
  l <- .fix(l, \(u) u == "umol m-2 d-1" & is_par(u), \(x) x / 86400, "μmol m-2 s-1")
  .fix(l, \(u) u == "gC m-2 d-1" & is_par(u), identity, "μmol m-2 s-1")
}

fix_ET_daily <- function(l) {
  # 日尺度 ET 统一为 mm d-1（kg H2O m-2 d-1 与 mm 数值等价，仅改标签）。
  .fix(
    l, \(u) u %in% c("kg H2O m-2 d-1", "kg H2O m-2 day-1", "mm") &
      startsWith(names(u), "ET"),
    identity, "mm d-1"
  )
}

# ── 碳通量模块（日 / 小时分离）────────────────────────────────────────────────
fix_carbon_daily <- function(l) {
  umol_units <- c(
    "umol m-2 s-1",
    "umolm-2s-1",
    "umol·m-2·s-1",
    "umol/s/m2",
    "umol/m2 s",
    "µmol CO2 m-2 s-1",
    "μmol CO2 m-2 s-1"
  )
  l %>%
    .fix(\(u) u %in% c("gCO2 m-2 d-1", "g CO2 m-2 d-1"), gCO2_2gC, "gC m-2 d-1") %>%
    .fix(\(u) u %in% umol_units & !startsWith(names(u), "PAR"), umol_s_2gC_d, "gC m-2 d-1") %>%
    .fix(\(u) u %in% c("mg CO2 m-2 s-1", "mg.CO2.m-2.s-1", "mgCO2 m-2 s-1"), mgCO2_2gC, "gC m-2 d-1")
}

fix_carbon_hourly <- function(l) {
  # This handles metadata such as Jinfoshan Forest_Hourly where 30-min fluxes
  # are labelled as daily carbon units; verify against raw data ranges if new
  # sites expose the same unit.
  l %>%
    .fix(\(u) u %in% c("g C m-2 d-1", "gC m-2 d-1"), gC_d_2umol_s, "µmol CO2 m-2 s-1") %>%
    .fix(\(u) u %in% c("mg CO2 m-2 s-1", "mg.CO2.m-2.s-1", "mgCO2 m-2 s-1"), mgCO2_2umol, "µmol CO2 m-2 s-1") %>%
    .fix(\(u) u == "g CO2 m-2 s-1", gCO2_s_2umol_s, "µmol CO2 m-2 s-1")
}

# ── 组合函数 ──────────────────────────────────────────────────────────────────
unify_unit_daily <- function(l) {
  # time/date 列保持字符，交由 add_time()/add_date() 解析为 datetime；
  # 其余字符列才转数值（否则 time 会被 as.numeric 变成 NA）
  l$data %<>% mutate(across(where(is.character) & !any_of(c("time", "date")), as.numeric))
  l |>
    fix_unit_notation() |>
    fix_soilT_names() |>
    fix_flux_names() |>
    fix_GPP() |>
    fix_carbon_daily() |>
    fix_PAR_daily() |>
    fix_radiation_daily() |>
    fix_ET_daily() |>
    fix_temp_K() |>
    fix_SM_pct() |>
    fix_Pa()
}

unify_unit_hourly <- function(l) {
  # time/date 列保持字符，交由 add_time() 解析为 datetime；
  # 其余字符列才转数值（否则 time 会被 as.numeric 变成 NA）
  l$data %<>% mutate(across(where(is.character) & !any_of(c("time", "date")), as.numeric))
  l |>
    fix_unit_notation() |>
    fix_soilT_names() |>
    fix_flux_names() |>
    fix_GPP() |>
    fix_carbon_hourly() |>
    fix_radiation() |>
    fix_temp_K() |>
    fix_SM_pct() |>
    fix_Pa()
}
