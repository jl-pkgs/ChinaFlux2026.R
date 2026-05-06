# %% 
pacman::p_load(
  Ipaper,
  data.table,
  dplyr,
  lubridate,
  ggplot2,
  gg.layers
)

# %%
df = fread("data-raw/BEPS/Forcing_Met_Hourly_BEPS_Forest_sp12_v20260506.csv")

# %% 
outdir = "data-raw/BEPS/Figures/Met"

plot_met <- function(SITE) {
  fout = glue("{outdir}/{SITE}_Met.png")
  isfile(fout) && return()

  d = df[site == SITE] %>% melt(c("site", "time"))

  p <- ggplot(d, aes(time, value)) +
    geom_line() +
    facet_wrap(~variable, scales = "free_y") +
    theme_bw()
  write_fig(p, fout, 14, 7, show = FALSE)
}

map(unique(df$site), plot_met)
