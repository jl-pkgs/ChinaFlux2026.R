umol2gC <- function(x) {
  x * 12 * 86400 / 10^6 # 1.0368
}

K2deg <- \(x) x - 273.15

gCO2_2gC <- function(x) {
  x / 44 * 12
}

find_WrongUnit_SM <- function(l) {
  which(unlist(l$unit) == "%" & substr(names(l$unit), 1, 2) == "SM")
}

find_WrongUnit_VPD <- function(l) {
  which(unlist(l$unit) == "hPa" & substr(names(l$unit), 1, 3) == "VPD")
}

unify_unit <- function(l) {
  l$data %>% mutate(across(where(is.character), as.numeric))

  # rename GEE to GPP
  if ("GEE" %in% names(l$data)) {
    l$data %<>% rename(GPP = GEE) %>% mutate(GPP = -GPP)
    l$unit %<>% rename(GPP = GEE)
  }

  if ("GEP" %in% names(l$data)) {
    l$data %<>% rename(GPP = GEP)
    l$unit %<>% rename(GPP = GEP)
  }

  if ("GPP" %in% names(l$data)) {
    if (mean(l$data$GPP, na.rm = TRUE) < 0) {
      l$data %<>% mutate(GPP = -GPP)
    }
  }

  # unit = l$unit
  vars <- sapply(l$unit, \(x) x == "kJ m-2 d-1") |>
    which() |>
    names()
  l$data %<>% mutate(across(all_of(vars), \(x) x / 1000))
  l$unit %<>% mutate(across(all_of(vars), \(x) "MJ m-2 d-1"))

  vars <- sapply(l$unit, \(x) x %in% c("MJ m-2 d-1", "MW m-2 d-1")) |>
    which() |>
    names()
  l$data %<>% mutate(across(all_of(vars), MJ_2W))
  l$unit %<>% mutate(across(all_of(vars), \(x) "W m-2"))

  vars <- sapply(l$unit, \(x) x == "gCO2 m-2 d-1") |>
    which() |>
    names()
  l$data %<>% mutate(across(all_of(vars), gCO2_2gC))
  l$unit %<>% mutate(across(all_of(vars), \(x) "gC m-2 d-1"))

  vars <- sapply(l$unit, \(x) x == "umol m-2 s-1") |>
    which() |>
    names()
  l$data %<>% mutate(across(all_of(vars), umol2gC))
  l$unit %<>% mutate(across(all_of(vars), \(x) "gC m-2 d-1"))

  vars <- sapply(l$unit, \(x) x == "mg CO2 m-2 s-1") |>
    which() |>
    names()
  l$data %<>% mutate(across(all_of(vars), \(x) x * 86400 / 1000 * 12 / 44))
  l$unit %<>% mutate(across(all_of(vars), \(x) "gC m-2 d-1"))

  # 修复温度错误
  vars_T <- sapply(l$unit, \(x) x == "K") |>
    which() |>
    names()
  if (length(vars_T) > 0) {
    l$data %<>% mutate(across(all_of(vars_T), K2deg))
    l$unit %<>% mutate(across(all_of(vars_T), \(x) "°C"))
  }

  vars_SM <- find_WrongUnit_SM(l)
  if (length(vars_SM) > 0) {
    l$data %<>% mutate(across(all_of(vars_SM), \(x) x / 100))
    l$unit %<>% mutate(across(all_of(vars_SM), \(x) "m3 m-3"))
  }

  vars_VPD <- find_WrongUnit_VPD(l)
  if (length(vars_VPD) > 0) {
    l$data %<>% mutate(across(all_of(vars_VPD), \(x) x / 10)) # 1 hPa = 0.1 kPa
    l$unit %<>% mutate(across(all_of(vars_VPD), \(x) "kPa"))
  }
  l
}
