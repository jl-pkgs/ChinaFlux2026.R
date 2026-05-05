# 2020–2022 年固城站农田生态系统碳水通量观测数据集

ISSN 2096-2223 CN 11-6035/N

# 周莉 1，耿金剑 1,2，周广胜 1\*，张森 3，吴宜宣 1,4

1. 中国气象科学研究院灾害天气国家重点实验室，北京 100081  
2. 河北固城农业气象国家野外科学观测研究站，河北保定 072656  
3. 郑州大学地球科学与技术学院，郑州 450001  
4. 南京信息工程大学大气科学学院，南京 210044

GR

文献 CSTR：32001.14.11-6035.csd.2023.0022.zh文献 DOI：10.11922/11-6035.csd.2023.0022.zh数据 DOI：10.57760/sciencedb.o00119.00071文献分类：地球科学

![](images/554c75ad3d5e5cf7e17f1f1049638c85eb594d5272c57b1f5f6044c91349e582.jpg)

收稿日期：2023-01-06  
开放同评：2023-01-30  
录用日期：2023-08-17  
发表日期：2023-09-24

摘要：河北固城农业气象国家野外科学观测研究站（固城站）是科技部批准的国家野外科学观测研究站之一，地处华北平原北部灌溉高产农业区， 生态类型为典型的华北冬小麦–夏玉米一年两熟制农田生态系统。固城站基于涡度相关技术开展了农田生态系统碳水通量的长期连续观测。本数据集收集整理了 2020–2022年固城站最新的碳水通量综合观测资料，按照中国通量观测研究网络（ChinaFlux）的通量数据质量控制与处理技术体系要求，进行数据质量控制与处理，形成标准化的碳水通量和辅助气象环境要素数据集，可用于农田生态系统碳收支评估、水资源利用和农业防灾减灾。

关键词：涡度相关；冬小麦；夏玉米；碳通量；水通量；农田碳汇；农田耗水量

数据库（集）基本信息简介  

<table><tr><td rowspan=1 colspan=1>数据库（集）名称</td><td rowspan=1 colspan=1>2020-2022年固城站农田生态系统碳水通量观测数据集</td></tr><tr><td rowspan=1 colspan=1>数据通信作者</td><td rowspan=1 colspan=1>周广胜（zhougs@cma.gov.cn）</td></tr><tr><td rowspan=1 colspan=1>数据作者</td><td rowspan=1 colspan=1>周莉、耿金剑、周广胜、张森、吴宜宣</td></tr><tr><td rowspan=1 colspan=1>数据时间范围</td><td rowspan=1 colspan=1>2020-2022年</td></tr><tr><td rowspan=1 colspan=1>地理区域</td><td rowspan=1 colspan=1>115°40&#x27;E，39°08&#x27;N，海拔15 m</td></tr><tr><td rowspan=1 colspan=1>数据量</td><td rowspan=1 colspan=1>25.8 MB</td></tr><tr><td rowspan=1 colspan=1>数据格式</td><td rowspan=1 colspan=1>*.xlsx</td></tr><tr><td rowspan=1 colspan=1>数据服务系统网址</td><td rowspan=1 colspan=1>https://doi.org/10.57760/sciencedb.o00119.00071</td></tr><tr><td rowspan=1 colspan=1>基金项目</td><td rowspan=1 colspan=1>科技部基础资源调查专项（2019FY101302）；中国气象局创新发展专项（CXFZ2023P052）。</td></tr><tr><td rowspan=1 colspan=1>数据库（集）组成</td><td rowspan=1 colspan=1>本数据集包括通量数据和气象数据2个数据子集，每个子集均包括30 min、日、月和年4种时间尺度的数据。其中：通量数据产品包含生态系统净碳交换（NEE）、生态系统呼吸（Reco）、生态系统光合（GEE）、感热通量（Hs）、潜热通量（LE)等观测指标；气象数据产品包括空气温湿度、风速、风向、太阳辐射、光合有效辐射、土壤温度、土壤水分以及降雨量等观测指标。</td></tr></table>

\* 论文通信作者 周广胜：zhougs@cma.gov.cn

# 引 言

农田生态系统是重要的碳源碳汇系统之一，具备较强的固碳减排潜力[1-2]。2022年，农业农村部会同国家发展改革委印发了《农业农村减排固碳实施方案》，提升农业生态系统固碳增汇能力并同步发展高效节水灌溉，以夯实保障国家粮食安全基础。华北地区是中国典型的冬小麦–夏玉米一年两熟制地区，是重要的粮仓之一，对保障粮食安全有十分重要的作用[3]。但该地区的农业稳产高产也同样受气候条件波动和气候变化的严重影响[4]，仍有大量的工作需要深入开展。

涡度相关技术通过测量一定高度上垂直风速脉动和被测气体浓度脉动来计算被测气体在该高度的通量，已经成为直接测定植被–大气间 $\mathrm { C O } _ { 2 }$ 、 $_ \mathrm { H _ { 2 } O }$ 等交换通量的标准方法[5-6]，并在生态系统至区域碳水通量研究中广泛应用，为生态系统碳汇、水分平衡、能量交换及其对气候变化的响应和反馈等方面的研究提供了重要支撑[7-9]。

本数据集为华北典型冬小麦–夏玉米一年两熟制农田生态系统碳水通量和辅助气象环境数据，数据采集地点为河北固城农业气象国家野外科学观测研究站（固城站），数据集时间跨度为 2019–2022年，包括30分钟、日、月和年尺度的数据产品，可用于农田生态系统碳收支评估、水资源利用和农业防灾减灾。据数据调研，目前华北平原的农田生态系统碳水通量观测中，已有中国科学院禹城综合试验站（禹城站）[10]和中国科学院栾城农业生态系统试验站（栾城站）[11]在科学数据银行（https://www.scidb.cn/）和国家生态科学数据存储库（https://ecodb.scidb.cn/）等网站共享了通量数据。固城站、栾城站和禹城站通量观测的对象同为冬小麦–夏玉米轮作系统，并且在华北平原上形成从北到南的空间格局，数据集联合分析可促进华北平原区域尺度农田生态系统碳源汇空间格局和机制的研究。

# 数据采集和处理方法

# 1.1 数据采集

河北固城农业气象国家野外科学观测研究站（以下简称固城站）位于华北平原东北部的河北省定兴县固城镇东（ $1 1 5 ^ { \circ } 4 0 ^ { \prime } \mathrm { E }$ ， $3 9 ^ { \circ } 0 8 ^ { \prime } \mathrm { N }$ ，海拔 $1 5 \mathrm { m }$ ），是科技部批准的国家野外科学观测研究站之一，也是中国气象局农业气象科技创新基地、中国气象科学研究院直属的国家级农业气象野外科学试验基地。固城站所在地区属暖温带大陆性季风气候区，气候温暖，水热同季，多年平均气温 $1 2 . 2 \mathrm { { ^ \circ C } }$ ，多年平均年降水量 $5 2 8 \mathrm { m m }$ ，降水主要集中于 6–9 月份，多年平均日照时数 $2 2 6 4 \mathrm { h }$ ，近年地下水位约$1 5 \mathrm { ~ m ~ }$ 。从我国农业生产的布局和分区看，固城站地处华北平原北部灌溉高产农业区，为典型的冬小麦–夏玉米轮作、一年两熟制农田生态系统。冬小麦品种为郯麦 98，种植密度平均为每平方米 716株，冬小麦越冬始期平均株高 $0 . 1 4 \mathrm { { m } }$ 、返青期平均株高 $0 . 0 6 ~ \mathrm { { m } }$ 、拔节期平均株高 $0 . 2 5 ~ \mathrm { m }$ 、抽穗期平均株高 $0 . 5 7 \mathrm { m }$ 、乳熟期平均株高 $0 . 6 8 \mathrm { m }$ ，最大冠层高度可达 $0 . 7 2 \mathrm { m }$ ，最大叶面积指数为 4.86；夏玉米品种为郑丹 958，播种密度平均为每平方米 7.2 株，夏玉米七叶期平均株高 $0 . 4 1 \mathrm { m }$ 、拔节期平均株高 $0 . 9 6 \mathrm { m }$ 、抽雄期平均株高 $2 . 1 \mathrm { m }$ 、乳熟期平均株高 $2 . 8 4 \mathrm { m }$ ，最大冠层高度可达 $2 . 9 0 \mathrm { m }$ ，最大叶面积指数为 4.37。固城站土壤类型以砂壤土为主，土壤有机碳含量约为 $1 3 . 6 7 ~ \mathrm { g } { \cdot } \mathrm { k g } ^ { - 1 }$ ，土壤全氮含量约为$0 . 8 7 ~ \mathrm { g } { \cdot } \mathrm { k g } ^ { - 1 }$ ，土壤有效磷含量约为 $2 5 . 7 6 \mathrm { \ m g ^ { \cdot } k g ^ { - 1 } }$ ，土壤有效钾含量约为 $1 1 8 . 5 5 \mathrm { m g ^ { \cdot } k g ^ { - 1 } }$ ， $\mathsf { p H }$ 值 8.19；$0 { - } 5 0 ~ \mathrm { c m }$ 土壤平均田间持水量为 $2 3 . 4 \%$ ，凋萎系数 $7 . 1 0 \%$ ，土壤容重 $1 . 2 3 ~ \mathrm { g } \cdot \mathrm { c m } ^ { - 3 }$ 。

固城站的碳水通量观测场地形平坦，场内建有高度为 $3 2 \mathrm { m }$ 的观测塔，主要观测设备包括一套开路涡度相关通量观测系统和一套气象环境观测系统（表1）。开路式涡度相关通量观测系统主要观测要素为 $\mathrm { C O } _ { 2 }$ 通量、 $\mathrm { H } _ { 2 } \mathrm { O }$ 通量、感热通量，传感器主要包括红外 $\mathrm { C O } _ { 2 } / \mathrm { H } _ { 2 } \mathrm { O }$ 气体分析仪（LI-7500）、三维超声风速仪（CSAT3），安装在观测塔 $4 . 5 \mathrm { m }$ 高处的支臂上，原始数据采集频率为 $1 0 \mathrm { H z }$ ，并提供$3 0 ~ \mathrm { m i n }$ 在线通量数据；配套的气象环境观测系统主要观测要素包括空气温湿度、风速风向、光合有效辐射、净辐射、降雨量、土壤热通量、土壤温湿度等，各气象环境要素的传感器型号和安装高度/深度等信息详见表1，气象环境数据采集频率为 $1 \mathrm { m i n }$ ，在线计算半小时平均值/累积值，并相应输出各种观测变量的日平均值/累积值。通量观测场仪器有固城站工作人员定期巡查进行日常维护，并由工程师定期对仪器进行标定校准。

表 1 固城站碳水通量观测设备信息  
Table 1 Information about the equipment for the carbon and water flux observation at Gucheng Station   

<table><tr><td rowspan=1 colspan=1>观测系统</td><td rowspan=1 colspan=1>测定要素</td><td rowspan=1 colspan=1>传感器型号</td><td rowspan=1 colspan=1>制造商</td><td rowspan=1 colspan=1>观测高度/深度</td></tr><tr><td rowspan=3 colspan=1>开路涡度相关通量观测系统</td><td rowspan=1 colspan=1>CO2、H2O通量</td><td rowspan=1 colspan=1>LI-7500</td><td rowspan=1 colspan=1>LI-COR</td><td rowspan=1 colspan=1>4.5 m</td></tr><tr><td rowspan=1 colspan=1>感热通量</td><td rowspan=1 colspan=1>LI-7500</td><td rowspan=1 colspan=1>LI-COR</td><td rowspan=1 colspan=1>4.5 m</td></tr><tr><td rowspan=1 colspan=1>三维超声风速</td><td rowspan=1 colspan=1>CSAT3</td><td rowspan=1 colspan=1>CAMPBELL</td><td rowspan=1 colspan=1>4.5 m</td></tr><tr><td rowspan=8 colspan=1>气象环境观测系统</td><td rowspan=1 colspan=1>空气温/湿度</td><td rowspan=1 colspan=1>HMP45C</td><td rowspan=1 colspan=1>Vaisala</td><td rowspan=1 colspan=1>4.5 m</td></tr><tr><td rowspan=1 colspan=1>风速</td><td rowspan=1 colspan=1>windsonic</td><td rowspan=1 colspan=1>GILL</td><td rowspan=1 colspan=1>4.5 m</td></tr><tr><td rowspan=1 colspan=1>风向</td><td rowspan=1 colspan=1>windsonic</td><td rowspan=1 colspan=1>GILL</td><td rowspan=1 colspan=1>4.5 m</td></tr><tr><td rowspan=1 colspan=1>光合有效辐射</td><td rowspan=1 colspan=1>LI-190SB</td><td rowspan=1 colspan=1>LI-COR</td><td rowspan=1 colspan=1>4.5 m</td></tr><tr><td rowspan=1 colspan=1>净辐射</td><td rowspan=1 colspan=1>CNR1</td><td rowspan=1 colspan=1>Kipp &amp; Zonen</td><td rowspan=1 colspan=1>4.5 m</td></tr><tr><td rowspan=1 colspan=1>土壤热通量</td><td rowspan=1 colspan=1>HFP01</td><td rowspan=1 colspan=1>Hukseflux</td><td rowspan=1 colspan=1>-8cm</td></tr><tr><td rowspan=1 colspan=1>土壤温度</td><td rowspan=1 colspan=1>107</td><td rowspan=1 colspan=1>CAMPBELL</td><td rowspan=1 colspan=1>-4 cm</td></tr><tr><td rowspan=1 colspan=1>土壤水分</td><td rowspan=1 colspan=1>EC-5</td><td rowspan=1 colspan=1>METER</td><td rowspan=1 colspan=1>-4 cm</td></tr><tr><td rowspan=2 colspan=1>数据采集器</td><td rowspan=1 colspan=1>通量采集</td><td rowspan=1 colspan=1>CR1000x</td><td rowspan=1 colspan=1>CAMPBELL</td><td rowspan=1 colspan=1>/</td></tr><tr><td rowspan=1 colspan=1>气象要素采集</td><td rowspan=1 colspan=1>CR3000</td><td rowspan=1 colspan=1>CAMPBELL</td><td rowspan=1 colspan=1>/</td></tr></table>

# 1.2 数据处理和产品加工方法

本数据集从观测数据采集、质量控制、数据处理和存储等各方面均遵循 ChinaFLUX 通量数据质量控制与处理技术体系完成[12-15]，数据处理软件主要采用EddyPro和Matlab。数据处理流程见图 1。

数据预处理：主要包括对原始 $1 0 \ \mathrm { H z }$ 高频通量观测数据中由于电子和物理噪声等产生的异常值进行剔除、二次坐标转换以消除地形不平坦或传感器不垂直等影响、计算 $3 0 \mathrm { { m i n } }$ 平均通量。

数据校正：主要包括对通量数据进行频率响应校正、超声虚温校正、WPL 校正、谱特征分析、稳态测试与湍流积分特性分析等。

数据质量控制/质量保证：对 $3 0 \mathrm { { m i n } }$ 气象观测数据的质量控制包括异常值和阈值剔除；对通量数据的质量控制主要包括异常值剔除、阈值剔除、夜间摩擦风速阈值控制和降雨同期数据剔除等。

![](images/ff8aa8e1424d19024c14a159fe2864d44481229ce540fbecf5b3e79bc98f3950.jpg)  
图 1 通量数据处理流程  
Figure 1 Processing flow of flux data

气象缺失数据插补：小于 $^ { 2 \mathrm { h } }$ 的气象数据缺失采用线性内插法进行插补；超过 $^ { 2 \mathrm { h } }$ 的气象数据缺失可采用重复变量法进行，如光合有效辐射的缺失值可通过建立观测站点的光合有效辐射与总辐射的关系来插补，也可利用附近气象站观测资料或平均日变化法进行插补。

水热通量缺失数据插补：小于 $^ { 2 \mathrm { ~ h ~ } }$ 的水热通量数据缺失，依据相邻数据进行线性插补；数据缺失超过 $^ { 2 \mathrm { ~ h ~ } }$ 时，采用非线性多元回归法（时间窗口，3 d）。非线性回归插补水热通量缺失数据时，主要基于水热通量与有效能量和水汽压亏损等变量的多元回归方程。

$\mathbf { C O } _ { 2 }$ 通量缺失数据插补：小于 $^ { 2 \mathrm { ~ h ~ } }$ 的 $\mathrm { C O } _ { 2 }$ 通量数据缺失，可用线性内插法插补；数据缺失超过$^ { 2 \mathrm { h } }$ 时，插补方法主要采用边际分布采样法、非线性多元回归法（时间窗口，5 d），更长时间的 $\mathrm { C O } _ { 2 }$ 通量缺失采用平均日变化法完成。在基于非线性回归插补 $\mathrm { C O } _ { 2 }$ 通量缺失数据时，生长季白天缺失数据主要利用植被光合作用与光合有效辐射之间的直角双曲线 Michaelis-Menten 模型；非生长季及生长季夜间缺失数据的插补，采用生态系统呼吸与温度之间的指数函数关系进行插补。

$\mathbf { C O } _ { 2 }$ 通量拆分：涡度相关系统直接观测到的碳通量是净生态系统 $\mathrm { C O } _ { 2 }$ 交换量（NEE），是光合碳吸收和呼吸碳排放两个过程平衡后的结果。为了获得生态系统光合（GEE）和生态系统呼吸（Reco）的相应通量数据，需要对NEE进行拆分。本数据集采用的是夜间观测途径，首先利用夜间碳通量和环境因子建立的呼吸模型估算白天生态系统呼吸，然后基于 ${ \mathrm { N E E } } = { \mathrm { G E E } } + { \mathrm { R e c o } }$ 得到生态系统光合(GEE)。

# 数据样本描述

本数据集总数量为 $2 5 . 8 ~ \mathrm { M B }$ ，包括2020–2022 年共3 年、4个时间尺度的碳水通量和气象环境2类数据，共计24个Excel文件组成。其中，2022 年数据结束采集时间为11月（开始本数据集整编和论文编写）。数据文件的命名格式为“年份 $^ +$ 站名 $^ +$ 数据类型 $^ +$ 时间尺度”，“数据类型”分别为通量和气象数据，“时间尺度”包括30分钟、日、月和年尺度。如“2020年固城通量 30分钟数据.xlsx”和“2020年固城气象30分钟数据.xlsx”。以2020年数据文件为例，表2为固城站通量数据文件表头说明，表3为固城站气象数据文件表头说明。

# 表 2 通量观测数据表内容说明

Table 2 Sheet description of flux data   

<table><tr><td rowspan=2 colspan=1>数据项</td><td rowspan=1 colspan=4>计量单位</td><td rowspan=2 colspan=1>数据项说明</td></tr><tr><td rowspan=1 colspan=1>30分钟尺度</td><td rowspan=1 colspan=1>日尺度</td><td rowspan=1 colspan=1>月尺度</td><td rowspan=1 colspan=1>年尺度</td></tr><tr><td rowspan=1 colspan=1>年</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>年份</td></tr><tr><td rowspan=1 colspan=1>月</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>?</td><td rowspan=1 colspan=1>月份</td></tr><tr><td rowspan=1 colspan=1>日</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>-</td><td rowspan=1 colspan=1>-</td><td rowspan=1 colspan=1>日期</td></tr><tr><td rowspan=1 colspan=1>时</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>-</td><td rowspan=1 colspan=1>-</td><td rowspan=1 colspan=1>?</td><td rowspan=1 colspan=1>小时</td></tr><tr><td rowspan=1 colspan=1>分</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1>-</td><td rowspan=1 colspan=1>分钟</td></tr><tr><td rowspan=1 colspan=1>NEE</td><td rowspan=1 colspan=1>mg CO2 m2 s1</td><td rowspan=1 colspan=1>gCm²d1</td><td rowspan=1 colspan=1>gC m²2 mon1</td><td rowspan=1 colspan=1>gCm²y1</td><td rowspan=1 colspan=1>生态系统净碳交换</td></tr><tr><td rowspan=1 colspan=1>Reco</td><td rowspan=1 colspan=1>mg CO2 m2 s-1</td><td rowspan=1 colspan=1>gCm²d1</td><td rowspan=1 colspan=1>g C m²2 mon-1</td><td rowspan=1 colspan=1>gCm²y1</td><td rowspan=1 colspan=1>生态系统呼吸</td></tr><tr><td rowspan=1 colspan=1>GEE</td><td rowspan=1 colspan=1>mg CO2 m2 s-1</td><td rowspan=1 colspan=1>gCm2d1</td><td rowspan=1 colspan=1>g C m²2 mon-1</td><td rowspan=1 colspan=1>gCm2y1</td><td rowspan=1 colspan=1>生态系统光合</td></tr><tr><td rowspan=1 colspan=1>Hs</td><td rowspan=1 colspan=1>Wm²</td><td rowspan=1 colspan=1>MW m2</td><td rowspan=1 colspan=1>MW m2</td><td rowspan=1 colspan=1>MW m2</td><td rowspan=1 colspan=1>感热通量</td></tr><tr><td rowspan=1 colspan=1>LE</td><td rowspan=1 colspan=1>W m²2</td><td rowspan=1 colspan=1>MW m2</td><td rowspan=1 colspan=1>MW m2</td><td rowspan=1 colspan=1>MW m2</td><td rowspan=1 colspan=1>潜热通量</td></tr></table>

\*注：半小时尺度通量数据表头说明：（1）“质控 NEE”“质控 LE”和“质控 Hs”分别表示经过质量控制后的净生态系统碳交换、感热通量和潜热通量；（2）“插补 NEE”“插补 LE”和“插补 Hs”分别表示数据插补后的生态系统碳交换、感热通量和潜热通量；（3）估算 Reco 和估算 GEE 分别表示由 NEE 数据拆分得到的生态系统呼吸和生态系统光合的估算值。日、月和年尺度通量均为每日、每月和每年各通量累积值。

# 表 3 半小时气象观测数据表内容说明

Table 3 Sheet description of half-hourly meteorological observation data   

<table><tr><td rowspan=1 colspan=1>数据项</td><td rowspan=1 colspan=1>计量单位</td><td rowspan=1 colspan=1>数据项说明</td></tr><tr><td rowspan=1 colspan=1>yy</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>年份</td></tr><tr><td rowspan=1 colspan=1>mm</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>月份</td></tr><tr><td rowspan=1 colspan=1>dd</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>日期</td></tr><tr><td rowspan=1 colspan=1>doy</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>日序</td></tr><tr><td rowspan=1 colspan=1>hh</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>小时</td></tr><tr><td rowspan=1 colspan=1>mm</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>分钟</td></tr><tr><td rowspan=1 colspan=1>T_probe_Avg</td><td rowspan=1 colspan=1>℃</td><td rowspan=1 colspan=1>4.5m 空气温度均值</td></tr><tr><td rowspan=1 colspan=1>RH_probe_Avg</td><td rowspan=1 colspan=1>%</td><td rowspan=1 colspan=1>4.5m 空气相对湿度均值</td></tr><tr><td rowspan=1 colspan=1>e_probe_Avg</td><td rowspan=1 colspan=1>kPa</td><td rowspan=1 colspan=1>4.5m水汽压均值</td></tr><tr><td rowspan=1 colspan=1>WS_Avg</td><td rowspan=1 colspan=1>ms1</td><td rowspan=1 colspan=1>4.5m风速</td></tr><tr><td rowspan=1 colspan=1>WD_Avg</td><td rowspan=1 colspan=1>·</td><td rowspan=1 colspan=1>风向方位角</td></tr><tr><td rowspan=1 colspan=1>WD_StDev</td><td rowspan=1 colspan=1>。</td><td rowspan=1 colspan=1>风向方位角的标准偏差</td></tr><tr><td rowspan=1 colspan=1>R_SW_in_Avg</td><td rowspan=1 colspan=1>Wm²</td><td rowspan=1 colspan=1>向下短波辐射均值(总辐射)</td></tr><tr><td rowspan=1 colspan=1>R_SW_out_Avg</td><td rowspan=1 colspan=1>Wm²2</td><td rowspan=1 colspan=1>向上短波辐射均值</td></tr><tr><td rowspan=1 colspan=1>albedo_Avg</td><td rowspan=1 colspan=1>/</td><td rowspan=1 colspan=1>向上短波与向下短波的比值</td></tr><tr><td rowspan=1 colspan=1>R_LW_in_meas_Avg</td><td rowspan=1 colspan=1>Wm2</td><td rowspan=1 colspan=1>向下长波辐射均值</td></tr><tr><td rowspan=1 colspan=1>R_LW_out_meas_Avg</td><td rowspan=1 colspan=1>Wm²</td><td rowspan=1 colspan=1>向上长波辐射均值</td></tr><tr><td rowspan=1 colspan=1>Rn_raw_Avg</td><td rowspan=1 colspan=1>Wm²</td><td rowspan=1 colspan=1>净辐射</td></tr><tr><td rowspan=1 colspan=1>PAR_density_Avg</td><td rowspan=1 colspan=1>μmol m2 s-1</td><td rowspan=1 colspan=1>光合有效辐射</td></tr><tr><td rowspan=1 colspan=1>Precipitation_Tot</td><td rowspan=1 colspan=1>mm</td><td rowspan=1 colspan=1>总降水量</td></tr><tr><td rowspan=1 colspan=1>shf_plate_N_Avg</td><td rowspan=1 colspan=1>W m2</td><td rowspan=1 colspan=1>朝北方向土壤热通量均值8cm</td></tr><tr><td rowspan=1 colspan=1>shf_plate_S_Avg</td><td rowspan=1 colspan=1>Wm2</td><td rowspan=1 colspan=1>朝南方向土壤热通量均值8cm</td></tr><tr><td rowspan=1 colspan=1>Soil_T_N_Avg</td><td rowspan=1 colspan=1>℃</td><td rowspan=1 colspan=1>朝北方向4cm土壤温度均值</td></tr><tr><td rowspan=1 colspan=1>Soil_T_S_Avg</td><td rowspan=1 colspan=1>℃</td><td rowspan=1 colspan=1>朝南方向4cm 土壤温度均值</td></tr><tr><td rowspan=1 colspan=1>Soil_VWC_N_Avg</td><td rowspan=1 colspan=1>m²m</td><td rowspan=1 colspan=1>朝北方向4cm土壤体积含水量</td></tr><tr><td rowspan=1 colspan=1>Soil_VWC_S_Avg</td><td rowspan=1 colspan=1>m²m³</td><td rowspan=1 colspan=1>朝南方向4cm土壤体积含水量</td></tr></table>

# 3 数据质量控制和评估

本数据集的数据质量控制在ChinaFLUX通量数据质量控制规范的指导下完成，具体步骤详见本文第 1.2 节数据处理流程部分内容。经过数据质量控制，固城站 2020–2022 年间半小时尺度的 $\mathrm { C O } _ { 2 }$ 通量、潜热通量和感热通量的有效数据分别为 $6 4 . 3 \% \pm 6 . 5 \%$ 、 $9 0 . 2 \% \pm 8 . 7 \%$ 、 $8 6 . 4 \% \pm 9 . 5 \%$ （表4）。根据文献调研，全球通量网 FLUXNET 通量站点的通量观测有效数据比例在 $5 0 \% - 8 3 \% ^ { [ 1 6 ] }$ ，ChinaFLUX 通量站的通量观测有效数据比例白天在 $6 2 . 8 \% 8 4 . 2 \%$ 、夜间为 $0 . 8 \% 5 1 . 1 \% ^ { 0 }$ 。与其他通量站相比，固城站 2020–2022 年通量的有效数据比例居于范围内较好水平。通量数据的缺失原因，

一方面主要是在数据质量控制时对降雨、夜间摩擦风速低湍流弱等情况下的数据进行删除造成的；  
另一方面主要源于供电不足、仪器故障、仪器维修等情况下的原始数据丢失。

表 4 半小时尺度通量数据质量控制后的有效数据比例  
Table 4 Proportions of valid data after quality control for half-hourly flux data $( \% )$   

<table><tr><td rowspan=1 colspan=1>年份</td><td rowspan=1 colspan=1>CO2通量</td><td rowspan=1 colspan=1>潜热通量</td><td rowspan=1 colspan=1>感热通量</td></tr><tr><td rowspan=1 colspan=1>2020</td><td rowspan=1 colspan=1>58.34%</td><td rowspan=1 colspan=1>81.99%</td><td rowspan=1 colspan=1>76.80%</td></tr><tr><td rowspan=1 colspan=1>2021</td><td rowspan=1 colspan=1>71.33%</td><td rowspan=1 colspan=1>99.47%</td><td rowspan=1 colspan=1>95.83%</td></tr><tr><td rowspan=1 colspan=1>2022</td><td rowspan=1 colspan=1>63.26%</td><td rowspan=1 colspan=1>89.28%</td><td rowspan=1 colspan=1>86.70%</td></tr></table>

# 数据使用方法和建议

数据可用于农田生态系统碳收支评估、农田耗水量评估、农田水分利用效率评估、气候变化对农田碳水交换过程的影响研究、农田生态系统模型发展、减轻不利气象条件对农田生态系统和农业生产的影响研究等方面，可更好地为我国农业气象业务服务和科学的发展提供基础保障。在本数据集的使用中请注意：涡度相关通量数据的处理方法在不断的发展，碳水通量数据的处理方法不是唯一的。鉴于此，本数据集提供了插补前的有效通量数据和插补后的连续时间序列数据。一方面，使用者可以根据研究目的尝试新的插值方法；另一方面，使用者可以根据研究目的选择使用数据，如在进行通量环境控制机制分析时，尽可能使用有效数据。

# 致 谢

感谢任三学、赵花荣、田晓丽、李超、郑宁等在固城站观测系统维护、计算机程序方面的大力支持。

# 数据作者分工职责

周莉（1975—），女，博士，研究员，研究方向为陆-气通量及其生理生态机制。主要承担工作：数据质量控制和论文撰写。

耿金剑（1990—），男，硕士，助理研究员，研究方向为气候变化与农业气候资源利用。主要承担工作：数据采集和数据整理。

周广胜（1965—），男，研究员，研究方向为气候变化和减灾。主要承担工作：通量站的运行与科学发展。

张森（1994—），男，硕士研究生，研究方向为生态系统碳通量及其控制机制。主要承担工作：数据质量分析。

吴宜宣（1998—），女，博士研究生，研究方向为农业气象。主要承担工作：背景数据整理。

# 参考文献

[1] 韩广轩, 周广胜, 许振柱. 中国农田生态系统土壤呼吸作用研究与展望[J]. 植物生态学报, 2008,

32(3): 719–733. DOI: 10.3773/j.issn.1005-264x.2008.03.022. [HAN G X, ZHOU G S, XU Z Z. Research and prospects for soil respiration of farmland ecosystems in China[J]. Journal of Plant Ecology, 2008, 32(3): 719–733. DOI: 10.3773/j.issn.1005-264x.2008.03.022.]

[2] 黄耀, 周广胜, 吴金水. 中国陆地生态系统碳收支模型[M]. 北京: 科学出版社, 2008. [HUANG Y,ZHOU G S, WU J S. Modelling carbon budgets of terrestrial ecosystems in China[M]. Beijing: SciencePress, 2008.]

[3] 张喜英. 华北典型区域农田耗水与节水灌溉研究[J]. 中国生态农业学报, 2018, 26(10): 1454–1464. DOI: 10.13930/j.cnki.cjea.180636. [ZHANG X Y. Water use and water-saving irrigation in typical farmlands in the North China Plain[J]. Chinese Journal of Eco-Agriculture, 2018, 26(10): 1454–1464. DOI: 10.13930/j.cnki.cjea.180636.]

[4] 文彦君, 方修琦, 刘洋, 等. $1 8 \sim 1 9$ 世纪之交华北平原的气候变化与粮价异常[J]. 中国科学: 地球 科学, 2020, 50(1): 122–133. [WEN Y J, FANG X Q, LIU Y, et al. Rising grain prices in response to phased climatic change during 1736-1850 in the North China Plain[J]. Scientia Sinica (Terrae), 2020, 50(1): 122–133.]

[5] BALDOCCHI D, VALENTINI R, RUNNING S, et al. Strategies for measuring and modelling carbon dioxide and water vapour fluxes over terrestrial ecosystems[J]. Global Change Biology, 1996, 2(3): 159– 168. DOI: 10.1111/j.1365-2486.1996.tb00069.x.

[6] 于贵瑞, 伏玉玲, 孙晓敏, 等. 中国陆地生态系统通量观测研究网络(ChinaFLUX)的研究进展及其发展思路[J]. 中国科学 D 辑: 地球科学, 2006, 36(S1): 1–21. [YU G R, FU Y L, SUN X M, et al.Research progress and development ideas of China terrestrial ecosystem flux observation researchnetwork (ChinaFLUX)[J]. Science in China (Series D: Earth Sciences), 2006, 36(S1): 1–21.]

[7] CHEN Z, YU G R, WANG Q F. Magnitude, pattern and controls of carbon flux and carbon use efficiency in China’s typical forests[J]. Global and Planetary Change, 2019, 172: 464–473. DOI: 10.1016/j.gloplacha.2018.11.004.

[8] WANG Y, ZHOU L, JIA Q Y, et al. Direct and indirect effects of environmental factors on daily $\mathrm { C O } _ { 2 }$ exchange in a rainfed maize cropland—a SEM analysis with 10 year observations[J]. Field Crops Research, 2019, 242: 107591. DOI: 10.1016/j.fcr.2019.107591.

[9] ZHOU L, WANG Y, JIA Q Y, et al. Evapotranspiration over a rainfed maize field in northeast China: how are relationships between the environment and terrestrial evapotranspiration mediated by leaf area?[J]. Agricultural Water Management, 2019, 221: 538–546. DOI: 10.1016/j.agwat.2019.05.026.

[10] 赵风华, 李发东, 占车生, 等. 2003–2010年禹城冬小麦夏玉米农田生态系统碳水通量观测数据集[J/OL]. 中国科学数据, 2021, 6(2). (2021-03-18). DOI: 10.11922/csdata.2020.0044.zh. [ZHAO F H,LI F D, ZHAN C S, et al. A carbon and water fluxes dataset of the farmland ecosystem of winter wheatand summer maize in Yucheng (2003–2010) [J/OL]. China Scientific Data, 2021, 6(2). (2021-03-18).DOI: 10.11922/csdata.2020.0044.zh.]

[11] 刘帆, 沈彦俊, 曹建生, 等. 2013–2017 年栾城冬小麦–夏玉米农田水热碳通量数据集[J/OL].中国科学数据, 2023, 8(2). (2023-06-19). DOI: 10.11922/11-6035.csd.2023.0031.zh. [LIU F, SHEN Y

J, CAO J S, et al. A dataset of water, heat, and carbon fluxes over the winter wheat-summer maize croplands in Luancheng during 2013–2017 [J/OL]. China Scientific Data, 2023, 8(2). (2023-06-19).

DOI: 10.11922/11-6035.csd.2023.0031.zh.]

[12] 李春, 何洪林, 刘敏, 等. ChinaFLUX $\mathrm { C O } _ { 2 }$ 通量数据处理系统与应用[J]. 地球信息科学, 2008, 10(5): 557–565. DOI: 10.3969/j.issn.1560-8999.2008.05.002. [LI C, HE H L, LIU M, et al. The design and application of $\mathrm { C O } _ { 2 }$ flux data processing system at ChinaFLUX[J]. Geo-Information Science, 2008, 10(5): 557–565. DOI: 10.3969/j.issn.1560-8999.2008.05.002.]

[13] 周莉. 辽河三角洲芦苇湿地生态系统水碳通量动态及其控制机制[D]. 北京：中国科学院植物研究所, 2009. [ZHOU L. Dynamics of water and carbon dioxide fluxes and their controls for a reed marshin Liaohe Delta [D]. Beijing: The Institute of Botany, Chinese Academy of Sciences, 2009]

[14] 张雷明, 罗艺伟, 刘敏, 等. 2003—2005 年中国通量观测研究联盟(China FLUX)碳水通量观测数据集[J]. 中国科学数据, 2019, 4(1): 18–34. [ZHANG L M, LUO Y W, LIU M, et al. Carbon and waterfluxes observed by the Chinese Flux Observation and Research Network(2003-2005)[J]. ChinaScientific Data, 2019, 4(1): 18–34.]

[15] BURBA G. Eddy Covariance Method for Scientific, Regulatory, and Commercial Applications [M]. Lincoln, Nebraska: LI-Cor Biosciences, 2022.

[16] FALGE E, BALDOCCHI D, OLSON R, et al. Gap filling strategies for long term energy flux data sets[J]. Agricultural and Forest Meteorology, 2001, 107(1): 71–77. DOI: 10.1016/S0168-1923(00)00235-5.

[17] 于贵瑞, 孙晓敏. 中国陆地生态系统碳通量观测技术及时空变化特征[M]. 北京: 科学出版社,2008. [YU G R, SUN X M. Flue measurement and research of terrestrial ecosystem in China[M]. Beijing:Science Press, 2008.]

# 论文引用格式

周莉, 耿金剑, 周广胜, 等. 2020–2022 年固城站农田生态系统碳水通量观测数据集[J/OL]. 中国科学数据, 2023, 8(3). (2023-01-06). DOI: 10.11922/11-6035.csd.2023.0022.zh.

# 数据引用格式

周莉, 耿金剑, 周广胜, 等. 2020–2022 年固城站农田生态系统碳水通量观测数据集[DS/OL]. ScienceData Bank, 2023. DOI:10.57760/sciencedb.o00119.00071.

# A dataset of carbon and water fluxes in farmland ecosystems at Gucheng Station (2020–2022)

ZHOU Li1, GENG Jinjian1,2, ZHOU Guangsheng1\*, ZHANG Sen3, WU Yixuan1,4

1. State Key Laboratory of Severe Weather, Chinese Academy of Meteorological Sciences, Beijing 100081,   
P. R. China   
2. Hebei Gucheng Agricultural Meteorology National Observation and Research Station, Baoding 072656,   
P. R. China   
3. School of Geo-Science and Technology, Zhengzhou University, Zhengzhou 450001, P. R. China

4. School of Atmospheric Sciences, Nanjing University of Information Science & Technology, Nanjing   
210044, P. R. China

\*Email: zhougs@cma.gov.cn

Abstract: Hebei Gucheng Agricultural Meteorology National Observation and Research Station (Gucheng Station) is one of the national field scientific observation and research stations approved by the Ministry of Science and Technology (MOST). Located in the irrigated high-yield agricultural area in the northern part of the North China Plain, it is a typical North China winter wheat-summer maize rotation system. Based on the eddy covariance technique, the observation of cropland ecosystem carbon and water fluxes has been carried out at Gucheng Station for a long time. Following the ChinaFLUX data processing protocols, we collected the carbon and water fluxes and auxiliary meteorological environment observations of the winter wheat and summer maize rotation ecosystem at Gucheng Station from 2020 to 2022, and produced a standardized dataset after data quality control and processing. This dataset has important scientific significance and practical application value in the assessment of farmland ecosystem carbon budget, water resources utilization, and the mitigation of the impact of adverse meteorological conditions on farmland ecosystems and agricultural production.

Keywords: eddy covariance; winter wheat; summer maize; carbon flux; water flux; cropland carbon sink; cropland water consumption

# Dataset Profile

<table><tr><td rowspan=1 colspan=1>Title</td><td rowspan=1 colspan=1>A dataset of carbon and water fluxes in farmland ecosystems at Gucheng Station (2020-2022)</td></tr><tr><td rowspan=1 colspan=1>Data corresponding author</td><td rowspan=1 colspan=1>ZHOU Guangsheng (zhougs @cma.gov.cn)</td></tr><tr><td rowspan=1 colspan=1>Data authors</td><td rowspan=1 colspan=1>ZHOU Li, GENG Jinjian, ZHOU Guangsheng, ZHANG Sen, WU Yixuan</td></tr><tr><td rowspan=1 colspan=1>Time range</td><td rowspan=1 colspan=1>2020 -2022</td></tr><tr><td rowspan=1 colspan=1>Geographical scope</td><td rowspan=1 colspan=1>115°40&#x27; E,39° 08&#x27; N,15m a.s.l.</td></tr><tr><td rowspan=1 colspan=1>Data volume</td><td rowspan=1 colspan=1>25.8 MB</td></tr><tr><td rowspan=1 colspan=1> Data format</td><td rowspan=1 colspan=1>*.xlsx</td></tr><tr><td rowspan=1 colspan=1>Data service system</td><td rowspan=1 colspan=1>&lt;https://doi.org/10.57760/sciencedb.o00119.00071&gt;</td></tr><tr><td rowspan=1 colspan=1>Sources of funding</td><td rowspan=1 colspan=1>National Science and Technology Basic Resources Survey Program of China(2019FY101302)； China Meteorological Administration Innovation DevelopmentSpecial Project (CXFZ2023P052).</td></tr><tr><td rowspan=1 colspan=1>Dataset composition</td><td rowspan=1 colspan=1>The dataset comprises two subsets,namely fluxes data and meteorological data. Eachsubset contains information at four different time scales: half-hourly,daily,monthly,andyearly. Among them, the flux data product covers ecosystem net carbon exchange (NEE),ecosystem respiration (Reco),ecosystem photosynthesis (GEE),sensible heat flux (Hs),and latent heat flux (LE),etc.； meteorological data product covers air temperature,humidity, wind speed, wind direction, solar radiation, photosynthetically active radiation,soil temperature,soil moisture,and rainfall, etc.</td></tr></table>