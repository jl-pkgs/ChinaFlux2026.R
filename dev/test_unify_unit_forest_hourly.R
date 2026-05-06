library(dplyr)
library(jsonlite)
library(magrittr)

source("R/unify_unit.R")

unit_file <- "data/Unit/ChinaFlux_Variable_Info_Forest_Hourly.json"
units <- read_json(unit_file, simplifyVector = FALSE)

make_case <- function(unit_map) {
  var_names <- names(unit_map)
  data <- as.data.frame(
    stats::setNames(rep(list(c(1, 2)), length(var_names)), var_names),
    check.names = FALSE
  )
  unit <- as.data.frame(
    as.list(unlist(unit_map, use.names = FALSE)),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  names(unit) <- var_names
  list(data = data, unit = unit)
}

expected_unit <- function(var) {
  if (var %in% c("year", "month", "day", "doy", "hour", "minute")) {
    return(c("/", "-"))
  }
  if (startsWith(var, "NEE") || var %in% c("RE", "Reco", "GPP")) {
    return("µmol CO2 m-2 s-1")
  }
  if (startsWith(var, "LE") || startsWith(var, "Hs") ||
      startsWith(var, "Rs") || startsWith(var, "Rn") ||
      startsWith(var, "Rln") || startsWith(var, "Q") ||
      startsWith(var, "G_")) {
    return("W m-2")
  }
  if (var == "ET") {
    return("g m-2 s-1")
  }
  if (startsWith(var, "Ta") || startsWith(var, "TS_") ||
      startsWith(var, "IRCT")) {
    return("°C")
  }
  if (startsWith(var, "RH")) {
    return("%")
  }
  if (startsWith(var, "ea") || startsWith(var, "Pa")) {
    return("kPa")
  }
  if (startsWith(var, "WS")) {
    return("m s-1")
  }
  if (startsWith(var, "WD")) {
    return("Deg")
  }
  if (startsWith(var, "PAR")) {
    return("μmol m-2 s-1")
  }
  if (startsWith(var, "SM")) {
    return("m3 m-3")
  }
  if (var == "Prcp") {
    return("mm")
  }
  character()
}

failures <- list()

for (site in names(units)) {
  site_units <- units[[site]][[1]]
  out <- unify_unit_hourly(make_case(site_units))
  unit_vec <- unlist(out$unit, use.names = TRUE)

  for (var in names(unit_vec)) {
    expected <- expected_unit(var)
    actual <- unname(unit_vec[[var]])
    if (length(expected) == 0 || !(actual %in% expected)) {
      failures[[length(failures) + 1]] <- data.frame(
        site = site,
        var = var,
        unit = actual,
        expected = paste(expected, collapse = " | "),
        stringsAsFactors = FALSE
      )
    }
  }
}

if (length(failures) > 0) {
  failures <- do.call(rbind, failures)
  print(failures, row.names = FALSE)
  stop("unify_unit_hourly() unit coverage failed for Forest_Hourly JSON.")
}

message("OK: unify_unit_hourly() covers all units in ", unit_file)
