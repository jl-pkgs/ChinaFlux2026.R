# ChinaFlux 半小时 Prcp 修复留档

> 4 站异常（盘锦/句容/金佛山/固城），2026-06-26 起，最终方案 06-28。
> 原则：个别站异常在各自目录清洗，公共管道只放通用规则。当前聚焦小时尺度，日降水问题暂缓。

## 状态

| 问题 | 状态 | 方案 |
|---|---|---|
| 聚合 `mean×N` 多算（盘锦 2×） | ✅ | 改 `sum` + `.SDcols` 排除 Prcp |
| 负缺测哨兵（13 站，-99999/-9999） | ✅ | `fix_Prcp_neg()`：Prcp<0→NA |
| 固城 2021-06 正向污染（150–3852mm） | ✅ | 固城目录 `check_prcp_*.R` 清洗后重合并 |
| 句容/金佛山 FluxLAI **日值**偏差 | ⏸ | 日尺度问题，暂缓（见待办） |
| 重跑 Rmd 重生输出 | ⬜ | 见待办 |

## 根因与解决

**聚合 bug**：Prcp 是累计量应 `sum`，旧码 `mean(na.rm)×N` 在有 NA 时多算 `N/N_present` 倍
（盘锦每小时「1 NA+1 实测」→ 恰好 2×）。改 `sum` 时须用 `.SDcols` 排除 Prcp，否则
`lapply(.SD, mean)` 会另生成同名 Prcp(均值)列顶替 sum、且 CSV 出现两列 Prcp。

```r
vars_mean <- setdiff(names(d), c("site", "time", "Prcp"))
d_hour <- d[, c(lapply(.SD, \(x) mean(x, na.rm = TRUE)),
                .(Prcp = sum(Prcp, na.rm = TRUE))),
            by = .(site, time = floor_date(time, "hour")), .SDcols = vars_mean]
```

> sum vs mean：实测雨时段「两槽相等」仅 12–18%，多为真实 30-min 观测 → `sum` 正确。

**负哨兵**：13 站（固城/禹城/西双版纳/千烟洲/燕山×3/锡林浩特/海北×2/三江源/鼎湖山/长白山）
Prcp 缺测写成负数。`fix_Prcp_neg()`（Prcp<0→NA）一条通用规则覆盖，对 -99999/-9999 混用均生效。

**固城污染**：源 csv 把累计值误填到 30min 槽。在固城目录单独清洗（`check_prcp_hour.R` 30min>30→NA、
`check_prcp_day.R` 日>200→NA），重合并。现 FluxMet max=30、无负值/无污染。早期为固城定制的
`fix_Prcp_rainy_day()`、`VARS_BOUNDS_30MIN` 会误删他站极值，已撤除。

## 代码改动

- `R/unify_unit.R`：新增 `fix_Prcp_neg()` 挂入 `unify_unit_hourly()`。
- `R/check_bounds.R`：`scale` 恢复 `c("daily","hourly")`。
- `ALL.Rmd` / `Forest/...sp12.Rmd`：聚合改 `sum` + `.SDcols`；移除 `check_bounds(scale="30min")`。
- 固城目录 `check_prcp_*.R`（站点级，不属公共管道）。

## 验证（sum 年合计 mm/yr）

```
盘锦   379 / 744 / 516          句容 1026 / 1555 / 827 / 479 / 780 / 486
金佛山 358 / 299                固城 清洗后 max 30mm/30min
```

盘锦 379 与 TODO `Prcp_d=379` 一致，确认 2× 源在 Rmd。

## 待办

- [ ] 重跑 `ALL.Rmd` 重生 `Forcing_Hourly_Met_sp31_*.csv`（版本号 `v20260614`→`v20260628`）。
- [ ] `check_Input.R` 单位自检重跑。
- [ ] ⏸ **日降水错误**（暂缓）：FluxLAI 日值端（句容 4–5× 缺失、金佛山 ~3× 多计）；固城源数据核实。
