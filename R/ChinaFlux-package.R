#' @keywords internal
#' @importFrom stringr str_extract_all str_extract str_replace_all
#' @import data.table
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL


add_time <- function(d) {
  # d <- d[, lapply(.SD, as.numeric)]
  # 部分站点（如句容、临泽）直接提供 time 列：若为字符则解析为 datetime。
  # 优先按 ymd_hm（如 "2015/1/1 0:00"）解析，失败的再用 ymd_hms 兜底
  # （如临泽 ISO 格式 "2012-01-01T00:00:00Z"）。
  if ("time" %in% names(d)) {
    if (is.character(d$time)) {
      t <- suppressWarnings(ymd_hm(d$time))
      if (anyNA(t)) t <- suppressWarnings(ymd_hms(d$time))
      d <- mutate(d, time = t)
    }
    return(d)
  }
  inds <- match(c("year", "doy", "hour"), names(d)) %>% rm_empty()
  use_yday <- length(inds) == 3
  if (use_yday) {
    d %>%
      mutate(time = make_datetime(year, 1, 1, 0) + ddays(doy - 1) + dhours(hour), .before = "year") %>%
      select(-year, -doy, -hour)
  } else {
    d %>%
      mutate(across(year:minute, as.numeric)) %>%
      mutate(time = make_datetime(year, month, day, hour, minute), .before = "year") %>%
      select(-year, -month, -day, -hour, -minute)
  }
}

add_date <- function(d) {
  if ("doy" %in% names(d)) {
    mutate(d, date = make_date(year, 1, 1) + ddays(doy - 1), .before = "year") %>%
      select(-year, -doy, -any_of(c("month", "day")))
  } else {
    mutate(d, date = make_date(year, month, day), .before = "year") |>
      select(-year, -month, -day)
  }
}

filter_date <- function(d, time_beg, time_end) {
  d[time >= time_beg & time <= time_end]
}


#' @importFrom stringr str_replace_all
rename_vars <- \(d, replacement) {
  rename_with(d, \(x) str_replace_all(x, replacement))
}
