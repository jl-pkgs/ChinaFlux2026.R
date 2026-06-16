# %%
devtools::load_all("../../..")
p_load(Ipaper, dplyr, ggplot2)


fix_names <- function(d) {
  rename_with(d, \(nms){
    str_replace_all(nms, c(
      "年" = "year", 
      "月" = "month", 
      "^日$" = "day", 
      "日平均|日" = ""
    ))
  })
}

# %%
fs <- dir2("./气象/日尺度/")

df <- map(fs, read_excel) %>% rbindlist()
inds_unit <- which(df$`年` == "/")[-1]
df <- df[-inds_unit, ]
df = fix_names(df)

fout = "data/三江源垂穗披-碱草人工草地_Met_日_2012_2016.csv"
fwrite(df, fout)

# %%
l <- read_ufile(fout)
l$data %<>% arrange(year, month, day)
# l$data[`一层土壤体积含水量` > 5.0, `一层土壤体积含水量` := 一层土壤体积含水量 / 100]
# l$data[`二层土壤体积含水量` > 5.0, `二层土壤体积含水量` := 二层土壤体积含水量 / 100]

# l$data[`一层土壤体积含水量` > 0.4, `一层土壤体积含水量` := NA_real_]
# l$data[`二层土壤体积含水量` > 0.4, `二层土壤体积含水量` := NA_real_]

# 一层土壤体积含水量, 二层土壤体积含水量在2016年数据异常，无法抢救，暂时置为NA
l$data[year == 2016, `:=`(
    `一层土壤温度` = NA_real_,
    `二层土壤温度` = NA_real_, 
    `一层土壤体积含水量` = NA_real_, 
    `二层土壤体积含水量` = NA_real_
)]

summary(l$data)
# l$data[`二层土壤体积含水量` > 1 | `一层土壤体积含水量` > 1, 
#     .(year, month, day, `一层土壤体积含水量`, `二层土壤体积含水量`)]
write_ufile(l, fout)

# %% 
dat <- l$data[, .(year, month, day, 
    SM1 = `一层土壤体积含水量`,
    SM2 = `二层土壤体积含水量`,
    SM3 = `三层土壤体积含水量`
    )] %>% 
    mutate(date = make_date(year, month, day)) %>%
    .[, .(date, SM1, SM2, SM3)] %>% 
    melt(c("date"))

p <- ggplot(dat, aes(date, value, color = variable)) + 
    geom_line() + 
    labs(x = NULL, y = "土壤体积含水量") + 
    theme_bw() + 
    theme(legend.title = element_blank())
write_fig(p, "a.pdf", 10, 5)
