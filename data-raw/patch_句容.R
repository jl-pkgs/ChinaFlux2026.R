# %% 
devtools::load_all()

# %% 
f = "Z:/GitHub/jl-pkgs/ChinaFlux2026/data-raw/Hourly/CRO_水稻_句容_30min_FluxMet_201501-202012.csv"
l = read_ufile(f)
l$data %>% summary()

d = l$data %>% add_time()
d_SM = d[, .(SM = mean(SM, na.rm = TRUE)), .(date = date(time))] %>% 
  mutate(year = year(date), month = month(date), day = day(date)) %>%
  .[, .(year, month, day, SM)]
# %% 

f_day = "Z:/GitHub/jl-pkgs/ChinaFlux2026/data-raw/Daily/CRO_水稻_句容_Day_FluxMet_201501-202012.csv"

l <- read_ufile(f_day)
l$data %>% summary()
l$data %<>% merge(d_SM) #%>% summary()
l$unit %<>% cbind(SM = "m3 m-3")
write_ufile(l, f_day)
