na_interp <- function(t, x) {
  # t = seq_along(x)
  inds <- which(is.na(x)) # NA index
  if (length(inds) == 0) {
    return(x)
  }

  x[inds] <- na.approx(x, t, t[inds], maxgap = 24, rule = 2)
  inds_bad <- which(is.na(x))

  if (length(inds_bad) > 0) {
    # 实现了一个历史平均差值，针对连续缺失超过24小时的情况
    d <- data.table(idx = seq_along(x), month = month(t), hour = hour(t), x)
    d_his <- d[, .(x_his = mean(x, na.rm = TRUE)), .(month, hour)]
    d <- merge(d, d_his, c("month", "hour"), all.x = TRUE, sort = FALSE)
    setorder(d, idx) # 恢复原始顺序
    x[inds_bad] <- d[inds_bad, x_his]
  }
  x
}
