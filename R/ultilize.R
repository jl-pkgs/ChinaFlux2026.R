# library(Ipaper)
# library(data.table)
# library(dplyr)
# library(stringr)
# library(lubridate)
# library(hydroTools)
# library(rtrend)

# pacman::p_load(
#   Ipaper, data.table, dplyr, lubridate, jsonlite,
#   hydroTools, ggplot2
# )

write_dir <- function(fs, fout) {
  df <- map(fs, read_file) |> rbindlist() %>% unique()
  fwrite(df, fout, bom = TRUE)
}

rm_spike <- function(x, halfwin = 3, sd.times = 3) {
  x2 = movmean(x, halfwin)
  sd = sd(x2, na.rm = TRUE)
  inds_bad = which(abs(x - x2) > sd.times * sd)
  # print2(inds_bad)
  x[inds_bad] = NA
  x
}

extract_site <- function(fs) {
  str_extract(basename(fs), "(?<=_).*?(?=_Day)")
}

fix_NEE <- function(d) {
  if ("NEE" %in% names(d)) {
    d[NEE < -100, NEE := NA]
  }
  d
}

fix_LE <- function(d) {
  if ("LE" %in% names(d)) {
    d[LE < -100, LE := NA]
  }
  d
}


dir2 <- function(path = ".", pattern = NULL, full.names = TRUE, ...) {
  dir(path_mnt(glue(path)), pattern, ..., full.names = full.names)
}

str_year = function(f) {
  str_extract_all(basename(f), "\\d{4}")[[1]]
}

select_any <- function(dt, ...) {
  # 构造一个包含所有目标列的虚拟参考框架
  expr <- rlang::expr(c(...))
  vars <- tryCatch(
    tidyselect::eval_select(expr, data = dt) |> names(),
    error = function(e) {
      # 提取 all_of/any_of 中的变量名
      rlang::eval_tidy(rlang::expr(c(...)))
    }
  )
  
  missing <- setdiff(vars, names(dt))
  if (length(missing)) {
    dt[, (missing) := NA]
  }
  dt[, ..vars]
}
