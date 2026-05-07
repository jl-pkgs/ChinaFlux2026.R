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

#let Figure3(site) = {
  let file = "SoilOBS/" + site + "_SM&TS_hourly.pdf"
  figure(
    image(file, width: 110%),
    caption: [
      #site
    ],
  )
}

= 1 SM & TS （日尺度）

#Figure3("DBF_天然栎林_宝天曼")
#Figure3("DBF_栓皮栎人工林_小浪底")
#Figure3("EBF_亚热带常绿阔叶林_金佛山")

#Figure3("EBF_橡胶林_海南儋州")
#Figure3("EBF_橡胶林_西双版纳")
#Figure3("EBF_热带雨林_西双版纳")

#Figure3("ENF_人工针叶林_千烟洲")
#Figure3("ENF_北方林森林_呼中")
#Figure3("MF_针阔混交_长白山")
#Figure3("MF_针阔混交_鼎湖山")


#pagebreak()

= 2 丢弃部分

#Figure3("ENF_人工针叶林_燕山")

#Figure3("MF_乔灌混交林_燕山")

#box-red[
  燕山观测质量不佳，这次先不采用。
]
