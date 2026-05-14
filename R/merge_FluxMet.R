# fmt: skip
VARS_DATE = c(
  "year", "month", "day", "hour", "minute", "second", 
  "date", "time",
  "doy",
  "年", "月", "日", "时", "分", "秒"
)

#' @export
merge_hourly_FluxMet <- function(f_met, SITE, VegType, VegName, ..., 
  outdir = "data-raw/0_Hourly", f_flux = NULL) 
{
  dir_root = dirname(f_met)
  f_flux = f_flux %||% gsub("Met", "Flux", f_met)

  c(year_beg, year_end) %<-% str_year(f_met)
  f_varnames = glue("{dir_root}/VarNames_{SITE}_Met_{year_beg}-{year_end}.csv")

  if (!isfile(f_varnames)) {
    units = fread_glue(f_met, nrows = 1)
    fwrite_glue(units, f_varnames, overwrite = FALSE)
    message("请人工修改变量名VarNames")
    code(dir_root)
    return()
  }

  ## 合并met和flux, 在人工修改变量名VarNames之后
  d_met = patch_varnames(f_met, f_varnames) %>% rm_useless_cols()
  d_flux = fread_glue(f_flux) %>% unique() %>% rm_useless_cols()

  by = intersect(names(d_flux), VARS_DATE)
  d = merge(d_flux, d_met, by)

  file = glue(
    "{VegType}_{VegName}_{SITE}_30min_FluxMet_{year_beg}_{year_end}.csv"
  )
  
  fwrite_glue(d, glue("{dir_root}/{file}"), overwrite = TRUE)
  fwrite_glue(d, glue("{outdir}/{file}"), overwrite = TRUE)
  glue("{outdir}/{file}") # return filepath
}

merge_daily_FluxMet <- function(
  f_met, SITE, VegType, VegName, ...,
  outdir = "data-raw/Daily", f_flux = NULL
)
{
  dir_root <- dirname(f_met)
  f_flux <- f_flux %||% gsub("Met", "Flux", f_met)

  c(year_beg, year_end) %<-% str_year(f_met)
  f_varnames <- glue("{dir_root}/VarNames_{SITE}_Met_{year_beg}-{year_end}.csv")

  if (!isfile(f_varnames)) {
    units <- fread_glue(f_met, nrows = 1)
    fwrite_glue(units, f_varnames, overwrite = FALSE)
    message("请人工修改变量名VarNames")
    code(dir_root)
    return()
  }

  ## 合并met和flux, 在人工修改变量名VarNames之后
  d_met <- patch_varnames(f_met, f_varnames) %>% rm_useless_cols()
  d_flux <- fread_glue(f_flux) %>%
    unique() %>%
    rm_useless_cols()
  
  by <- intersect(names(d_flux), VARS_DATE)
  d <- merge(d_flux, d_met, by, sort = FALSE)
  file <- glue(
    "{VegType}_{VegName}_{SITE}_Day_FluxMet_{year_beg}_{year_end}.csv"
  )

  fwrite_glue(d, glue("{dir_root}/{file}"), overwrite = TRUE)
  fwrite_glue(d, glue("{outdir}/{file}"), overwrite = TRUE)
  glue("{outdir}/{file}") # return filepath
}



patch_varnames <- function(f_met, f_var) {
  d = fread_glue(f_met) %>% unique()
  vars = fread_glue(f_var, comment.char = "#")
  info = match2(names(d), names(vars))
  vars = vars[, info$I_y, with = FALSE]

  if (nrow(vars) == 1) {
    # 比较正的站点，数据直接采用
    message("Variable names not modified. Raw data was adopted.")
    return(d)
  }

  i_name = which(vars[[1]] %in% c("year", "date", "time"))
  i_unit = which(vars[[1]] %in% c("", "-", "/"))
  # if (length(J) == ncol(d)) { # 全部变量匹配
    names(d)[info$I_x] = unlist(vars[i_name, ]) # names
    d[1, info$I_x] = vars[i_unit, ] # unit, make sure 1st row is unit
    d
  # } else {
  #   stop("Variable names do not match.")
  # }
  return(d)
}


# read_fluxmet <- function(f_met) {
#   f_flux <- gsub("Met", "Flux", f_met)
#   met <- read_ufile(f_met)
#   flux <- read_ufile(f_flux)
#   l <- merge_ufile(flux, met)
#   l
# }
