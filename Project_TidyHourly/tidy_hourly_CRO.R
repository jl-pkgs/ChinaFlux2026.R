# %% load pkg
pacman::p_load(
  Ipaper, data.table, dplyr, lubridate,
  ggplot2, gg.layers, patchwork
)

devtools::load_all(".")
outdir = "data-raw/Hourly"
# guess_fout <- function(f_met, outdir) {
#   sprintf("%s/%s", outdir, gsub("Met", "FluxMet", basename(f_met)))
# }

# %% 1 临泽
f_met = "data-raw/ALL/ChinaFlux_CRO_临泽_2012-2015/临泽_30min_Met_2012_2015.csv"
SITE = "临泽"
VegType = "CRO"
VegName = "制种玉米"
merge_hourly_FluxMet(f_met, SITE, VegType, VegName)
# l$data[SM_10cm == 0, SM_10cm := NA_real_] %>% invisible()
# l$data[TS_10cm > 100, TS_10cm := NA_real_] %>% invisible()


# %% 2 固城
# l2$data[albedo > 100, albedo := albedo / 1000] %>% invisible()
f_met <- "data-raw/ALL/ChinaFlux_CRO_固城_冬小麦夏玉米_2020-2022/固城_Met_30min_2020_2022.csv"
SITE <- "固城"
VegType <- "CRO"
VegName = "冬小麦夏玉米"
merge_hourly_FluxMet(f_met, SITE, VegType, VegName)


# %% 3 禹城
f_met = "data-raw/ALL/ChinaFlux_CRO_禹城_2003-2010/禹城_Met_30min_2003_2010.csv"
SITE <- "禹城"
VegType <- "CRO"
VegName <- "冬小麦夏玉米"
merge_hourly_FluxMet(f_met, SITE, VegType, VegName)


# %% 4 CRO 盘锦 稻田
f_met = "data-raw/ALL/ChinaFlux_CRO_盘锦_稻田-2018-2020/盘锦-稻田站_Met_30min_2018-2020.csv"
SITE <- "盘锦"
VegType <- "CRO"
VegName <- "水稻"
merge_hourly_FluxMet(f_met, SITE, VegType, VegName)


# %% 5 CRO 锦州 春玉米
f_met = "data-raw/ALL/ChinaFlux_CRO_锦州_2005-2014/锦州_Met_30min_2005_2014.csv"
SITE <- "锦州"
VegType <- "CRO"
VegName <- "春玉米"
merge_hourly_FluxMet(f_met, SITE, VegType, VegName)


# %% CRO 长岭 水稻（东北）
f_met = "data-raw/ALL/ChinaFlux_CRO_长岭_稻田_2020/长岭_水稻_Met_30min_2018-2020.csv"
SITE = "长岭"
VegType = "CRO"
VegName = "水稻"
merge_hourly_FluxMet(f_met, SITE, VegType, VegName)
