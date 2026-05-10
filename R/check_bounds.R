check_bounds_SM <- function(d) {
  mutate(d, across(starts_with("SM"), \(x) {
    x[x <= 0 | x > 1] <- NA_real_
    x
  }))
}
