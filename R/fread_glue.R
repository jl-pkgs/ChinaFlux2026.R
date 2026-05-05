# ' @examples vars = "年,月,日,时,分,秒"
split_vars <- function(vars) {
  strsplit(vars, ",")[[1]] %>% as.list() %>% as.data.table()
}

rm_useless_cols <- function(d) {
  d %>% select(-any_of("second"))
}

# duplicate rows are removed by default
fread_glue <- function(f, ...) {
  d = fread(glue(f), ...) %>% unique() # %>% rm_useless_cols()
  inds_bad = which(d[[1]] %in% c("-", "/")) # 只保留第一行的unit

  if (length(inds_bad) > 1) {
    inds_bad = inds_bad[-1] # 保留第一次出现的unit
    d = d[-inds_bad, ]      # 其余删除
  }
  d
}

fwrite_glue <- function(d, fout, overwrite = FALSE, ..., col.names = TRUE) {
  file = glue(fout)
  if (file.exists(file) && !overwrite) {
    warning("File already exists. Set overwrite = TRUE to overwrite.")
  } else {
    mkdir(dirname(file))
    fwrite(d, file, quote = FALSE, bom = TRUE, col.names = col.names, ...)
  }
}
