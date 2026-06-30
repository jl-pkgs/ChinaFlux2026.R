# GRA_高寒草甸_若尔盖
# %% 
pacman::p_load(Ipaper, data.table, ggplot2)
devtools::load_all("../../")

# %% 
f = "backup/若尔盖_Met_30min_2015-2020.csv"
l = read_ufile(f)

l$data[year == 2016, WS_canopy := NA]
d = l$data %>% add_time()
write_ufile(l, basename(f)) # the last step

# %% 
d[WD == WS_canopy, .N, year]
d[WS_canopy > 50, .N, year]

# %% 
p <- ggplot(d, aes(time, WS_canopy)) +
  geom_line() +
  geom_hline(yintercept = 20, color = "red") +
#   scale_x_datetime(date_labels = "%Y-%m", date_breaks = "1 year") +
  labs(x = NULL, y = "WS_canopy (m/s)") +
  theme_bw()
write_fig(p, "WS_canopy.png")

# %% 结论
# 2016年风速数据异常，风速被记录为风向
