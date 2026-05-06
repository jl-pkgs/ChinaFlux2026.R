#' @keywords internal
#' @importFrom stringr str_extract_all str_extract str_replace_all
#' @import data.table
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL


add_time <- function(d) {
  # d <- d[, lapply(.SD, as.numeric)]
  inds = match(c("year", "doy", "hour"), names(d)) %>% rm_empty()
  use_yday = length(inds) == 3
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
  mutate(d, date = make_date(year, month, day), .before = "year") |>
    select(-year, -month, -day)
}

filter_date <- function(d, time_beg, time_end) {
  d[time >= time_beg & time <= time_end]
}


#' @importFrom stringr str_replace_all
rename_vars <- \(d, replacement) {
  rename_with(d, \(x) str_replace_all(x, replacement))
}
