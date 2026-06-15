# ── 多层变量取第一层（最浅层）─────────────────────────────────────────────────

#' 从变量名解析土壤深度（cm），用于排序选层
#'
#' 兼容以下命名：
#' - `SM_5cm` / `TS_4cm_N`  →  5 / 4（取 cm 前数字）
#' - `SM_0_20_1`            →  0（区间取下界）
#' - `SM_1` / `SM_2`        →  按末尾索引排序（视作极浅，1→0.01）
#' - 裸 `SM`                →  Inf（代表多层平均，非分层；仅当没有任何分层时才会被选中）
#' @noRd
.var_depth <- function(v) {
  cm <- stringr::str_extract(v, "\\d+(?:\\.\\d+)?(?=cm)")
  if (!is.na(cm)) return(as.numeric(cm))
  rng <- stringr::str_match(v, "_(\\d+)_\\d+")[, 2]
  if (!is.na(rng)) return(as.numeric(rng))
  idx <- stringr::str_match(v, "_(\\d+)$")[, 2]
  if (!is.na(idx)) return(as.numeric(idx) / 100)
  Inf  # 裸 SM = 多层平均，排到最后
}

#' 列出某前缀的全部分层列（来源变量）
#' @noRd
layer_vars <- function(d, prefix) {
  grep(sprintf("^%s(_|$)", prefix), names(d), value = TRUE)
}

#' 返回第一层（最浅层）所对应的源变量名
#'
#' 与 `pick_layer1()` 共用同一选层逻辑，供记录来源（provenance）使用。
#' 无匹配列时返回 `character(0)`。
#' @noRd
layer1_var <- function(d, prefix = "SM") {
  vars <- layer_vars(d, prefix)
  if (length(vars) == 0) return(character(0))
  depth <- vapply(vars, .var_depth, numeric(1))
  vars[order(depth, seq_along(vars))][1]
}

#' 挑选第一层（最浅层）变量
#'
#' 在数据框 `d` 中找出所有以 `prefix` 开头的列（如 `SM`、`TS`、`G`），按深度
#' 排序后取最浅的一层，写入名为 `to` 的列；深度无法解析时按出现顺序取第一个。
#' 默认为加列（非破坏式），不删除其余分层。
#'
#' @param d    data.frame / data.table
#' @param prefix 变量前缀，默认 `"SM"`
#' @param to   输出列名，默认与 `prefix` 相同（即把第一层写回 `SM`）
#' @return 增加（或覆盖）`to` 列后的 `d`
#' @examples
#' # d %>% pick_layer1()              # 取最浅层土壤湿度 → SM
#' # d %>% pick_layer1("TS", "TS1")   # 取最浅层土壤温度 → TS1
pick_layer1 <- function(d, prefix = "SM", to = prefix) {
  top <- layer1_var(d, prefix)
  if (length(top) == 0) return(d)
  d[[to]] <- d[[top]]
  d
}

#' 多观测取中位数（行中位数合成一列）
#'
#' 把所有以 `prefix` 开头的列按行求**中位数**（忽略 `NA` 与 `-9999` 缺测），写入
#' `to` 列。相比均值，中位数对单板异常/坏值更稳健。适用于同一深度布设的多块土壤
#' 热通量板（HFP）或多重复观测的合成：如锦州 `G_8cm_1/2`、固城 `G_8cm_N/S`、
#' 长白山 `G_0_1/2`、燕山 `G_2cm+G_5cm`、盘锦 `G_1/2/3`。
#'
#' @param d    data.frame / data.table
#' @param prefix 变量前缀，默认 `"G"`
#' @param to   输出列名，默认与 `prefix` 相同（即把结果写回 `G`）
#' @param abs_max 值域控制：单板绝对值超过该阈值视为坏值置 `NA`（合成前逐板进行，
#'   故单板独留的异常段也会被剔除）。默认 `100`（日尺度地热通量）；设 `Inf` 关闭。
#' @return 增加（或覆盖）`to` 列后的 `d`
#' @examples
#' # d %>% avg_layer("G")    # 多块热通量板 → 单列 G（行中位数，|G|>100 置 NA）
avg_layer <- function(d, prefix = "G", to = prefix, abs_max = 100) {
  vars <- grep(sprintf("^%s(_|$)", prefix), names(d), value = TRUE)
  if (length(vars) == 0) return(d)
  M <- vapply(vars, \(v) as.numeric(d[[v]]), numeric(nrow(d)))
  M[M == -9999] <- NA
  M[abs(M) > abs_max] <- NA # 值域控制：逐板剔除超限坏值
  val <- apply(M, 1, median, na.rm = TRUE)
  val[is.nan(val)] <- NA_real_ # 整行皆缺测
  d[[to]] <- val
  d
}
