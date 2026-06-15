#' 气象/能量驱动变量的物理值域（超出范围置 NA）
#'
#' 按「变量基名」匹配列：列名等于 key，或以 `key_` 开头
#' （如 `Ta_canopy`/`Ta_2`→`Ta`，`TS_5cm`→`TS`，`RH_canopy`→`RH`，
#'  `WS_canopy`→`WS`，`SM_L1`/`SM_5cm`→`SM`，`G_8cm_1`→`G`）。
#' 同时匹配多个 key 时取最长者（`Rs_out` 优先于 `Rs`）。
#' 取值为**日尺度**（日均速率 / 日累计）的合理上下限，从宽设置以免误删有效值。
#' 注意辐射、能量通量、PAR 存的是日均 W m-2 / μmol m-2 s-1，远低于瞬时峰值，
#' 故上限按日均设定（如 Rs 日均最大 ~400，而非瞬时 ~1000+）。若改用于小时数据，
#' 需另传更宽的 `bounds`。碳通量（NEE/GPP/RE/ET）清洗仍由 `check_Flux()` 负责。
# styler: off
VARS_BOUNDS <- list(
  Ta      = c(-50,  50),   # °C  气温（日均）
  TS      = c(-40,  60),   # °C  土壤温度（日均）
  RH      = c(  0, 100),   # %   相对湿度
  WS      = c(  0,  30),   # m/s 风速（日均）
  WD      = c(  0, 360),   # Deg 风向
  Prcp    = c(  0, 800),   # mm  日降水
  Rs      = c(  0, 450),   # W/m2 入射短波（日均）
  Rs_out  = c(  0, 300),   # W/m2 反射短波（日均）
  Rln_in  = c(  0, 600),   # W/m2 入射长波（日均）
  Rln_out = c(  0, 700),   # W/m2 出射长波（日均）
  Rn      = c(-150, 350),  # W/m2 净辐射（日均）
  Q       = c(  0, 450),   # W/m2 总辐射/能量（日均）
  PAR     = c(  0, 1200),  # μmol m-2 s-1（日均）
  PPFD    = c(  0, 1200),  # μmol m-2 s-1（日均）
  LE      = c(-100, 400),  # W/m2 潜热（日均）
  Hs      = c(-150, 400),  # W/m2 显热（日均）
  ET      = c(-5, 10),    # mm/d 日蒸散发
  NEE     = c(-50, 50),    # gC m-2 d-1 日均净生态系统交换通量（负值：碳汇）
  G       = c(-100, 100),  # W/m2 土壤热通量（日均）
  ea      = c(  0,   8),   # kPa  水汽压
  VPD     = c(  0,   8),   # kPa  饱和水汽压差
  Pa      = c( 50, 110)   # kPa  气压
  # SM      = c(  0,   1)    # m3 m-3 土壤含水量
)
# styler: on

# 返回与列名匹配的最长 bound 键（精确名或 `key_` 前缀），无匹配返回 NA
.bound_key <- function(col, keys) {
  hit <- keys[col == keys | startsWith(col, paste0(keys, "_"))]
  if (length(hit) == 0) {
    return(NA_character_)
  }
  hit[which.max(nchar(hit))]
}

#' 变量值域检查：超出物理范围的观测置 NA
#'
#' @param d data.frame/data.table，逐列按 `bounds` 匹配并裁剪。
#' @param bounds 命名列表，每项 `c(下限, 上限)`，默认 `VARS_BOUNDS`。
check_bounds <- function(d, bounds = VARS_BOUNDS) {
  keys <- names(bounds)
  for (col in names(d)) {
    x <- d[[col]]
    if (!is.numeric(x)) next
    key <- .bound_key(col, keys)
    if (is.na(key)) next
    rng <- bounds[[key]]
    x[x <= rng[1] | x >= rng[2]] <- NA_real_
    d[[col]] <- x
  }
  d
}

check_bounds_SM <- function(d) {
  mutate(d, across(starts_with("SM"), \(x) {
    x[x <= 0 | x > 1] <- NA_real_
    x
  }))
}
