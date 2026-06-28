# %% 
pacman::p_load(
    Ipaper, data.table, dplyr, lubridate, 
    ggplot2
)

devtools::load_all("../..")
# %% 降雨资料较差
set_font()

f = "./固城_Met_日_2020_2022.csv"
l = read_ufile(f)
l$data[Prcp > 200, Prcp := NA_real_]

write_ufile(l, f)


# %% 
d = l$data %>% add_date()
# d[Prcp > 100, .(time, Prcp)]
# d[Prcp > 200, Prcp := NA_real_]
xlims <- c(ymd_hm("2021-06-01 00:00"), ymd_hm("2021-07-25 23:59"))

p <- ggplot(d, aes(date, Prcp)) + 
    geom_line() + theme_bw()
    # scale_x_datetime(limits = xlims)
write_fig(p, "./figs/prcp.pdf")
