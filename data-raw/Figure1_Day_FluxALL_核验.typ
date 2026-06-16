#import "@preview/modern-cug-report:0.1.3": *
#show: doc => template(doc, footer: "ChinaFlux 2026", header: "")

#let version = "v20260615"

#let Figure1(site) = {
  let file = "Daily_FluxALL/" + site + "_Daily_FluxALL_" + version + ".pdf"
  figure(
    image(file, width: 110%),
    caption: [
      *#site* 气象与通量数据日尺度时间序列。
    ],
  )
}

#let sites = (
  "CRO_典型粮草_庆阳",
  "CRO_冬小麦夏玉米_固城",
  "CRO_冬小麦夏玉米_栾城",
  "CRO_冬小麦夏玉米_禹城",
  "CRO_制种玉米_临泽",
  "CRO_春玉米_锦州",
  "CRO_水稻_句容",
  "CRO_水稻_盘锦",
  "CRO_水稻_长岭",
  "DBF_天然栎林_宝天曼",
  "DBF_栓皮栎人工林_小浪底",
  "DBF_温带落叶阔叶林_帽儿山",
  "EBF_亚热带常绿阔叶林_哀牢山",
  "EBF_亚热带常绿阔叶林_金佛山",
  "EBF_橡胶林_海南儋州",
  "EBF_橡胶林_西双版纳",
  "EBF_热带雨林_西双版纳",
  "ENF_人工针叶林_千烟洲",
  "ENF_人工针叶林_燕山",
  "ENF_北方林森林_呼中",
  "GRA_人工垂穗披碱草_三江源",
  "GRA_典型草原_多伦",
  "GRA_典型草原_锡林浩特",
  "GRA_刈割草原_锡林浩特",
  "GRA_稀树草原_元江",
  "GRA_高寒草甸_当雄",
  "GRA_高寒草甸_海北",
  "GRA_高寒草甸_若尔盖",
  "GRA_高寒草甸_那曲",
  "MF_乔灌混交林_燕山",
  "MF_针阔混交_长白山",
  "MF_针阔混交_鼎湖山",
  "SAV_荒漠草原_达茂",
  "WET_南荻湿地_洞庭湖",
  "WET_崇明东滩",
  "WET_芦苇湿地_盘锦",
  "WET_高寒湿地_海北",
  "WSA_灌丛_燕山",
  "WSA_退耕还林_普定",
  "WSA_高寒灌丛_海北",
)

= 1 Flux （日尺度）

#for site in sites {
  Figure1(site)
}



#pagebreak()

= 2 总结

- [x] `CRO_冬小麦夏玉米_固城`: SM_4cm_S数值偏高（0.5~0.6），变量移除

- [x] `CRO_冬小麦夏玉米_禹城`: SM_20cm基本无观测，移除

- [x] `GRA_人工垂穗披碱草_三江源`: 2016年SM_5cm, SM_15cm, TS_5cm, TS_15cm数据均值错误，全部移除

- [x] `CRO_水稻_句容`：日尺度SM观测全部为0；但hourly数据正常，从hourly数据中补充。

- [x] `CRO_水稻_盘锦`: RH 2021 unit为1；G 2021异常偏高；已手动移除。

- [x] `MF_乔灌混交林_燕山`: flux数据质量较差，仅1年可用数据。舍弃之。

- [x] `WET_高寒湿地_海北`: SM_3全部为NA, 删除之
