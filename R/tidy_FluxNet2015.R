## Known issues
# 2015 patch is not applied. LE, LH will lost some good values.

timename <- c("TIMESTAMP_START", "TIMESTAMP_END")

# except date, all variables were double
# Update 20191216 (FULLSET used, rename variabls)
# SW_OUT_F: SW_OUT
# LW_OUT_F: LW_OUT

# non_QC variables
# * "SW_OUT_QC", "LW_OUT_QC", "WD", "NETRAD_QC", "USTAR_QC"
vars_val <- c(
  "SW_IN_F",         # incoming Shortwave Radiation                                 | W/m2
  # ! "SW_OUT",          # outgoing Shortwave Radiation                                 | W/m2 
  "LW_IN_F",         # incoming Longwave Radiation                                  | W/m2
  # ! "LW_OUT",          # outgoing Longwave Radiation                                  | W/m2
  # ! "NETRAD",          # Rn, NET Radiation                                            | W/m2
  "LE_F_MDS",        # Latent heat flux                                             | W/m2
  "LE_CORR",         # LE_F_MDS_QC quality flag for LE_F_MDS, LE_CORR
  "H_F_MDS",         # Sensible heat flux                                           | W/m2
  "H_CORR",          # corrected H_F_MDS by energy balance closure correction factor, QC as H_F_MDC_QC
  "G_F_MDS",         # Soil heat flux                                               | W/m2, could be negative
  "PA_F",            # Atmospheric pressure                                         | kPa
  "P_F",             # Precipitation                                                | mm
  "VPD_F",           # Vapor Pressure Deficit                                       | hPa
  "WS_F",            # Wind Speed                                                   | m/s
  # ! "WD",              # Wind Direction                                               | Decimal degrees
  # ! "USTAR",           # Friction velocity                                            | m/s
  # ! "RH",              # Relative Humidity                                            | %
  # ! "PPFD_IN",         # incoming Photosynthetic photon flux density                  | W/m2
  "CO2_F_MDS",       # CO2 mole fraction                                            | umol CO2/mol
  "TA_F",            # air temperature                                              | degC
  # "TS_F_MDS_1",      # Soil temperature, '                                          # ' increases with the depth, 1 is shallowest | degC
  # "SWC_F_MDS_1",     # Soil water content                                           | %
  "NEE_VUT_REF",     # Net Ecosystem Exchange, using Variable Ustar Threshold (VUT) | umol CO2/mol
                     # for each year, reference selected on the basis of the model
                     # efficiency (MEF). The MEF analysis is repeated for each time aggregation
  "RECO_DT_VUT_REF", # daytime partitioning Ecosystem Respiration                   | umol CO2/mol
  "RECO_NT_VUT_REF", # nighttime partitioning Ecosystem Respiration                 | umol CO2/mol
  "GPP_DT_VUT_REF",  # daytime partitioning Gross Primary Production,               | umol CO2/mol
  "GPP_NT_VUT_REF"   # nighttime partitioning Gross Primary Production,             | umol CO2/mol
)

################################################################################
vars_QC <- paste0(vars_val, "_QC")
vars_QC[match(c("LE_CORR_QC", "H_CORR_QC"), vars_QC)] <- c("LE_F_MDS_QC", "H_F_MDS_QC")

N = length(vars_val)
vars_QC[(N - 3):N] <- vars_QC[N-4] # RECO, GPP share the same QC with NEE

vars_all <- c(vars_val, vars_QC) # unique

# NA VALUES ---------------------------------------------------------------
#
# variables x < 0 set to be NA, values can't be negative
var_no_negative <- c(
  "SW_IN_F", "SW_OUT_F", "LW_IN_F", "LW_OUT_F",
  "PA_F", "PPFD_IN",
  "P_F", "VPD_F", "WS_F", "WD", "USTAR", "CO2_F_MDS", 
  "RECO_DT_VUT_REF", "RECO_NT_VUT_REF"
)

# vars_0na <- paste(c('SW_', 'LW_', 'PPFD_', 'PA_'),
#                   collapse = "|") %>% {vars_val[grep(., vars_val)]} #, 'GPP_'
# variables x < 0 set to be NA, except vars_0na variables
# fixed 17 Dec' 2017
# vars_noNeg <- vars_val[-grep("TA_F|TS_F|NEE|G_F_MDS|GPP|LE|H|NETRAD", vars_val)] %>% setdiff(vars_0na)
# all variables: vars_noNeg + vars_0na + "TA_F|TS_F|NEE|G_F_MDS"
#
# else variables (TA_F, TS_F, NEE) x < -9000 set to be NA
################################################################################


apply_qc <- function(x_val, x_qc) {
  x_val[x_qc > 2] <- NA # poor设置为NA
  vars <- names(x_val)

  for (i in seq_along(vars)) {
    var <- vars[i]

    I_0 <- numeric() # error fix, 17 Dec' 2017，不能为0的值
    if (var %in% var_no_negative) {
      # variables x < 0 set to be 0
      I_0 <- which(x_val[[i]] < 0)
    }

    I_na <- which(x_val[[i]] <= -9000 | x_qc[[i]] > 2) # should be caution the short form

    if (length(I_0) > 0) {
      set(x_val, i = I_0, j = i, value = NA) # 09 Mar, 2018
    }
    if (length(I_na) > 0) {
      set(x_val, i = I_na, j = i, value = NA)
    }
  }
  return(x_val)
}


# 1. 为提防有些变量没有QC，引入d_other
tidy_hourly <- function(df) {
  # * 0 = measured; 1 = good quality gapfill; 2 = medium; 3 = poor
  d_soil <- select(df, starts_with("SWC_F_MDS_"), starts_with("TS_F_MDS_"), -ends_with("_QC"))
  vars_qc <- paste0(names(d_soil), "_QC")
  d_soil_qc <- select(df, all_of(vars_qc))
  d_soil = apply_qc(d_soil, d_soil_qc)
  
  d_val <- df[, vars_val, with = FALSE]
  d_qc <- df[, vars_QC, with = FALSE]
  d_val = apply_qc(d_val, d_qc)

  var_other = setdiff(names(df), c(names(d_val), names(d_soil), "time", "date"))
  d_other = select(df, all_of(var_other))
  cbind(df[, .(time, date)], d_val, d_other, d_soil)
}
