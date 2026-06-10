# CLAUDE.md

中国通量站 ChinaFlux 数据清洗（R package `ChinaFlux`）。本文件聚焦
`Project_TidyHourly/` 下的**通量(Flux)与气象(Met)半小时数据融合**工作流。
站点元数据（从 MinerU 解析的 md 提取）的规则见 `AGENTS.md`。

## 目标

把每个站点原始的 `*_Met_30min_*.csv` 与 `*_Flux_30min_*.csv` 两张表，
统一变量名后按时间字段合并成一张 `FluxMet` 表，输出到 `data-raw/Hourly/`，
为碳水通量模型验证提供输入。

## 唯一入口：`merge_hourly_FluxMet()`

定义于 `R/merge_FluxMet.R`。两个驱动脚本——`tidy_hourly_CRO.R`（农田站）和
`tidy_hourly_Forest.Rmd`（森林/草地/湿地等其余植被类型）——都只是**每个站点
调用一次**该函数，传入 4 个核心参数：

```r
merge_hourly_FluxMet(f_met, SITE, VegType, VegName, ..., f_flux = NULL)
```

- `f_met`  —— Met 文件路径；`f_flux` 默认由 `gsub("Met", "Flux", f_met)` 推断。
- `SITE`   —— 站点中文名，如 `"临泽"`。
- `VegType`—— 植被类型缩写：`CRO/DBF/EBF/ENF/MF/GRA/WSA/WET/SAV`。
- `VegName`—— 中文植被名，如 `"制种玉米"`。
- `f_flux` —— 仅当 Flux 文件名无法用 Met→Flux 替换得到时显式传入
  （见 `Rmd` 中燕山、海北湿地：一个 Met 对应多个 Flux 塔）。

文件名约定：输出为
`{VegType}_{VegName}_{SITE}_30min_FluxMet_{year_beg}_{year_end}.csv`，
同时写到原目录 `dir_root` 和 `outdir`。年份由 `str_year()` 从文件名里的两个
4 位数字提取。

## 关键的两阶段流程（容易踩坑）

`merge_hourly_FluxMet` 依赖一个**人工介入**的两步流程：

1. **首次运行**：若同目录下不存在 `VarNames_{SITE}_Met_{年}-{年}.csv`，
   函数只把 Met 表头写成该 VarNames 模板，提示「请人工修改变量名 VarNames」，
   用 `code()` 打开目录后 **return()**，不产出 FluxMet。
2. **人工编辑 VarNames 后再次运行**：`patch_varnames()` 读入 VarNames，
   将原始列名映射为标准名、把单位写到数据第 1 行，再与 Flux 表合并输出。

> 所以一个站点通常要跑两遍。第一遍生成 VarNames 让人改名，第二遍才出结果。
> 如果 VarNames 只有 1 行（表示站点列名规范、无需改），`patch_varnames`
> 直接采用原始数据并提示 "Raw data was adopted."。

合并逻辑：`by = intersect(names(d_flux), VARS_DATE)`，即按双方共有的时间列
（`year/month/day/hour/...` 及中文 `年/月/日/时/分/秒`、`date/time/doy`）做
`merge`。两表都先 `unique()` 去重、`rm_useless_cols()` 删掉 `second` 列。

## IO 辅助函数（`R/fread_glue.R`、`R/ultilize.R`）

- `fread_glue(f, ...)` —— 路径支持 `glue` 插值，自动 `unique()`；只保留第一行
  单位，删掉数据中混入的多余 `-`/`/` 单位行。
- `fwrite_glue(d, fout, overwrite=FALSE)` —— `glue` 路径、自动建目录、写 BOM。
  **默认不覆盖**已存在文件（仅 warning）；合并输出处显式传 `overwrite=TRUE`。
- `dir2(path, pattern)` —— `glue` + `dir()`，森林脚本用它在站点目录里按
  `"_Met_30min"` 模式定位文件。
- `str_year(f)` —— 取文件名中所有 4 位年份。

## 约定与注意

- 脚本头部统一 `pacman::p_load(...)` 加载依赖，`devtools::load_all(".")`
  加载本包；`outdir = "data-raw/Hourly"`。
- 单元格分隔用 `# %%`（R 脚本）或 `{r}` chunk（Rmd），按站点逐块执行，
  **不是**一次 source 整个文件。
- 同一行内常见数据修正（注释示例）：异常值置 `NA`、单位换算，如
  `l$data[TS_10cm > 100, TS_10cm := NA_real_]`、`albedo := albedo/1000`。
- 一个 Met 多个 Flux 的站点（如燕山三种林型、海北湿地）必须显式传 `f_flux`。
- 数据文件、VarNames 编码为 UTF-8，路径含中文，注意 Windows 下的编码。

## 目录速览

- `R/` —— 包源码；核心是 `merge_FluxMet.R`。
- `Project_TidyHourly/` —— 半小时数据融合驱动脚本（本文件主题）。
- `data-raw/ALL/` —— 各站点原始 Met/Flux/VarNames；`data-raw/Hourly/` 输出。
- `Mineru/` —— 各站点数据文章的 md 解析结果（站点元数据来源，详见 `AGENTS.md`）。
- 站点清单与已知问题见 `README.md`。
