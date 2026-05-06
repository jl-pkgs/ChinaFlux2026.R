#import "@preview/modern-cug-report:0.1.3": *
#show: doc => template(doc, footer: "ChinaFlux 2026", header: "")

#let Figure1(site) = {
  let file = "Figures/Flux/" + site + ".pdf"
  figure(
    image(file, width: 110%),
    caption: [
      #site
    ],
  )
}

#let Figure2(site) = {
  let file = "Figures/Met/" + site + "_Met.png"
  figure(
    image(file, width: 110%),
    caption: [
      #site
    ],
  )
}


= 1 Flux （日尺度）

#box-blue[无完美观测。最好用QC_flag过滤数据。]

#Figure1("DBF_天然栎林_宝天曼")
#Figure1("DBF_栓皮栎人工林_小浪底")
#Figure1("EBF_亚热带常绿阔叶林_金佛山")

#Figure1("EBF_橡胶林_海南儋州")
#box-red[
  *VPD* 2017异常偏高、2018缺乏观测。
]

#Figure1("EBF_橡胶林_西双版纳")
#box-red[
  `EBF_橡胶林_西双版纳` Rn在2014-2015存在数据错误（异常偏高）
]

#Figure1("EBF_热带雨林_西双版纳")
#box-red[
  *NEE, RE, GPP, ET*存在少许钉值。
]

#Figure1("ENF_人工针叶林_千烟洲")
#Figure1("ENF_人工针叶林_燕山")
#Figure1("ENF_北方林森林_呼中")
#Figure1("MF_乔灌混交林_燕山")
#Figure1("MF_针阔混交_长白山")
#Figure1("MF_针阔混交_鼎湖山")


#pagebreak()

= 2 Met （小时尺度）

#Figure2("DBF_天然栎林_宝天曼")
#Figure2("DBF_栓皮栎人工林_小浪底")

#Figure2("EBF_亚热带常绿阔叶林_金佛山")

#box-red[
  WS_canopy存在连续钉值，超过10m/s的风速可疑。
]

#Figure2("EBF_橡胶林_海南儋州")
#Figure2("EBF_橡胶林_西双版纳")
#Figure2("EBF_热带雨林_西双版纳")

#Figure2("ENF_人工针叶林_千烟洲")

#Figure2("ENF_北方林森林_呼中")

#box-red[
  Prcp缺失率过高，50%-60%。
]

#Figure2("ENF_人工针叶林_燕山")

#box-red[
  仅2年数据。
  Rln_in观测质量不佳，缺失率过高。Prcp观测缺失率20%。
]

#Figure2("MF_乔灌混交林_燕山")

同上。

#Figure2("MF_针阔混交_长白山")

#Figure2("MF_针阔混交_鼎湖山") // 图24


= Notes

- `EBF_橡胶林_西双版纳`: glass_LAI存在明显趋势，明显错误。应使用LAI_whit。

- `MF_乔灌混交林_燕山`: 只有两年数据，生长季1个月的Rs数据存在bug。

