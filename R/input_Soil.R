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
