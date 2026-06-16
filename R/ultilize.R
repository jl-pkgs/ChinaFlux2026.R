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
  dots <- rlang::enquos(...)
  vars <- unlist(lapply(dots, function(q) {
    expr <- rlang::quo_get_expr(q)
    if (rlang::is_call(expr, c("any_of", "all_of"))) {
      return(rlang::eval_bare(expr[[2]], rlang::quo_get_env(q)))
    }
    names(tidyselect::eval_select(expr, data = dt))
  }), use.names = FALSE)
  vars <- unique(vars)

  missing <- setdiff(vars, names(dt))
  if (length(missing)) {
    if (data.table::is.data.table(dt)) {
      dt[, (missing) := NA]
    } else {
      dt[missing] <- NA
    }
  }
  select(dt, all_of(vars))
}


find_met_day <- function(dir_root) {
  fs <- dir2(dir_root, "_Met.*.csv")
  ans <- fs[grep("_(日|Day|day)", basename(fs))]
  if (length(ans) == 0) {
    print(dir(dir_root))
  } else {
    print(ans)
  }
  ans
}

# 冠层变量回退：缺 *_canopy 时用塔层基础观测填补
# - 同时存在：用基础值补冠层的 NA 空缺（fcoalesce）
# - 仅有基础：直接复制为 *_canopy
coalesce_canopy <- function(d) {
  fallback <- c(Ta_canopy = "Ta", RH_canopy = "RH", WS_canopy = "WS")
  for (cv in names(fallback)) {
    bv <- fallback[[cv]]
    if (!bv %in% names(d)) next
    # 强制转 numeric：某些站基础列全 NA 会被读成 logical，
    # 与 numeric 的 *_canopy 列直接 fcoalesce 会报「type logical vs double」
    if (cv %in% names(d)) {
      d[[cv]] <- data.table::fcoalesce(as.numeric(d[[cv]]), as.numeric(d[[bv]]))
    } else {
      d[[cv]] <- as.numeric(d[[bv]])
    }
  }
  d
}
