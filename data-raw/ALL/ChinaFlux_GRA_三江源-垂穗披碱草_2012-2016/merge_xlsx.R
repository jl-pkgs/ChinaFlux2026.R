# %% 
devtools::load_all("../../..")
library(Ipaper)

# %% 
fs = dir2("./气象/日尺度/")

df = map(fs, read_excel) %>% rbindlist()
inds_unit = which(df$`年` == '/')[-1]
df = df[-inds_unit, ]

fout = "data/三江源垂穗披-碱草人工草地_Met_日_2012_2016.csv"
fwrite(df, fout)

# %% 
l <- read_ufile(fout)$data 
summary(l)
