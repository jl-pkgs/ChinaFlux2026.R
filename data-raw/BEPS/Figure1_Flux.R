pacman::p_load(
  Ipaper,
  data.table,
  dplyr,
  lubridate,
  ggplot2,
  gg.layers
)


# ERA5L数据热带Tair不全，奇怪。Tair不予采用。
df_lai = fread("data-raw/BEPS/Forcing_LAI_Daily_BEPS_Forest_sp12_v20260506.csv")
df_flux = fread(
  "./data-raw/BEPS/Forcing_Flux_Daily_BEPS_Forest_sp12_v20260506.csv"
)
df = merge(df_flux, df_lai, by = c("site", "date")) %>% select(-Tavg)
fwrite(df, "data-raw/BEPS/Forcing_FluxLAI_Daily_BEPS_Forest_sp12_v20260506.csv", bom = TRUE)

sites = df$site %>% unique_sort()
d = df[site == sites[1]] %>%
  melt(c("site", "name", "date"))

# %%
outdir = "data-raw/BEPS/Figures"
foreach(SITE = sites, i = icount()) %do%
  {
    fout = glue("{outdir}/{SITE}.pdf")
    d = df[site == SITE] %>% melt(c("site", "name", "date"))

    p <- ggplot(d, aes(date, value)) +
      geom_line() +
      facet_wrap(~variable, scales = "free_y") +
      theme_bw()

    write_fig(p, fout, 14, 7, show = FALSE)
  }
