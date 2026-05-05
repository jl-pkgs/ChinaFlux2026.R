vspan_pulse <- function(pulse, alpha = 0.15) {
  list(
    geom_rect(
      data = pulse,
      aes(xmin = date_start, xmax = date_peak, ymin = -Inf, ymax = Inf),
      fill = "blue", alpha = alpha, inherit.aes = FALSE
    ),
    geom_rect(
      data = pulse,
      aes(xmin = date_peak, xmax = date_end, ymin = -Inf, ymax = Inf),
      fill = "red", alpha = alpha, inherit.aes = FALSE
    )
  )
}

# vspan_day <- function(day, alpha = 0.15) {
#   geom_rect(
#     data = day,
#     aes(xmin = time_beg, xmax = time_end, ymin = -Inf, ymax = Inf),
#     fill = "red", alpha = alpha, inherit.aes = FALSE
#   )
# }

vspan_day <- function(time_beg, time_end, alpha = 0.15) {
  dates <- seq(time_beg, time_end, by = "day") %>%
    as_date() %>%
    unique()
  time_rise <- format(dates, "%Y-%m-%d 06:00:00") %>% as.POSIXct(tz = "UTC")
  time_set <- format(dates, "%Y-%m-%d 18:00:00") %>% as.POSIXct(tz = "UTC")
  day <- data.table(time_rise, time_set)

  geom_rect(
    data = day,
    aes(xmin = time_rise, xmax = time_set, ymin = -Inf, ymax = Inf),
    fill = "red", alpha = alpha, inherit.aes = FALSE
  )
}
