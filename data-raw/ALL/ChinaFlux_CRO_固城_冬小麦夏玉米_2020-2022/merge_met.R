pacman::p_load(
    Ipaper, data.table, dplyr, lubridate, stringr
)

fs = dir2("./气象数据集/", "日")

d = map(fs, read_excel) %>% rbindlist()
names(d)[1:3] <- c("year", "month", "day")

d = rename_with(d, \(x) {
    str_replace_all(x, c(
        "_probe_(Avg|avg)" = "",
        "_density_Avg" = "",
        "_Avg|_meas|_raw" = "",
        "R_SW" = "Rs",
        "R_LW" = "Rln", 
        "Precipitation_Tot" = "Prcp", 
        "shf_plate" = "G"
    ))
})

fwrite(d, "固城_Met_日_2020_2022.csv", bom=TRUE)
