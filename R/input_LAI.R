#' @export
process_LAI <- function(sp, subfix = "st341", outdir = "./data-raw") {
  dates <- fread("Z:/Global/GlobalLAI/LAI_MODIS_GLASS/LAI_MODIS_GLASS_2000-2024_dates.csv")$date

  f_glass_g005 <- glue("{outdir}/LAI_GLASS_8D_G005_2000-2024_{subfix}.csv")
  f_glass_g010 <- glue("{outdir}/LAI_GLASS_8D_G010_2000-2024_{subfix}.csv")
  f_whit_v016 <- glue("{outdir}/LAI_WHIT_8D_V016_2000-2024_{subfix}.csv")
  f_all <- glue("{outdir}/LAI_ALL_8D_2000-2024_{subfix}.csv")

  # GLASS_G005
  print("Processing LAI_GLASS_G005 ...")
  fs <- dir2("Z:/Global/GlobalLAI/LAI_MODIS_GLASS/data", "G005")
  df_lai <- extract_rasts(fs, sp, dates) %>% rename(LAI_glass_G005 = value)
  fwrite(df_lai, f_glass_g005)

  # GLASS_G010
  print("Processing LAI_GLASS_G010 ...")
  fs <- dir2("Z:/Global/GlobalLAI/LAI_MODIS_GLASS/data", "G010")
  df_lai <- extract_rasts(fs, sp, dates) %>% rename(LAI_glass_G010 = value)
  fwrite(df_lai, f_glass_g010)

  # WHIT_V016
  print("Processing LAI_WHIT_V016 ...")
  ra <- rast("Z:/DATA/ERA5L/LAI_Global_2000-2024_WHIT_V016.nc")
  df_lai <- extract_rast(ra, sp) %>% rename(LAI_whit = value)
  fwrite(df_lai, f_whit_v016)

  lst_lai <- list(
    LAI_GLASS_G005 = fread(f_glass_g005),
    LAI_GLASS = fread(f_glass_g010),
    LAI_WHIT = fread(f_whit_v016)
  )
  df_lai <- purrr::reduce(lst_lai, merge, all = TRUE)
  fwrite(df_lai, f_all)
}

## 采用na.approx对LAI进行线性插值
#' @importFrom Ipaper which.notna
approx_LAI <- function(t, y, tout) {
  inds <- which.notna(y)
  t <- t[inds]
  y <- y[inds]

  # rule=2, if x out range, use nearest
  yout = approx(t, y, xout = tout, rule = 2)$y
  yout
  # data.table(date = tout, value = yout)
}
