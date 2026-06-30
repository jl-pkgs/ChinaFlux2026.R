# %% 
pacman::p_load(
    Ipaper, data.table, dplyr, lubridate, 
    ggplot2
)
setwd("data-raw/ALL/CRO_冬小麦夏玉米_固城_2020-2022/")
devtools::load_all("../..")



# %% 降雨资料较差
set_font()

f = "backup/固城_Met_30min_2020_2022.csv"
f = "/mnt/z/GitHub/jl-pkgs/ChinaFlux2026/data-raw/Hourly/CRO_冬小麦夏玉米_固城_30min_FluxMet_2020_2022.csv"

l = read_ufile(f)
l$data[Prcp > 30, Prcp := NA_real_]

# write_ufile(l, basename(f))

d = l$data %>% add_time() %>% 
  .[, .(time, Prcp)]

d2 <- d[, sum(Prcp), .(time = floor_date(time, "hour"))]

xlims <- c(ymd_hm("2021-06-01 00:00"), ymd_hm("2021-07-25 23:59"))

summary(d)
summary(d2)

# %% 
p <- ggplot(d, aes(time, Prcp)) + 
    geom_line() + theme_bw() 
    # scale_x_datetime(limits = xlims)
write_fig(p, "./figs/prcp_hour.pdf")


# %% 

# %% 
# # A data frame: 14 × 2
#    floor_date              N
#    <dttm>              <int>
#  1 2021-06-12 00:00:00    10
#  2 2021-06-13 00:00:00    18
#  3 2021-06-14 00:00:00     1
#  4 2021-06-15 00:00:00    14
#  5 2021-06-16 00:00:00     8
#  6 2021-06-17 00:00:00    13
#  7 2021-06-18 00:00:00     7
#  8 2021-06-19 00:00:00    16
#  9 2021-06-20 00:00:00    11
# 10 2021-06-21 00:00:00     7
# 11 2021-06-22 00:00:00    15
# 12 2021-06-23 00:00:00    10
# 13 2021-06-24 00:00:00     9
# 14 2021-06-25 00:00:00    11
