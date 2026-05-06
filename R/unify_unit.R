# ── 标量转换 ──────────────────────────────────────────────────────────────────
hPa2kPa <- \(x) x / 10
pct2m3m3 <- \(x) x / 100
K2degC <- \(x) x - 273.15
umol_s_2gC_d <- \(x) x * 12 * 86400 / 1e6
gC_d_2umol_s <- \(x) x / 12 * 1e6 / 86400
mgCO2_2gC <- \(x) x * 86400 / 1000 * 12 / 44
mgCO2_2umol <- \(x) x * 1000 / 44
gCO2_2gC <- \(x) x / 44 * 12
MJ_2W <- \(x) x * 1e6 / 86400

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

fix_SM_pct <- function(l) {
  # [data]: [%] → [m3 m-3]
  .fix(l, \(u) u == "%" & startsWith(names(u), "SM"), pct2m3m3, "m3 m-3")
}

# hPa → kPa
fix_Pa <- function(l) {
  # Pa
  l <- .fix(l, \(u) u == "hPa" & names(u) == "Pa", hPa2kPa, "kPa")

  # VPD
  l <- .fix(l, \(u) u == "hPa" & startsWith(names(u), "VPD"), hPa2kPa, "kPa")
}


fix_temp_K <- function(l) {
  .fix(l, \(u) u == "K", K2degC, "°C")
}

fix_unit_notation <- function(l) {
  replacement <- list(
    "kPa" = "kpa",
    "hPa" = "hpa",
    "m3 m-3" = "m^3 m^-3",
    "W m-2" = c("W/m^2", "W·m-2", "Wm-2", "W.m-2"),
    "m s-1" = c("m·s-1", "m/s", "\tm s-1"),
    "g m-2 s-1" = c("g·m-2·s-1", "g/m-2s-1"),
    "gC m-2 d-1" = "g C m-2 d-1",
    "μmol m-2 s-1" = \(u) {
      u %in%
        c("μmol/m2/s", "umol/s/m2", "umol·m-2·s-1", "umol m-2 s-1") &
        startsWith(names(u), "PAR")
    },
    "Deg" = \(u) {
      u %in% c("degree", "degrees", "°") & startsWith(names(u), "WD")
    },
    "µmol CO2 m-2 s-1" = \(u) {
      u %in%
        c(
          "umol m-2 s-1",
          "umolm-2s-1",
          "umol·m-2·s-1",
          "umol/s/m2",
          "μmol m-2 s-1",
          "μmol/m2/s"
        ) &
        !startsWith(names(u), "PAR")
    },
    "°C" = \(u) {
      u %in%
        c("℃", "C", "Deg C", "°") &
        (startsWith(names(u), "Ta") |
          startsWith(names(u), "TS_") |
          startsWith(names(u), "IRCT"))
    }
  )
  .fix_nota_replacement(l, replacement)
}


fix_radiation <- function(l) {
  l <- .fix(l, \(u) u == "kJ m-2 d-1", \(x) x / 1000, "MJ m-2 d-1")
  .fix(l, \(u) u %in% c("MJ m-2 d-1", "MW m-2 d-1"), MJ_2W, "W m-2")
}

# ── 碳通量模块（日 / 小时分离）────────────────────────────────────────────────
fix_carbon_daily <- function(l) {
  l <- .fix(l, \(u) u == "gCO2 m-2 d-1", gCO2_2gC, "gC m-2 d-1")

  umol_units <- c(
    "umol m-2 s-1",
    "umolm-2s-1",
    "umol·m-2·s-1",
    "umol/s/m2",
    "µmol CO2 m-2 s-1",
    "μmol CO2 m-2 s-1"
  )
  l <- .fix(
    l,
    \(u) u %in% umol_units & !startsWith(names(u), "PAR"),
    umol_s_2gC_d,
    "gC m-2 d-1"
  )

  .fix(l, \(u) u %in% c("mg CO2 m-2 s-1", "mg.CO2.m-2.s-1"), mgCO2_2gC, "gC m-2 d-1")
}

fix_carbon_hourly <- function(l) {
  # This handles metadata such as Jinfoshan Forest_Hourly where 30-min fluxes
  # are labelled as daily carbon units; verify against raw data ranges if new
  # sites expose the same unit.
  l <- .fix(
    l,
    \(u) u %in% c("g C m-2 d-1", "gC m-2 d-1"),
    gC_d_2umol_s,
    "µmol CO2 m-2 s-1"
  )

  l <- .fix(l, \(u) u %in% c("mg CO2 m-2 s-1", "mg.CO2.m-2.s-1"), mgCO2_2umol, "µmol CO2 m-2 s-1")

  l
}

# ── 组合函数 ──────────────────────────────────────────────────────────────────
unify_unit_daily <- function(l) {
  l$data %<>% mutate(across(where(is.character), as.numeric))
  l |>
    fix_unit_notation() |>
    fix_GPP() |>
    fix_radiation() |>
    fix_carbon_daily() |>
    fix_temp_K() |>
    fix_SM_pct() |>
    fix_Pa()
}

unify_unit_hourly <- function(l) {
  l$data %<>% mutate(across(where(is.character), as.numeric))
  l |>
    fix_unit_notation() |>
    fix_GPP() |>
    fix_carbon_hourly() |>
    fix_temp_K() |>
    fix_SM_pct() |>
    fix_Pa()
}
