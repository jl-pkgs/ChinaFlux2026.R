#' @keywords internal
#' @importFrom stringr str_extract_all str_extract str_replace_all
#' @import data.table
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

# 字符 datetime 解析：优先 ymd_hm（如句容 "2015/1/1 0:00"），失败的再用
# ymd_hms 兜底（如临泽 ISO "2012-01-01T00:00:00Z"）。非字符则原样返回。
.parse_time <- function(x) {
  if (!is.character(x)) {
    return(x)
  }
  t <- suppressWarnings(ymd_hm(x))
  if (anyNA(t)) t <- suppressWarnings(ymd_hms(x))
  t
}

add_time <- function(d) {
  # d <- d[, lapply(.SD, as.numeric)]
  # 部分站点直接提供 time 列（句容、临泽）。
  if ("time" %in% names(d)) {
    return(mutate(d, time = .parse_time(time)))
  }
  # 部分站点（如盘锦）把半小时 datetime 放在名为 date 的列里：若含时分（字符或
  # POSIXct）则当作 time，重命名后返回。
  if ("date" %in% names(d) && (is.character(d$date) || inherits(d$date, "POSIXt"))) {
    return(mutate(d, time = .parse_time(date), .before = 1) %>% select(-date))
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
  # 部分站点（庆阳、栾城、临泽、普定）直接提供 date 列（字符，如
  # "2019-01-01" 或 "2012/1/1"），无 year/month/day：解析为 Date 后返回。
  if ("date" %in% names(d)) {
    if (is.character(d$date)) d <- mutate(d, date = ymd(date))
    return(d)
  }
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
