#' 气象/能量驱动变量的物理值域（超出范围置 NA）
#'
#' 按「变量基名」匹配列：列名等于 key，或以 `key_` 开头
#' （如 `Ta_canopy`/`Ta_2`→`Ta`，`TS_5cm`→`TS`，`RH_canopy`→`RH`，
#'  `WS_canopy`→`WS`，`SM_L1`/`SM_5cm`→`SM`，`G_8cm_1`→`G`）。
#' 同时匹配多个 key 时取最长者（`Rs_out` 优先于 `Rs`）。
#'
#' **区分两套尺度**：
#' - `VARS_BOUNDS_DAILY`：**日尺度**（日均速率 / 日累计）的合理上下限。
#'   辐射、能量通量、PAR 存的是日均 W m-2 / μmol m-2 s-1，远低于瞬时峰值，
#'   故上限按日均设定（如 Rs 日均最大 ~450，而非瞬时 ~1300）。
#' - `VARS_BOUNDS_HOURLY`：**小时/半小时尺度**（瞬时速率）的上下限，明显更宽。
#'   辐射峰值按晴空瞬时上限放开（Rs ~1400、PAR ~2500）；风速放宽到阵风量级；
#'   能量通量（LE/Hs/Rn/G）允许更大瞬时正负值；降水改为小时累计上限。
#'
#' `VARS_BOUNDS` 默认指向日尺度，保持旧调用 `check_bounds(d)` 行为不变。
#' 碳通量（NEE/GPP/RE/ET）清洗仍由 `check_Flux()` 负责。
# styler: off
VARS_BOUNDS_DAILY <- list(
  Ta        = c(-50,  50),   # °C  气温（日均）
  TS        = c(-40,  60),   # °C  土壤温度（日均）
  RH        = c(  0, 100),   # %   相对湿度
  WS        = c(  0,  10),   # m/s 风速（日均）
  WS_canopy = c(  0,  10),   # m/s 风速（日均）
  WD        = c(  0, 360),   # Deg 风向
  Prcp      = c(  0, 300),   # mm  日降水
  Rs        = c(  0, 450),   # W/m2 入射短波（日均）
  Rs_out    = c(  0, 300),   # W/m2 反射短波（日均）
  Rln_in    = c(  0, 600),   # W/m2 入射长波（日均）
  Rln_out   = c(  0, 700),   # W/m2 出射长波（日均）
  Rn        = c(-150, 350),  # W/m2 净辐射（日均）
  Q         = c(  0, 450),   # W/m2 总辐射/能量（日均）
  PAR       = c(  0, 1200),  # μmol m-2 s-1（日均）
  PPFD      = c(  0, 1200),  # μmol m-2 s-1（日均）
  LE        = c(-60, 400),  # W/m2 潜热（日均）
  Hs        = c(-60, 400),  # W/m2 显热（日均）
  ET        = c(-5, 10),    # mm/d 日蒸散发
  NEE       = c(-50, 50),    # gC m-2 d-1 日均净生态系统交换通量（负值：碳汇）
  G         = c(-100, 100),  # W/m2 土壤热通量（日均）
  ea        = c(  0,   8),   # kPa  水汽压
  VPD       = c(  0,   8),   # kPa  饱和水汽压差
  Pa        = c( 50, 110)   # kPa  气压
  # SM      = c(  0,   1)    # m3 m-3 土壤含水量
)

VARS_BOUNDS_HOURLY <- list(
  Ta        = c(-50,   55),   # °C  气温（瞬时）
  TS        = c(-40,   70),   # °C  土壤温度（瞬时）
  RH        = c(  0,  100),   # %   相对湿度
  WS        = c(  0,   15),   # m/s 风速（瞬时，含阵风）
  WS_canopy = c(  0,   15),   # m/s 风速（瞬时，含阵风）
  WD        = c(  0,  360),   # Deg 风向
  Prcp      = c(  0,  100),   # mm  小时降水
  Rs        = c(  0, 1400),   # W/m2 入射短波（瞬时晴空峰值）
  Rs_out    = c(  0,  800),   # W/m2 反射短波（瞬时）
  Rln_in    = c(  0,  600),   # W/m2 入射长波（瞬时，本就平稳）
  Rln_out   = c(  0,  700),   # W/m2 出射长波（瞬时）
  Rn        = c(-200, 1000),  # W/m2 净辐射（瞬时）
  Q         = c(  0, 1400),   # W/m2 总辐射/能量（瞬时）
  PAR       = c(  0, 2500),   # μmol m-2 s-1（瞬时峰值）
  PPFD      = c(  0, 2500),   # μmol m-2 s-1（瞬时峰值）
  LE        = c(-150, 1000),  # W/m2 潜热（瞬时）
  Hs        = c(-200,  800),  # W/m2 显热（瞬时）
  ET        = c(-0.5,   3),   # mm/h 小时蒸散发
  NEE       = c(-100, 100),   # 瞬时净生态系统交换通量（单位随数据而定）
  G         = c(-300,  300),  # W/m2 土壤热通量（瞬时）
  ea        = c(  0,    8),   # kPa  水汽压
  VPD       = c(  0,   10),   # kPa  饱和水汽压差
  Pa        = c( 50,  110)    # kPa  气压
  # SM      = c(  0,    1)    # m3 m-3 土壤含水量
)

# 旧名兼容：默认日尺度
VARS_BOUNDS <- VARS_BOUNDS_DAILY
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
#' @param scale `"daily"`（默认）或 `"hourly"`，选用对应的内置值域表。
#'   小时尺度的辐射/能量/风速上限明显放宽，降水改为小时累计上限。
#' @param bounds 命名列表，每项 `c(下限, 上限)`。显式传入则覆盖 `scale`；
#'   不传则按 `scale` 选用 `VARS_BOUNDS_DAILY` / `VARS_BOUNDS_HOURLY`。
check_bounds <- function(d, scale = c("daily", "hourly"), bounds = NULL) {
  scale <- match.arg(scale)
  if (is.null(bounds)) {
    bounds <- if (scale == "hourly") VARS_BOUNDS_HOURLY else VARS_BOUNDS_DAILY
  }
  keys <- names(bounds)
  for (col in names(d)) {
    x <- d[[col]]
    if (!is.numeric(x)) next
    key <- .bound_key(col, keys)
    if (is.na(key)) next
    rng <- bounds[[key]]
    # 边界为有效值（含 0 降水、夜间 0 辐射、静风、RH=100 饱和），仅剔除严格越界
    x[x < rng[1] | x > rng[2]] <- NA_real_
    d[[col]] <- x
  }
  d
}

#' RH/SM 质量控制：恰为 0 的观测置 NA
#'
#' 相对湿度 RH 或土壤含水量 SM 读数恰好为 0，多为传感器故障/缺测哨兵，
#' 而非真实观测，统一置 NA。按列名前缀匹配（RH/RH_canopy…，SM/SM_5cm/SM_L1…）。
check_zero <- function(d, prefix = c("RH", "SM")) {
  for (col in names(d)) {
    x <- d[[col]]
    if (is.numeric(x) && any(startsWith(col, prefix))) {
      x[x == 0] <- NA_real_
      d[[col]] <- x
    }
  }
  d
}

check_bounds_SM <- function(d) {
  mutate(d, across(starts_with("SM"), \(x) {
    x[x <= 0 | x > 1] <- NA_real_
    x
  }))
}
