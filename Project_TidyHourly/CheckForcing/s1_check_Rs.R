# %%
SITE = "CRO_冬小麦夏玉米_固城"
SITE = "GRA_典型草原_多伦"
SITE = "GRA_高寒草甸_海北"
SITE = "GRA_典型草原_多伦"
SITE = "ENF_北方林森林_呼中"

d <- Met[site == SITE, .(time, Rs)]
d[, .(n_valid = sum(!is.na(Rs))), .(hour = hour(time))]


# %%
# magrittr
f = "data-raw/Hourly/CRO_冬小麦夏玉米_固城_30min_FluxMet_2020_2022.csv"
f <- "data-raw/Hourly/GRA_典型草原_多伦_30min_FluxMet_2006_2015.csv"

l <- read_ufile(f)
d <- l$data %>%
  add_time() %>%
  .[, .(time, Rs)]
