# %% 
devtools::load_all("../../..")
p_load(Ipaper)

# %% 
# [kJ m2 d-1] to [W m-2]
fix_unit <- \(x) x * 1000 / 86400

f = "海北_Flux_day_2011-2020.csv"
l <- read_ufile(f)

l$data %<>% 
    mutate(
        LE = fix_unit(LE), 
        Hs = fix_unit(Hs)
    )
write_ufile(l, f)
