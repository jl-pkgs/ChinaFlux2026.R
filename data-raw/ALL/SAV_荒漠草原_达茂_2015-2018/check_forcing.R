# %%
pacman::p_load(Ipaper, ggplot2)
devtools::load_all("../..") # ChinaFlux2026


# %% 
f = "backup/SAV_荒漠草原_达茂_FluxMet_30min_2015-2018.csv"
l = read_ufile(f)
l$data[WS_canopy > 20, WS_canopy := NA]
write_ufile(l, basename(f))

d = l$data %>% add_time()

# %% 
p <- ggplot(d, aes(x = time, y = WS_canopy)) +
  geom_line() +
  theme_minimal()
write_fig(p, "WS_canopy.png", width = 10, height = 4)
