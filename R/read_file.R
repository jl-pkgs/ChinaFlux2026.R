#' @importFrom Ipaper file_ext read_xlsx map
#' @importFrom data.table fread fwrite rbindlist
#' @importFrom dplyr select all_of mutate
#' @importFrom stringr str_extract str_replace_all
#' @importFrom readxl read_xls
#' @importFrom glue glue
#' @export
read_file <- function(f) {
  fun <- switch(file_ext(f),
    csv = data.table::fread,
    xls = readxl::read_xls,
    xlsx = read_xlsx
  )
  d <- fun(f)
  if ("DOY" %in% names(d)) d <- select(d, -DOY)
  d |> data.table()
}

read_files <- function(fs) {
  map(fs, read_file)
}


# 合并同一站点不同年份
merge_files <- function(fs, prefix, outdir = NULL) {
  if (is.null(outdir)) outdir <- dirname(fs[1])

  years <- str_extract(basename(fs), "\\d{4}")
  year_min <- min(years)
  year_max <- max(years)

  name <- str_replace_all(prefix, c(
    "热带" = "_热带",
    "落叶阔叶林" = "_DBF",
    "统计数据" = "",
    "分钟数据" = "min",
    "气象" = "_Met_",
    "通量" = "_Flux_"
  ))
  fout <- glue("{outdir}/{name}_{year_min}_{year_max}.csv")

  lst <- map(fs, read_file)

  df <- map(lst, \(d) d) |> rbindlist()
  fwrite(df, fout, bom = TRUE)
}


rm_empty_cols <- function(d) {
  cols_bad <- sapply(d, \(x) all(is.na(x)))
  inds <- which(!cols_bad)
  select(d, all_of(inds))
}

merge_fluxmet <- function(f, fout = NULL) {
  f_flux <- f
  f_met <- gsub("_Flux", "_Met", f_flux)
  d_flux <- read_file(f_flux)
  d_met <- read_file(f_met) |> rm_empty_cols()
  d <- cbind(d_flux, d_met[, -(1:3)])

  if (!is.null(fout)) fwrite(d, fout, quote = FALSE, bom = TRUE)
  d
}

# 只处理
process <- function(lst_fs) {
  foreach(fs = lst_fs, prefix = names(lst_fs), i = icount()) %do% {
    runningId(i)
    merge_files(fs, prefix)
  }
}
