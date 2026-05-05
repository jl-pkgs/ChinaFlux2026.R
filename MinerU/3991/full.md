ISSN 2096-2223 CN 11-6035/N

![](images/4a90d9e6a2ae9e74868a07ceb066e95d1d26e5a82b8c62c1b37d11c5b993c804.jpg)

文献 CSTR：32001.14.11-6035.csd.2023.0103.zh文献 DOI：10.11922/11-6035.csd.2023.0103.zh数据 DOI：10.57760/sciencedb.o00119.00048文献分类：生物学

![](images/4f94b922b4032b3b84a78efb40661efbd355fad1f59a94844700c1ba12760231.jpg)

收稿日期：2023-05-09  
开放同评：2023-05-17  
录用日期：2023-07-11  
发表日期：2023-09-05

\* 论文通信作者 汤旭光：xgtang@swu.edu.cn

# 2020–2021 年金佛山亚热带常绿阔叶林碳水通量观测数据集

汤旭光 1\*，孔德兵 1，陈亚楠 1，李元庆 1，钱凤 1，丁智 1，

马明国

1. 西南大学，地理科学学院，重庆金佛山喀斯特生态系统国家野外科学观测研究站，重庆 400715

摘要：重庆金佛山喀斯特生态系统国家野外科学观测研究站于 2020 年 12 月被列入国家野外站择优建设名单，其主观测场以亚热带常绿阔叶林生态系统为研究对象，基于微气象学理论的涡度相关技术开展碳水通量的长期定位观测。本数据集为金佛山亚热带常绿阔叶林 2020–2021 年通量观测数据，基于 ChinaFLUX 数据处理体系，观测数据经质量控制和评估后，经插补和拆分形成了标准化的生态系统碳水通量和关键气象要素数据集。数据指标包含生态系统净碳交换量、总初级生产力、生态系统呼吸、潜热通量、显热通量等，以及空气温/湿度、风速/风向、土壤温/湿度、降水、太阳下行短波辐射、净辐射和光合有效辐射等。本数据集可以为分析我国典型森林生态系统的碳源/汇动态、碳水耦合特征及其对全球气候变化的响应机制提供重要的基础数据。

关键词：涡动相关；碳水循环；通量观测；金佛山；常绿阔叶林

数据库（集）基本信息简介  

<table><tr><td rowspan=1 colspan=1>数据库（集）名称</td><td rowspan=1 colspan=1>2020-2021年金佛山亚热带常绿阔叶林碳水通量观测数据集</td></tr><tr><td rowspan=1 colspan=1>数据通信作者</td><td rowspan=1 colspan=1>汤旭光（xgtang@swu.edu.cn）</td></tr><tr><td rowspan=1 colspan=1>数据作者</td><td rowspan=1 colspan=1>汤旭光、孔德兵、陈亚楠、李元庆、钱凤、丁智、马明国</td></tr><tr><td rowspan=1 colspan=1>数据时间范围</td><td rowspan=1 colspan=1>2020-2021年</td></tr><tr><td rowspan=1 colspan=1>地理区域</td><td rowspan=1 colspan=1>重庆市南川区金佛山国家野外站烂坝箐观测场（107.1508E，29.0217N，海拔1543 m)</td></tr><tr><td rowspan=1 colspan=1>生态系统类型</td><td rowspan=1 colspan=1>亚热带常绿阔叶林</td></tr><tr><td rowspan=1 colspan=1>数据量</td><td rowspan=1 colspan=1>36.1 MB</td></tr><tr><td rowspan=1 colspan=1>数据格式</td><td rowspan=1 colspan=1>*.xlsx</td></tr><tr><td rowspan=1 colspan=1>数据服务系统网址</td><td rowspan=1 colspan=1>http://dx.doi.org/10.57760/sciencedb.o00119.00048</td></tr><tr><td rowspan=1 colspan=1>基金项目</td><td rowspan=1 colspan=1>科技部基础资源调查专项（2021FY100701）</td></tr><tr><td rowspan=1 colspan=1>数据库（集）组成</td><td rowspan=1 colspan=1>本数据集共4个EXCEL数据文件，分为通量数据和气象数据两类。数据指标包含生态系统净碳交换量、总初级生产力、生态系统呼吸、潜热通量、显热通量等，以及空气温/湿度、风速/风向、土壤温/湿度、降水、太阳下行短波辐射、净辐射和光合有效辐射等。观测数据经插补和拆分形成标准化数据产品。气象数据分为10min、30min、日、月和年尺度，通量数据分为30min、日、月和年尺度。</td></tr></table>

# 引 言

重庆金佛山喀斯特生态系统国家野外科学观测研究站（以下简称金佛山国家站）于 2020 年 12月被列入国家野外站择优建设名单，针对西南喀斯特地区生态环境问题，在重庆市南川区金佛山国家级自然保护区周边区域，以“一站多点”模式，对典型生态系统的水、土、气、生等关键要素和生态水文过程已持续开展了10 余年观测研究，积累了丰富的数据资源。该区域属亚热带湿润季风气候，冬短、春早、夏长，雨热同季，年均气温 $8 . 2 ^ { \circ } \mathrm { C }$ ，年降水量 1434 mm[1]。作为我国西南地区罕见的生物基因库，金佛山国家级自然保护区也是同纬度喀斯特地区生物多样性最丰富的地区之一，濒危、特有、模式及孑遗物种保存较好且成片分布，如银杉（Cathaya argyrophylla）、珙桐（Davidiainvolucrata）、金佛山兰（Tangtsinia nanchuanica S. C. Chen）、林麝（Moschus berezovskii）、白颊黑叶猴（Presbytisfransoisi）、金佛山拟小鲵（Pseudohynobius jinfo）等。

金佛山国家站主观测场位于烂坝箐天然次生林，地处金佛山相对平坦的西坡半山坡，土壤类型主要为石灰土，伴有少量棕黄壤，基岩地层以寒武纪、奥陶纪的石灰岩、白云岩为主。植被群落以常绿阔叶林为主，人类耕作活动大约在 60–70 年前退出。观测场植被类型丰富，乔、灌、草垂直结构明显，形成独特的森林景观，主要优势树种有美丽新木姜子（Neolitsea pulchella (Meissn.) Merr.）、雷公鹅耳枥（Carpinus viminea Lindley）、金山杜鹃（Rhododendron longipes var. chienianum）、山矾（Symplocos sumuntia Buch.-Ham. ex D. Don）、柃木（Eurya japonica Thunb.）等。观测场内林木密度约为 1423 株 $\cdot / \mathrm { h m } ^ { 2 }$ ，平均胸径约为 $1 8 . 6 3 \pm 5 . 6 3 \mathrm { c m }$ ，平均树高约为 $1 6 . 3 3 \pm 3 . 2 4 \mathrm { m }$ 。亚热带常绿阔叶林作为陆地上最为典型的森林生态系统类型之一，在固碳增汇、调节大气、保持水土、涵养水源及维持生物多样性等方面发挥着重要作用[2-3]。

本研究基于中国通量观测研究网络（Chinese Flux Observation and Research Network, ChinaFLUX）标准化的通量观测数据处理体系，整理了 2020–2021 年金佛山亚热带常绿阔叶林碳水通量和关键气象要素数据集。本数据集针对西南喀斯特地区亚热带常绿阔叶林开展持续观测，获取精细化碳、水通量等微气象观测数据，能够为开展亚热带常绿阔叶林生态系统碳、水循环特征及环境控制机制、全球变化与人类活动影响下的生态系统响应、以及区域碳收支贡献评估等方面研究提供数据支撑。

# 数据采集和处理方法

通量观测塔位于金佛山国家站烂坝箐天然次生林观测场（ $( 1 0 7 . 1 5 0 8 ^ { \circ } \mathrm { E } , 2 9 . 0 2 1 7 ^ { \circ } \mathrm { N }$ ，海拔 $1 5 4 3 \mathrm { m }$ ，坡度为 $9 . 4 ^ { \circ }$ ，坡向为正南向），自2019年底开始观测，塔高 $^ { 2 8 \mathrm { m } }$ （图1）。数据采集分为通量数据和气象数据两部分，分别安装有 1套闭路涡度相关系统CPEC310和1套自动气象站。主要观测指标及传感器相关信息如表1，其中CPEC310是成套的闭路涡度相关通量观测系统，适用于长期定位观测大气边界层中 $\mathrm { C O } _ { 2 }$ 、水和能量的交换。

![](images/18a84ebae8e8baa877ca89173a5dfe4ea7fc46addcaf2ac7e7981857f3cf8598.jpg)  
图 1 金佛山国家站通量观测塔

Figure 1 The flux tower of the Chongqing Jinfo Mountain Karst Ecosystem National Observation and Research

Station

表 1 通量观测场主要观测指标及传感器信息  
Table 1 Main observation indices typically monitored at the flux site and the associated sensor information   

<table><tr><td rowspan=1 colspan=1>观测系统</td><td rowspan=1 colspan=1>观测指标</td><td rowspan=1 colspan=1>传感器型号</td><td rowspan=1 colspan=1>传感器制造商</td><td rowspan=1 colspan=1>数据采集器</td><td rowspan=1 colspan=1>数据采集器制造商</td></tr><tr><td rowspan=10 colspan=1>常规气象观测要素</td><td rowspan=1 colspan=1>气压</td><td rowspan=1 colspan=1>PTB110</td><td rowspan=1 colspan=1>Vaisala</td><td rowspan=12 colspan=1>CR6-ST</td><td rowspan=12 colspan=1>Campbell</td></tr><tr><td rowspan=1 colspan=1>空气温/湿度</td><td rowspan=1 colspan=1>HMP155A</td><td rowspan=1 colspan=1>Vaisala</td></tr><tr><td rowspan=1 colspan=1>风速/风向</td><td rowspan=1 colspan=1>Windsonic</td><td rowspan=1 colspan=1>Gill</td></tr><tr><td rowspan=1 colspan=1>辐射四分量</td><td rowspan=1 colspan=1>CNR4</td><td rowspan=1 colspan=1>Kipp &amp; Zonen</td></tr><tr><td rowspan=1 colspan=1>降水量</td><td rowspan=1 colspan=1>TB6</td><td rowspan=1 colspan=1>HyQuestSolutions</td></tr><tr><td rowspan=1 colspan=1>光合有效辐射</td><td rowspan=1 colspan=1>LI-190R</td><td rowspan=1 colspan=1>LI-COR</td></tr><tr><td rowspan=1 colspan=1>土壤热通量</td><td rowspan=1 colspan=1>HFP01</td><td rowspan=1 colspan=1>Hukseflux</td></tr><tr><td rowspan=1 colspan=1>土壤温度</td><td rowspan=1 colspan=1>109-L</td><td rowspan=1 colspan=1>Campbell</td></tr><tr><td rowspan=1 colspan=1>土壤湿度</td><td rowspan=1 colspan=1>CS616</td><td rowspan=1 colspan=1>Campbell</td></tr><tr><td rowspan=1 colspan=1>土壤平均温度</td><td rowspan=1 colspan=1>AV-TCAV</td><td rowspan=1 colspan=1>AVALON</td></tr><tr><td rowspan=2 colspan=1>通量观测</td><td rowspan=1 colspan=1>CO2/HO红外分析仪</td><td rowspan=1 colspan=1>EC155</td><td rowspan=1 colspan=1>Campbell</td></tr><tr><td rowspan=1 colspan=1>三维超声风速仪</td><td rowspan=1 colspan=1>CSAT3A</td><td rowspan=1 colspan=1>Campbell</td></tr></table>

基于 EddyPro 涡度协方差数据处理软件（V6.1），对通量数据做后处理（图 2）。通量数据的处理流程主要分为两部分，首先是对 $1 0 \mathrm { H z }$ 的原始观测数据进行野点剔除、延迟时间校正、坐标旋转、频率响应订正、超声虚温修正和密度（WPL）校正等过程，计算得到30分钟的潜热、显热和 $\mathrm { C O } _ { 2 }$ 通量，然后进行数据的插补和拆分[3]。缺失数据插补方法具体为：对于短时间内（小于 2小时）缺失的通量和气象观测数据，采用线性内插的方式完成插补；对于长时间（小于2 小时）缺失的气象数据，采用平均日变化法，将缺失数据日前后各 4 天（共 8 天）每半小时值的平均值求出，对缺失的相应时段进行插补，而通量观测数据采用非线性回归模型进行插补。具体操作上，日间缺失数据利用碳通量与光合有效辐射之间的直角双曲线关系进行插补，夜间缺失数据则是利用生态系统呼吸与大气/土壤温度之间的指数关系进行插补。对于长期缺失的水汽通量数据，采用查表法进行插补。而后，采用非线性拟合法将净生态系统碳交换量（NEE）拆分为总初级生产力（GPP）和生态系统呼吸（RE）[4]。具体的数据处理方法、质量控制和数据格式参见张雷明等论文[5-6]。

![](images/3c66cfdc6861a452fad97f438535c28afe166117300a873fa2e5a79a11e2e2cb.jpg)  
图 2 通量观测数据处理流程  
Figure 2 Processing flow of the flux data

# 2 数据样本描述

本数据集为金佛山国家站亚热带常绿阔叶林 2020–2021 年连续 2 年的碳水通量观测数据，从类型上包括气象数据和通量数据两部分，共有4 个EXCEL 数据文件，数据量 $3 6 . 0 5 ~ \mathrm { M B }$ 。数据指标包含生态系统净碳交换量、总初级生产力、生态系统呼吸、潜热通量、显热通量等，以及空气温/湿度、风速/风向、土壤温/湿度、降水、太阳下行短波辐射、净辐射和光合有效辐射等。观测数据经质量控制和评估后，经插补和拆分形成标准化数据产品。气象数据分为 $1 0 \mathrm { { m i n } }$ 、 $3 0 \mathrm { { m i n } }$ 、日、月和年尺度，通量数据分为 $3 0 ~ \mathrm { m i n }$ 、日、月和年尺度。气象数据表头参数含义及单位如表2所示，通量数据表头参数含义及单位如表3所示。

# 表 2 主要气象观测数据说明

Table 2 Description of the main meteorological observation data   
表 3 主要通量观测数据说明  

<table><tr><td rowspan=1 colspan=1>序号</td><td rowspan=1 colspan=1>数据项</td><td rowspan=1 colspan=1>单位</td><td rowspan=1 colspan=1>安装高度</td><td rowspan=1 colspan=1>说明</td></tr><tr><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>年</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>年份</td></tr><tr><td rowspan=1 colspan=1>2</td><td rowspan=1 colspan=1>月</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>月份</td></tr><tr><td rowspan=1 colspan=1>3</td><td rowspan=1 colspan=1>日</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>日期</td></tr><tr><td rowspan=1 colspan=1>4</td><td rowspan=1 colspan=1>时</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>小时</td></tr><tr><td rowspan=1 colspan=1>5</td><td rowspan=1 colspan=1>分</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>分钟</td></tr><tr><td rowspan=1 colspan=1>6</td><td rowspan=1 colspan=1>Ta</td><td rowspan=1 colspan=1>℃</td><td rowspan=1 colspan=1>4 m/24 m</td><td rowspan=1 colspan=1>空气温度</td></tr><tr><td rowspan=1 colspan=1>7</td><td rowspan=1 colspan=1>RH</td><td rowspan=1 colspan=1>%</td><td rowspan=1 colspan=1>4 m/24 m</td><td rowspan=1 colspan=1>空气湿度</td></tr><tr><td rowspan=1 colspan=1>8</td><td rowspan=1 colspan=1>Press</td><td rowspan=1 colspan=1>hPa</td><td rowspan=1 colspan=1>1.5 m</td><td rowspan=1 colspan=1>大气压</td></tr><tr><td rowspan=1 colspan=1>9</td><td rowspan=1 colspan=1>DR</td><td rowspan=1 colspan=1>W m2</td><td rowspan=1 colspan=1>24 m</td><td rowspan=1 colspan=1>下行短波辐射</td></tr><tr><td rowspan=1 colspan=1>10</td><td rowspan=1 colspan=1>Rn</td><td rowspan=1 colspan=1>Wm2</td><td rowspan=1 colspan=1>24m</td><td rowspan=1 colspan=1>净辐射</td></tr><tr><td rowspan=1 colspan=1>11</td><td rowspan=1 colspan=1>WD</td><td rowspan=1 colspan=1>ms1</td><td rowspan=1 colspan=1>4 m/24 m</td><td rowspan=1 colspan=1>风速</td></tr><tr><td rowspan=1 colspan=1>12</td><td rowspan=1 colspan=1>WS</td><td rowspan=1 colspan=1>Deg</td><td rowspan=1 colspan=1>4 m/24 m</td><td rowspan=1 colspan=1>风向</td></tr><tr><td rowspan=1 colspan=1>13</td><td rowspan=1 colspan=1>PAR</td><td rowspan=1 colspan=1>μmol m2 s-1</td><td rowspan=1 colspan=1>24m</td><td rowspan=1 colspan=1>光合有效辐射</td></tr><tr><td rowspan=1 colspan=1>14</td><td rowspan=1 colspan=1>Ts</td><td rowspan=1 colspan=1>℃</td><td rowspan=1 colspan=1>地下10 cm,20 cm,40 cm, 60 cm,80 cm,120 cm,160 cm</td><td rowspan=1 colspan=1>土壤温度</td></tr><tr><td rowspan=1 colspan=1>15</td><td rowspan=1 colspan=1>MS</td><td rowspan=1 colspan=1>%</td><td rowspan=1 colspan=1>地下10 cm,20 cm, 40cm,60 cm,80 cm,120 cm,160 cm</td><td rowspan=1 colspan=1>体积含水量</td></tr><tr><td rowspan=1 colspan=1>16</td><td rowspan=1 colspan=1>Rain</td><td rowspan=1 colspan=1>mm</td><td rowspan=1 colspan=1>28m</td><td rowspan=1 colspan=1>累计值</td></tr><tr><td rowspan=1 colspan=1>17</td><td rowspan=1 colspan=1>E</td><td rowspan=1 colspan=1>kPa</td><td rowspan=1 colspan=1>23m</td><td rowspan=1 colspan=1>水汽压</td></tr></table>

Table 3 Description of the main flux observation data   

<table><tr><td rowspan=1 colspan=1>序号</td><td rowspan=1 colspan=1>数据项</td><td rowspan=1 colspan=1>单位</td><td rowspan=1 colspan=1>安装高度</td><td rowspan=1 colspan=1>说明</td></tr><tr><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>年</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>年份</td></tr><tr><td rowspan=1 colspan=1>2</td><td rowspan=1 colspan=1>月</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>月份</td></tr><tr><td rowspan=1 colspan=1>3</td><td rowspan=1 colspan=1>日</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>日期</td></tr><tr><td rowspan=1 colspan=1>4</td><td rowspan=1 colspan=1>时</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>小时</td></tr><tr><td rowspan=1 colspan=1>5</td><td rowspan=1 colspan=1>分</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>分钟</td></tr><tr><td rowspan=1 colspan=1>6</td><td rowspan=1 colspan=1>NEE</td><td rowspan=1 colspan=1>g C m2d-1</td><td rowspan=1 colspan=1>23 m</td><td rowspan=1 colspan=1>生态系统净碳交换量（NEE值为负值表示生态系统是碳汇功能，反之为碳源)</td></tr><tr><td rowspan=1 colspan=1>7</td><td rowspan=1 colspan=1>RE</td><td rowspan=1 colspan=1>gCm2d-1</td><td rowspan=1 colspan=1>23m</td><td rowspan=1 colspan=1>生态系统呼吸</td></tr><tr><td rowspan=1 colspan=1>8</td><td rowspan=1 colspan=1>GPP</td><td rowspan=1 colspan=1>gCm2d-1</td><td rowspan=1 colspan=1>23m</td><td rowspan=1 colspan=1>生态系统总初级生产力</td></tr><tr><td rowspan=1 colspan=1>9</td><td rowspan=1 colspan=1>LE</td><td rowspan=1 colspan=1>Wm²</td><td rowspan=1 colspan=1>23m</td><td rowspan=1 colspan=1>潜热通量</td></tr><tr><td rowspan=1 colspan=1>10</td><td rowspan=1 colspan=1>Hs</td><td rowspan=1 colspan=1>Wm2</td><td rowspan=1 colspan=1>23m</td><td rowspan=1 colspan=1>显热通量</td></tr></table>

# 数据质量控制和评估

本数据集数据采用ChinaFLUX标准方法进行质量控制，具体参见张雷明等论文[5-6]。2020–2021年共 2 年间，金佛山站半小时尺度 $\mathrm { C O } _ { 2 }$ 通量、潜热通量和显热通量的有效观测数据比例分别为$8 0 . 9 3 \% 8 6 . 4 7 \%$ 、 $8 1 . 9 6 \% 8 6 . 5 1 \%$ 、 $8 1 . 9 6 \% 8 6 . 5 1 \%$ 。经分析，数据缺失的原因主要包括两类：（1）数据质量控制引起的缺失，包括剔除夜间通量数据筛选、异常数据等，特别是夜间数据的质控和筛选是引起有效观测数据降低的主要因素；（2）停电、仪器故障等因素导致的数据缺失。

# 数据使用方法和建议

本数据集可以通过科学数据银行 Science Data Bank(https://www.scidb.cn/)在线服务网址下载。本数据集能够为典型森林类型的碳汇能力评估、生态系统碳水耦合研究、生态过程模型模拟以及遥感反演等领域提供数据支持，同时也可以直接将本数据应用于全球不同气候带或不同森林类型之间碳汇能力的对比研究中。

# 致 谢

谨以此文纪念已故首任站长马明国教授，马老师将自己的一生奉献给了科研教育事业，他的离去是西南大学的重大损失。金佛山亚热带常绿阔叶林碳水通量观测数据的积累离不开西南大学地理科学学院“地表过程观测与模拟”团队的大力支持，承担了通量和气象观测设备的野外维护和原始数据采集工作，为本数据集的生产做出了重要贡献。

# 数据作者分工职责

汤旭光（1986—），男，河南省商丘人，博士，教授，研究方向为生态系统碳水循环与全球变化。主要承担工作：碳水通量数据处理方法与论文撰写。

孔德兵（1990—），男，甘肃省定西人，硕士，实验师，研究方向为空气污染与大气扩散。主要承担工作：观测系统运行管理。

陈亚楠（1998—），女，四川小金人，硕士研究生，研究方向为生态系统碳水循环过程。主要承担工作：碳水通量数据处理与质量分析。

李元庆（1981—），男，博士，重庆奉节人，实验师，研究方向为国土资源与区域发展。主要承担工作：自标定闭路涡度相关系统CPEC310等观测仪器和系统维护管理、仪器数据质量分析。

钱凤（1987—），男，重庆云阳人，博士，实验师，研究方向为生态系统与生物多样性。主要承担工作：数据观测、整理及分析。

丁智（1989—），男，湖北省孝感人，博士，实验师，研究方向为生态碳水循环的人为效应研究。主要承担工作：碳水通量数据管理与服务。

马明国（1976—2023），男，湖北省宜昌人，博士，教授，研究方向为地表过程观测模拟。主要承担工作：观测系统条件支持与管理。

# 参考文献

[1] 夏春燕, 黄慧敏, 夏虹, 等. 金佛山不同群落紫耳箭竹生长和繁殖权衡的形态及生物量特征[J].林业科学研究, 2021, 34(3): 118–126. DOI: 10.13275/j.cnki.lykxyj.2021.03.013. [XIA C Y, HUANG H M,

XIA H, et al. Morphological and biomass characteristics of Fargesia decurvata in different forest types in jinfo mountain[J]. Forest Research, 2021, 34(3): 118–126. DOI: 10.13275/j.cnki.lykxyj.2021.03.013.]

[2] ZHOU G Y, PENG C H, LI Y L, et al. A climate change-induced threat to the ecological resilience of a subtropical monsoon evergreen broad-leaved forest in Southern China[J]. Global Change Biology, 2013, 19(4): 1197–1210. DOI: 10.1111/gcb.12128.

[3] 起德花, 费学海, 宋清海, 等. 2009—2013 年哀牢山亚热带常绿阔叶林碳水通量观测数据集[J/OL]. 中国科学数据, 2021, 6(1). (2021-03-06). DOI: 10.11922/csdata.2020.0089.zh. [QI D H, FEI X H, SONG Q H, et al. A dataset of carbon and water fluxes observation in subtropical evergreen broad-leaved forest in Ailao Shan from 2009 to 2013[J/OL]. China Scientific Data, 2021, 6(1). (2021-03-06). DOI: 10.11922/csdata.2020.0089.zh.]

[4] REICHSTEIN M, FALGE E, BALDOCCHI D, et al. On the separation of net ecosystem exchange into assimilation and ecosystem respiration: review and improved algorithm[J]. Global Change Biology, 2005, 11(9): 1424–1439. DOI: 10.1111/j.1365-2486.2005.001002.x.

[5] 张雷明, 罗艺伟, 刘敏, 等. 2003—2005年中国通量观测研究联盟(ChinaFLUX)碳水通量观测数据集[J/OL]. 中国科学数据, 2019, 4(1). (2018-12-29). DOI: 10.11922/csdata.2018.0028.zh. [ZHANG L M,LUO Y W, LIU M, et al. Carbon and water fluxes observed by the Chinese Flux Observation and ResearchNetwork(2003-2005)[J]. China Scientific Data, 2019, 4(1). (2018-12-29). DOI:10.11922/csdata.2018.0028.zh.

[6] 于贵瑞, 孙晓敏. 陆地生态系统通量观测的原理与方法[M]. 2 版. 北京: 高等教育出版社, 2017.[YU G R, SUN X M. Principles of flux measurement in terrestrial ecosystems[M]. 2nd ed. Beijing: HigherEducation Press, 2017.]

# 论文引用格式

汤旭光, 孔德兵, 陈亚楠, 等. 2020–2021 年金佛山亚热带常绿阔叶林碳水通量观测数据集[J/OL]. 中国科学数据, 2023, 8(4). (2023-09-05). DOI: 10.11922/11-6035.csd.2023.0103.zh.

# 数据引用格式

汤旭光, 孔德兵, 陈亚楠, 等. 2020–2021 年金佛山亚热带常绿阔叶林碳水通量观测数据集[DB/OL].  
Science Data Bank, 2023. (2023-06-02). DOI: 10.57760/sciencedb.o00119.00048.

A dataset of carbon and water fluxes observations in subtropical evergreen broad-leaved forest in Jinfo Mountain from 2020 to 2021

TANG Xuguang1\*, KONG Debing1, CHEN Yanan1, LI Yuanqing1, QIAN Feng1, DING Zhi1, MA Mingguo1

1. Chongqing Jinfo Mountain Karst Ecosystem National Observation and Research Station, School of Geographical Sciences, Southwest University, Chongqing 400715, P. R. China

\*Email: xgtang@swu.edu.cn

Abstract: Chongqing Jinfo Mountain Karst Ecosystem National Observation and Research Station was officially included in the construction list of the selected national field stations in December, 2020 by China’s Ministry of Science and Technology. In its main observation field, based on the eddy covariance technique, long-term and continuous measurements of carbon and water fluxes in the subtropical evergreen broad-leaved forest ecosystem has been carried out since three years ago. Using the flux data processing system of ChinaFLUX, we conducted the strict work of data quality control and evaluation and obtained the standard dataset of carbon and water fluxes and the key meteorological data in the subtropical evergreen broad-leaved forest ecosystem at the Jinfo Station from 2020 to 2021. The dataset was comprised of net ecosystem carbon exchange, gross primary productivity, ecosystem respiration, latent heat, sensible heat, as well as air temperature/humidity, wind speed/direction, soil temperature/humidity, precipitation, downwelling shortwave radiation, net radiation and photosynthetically active radiation. This dataset can provide significant data support for analyzing the carbon source/sink of typical forest ecosystems, exploring the coupling relation between carbon and water cycles, as well as their response mechanisms to global climate change.

Keywords: eddy covariance system; carbon and water cycles; flux observation; Jinfo Mountain; evergreen broad-leaved forest

# Dataset Profile

<table><tr><td colspan="1" rowspan="1">Title</td><td colspan="1" rowspan="1">A dataset of carbon and water fluxes observations in subtropical evergreen broad-leaved forest in Jinfo Mountain from 2020 to 2021</td></tr><tr><td colspan="1" rowspan="1">Data corresponding author</td><td colspan="1" rowspan="1">TANG Xuguang (xgtang@swu.edu.cn)</td></tr><tr><td colspan="1" rowspan="1">Data author(s)</td><td colspan="1" rowspan="1"> TANG Xuguang, KONG Debing, CHEN Yanan, LI Yuanqing, QIAN Feng, DING Zhi,MA Mingguo</td></tr><tr><td colspan="1" rowspan="1">Time range</td><td colspan="1" rowspan="1">2020-2021</td></tr><tr><td colspan="1" rowspan="1">Geographical scope</td><td colspan="1" rowspan="1">Chongqing Jinfo Mountain Station，Nanchuan District, Chongqing (1O7.1508E,29.0217N; altitude: 1,543 m)</td></tr><tr><td colspan="1" rowspan="1">Ecosystem type</td><td colspan="1" rowspan="1">Subtropical evergreen broad-leaved forest ecosystem</td></tr><tr><td colspan="1" rowspan="1"> Data volume</td><td colspan="1" rowspan="1">36.1 MB</td></tr><tr><td colspan="1" rowspan="1">Data format</td><td colspan="1" rowspan="1">*.xlsx</td></tr><tr><td colspan="1" rowspan="1">Data service system</td><td colspan="1" rowspan="1">http://dx.doi.org/10.57760/sciencedb.o00119.00048</td></tr><tr><td colspan="1" rowspan="1">Source(s) of funding</td><td colspan="1" rowspan="1">The Special Project on National Science and Technology Basic Resources Investigationof China (2021FY100701)</td></tr><tr><td colspan="1" rowspan="1">Dataset composition</td><td colspan="1" rowspan="1">This data set consists of 4 EXCEL data files,falling into 2 categories, namely flux dataand meteorological data. The dataset contains the data of net ecosystem carbonexchange, gross primary productivity, ecosystem respiration, latent heat, sensible heat,as well as air temperature/humidity, wind speed/direction, soil temperature/humidity,</td></tr><tr><td>intervals of 3O min, daily,monthly and annual scales.</td><td>precipitation, downwelling shortwave radiation, net radiation and photosynthetically active radiation. The observed data have been interpolated and partitioned to create standardized data products. The meteorological data are categorized into intervals of 10 min,3O min,daily,monthly and annual scales,and flux data are categorized into</td></tr></table>