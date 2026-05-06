# `SoilGrids`: 6层，(0 - 0.05 m, 0.05 - 0.15 m, 0.15 - 0.30 m, 0.30 - 0.60 m, 0.60 - 1.00 m, and 1.00 - 2.00 m)
# 6层土壤进行加权

# 对OpenLandMap 土壤属性深度加权
# 方案2: 矩阵版本（常数外推）
# https://claude.ai/chat/dbe620ba-8d7b-4c9d-99d4-43a0813b6d8c

# Dai 2019, SoilGrids土壤属性数据加权
#' @export
soil_weighted_facet <- function(props, depths) {
  sg <- c(0, 0.05, 0.15, 0.30, 0.60, 1.00, 2.00)
  n <- length(depths) - 1

  # 2米内重叠
  ovlp <- outer(1:n, 1:6, function(i, j) {
    pmax(0, pmin(depths[i + 1], sg[j + 1]) - pmax(depths[i], sg[j]))
  })

  # 2米外部分（用最深层填充）
  below <- pmax(0, depths[-1] - pmax(depths[-length(depths)], 2.00))

  (ovlp %*% props + below * props[6]) / (rowSums(ovlp) + below)
}

# OpenLandMap 土壤属性深度加权
#' @export
soil_weighted_edge <- function(props, depths) {
  edge_depths = c(0, 0.1, 0.3, 0.6, 1.0, 2.0)
  approx_fn <- approxfun(edge_depths, props, rule = 2)

  sapply(1:(length(depths) - 1), function(i) {
    # 用梯形法则积分
    n_seg <- 10
    d_seq <- seq(depths[i], depths[i + 1], length.out = n_seg + 1)
    y_seq <- approx_fn(d_seq)

    # 梯形积分
    sum((y_seq[-1] + y_seq[-(n_seg + 1)]) / 2 * diff(d_seq)) / (depths[i + 1] - depths[i])
  })
}

# 使用示例
# props <- c(25, 30, 35, 40, 45, 50)
# depths <- c(0, 0.10, 0.30, 0.50, 1.00, 1.50)
# soil_weighted_extrap(props, depths)

# 统一处理土壤温湿度，插值至BEPS标准层
# BEPS土壤层 dz = [0.05, 0.10, 0.20, 0.40, 1.25] m
# 对应的节点中心深度为: 2.5, 10.0, 25.0, 55.0, 137.5 cm

#' 垂直插值土壤剖面数据
#' @param df 包含观测数据的数据框
#' @param var_prefix 变量前缀，如 "TS" 或 "SM"
#' @return 返回 ntime x 5 的矩阵，列名为 Prefix_L1 到 Prefix_L5
interp_soil_profile <- function(df, var_prefix = "TS") {
  target_depths <- c(2.5, 10.0, 25.0, 55.0, 137.5)
  
  # 匹配形如 TS_5cm, SM_10cm 的列
  pattern <- sprintf("^%s_(\\d+)cm$", var_prefix)
  cols <- grep(pattern, names(df), value = TRUE)
  
  if (length(cols) == 0) {
    res <- matrix(NA_real_, nrow = nrow(df), ncol = 5)
    colnames(res) <- sprintf("%s_L%d", var_prefix, 1:5)
    return(res)
  }
  
  # 提取深度并对齐列顺序
  obs_depths <- as.numeric(sub(pattern, "\\1", cols))
  ord <- order(obs_depths)
  cols <- cols[ord]
  obs_depths <- obs_depths[ord]
  
  mat_obs <- as.matrix(df[, cols, drop = FALSE])
  
  # 逐行线性插值 (rule=2 表示两端采用最近邻平延外推)
  res <- t(apply(mat_obs, 1, function(y) {
    valid <- !is.na(y)
    n_valid <- sum(valid)
    if (n_valid == 0) return(rep(NA_real_, 5))
    if (n_valid == 1) return(rep(y[valid][1], 5))
    approx(x = obs_depths[valid], y = y[valid], xout = target_depths, rule = 2)$y
  }))
  
  colnames(res) <- sprintf("%s_L%d", var_prefix, 1:5)
  return(res)
}

#' 批量处理站点的TS和SM，并合并回原数据框
#' @param df 站点原始数据框
#' @return 拼接了 TS_L1~L5 和 SM_L1~L5 的新数据框
process_site_soil <- function(df) {
  ts_mat <- interp_soil_profile(df, "TS")
  sm_mat <- interp_soil_profile(df, "SM")
  cbind(df, as.data.frame(ts_mat), as.data.frame(sm_mat))
}
