args <- commandArgs(trailingOnly = TRUE)
print(args)

library(Ipaper)
f = "GRA_那曲_高寒草甸_2014-2018_Day_Flux.xlsx"
fout = gsub(".xlsx", ".csv", f)

d = read_xlsx(f)
fwrite(d, fout, bom=TRUE)
