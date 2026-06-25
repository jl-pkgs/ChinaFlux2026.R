# 1 BEPS驱动

## 1.1 Hourly气象驱动

```r
f = "/mnt/z/GitHub/jl-pkgs/ChinaFlux2026/data-raw/Forcing_Hourly_Met_sp31_v20260614.csv"
d_met = fread(f)
head(d_met)
```

```r
                    site                time Ta_canopy RH_canopy WS_canopy       Rs Rln_in  Prcp
                  <char>              <POSc>     <num>     <num>     <num>    <num>  <num> <num>
      1: CRO_春玉米_锦州 2005-01-01 00:00:00 -12.18103  52.66133 0.7565360 2.454305     NA     0
      2: CRO_春玉米_锦州 2005-01-01 01:00:00 -12.62179  53.43525 0.7984216 2.455316     NA     0
      3: CRO_春玉米_锦州 2005-01-01 02:00:00 -12.81463  54.02200 0.8661329 3.659513     NA     0
      4: CRO_春玉米_锦州 2005-01-01 03:00:00 -13.18538  54.75006 0.8036139 3.664217     NA     0
      5: CRO_春玉米_锦州 2005-01-01 04:00:00 -13.50755  55.45962 0.7975148 3.658892     NA     0
```

单位都已经转为标准单位：[{
    site:"/",
    time:"/",
    Ta_canopy:"°C",
    RH_canopy:"%",
    WS_canopy:"m s-1",
    Rs:"W m-2",
    Rln_in:"W m-2",
    Prcp:"mm"
  }]

## 1.2 Daily验证数据

需要ET, GPP, SM_*, TS_*。

同时LAI数据也在该文件。

```r
f = "/mnt/z/GitHub/jl-pkgs/ChinaFlux2026/data-raw/Daily_FluxALL/CRO_冬小麦夏玉米_固城_Daily_FluxALL_v20260615.csv"
d_flux = fread(f)
head(d_flux)
```

```r
[data.table]: 
# A data frame: 6 × 18
  date         NEE    RE   GPP    ET    Rn    Rs    LE    Hs     Ta    RH    WS  Prcp SM_L1       G TS_4cm_N TS_4cm_S
  <IDate>    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl>   <dbl>    <dbl>    <dbl>
1 2020-01-01 0.883  2.59 1.71  0.531  6.05  89.6  15.4  5.75 -5.53   41.2 0.656   0   0.123 -16.1     -2.42    -3.37 
2 2020-01-02 1.19   2.09 0.892 1.18   3.66  74.5  34.3 -4.26 -3.63   43.6 0.463   0   0.126 -12.3     -2.02    -2.77 
3 2020-01-03 0.958  2.07 1.11  0.508  9.11  82.9  14.7  5.81 -2.05   51.1 0.366   0   0.129  -9.17    -1.66    -2.05 
4 2020-01-04 0.494  2.02 1.53  0.640 11.5   87.0  18.5  3.41 -0.673  52.3 0.544   0   0.133  -6.95    -1.29    -1.50 
5 2020-01-05 0.373  2.10 1.73  0.402  5.36  31.3  11.6  6.39 -0.554  76.3 1.64    0   0.130  -5.34    -0.980   -1.12 
6 2020-01-06 0.450  2.08 1.63  0.353  6.62  48.9  10.2  2.56 -0.199  92.9 0.426   2.6 0.141   0.232   -0.260   -0.217
# ℹ 1 more variable: SM_4cm_N <dbl>
```

单位都已经转为标准单位：[{
    date:"/",
    NEE:"gC m-2 d-1",
    RE:"gC m-2 d-1",
    GPP:"gC m-2 d-1",
    ET:"mm d-1",
    Rn:"W m-2",
    Rs:"W m-2",
    LE:"W m-2",
    Hs:"W m-2",
    Ta:"°C",
    RH:"%",
    WS:"m s-1",
    Prcp:"mm d-1",
    SM_L1:"m3 m-3",
    G:"W m-2",
    TS_4cm_N:"°C",
    TS_4cm_S:"°C",
    SM_4cm_N:"m3 m-3"
  }]

## 1.3 Metadata（站点元数据）

读取站点元数据

```r
f = "/mnt/z/GitHub/jl-pkgs/ChinaFlux2026/data/Metadata/ChinaFlux_Metadata.csv"
d_meta = read.csv(f, fileEncoding = "GBK", stringsAsFactors = FALSE)
head(d_meta)
```

```r
                         site      lon      lat VegType        SoilType
1     DBF_栓皮栎人工林_小浪底 112.4689 35.02917     DBF            loam
2         DBF_天然栎林_宝天曼 111.9353 33.49972     DBF            loam
3       EBF_热带雨林_西双版纳 101.2500 21.91667     EBF       clay_loam
4         EBF_橡胶林_海南儋州 109.4750 19.54639     EBF sandy_clay_loam
5         EBF_橡胶林_西双版纳 101.2667 21.90000     EBF       clay_loam
6 EBF_亚热带常绿阔叶林_金佛山 107.1508 29.02170     EBF       clay_loam
                                                                  SoilType_CN
1                                              棕壤和石灰岩风化母质淋溶性褐土
2 山地棕壤为主,土层厚度在40~100cm 之间。山地棕壤、山地黄棕壤和山地褐土3个土类
3                                                以砖红壤为主，局部伴生赤红壤
4                                    花岗岩风化而成的砖红壤，多\n为沙质粘壤土
5                                             砖红壤/赤红壤；壤土—黏壤土—黏土
6        石灰土，伴有少量棕黄壤，基岩地层以寒武纪、奥陶纪的石灰岩、白云岩为主
                    z_TS                   z_SM z_Uz z_overstory
1              0,5,10,20                5,10,20 36.0          11
2                   5,20               10,20,50 22.0          20
3         0,40,60,80,100                5,20,40 42.0          35
4              2,5,20,50                5,20,50 33.0          18
5             0,5,20,100               5,20,100 28.9          21
6 10,20,40,60,80,120,160 10,20,40,60,80,120,160 24.0          16
```

单位都已经转为标准单位：[{
    site:"/",
    lon:"°",
    lat:"°",
    VegType:"/",
    SoilType:"/",
    SoilType_CN:"/",
    z_TS:"cm",
    z_SM:"cm",
    z_Uz:"m",
    z_overstory:"m"
  }]
