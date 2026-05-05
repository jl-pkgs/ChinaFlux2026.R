rm_useless_cols <- function(d) {
  d %>% select(-any_of("second"))
}


read_ufile <- function(f, ..., nrows = Inf) {
  unit <- fread(f, nrows = 1)
  dat <- fread(f, skip = 2, header = FALSE, nrows = nrows) %>% unique() # rm duplicated unit rows

  inds_good = dat[[1]] %!in% c("-", "/") # rm unit rows
  dat <- dat[inds_good, ]

  dat[dat == -99999] = NA
  dat[dat == -9999] = NA

  names(dat) <- names(unit)
  structure(list(data = dat, unit = unit), class = "unit_df")
}

#' @export
write_ufile <- function(x, ...) UseMethod("write_ufile")

#' @export
write_ufile.data.frame <- function(data, unit, fout) {
  fwrite(unit, fout, bom = TRUE)
  fwrite(data, fout, col.names = FALSE, append = TRUE)
}

#' @export
write_ufile.unit_df <- function(l, fout) {
  fwrite(l$unit, fout, bom = TRUE)
  fwrite(l$data, fout, col.names = FALSE, append = TRUE)
}


#' @export
map_ufile <- function(l, fun) {
  data = fun(l$data)
  unit = fun(l$unit)
  structure(list(data = data, unit = unit), class = "unit_df")
}

#' @export
merge_ufile <- function(x, y, ...) {
  UseMethod("merge_ufile")
}

#' @export
merge_ufile.list <- function(l, ...) {
  x <- l[[1]]
  y <- l[[2]]
  merge_ufile(x, y)
}

#' @export
merge_ufile.unit_df <- function(x, y, ...) {
  vars_comm <- intersect(names(x$data), names(y$data))
  data <- merge(x$data, y$data)
  if ("year" %in% names(data)) {
    data = data[year != "/"]
  }
  unit <- cbind(x$unit, y$unit %>% select(-all_of(vars_comm)))

  if (!isTRUE(all.equal(names(data), names(unit)))) {
    stop("[e] names are different!")
  }
  structure(list(data = data, unit = unit), class = "unit_df")
}
