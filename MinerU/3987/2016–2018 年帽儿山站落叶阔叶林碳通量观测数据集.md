ISSN 2096-2223 CN 11-6035/N

GR

文献 CSTR：32001.14.11-6035.csd.2023.0024.zh文献 DOI：10.11922/11-6035.csd.2023.0024.zh数据 DOI：10.57760/sciencedb.o00119.00075文献分类：地球科学

![](images/f1815f06d36094ca1c6e531eee3e9dd021ad7552efcd07b5b615967137b2cf80.jpg)

收稿日期：2023-01-14  
开放同评：2023-01-31  
录用日期：2023-04-25  
发表日期：2023-06-16

# 2016–2018 年帽儿山站落叶阔叶林碳通量观测数据集

王兴昌 1，胡可铭 2，刘帆 3，朱苑 1，张全智 1，王传宽 1\*

1. 东北林业大学，生态研究中心，哈尔滨 150040  
2. 东北林业大学，奥林学院，哈尔滨 150040  
3. 中国科学院遗传与发育生物学研究所，农业资源研究中心，石家庄 050022

摘要：森林生态系统是陆地生态系统碳循环的主体，准确估算森林生态系统的碳通量是理解全球变化对全球碳循环影响的基础。基于微气象理论的涡动协方差法是陆地生态系统碳通量的标准监测方法之一，已经广泛用于森林、草地、农田等生态系统碳通量长期监测。黑龙江帽儿山森林生态系统国家野外科学观测研究站，属大陆性季风气候，主要植被为天然次生林（温带落叶阔叶林），在我国东北东部山地森林中具有典型性。本数据集整理了 2016–2018 年帽儿山落叶阔叶林实测的碳通量数据和气象观测数据，包括总初级生产力、生态系统呼吸、净生态系统交换量、入射太阳辐射、入射光合有效辐射、气温、土壤温度、土壤水分和降水量。数据集分为半小时、日、月和年 4 个时间尺度。建立和共享本数据集可为评价我国东北温带次生林在区域碳循环中的地位以及优化碳循环模型提供必要、准确、可靠的数据支撑。

关键词：涡动协方差；通量数据；碳循环；落叶阔叶林

数据库（集）基本信息简介  

<table><tr><td rowspan=1 colspan=1>数据库（集）名称</td><td rowspan=1 colspan=1>2016-2018 年帽儿山站落叶阔叶林碳通量数据集</td></tr><tr><td rowspan=1 colspan=1>数据通信作者</td><td rowspan=1 colspan=1>王传宽（wangck-cf@nefu.edu.cn）</td></tr><tr><td rowspan=1 colspan=1>数据作者</td><td rowspan=1 colspan=1>王兴昌、胡可铭、刘帆、朱苑、张全智、王传宽</td></tr><tr><td rowspan=1 colspan=1>数据时间范围</td><td rowspan=1 colspan=1>2016-2018年</td></tr><tr><td rowspan=1 colspan=1>地理区域</td><td rowspan=1 colspan=1>45°25.002&#x27;N，12740.070&#x27;E，黑龙江帽儿山森林生态系统国家野外科学观测研究站。</td></tr><tr><td rowspan=1 colspan=1>数据量</td><td rowspan=1 colspan=1>8.18 MB</td></tr><tr><td rowspan=1 colspan=1>数据格式</td><td rowspan=1 colspan=1>*.xlsx</td></tr><tr><td rowspan=1 colspan=1>数据服务系统网址</td><td rowspan=1 colspan=1>https://doi.org/10.57760/sciencedb.o00119.00075</td></tr><tr><td rowspan=1 colspan=1>基金项目</td><td rowspan=1 colspan=1>国家自然科学基金（32171765，41503071)</td></tr><tr><td rowspan=1 colspan=1>数据库（集）组成</td><td rowspan=1 colspan=1>数据集共包括2个数据文件夹，其中：(1）落叶阔叶林气象数据文件夹是2016-2018年半小时、日、月和年尺度的常规气象数据（包括入射太阳辐射、入射光合有效辐射、气温、饱和水汽压亏缺、土壤温度、土壤水分和降水),共12个EXCEL表格文件，数据量为5.16 MB;</td></tr></table>

\* 论文通信作者 王传宽：wangck-cf@nefu.edu.cn

<table><tr><td>数据库（集）组成</td><td>(2）落叶阔叶林通量数据文件夹是2016-2018年半小时、日、月和年尺度的通 量数据（包括总初级生产力、生态系统呼吸、净生态系统交换量），共12个 EXCEL表格文件，数据量为3.02MB。</td></tr></table>

# 引 言

亚洲温带森林是世界三大温带森林之一，而天然次生林（落叶阔叶林）是中国东北东部地区最典型的植被类型之一。由于长期受到人类生产活动的影响，我国温带植被遭受了严重的破坏[1]。近年来，随着国家对生态文明的重视程度加强，大规模退耕还林和天然林保护工程逐步展开，温带落叶阔叶林碳循环在区域碳循环研究中的地位上升。中国东部地区作为落叶阔叶林分布面积最多的区域[2]，在实现碳中和目标中起重要作用[3]。而森林生态系统碳通量的精准量化有助于区域小气候和碳循环的研究[4]，并为陆地生态系统碳循环在全球变化中的响应提供科学依据。

涡动协方差（Eddy Covariance）技术能够直接连续高频地测量陆地生态系统与大气之间的碳通量交换值[5]。1990 年 Wofsy 等[6]首次将其用于测定年尺度森林生态系统的 $\mathrm { C O } _ { 2 }$ 通量，开启了涡动协方差技术应用于生态领域测定的新纪元。2002 年我国正式成立中国陆地生态系统通量观测网络（ChinaFLUX），为进一步观测中国碳水能量通量夯实了基础[7]。经过20年的发展，ChinaFLUX 研究站点已达 79 个（观测塔 83 座）[8]。帽儿山森林生态系统站作为 ChinaFLUX 的成员之一，积累了多年的碳通量、能量通量和气象观测数据。

本数据集整理了2016–2018 年的帽儿山落叶阔叶林通量数据和常规气象数据，包括 $\mathrm { C O } _ { 2 }$ 通量、气温、降水量、土壤温度和土壤体积含水率等观测指标，实现数据公开共享，以期为区域内大尺度$\mathrm { C O } _ { 2 }$ 通量年际波动及其驱动机制、温带森林碳汇强度研究以及优化生物地球循环模型提供数据支撑。

# 数据采集和处理方法

# 1.1 样地描述

研究地点位于黑龙江省帽儿山森林生态系统国家野外科学观测研究站（ $4 5 ^ { \circ } 2 4 \mathrm { N }$ ， $1 2 7 ^ { \circ } 4 0 ^ { \prime } \mathrm { E }$ ），属大陆性季风气候，夏季温暖湿润，冬季寒冷干燥。年平均气温为 $3 . 1 ^ { \circ } \mathrm { C }$ ，年平均降水量为 $6 2 9 \mathrm { m m } ^ { [ 9 ] }$ 。

帽儿山通量塔（ $4 5 ^ { \circ } 2 5 . 0 0 2 \mathrm { N }$ ， $1 2 7 ^ { \circ } 4 0 . 0 7 0 ^ { \prime } \mathrm { E }$ ）位于千层沟东北-西南走向的山谷（宽 $2 0 0 0 \mathrm { m }$ ，深$2 4 0 \mathrm { m } )$ ）中西南一侧的低谷区域。土壤为典型暗棕壤[9]。通量塔所属样地植被为采伐后形成的温带落叶阔叶林，林龄约为 70 年，平均冠层高度约 $2 0 ~ \mathrm { m } ^ { [ 1 0 ] }$ 。通量贡献区内林分结构复杂，将主要乔木树种按生物量密度大小从高到低进行排序，包括春榆（Ulmus davidiana var. japonica）、水曲柳（Fraxinusmandschurica）、白桦（Betula platyphylla）、胡桃楸（Juglans mandshurica）、五角槭（Acer mono）和大青杨（Populus ussuriensis）等。林下植被以暴马丁香（Syinga reticulata var. mandshurica）为主[11]。通量塔塔高 $4 8 \mathrm { ~ m ~ }$ ，开路涡动协方差系统安装在通量塔的 $3 6 ~ \mathrm { m }$ 高处，于 2007 年 7 月调试完成。

# 1.2 数据采集方法

$\mathrm { C O } _ { 2 }$ 通量数据采用开路涡动协方差（OPEC）系统测量，包括水平安装的三维超风速仪（CSAT3,Campbell Scientific Inc., USA）和垂直安装的开路式 $\mathrm { C O } _ { 2 } / \mathrm { H } _ { 2 } \mathrm { O }$ 红外气体分析仪（LI-7500, LI-COR, USA）。通过数据采集器（CR3000, Campbell Scientific Inc., USA）以 $1 0 \ \mathrm { H z }$ 的频率在线采集原始数据，同时并输出 $3 0 \mathrm { { m i n } }$ 平均值。使用 8 层廓线系统（AP100, Campbell Scientific Inc., USA）测量 EC 系统下方$\mathrm { C O } _ { 2 } / \mathrm { H } _ { 2 } \mathrm { O }$ 摩尔分数，安装高度在 $0 . 5 \mathrm { m }$ 、 $2 \mathrm { m }$ 、 $4 \mathrm { m }$ 、 $8 \mathrm { m }$ 、 $1 6 \mathrm { m }$ 、 $2 0 \mathrm { m }$ 、 $2 8 \mathrm { m }$ 和 $3 6 \mathrm { m }$ 。原始测量频率为 $2 \mathrm { H z }$ ，通过数据采集器（CR1000, Campbell Scientific Inc., USA）记录 $\mathrm { C O } _ { 2 }$ 浓度的 $2 \mathrm { m i n }$ 和 $3 0 \mathrm { { m i n } }$ 平均值。常规气象数据包括入射太阳辐射（SR）、入射光合有效辐射（PAR）、气温（Ta）、饱和水汽压亏缺（VPD）、土壤温度（Ts）、土壤水分（Ms），其观测记录输出频率为 $3 0 \mathrm { { m i n } }$ ，由通量塔上相应的数据采集系统自动完成数据获取和存储。降水量（Precipitation）由观测员在距离通量塔 2$\mathrm { k m }$ 处的气象观测站进行人工采集。为了保证数据的准确性和研究结果的可靠度，对所有仪器设备进行定期校对和维护。所用仪器配置见表 1。

# 表 1 观测项目所用观测仪器相关信息

Table 1 Information of the analyzers used in the project   

<table><tr><td rowspan=1 colspan=1>观测系统</td><td rowspan=1 colspan=1>观测要素</td><td rowspan=1 colspan=1>观测仪器</td><td rowspan=1 colspan=1>观测仪器制造商</td><td rowspan=1 colspan=1>数据采集传感器</td></tr><tr><td rowspan=7 colspan=1>常规气象要素</td><td rowspan=1 colspan=1>入射太阳辐射</td><td rowspan=1 colspan=1>CNR4</td><td rowspan=2 colspan=1>Kipp&amp; Zonen, the Netherlands</td><td rowspan=7 colspan=1>CR1000</td></tr><tr><td rowspan=1 colspan=1>入射光合有效辐射</td><td rowspan=1 colspan=1>PQS1</td></tr><tr><td rowspan=1 colspan=1>气温</td><td rowspan=1 colspan=1>HMP45C with 076B</td><td rowspan=1 colspan=1>Vessla, Finland</td></tr><tr><td rowspan=1 colspan=1>降水量</td><td rowspan=1 colspan=1>JQR-1雨量筒</td><td rowspan=1 colspan=1>长春气象仪器有限公司</td></tr><tr><td rowspan=1 colspan=1>饱和水汽压亏缺</td><td rowspan=1 colspan=1>HMP45C with 076B</td><td rowspan=1 colspan=1>Vessla, Finland</td></tr><tr><td rowspan=1 colspan=1>土壤温度</td><td rowspan=1 colspan=1>Model 107</td><td rowspan=1 colspan=1>Campbell Scientific Inc., USA</td></tr><tr><td rowspan=1 colspan=1>土壤体积含水率</td><td rowspan=1 colspan=1>EasyAG /CS616</td><td rowspan=1 colspan=1>Sentek Inc., Australia/Campbell Scientific Inc., USA</td></tr><tr><td rowspan=2 colspan=1>CO2涡动通量</td><td rowspan=1 colspan=1>三维超声风速</td><td rowspan=1 colspan=1>CSAT3</td><td rowspan=1 colspan=1>Campbell Scientific Inc., USA</td><td rowspan=2 colspan=1>CR3000</td></tr><tr><td rowspan=1 colspan=1>CO2、HO密度</td><td rowspan=1 colspan=1>LI-7500</td><td rowspan=1 colspan=1>LI-COR, USA</td></tr><tr><td rowspan=1 colspan=1>CO2储存通量</td><td rowspan=1 colspan=1>8层COz、HO摩尔分数廓线</td><td rowspan=1 colspan=1>AP100</td><td rowspan=1 colspan=1>Campbell Scientific Inc., USA</td><td rowspan=1 colspan=1>CR1000</td></tr></table>

# 1.3 数据加工、处理方法与流程

$\mathrm { C O } _ { 2 }$ 通量数据由数据采集器（CR3000, Campbell Scientific Inc., USA）自动采集并存储，原始采样频率为 $1 0 \mathrm { H z }$ ，数据处理时将其转换为时间步长为 $3 0 \mathrm { { m i n } }$ 的平均值。基于ChinaFLUX的数据处理流程，对获得的碳通量原始观测数据完成标准化的质量控制和数据处理。此外，根据站点的实际情况，数据处理流程做出了相应的调整。数据处理流程见图 1。

$3 0 \mathrm { { m i n } }$ 尺度的净生态系统交换量（NEE）计算公式如下：

$$
N E E = F c + F s
$$

其中 $F c$ 表示垂直湍流通量， $F s$ 表示储存通量。

通量数据质量控制：采用国际上普遍认可的涡动协方差通量数据质量控制方法， $F c$ 数据处理主要包括野点去除、延时校正、平面拟合坐标旋转、频率响应校正、WPL 和表面加热效应校正[12]。 $F s$ 计算中利用了8层廓线并选择 $2 \mathrm { m i n }$ 时间窗口代替传统 $3 0 ~ \mathrm { { m i n } }$ 时间窗口，用于减少由时间平均造成的 $F s$ 低估[13]。

![](images/505e4f4b230e38e86d12469ac66d4c6330c1141d1c5693ea5076a52c3aa16b11.jpg)  
图 1 帽儿山站碳通量数据和常规气象数据处理流程  
Figure 1 Flow chart of the processing of carbon flux and conventional meteorological data at Maoershan Station

缺失数据插补：对于NEE缺失数据，采用非线性回归的方式进行插补。5–9月白天的NEE 用各月份的直角双曲线光响应模型插补[14]。4 月末和 10 月初由于光合作用弱，直角双曲线模型拟合效果较差，采用平均日变化法完成插补，公式如下：

$$
N E E = \frac { - \alpha \times A _ { \operatorname* { m a x } } \times P A R } { \alpha \times P A R + A _ { \operatorname* { m a x } } } + R _ { d }
$$

其中 $\mathfrak { a }$ 为光合量子效率， $\mathbf { A } _ { \mathrm { m a x } }$ 为冠层最大光合速率，PAR 为冠层上方入射光合有效辐射， $\mathrm { R _ { d } }$ 为白天平均呼吸速率。 $\mathfrak { a }$ 、 $\mathbf { A } _ { \mathrm { m a x } }$ 和 $\mathrm { R _ { d } }$ 通过非线性回归从测量的NEE和 PAR 值拟合获得。

夜间数据过滤与插补：为了最大程度减少平流项的影响，夜间NEE即夜间生态系统呼吸（夜间Re）数据不是用传统的摩擦风速阈值过滤，而是用傍晚最大呼吸法过滤[15]。根据 Gorsel[15]等的研究，测试了4个时间窗口（2.0、2.5、3.0、 $4 . 0 \mathrm { h }$ ）和6个呼吸阈值区间（ $0 . 2 5 { - } 2 . 0 \operatorname { R } _ { \mathrm { d } }$ 、 $0 . 2 5 { - } 3 . 0 \mathrm { R } _ { \mathrm { d } }$ 、0.25–$4 . 0 \mathrm { R _ { d } }$ 、 $0 . 5 { - } 2 . 0 \mathrm { R _ { d } }$ 、 $0 . 5 { - } 3 . 0 \mathrm { R _ { d } }$ 和 $0 . 5 { \mathrm { - } } 4 . 0 \mathrm { R _ { d } }$ ）共24个组合的 $\mathrm { C O } _ { 2 }$ 通量，1–4 月和 10–12 月的 $\mathrm { R _ { d } }$ 设为$0 . 1 \ \mathrm { m g } \ C \mathrm { O } _ { 2 } \ \mathrm { m } ^ { - 2 } \ \mathrm { s } ^ { - 1 }$ ，5–9 月的 $\mathrm { R _ { d } }$ 由公式（2）计算得出。 $\mathrm { C O } _ { 2 }$ 通量选择 $3 . 0 \mathrm { h }$ 时间窗口、 $0 . 5 { - } 3 . 0 \mathrm { R } _ { \mathrm { d } }$ 区间的估计值为参考。全年夜间数据通过最大呼吸法进行过滤，5–9月数据缺失值采用湿度调整的温度呼吸模型（公式 3）[16]插补，1–4 月和 10–12 月缺失值采用温度呼吸模型（公式 4）插补。湿度调整的温度呼吸模型如下：

$$
R e = ( a + b \times S W C + S W C ^ { 2 } ) \times \mathrm { e } ^ { E _ { 0 } \times \left( \frac { 1 } { T _ { r e f } - T _ { 0 } } - \frac { 1 } { T _ { s } - T _ { 0 } } \right) }
$$

$$
\begin{array} { r } { R e = c \times \mathrm { e } ^ { E _ { 0 } \times \left( \frac { 1 } { T _ { r e f } - T _ { 0 } } - \frac { 1 } { T _ { s } - T _ { 0 } } \right) } } \end{array}
$$

其中根据 Lloyd[17]等的研究， $\mathrm { T } _ { 0 }$ 为 $^ { - 4 6 . 0 2 ^ { \circ } \mathrm { C } }$ ， $\mathrm { E } _ { 0 }$ 为活化能参数。a、b、c为经验系数[16]。SWC 为 30cm土壤湿度，TS为 $0 \mathrm { c m }$ 土壤温度， $\mathrm { T _ { r e f } }$ 为参考温度设为 $1 0 ~ ^ { \circ } \mathrm { C }$ 。由于 1–4月和 10–12 月的土壤含水率变化极小，且这段时间的 Re主要源于土壤呼吸，因此仅用 $5 \ \mathrm { c m }$ 土壤温度拟合呼吸模型来对夜间数据进行插补和估算白天 Re。

$\mathbf { C O } _ { 2 }$ 通量数据拆分：生态系统净碳吸收时，NEE 为负值。用Re与NEE的差值来计算生态系统总初级生产力（GPP）值。

气象数据：使用常规气象观测系统获得观测数据。气象数据包括气温、降水量、土壤温度和土壤体积含水率。各种数据用数据采集器（CR1000）采集并存储。缺失的气象数据利用通量塔周边气象站进行插补。其中需要说明的是，降水量数据采用人工观测数据，包括日、月和年 3 个时间尺度。

# 数据样本描述

本数据集为帽儿山落叶阔叶林2016–2018年连续3年的碳通量观测数据。数据集由24个EXCEL数据文件组成，总数据量为 $8 . 1 8 \mathrm { M B }$ ，包括 2016–2018 年30分钟、日、月和年尺度的常规气象数据文件和通量数据文件。

以 2016 年数据为例，表 2、表 3 分别为 2016 年帽儿山落叶阔叶林不同时间尺度气象和通量数据表头参数含义及单位说明。

表 2 帽儿山站不同时间尺度气象观测数据表说明  
Table 2 Description of meteorological observation data table at different time scales at Maoershan Station   

<table><tr><td rowspan=1 colspan=1>序号</td><td rowspan=1 colspan=1>字段名称</td><td rowspan=1 colspan=1>字段代码</td><td rowspan=1 colspan=1>量纲</td><td rowspan=1 colspan=1>数据类型</td><td rowspan=1 colspan=1>示例数据</td><td rowspan=1 colspan=1>数据说明</td></tr><tr><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>年份</td><td rowspan=1 colspan=1>YYYY</td><td rowspan=1 colspan=1>二</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>2016</td><td rowspan=1 colspan=1></td></tr><tr><td rowspan=1 colspan=1>2</td><td rowspan=1 colspan=1>月份</td><td rowspan=1 colspan=1>MM00</td><td rowspan=1 colspan=1>-</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1></td></tr><tr><td rowspan=1 colspan=1>3</td><td rowspan=1 colspan=1>日期</td><td rowspan=1 colspan=1>DD00</td><td rowspan=1 colspan=1>-</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1></td></tr><tr><td rowspan=1 colspan=1>4</td><td rowspan=1 colspan=1>小时</td><td rowspan=1 colspan=1>HH00</td><td rowspan=1 colspan=1>■</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>7</td><td rowspan=1 colspan=1>■</td></tr><tr><td rowspan=1 colspan=1>5</td><td rowspan=1 colspan=1>分钟</td><td rowspan=1 colspan=1>MI00</td><td rowspan=1 colspan=1>-</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>30</td><td rowspan=1 colspan=1></td></tr><tr><td rowspan=1 colspan=1>6</td><td rowspan=1 colspan=1>入射太阳辐射</td><td rowspan=1 colspan=1>SR</td><td rowspan=1 colspan=1>Wm²2</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>5.248</td><td rowspan=1 colspan=1>观测高度48m</td></tr><tr><td rowspan=1 colspan=1>7</td><td rowspan=1 colspan=1>入射光合有效辐射</td><td rowspan=1 colspan=1>PAR</td><td rowspan=1 colspan=1>μmol m²2 s-1</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>9.691</td><td rowspan=1 colspan=1>观测高度48m</td></tr><tr><td rowspan=1 colspan=1>8</td><td rowspan=1 colspan=1>气温</td><td rowspan=1 colspan=1>Ta</td><td rowspan=1 colspan=1>℃</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>-10.57</td><td rowspan=1 colspan=1>观测高度16m</td></tr><tr><td rowspan=1 colspan=1>9</td><td rowspan=1 colspan=1>饱和水汽压亏缺</td><td rowspan=1 colspan=1>VPD</td><td rowspan=1 colspan=1>kPa</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>0.051</td><td rowspan=1 colspan=1>观测高度16m</td></tr></table>

表 3 帽儿山站不同时间尺度通量观测数据表说明  

<table><tr><td rowspan=1 colspan=1>序号</td><td rowspan=1 colspan=1>字段名称</td><td rowspan=1 colspan=1>字段代码</td><td rowspan=1 colspan=1>量纲</td><td rowspan=1 colspan=1>数据类型</td><td rowspan=1 colspan=1>示例数据</td><td rowspan=1 colspan=1>数据说明</td></tr><tr><td rowspan=1 colspan=1>10</td><td rowspan=1 colspan=1>0cm土壤温度</td><td rowspan=1 colspan=1>Ts0cm</td><td rowspan=1 colspan=1>℃</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>-3.976</td><td rowspan=1 colspan=1>观测高度0cm</td></tr><tr><td rowspan=1 colspan=1>11</td><td rowspan=1 colspan=1>5cm土壤温度</td><td rowspan=1 colspan=1>Ts5cm</td><td rowspan=1 colspan=1>℃</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>-1.629</td><td rowspan=1 colspan=1>观测高度-5cm</td></tr><tr><td rowspan=1 colspan=1>12</td><td rowspan=1 colspan=1>10 cm土壤水分</td><td rowspan=1 colspan=1>Ms10cm</td><td rowspan=1 colspan=1>%</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>6.1185</td><td rowspan=1 colspan=1>观测高度-10 cm</td></tr><tr><td rowspan=1 colspan=1>13</td><td rowspan=1 colspan=1>20cm土壤水分</td><td rowspan=1 colspan=1>Ms20cm</td><td rowspan=1 colspan=1>%</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>19.0425</td><td rowspan=1 colspan=1>观测高度-20 cm</td></tr><tr><td rowspan=1 colspan=1>14</td><td rowspan=1 colspan=1>30cm土壤水分</td><td rowspan=1 colspan=1>Ms30cm</td><td rowspan=1 colspan=1>%</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>23.9775</td><td rowspan=1 colspan=1>观测高度-30 cm</td></tr><tr><td rowspan=1 colspan=1>15</td><td rowspan=1 colspan=1>50cm土壤水分</td><td rowspan=1 colspan=1>Ms50cm</td><td rowspan=1 colspan=1>%</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>29.2875</td><td rowspan=1 colspan=1>观测高度-50cm</td></tr><tr><td rowspan=1 colspan=1>16</td><td rowspan=1 colspan=1>总降水量</td><td rowspan=1 colspan=1>Precipitation</td><td rowspan=1 colspan=1>mm</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>观测高度30cm</td></tr></table>

Table 3 Description of different time scales flux observation data table at Maoershan Station   

<table><tr><td rowspan=1 colspan=1>序号</td><td rowspan=1 colspan=1>字段名称</td><td rowspan=1 colspan=1>字段代码</td><td rowspan=1 colspan=1>量纲</td><td rowspan=1 colspan=1>数据类型</td><td rowspan=1 colspan=1>示例数据</td><td rowspan=1 colspan=1>数据项说明</td></tr><tr><td rowspan=1 colspan=1>1</td><td rowspan=1 colspan=1>年份</td><td rowspan=1 colspan=1>YYYY</td><td rowspan=1 colspan=1>:</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>2016</td><td rowspan=1 colspan=1></td></tr><tr><td rowspan=1 colspan=1>2</td><td rowspan=1 colspan=1>月份</td><td rowspan=1 colspan=1>MM00</td><td rowspan=1 colspan=1>-</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>6</td><td rowspan=1 colspan=1>-</td></tr><tr><td rowspan=1 colspan=1>3</td><td rowspan=1 colspan=1>日期</td><td rowspan=1 colspan=1>DD00</td><td rowspan=1 colspan=1>-</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>3</td><td rowspan=1 colspan=1>-</td></tr><tr><td rowspan=1 colspan=1>4</td><td rowspan=1 colspan=1>小时</td><td rowspan=1 colspan=1>HH00</td><td rowspan=1 colspan=1>-</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>7</td><td rowspan=1 colspan=1>-</td></tr><tr><td rowspan=1 colspan=1>5</td><td rowspan=1 colspan=1>分钟</td><td rowspan=1 colspan=1>MI00</td><td rowspan=1 colspan=1></td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>30</td><td rowspan=1 colspan=1>-</td></tr><tr><td rowspan=1 colspan=1>6</td><td rowspan=1 colspan=1>生态系统净CO2交换</td><td rowspan=1 colspan=1>NEE</td><td rowspan=1 colspan=1>mg CO2 m² s-1, gC m² d-1,gC m² mon-1, gC m² a-1</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>-0.4181</td><td rowspan=1 colspan=1>半小时/日/月/年尺度的生态系统CO2净交换通量</td></tr><tr><td rowspan=1 colspan=1>7</td><td rowspan=1 colspan=1>生态系统呼吸</td><td rowspan=1 colspan=1>ER</td><td rowspan=1 colspan=1>mg CO2 m² s1,gC m² d1,gC m² mon1, gC m² a1</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>0.2613</td><td rowspan=1 colspan=1>半小时/日/月/年尺度的生态系统呼吸</td></tr><tr><td rowspan=1 colspan=1>8</td><td rowspan=1 colspan=1>总生态系统生产力</td><td rowspan=1 colspan=1>GPP</td><td rowspan=1 colspan=1>mg CO2 m² s1, gC m² d¹,gC m² mon1, gC m² a1</td><td rowspan=1 colspan=1>数值型</td><td rowspan=1 colspan=1>0.6795</td><td rowspan=1 colspan=1>半小时/日/月/年尺度的总生态系统生产力</td></tr></table>

# 数据质量控制和评估

本数据集中的所有数据均由帽儿山样地的实时观测、采集、质量控制、处理和存储产生，各方面都严格遵守了国际通量观测领域普遍认同的质量控制方法，具体的数据质量控制方法已在数据处理流程中有所简介。特别指出，本数据集采用 $2 \ \mathrm { m i n }$ 快速廓线计算 $\mathrm { C O } _ { 2 }$ 储存通量，夜间数据采用傍晚最大呼吸法而不是摩擦风速阈值过滤。

在半小时尺度上，2016–2018 年间的生态系统净 $\mathrm { C O } _ { 2 }$ 通量（NEE）的有效观测数据比例分别为$6 9 . 7 8 \%$ 、 $5 2 . 1 3 \%$ 、 $6 1 . 9 2 \%$ 。由于设备发生故障，2017 年3月10 日–6月28日、8月 24日–9月 9日的 $1 0 \mathrm { c m }$ 土壤水分、 $2 0 \mathrm { c m }$ 土壤水分和 $5 0 \mathrm { c m }$ 土壤水分数据缺失。

# 数据价值

目前国内基于涡动协方差技术对森林生态系统碳通量的研究已经发展了许多年[18]，对东北温带落叶阔叶林碳通量的研究也逐年增多[19-20]，但国内以论文形式公开发表的东北地区森林生态系统碳

通量观测数据集仍较少且时间较远[21-22]。本数据集采用国际流行的 EC 碳通量观测技术，基于因地制宜的 ChinaFLUX 的数据处理方法，向学界提供 2016–2018 年碳通量和常规气象数据，为东北地区森林生态系统生态功能、区域碳循环研究和模型建立等方面提供数据支撑。

# 数据使用方法

本数据集由国家生态科学数据存储库（EcoDB）提供数据共享资源，可在数据存储库中自由下载，用户可在 Science Data Bank 查询到本数据集。帽儿山群落演替较快，2016–2018 年的观测时间较近，更能体现森林碳通量现状。对于一般模型验证而言 3 年数据已经足够，因此本数据集公开 3年监测数据。后续依照站点实际情况，可协议共享时间尺度较长的数据集。

数据应用者在使用本数据集时需要注意以下2个方面：

（1）受通量观测系统运行状态及数据质量控制方法影响，数据在部分时间内出现不同程度的缺失，对缺失数据进行插补必然会导致不确定性。本数据集是在半小时尺度上的数据为基础进行数据累计求和，进而得出日、月和年尺度数据。所以，建议数据使用者根据研究的时间尺度与实际需要，有选择的使用本数据的各尺度数据。

（2）由于基于涡动协方差法测量的碳通量数据处理方法的多样性，不同处理方法的结果可能存在一定的差异。

# 数据作者分工职责

王兴昌（1982—），男，山东省淄博市人，博士，副教授，研究方向为森林碳氮水循环及其对气候变化的响应。主要承担工作：实验设计、野外系统维护和数据分析、论文写作。

胡可铭（1999—），女，江苏省南京市人，硕士研究生，研究方向为陆地生态系统碳循环。主要承担工作：论文写作、数据整理。

刘帆（1992—），女，河北省保定市人，博士，助理研究员，研究方向为陆地生态系统碳水耦合关系。主要承担工作：野外系统维护和数据分析。

朱苑（1994—），女，安徽省淮南市人，博士研究生，研究方向为森林生态系统碳循环。主要承担工作：野外系统维护和数据整理。

张全智（1981—），男，甘肃省白银市人，博士，副教授，研究方向为森林生态系统碳循环。主要承担工作：实验设计和系统维护。

王传宽（1963—），男，浙江省衢州市人，博士，教授，研究方向为森林生态系统结构与功能对全球变化的响应。主要承担工作：实验设计和经费支持。

# 参考文献

[1] 上官铁梁, 李晋鹏, 郭东罡. 中国暖温带山地植被生态学研究进展[J]. 山地学报, 2009, 27(2): 129–139. DOI: 10.3969/j.issn.1008-2786.2009.02.001. [SHANGGUAN T L, LI J P, GUO D G. Advance in mountain vegetation ecology in the warm-temperate zone of China[J]. Journal of Mountain Science, 2009, 27(2): 129–139. DOI: 10.3969/j.issn.1008-2786.2009.02.001.]

[2] 高兰. 中国落叶阔叶林分布格局及控制因子分析[D]. 山东理工大学, 2021. [GAO L. Distribution

pattern and controlling factors of deciduous broad-leaved forest in China[D]. Shandong University of Technology, 2021.]   
[3] WANG J, FENG L, PALMER P I, et al. Large Chinese land carbon sink estimated from atmospheric carbon dioxide data[J]. Nature, 2020, 586(7831): 720–723. DOI: 10.1038/s41586-020-2849-9.   
[4] YU G R, CHEN Z, PIAO S L, et al. High carbon dioxide uptake by subtropical forest ecosystems in the East Asian monsoon region[J]. Proceedings of the National Academy of Sciences of the United States of America, 2014, 111(13): 4910–4915. DOI: 10.1073/pnas.1317065111.   
[5] 王兴昌, 王传宽. 森林生态系统碳循环的基本概念和野外测定方法评述[J]. 生态学报, 2015, 35(13): 4241–4256. DOI: 10.5846/stxb201407011359. [WANG X C, WANG C K. Fundamental concepts and field measurement methods of carbon cycling in forest ecosystems: a review[J]. Acta Ecologica Sinica, 2015, 35(13): 4241–4256. DOI: 10.5846/stxb201407011359.]   
[6] WOFSY S C, GOULDEN M L, MUNGER J W, et al. Net exchange of $\mathrm { C O } _ { 2 }$ in a mid-latitude forest[J]. Science, 1993, 260(5112): 1314–1317. DOI: 10.1126/science.260.5112.1314.   
[7] 于贵瑞. 中国陆地生态系统通量观测研究网络(ChinaFLUX)的建设和发展[J]. 高科技与产业化, 2007(1): 110–111. [YU G R. Construction and development of China terrestrial ecosystem flux observation and research network (ChinaFLUX)[J]. High-Technology & Industrialization, 2007(1): 110–111.] [8] 于贵瑞, 何念鹏, 陈智. 《中国区域陆地生态系统碳氮水通量及其辅助参数观测专题》卷首语[J]. 中国科学数据, 2019, 4(1): 5–7. [YU G R, HE N P, CHEN Z. Preface of special topics on carbon, nitrogen and water fluxes and their auxiliary parameters of terrestrial ecosystem in China region[J]. China Scientific Data, 2019, 4(1): 5–7.]   
[9] 焦振, 王传宽, 王兴昌. 温带落叶阔叶林冠层 $\mathrm { C O } _ { 2 }$ 浓度的时空变异[J]. 植物生态学报, 2011, 35(5): 512–522. DOI: 10.3724/SP.J.1258.2011.00512. [JIAO Z, WANG C K, WANG X C. Spatio-temporal variations of $\mathrm { C O } _ { 2 }$ concentration within the canopy in a temperate deciduous forest, Northeast China[J]. Chinese Journal of Plant Ecology, 2011, 35(5): 512–522. DOI: 10.3724/SP.J.1258.2011.00512.]   
[10] LIU F, WANG C K, WANG X C, et al. Environmental and biotic controls on the interannual variations in $\mathrm { C O } _ { 2 }$ fluxes of a continental monsoon temperate forest[J]. Agricultural and Forest Meteorology, 2021, 296: 108232. DOI: 10.1016/j.agrformet.2020.108232.   
[11] 刘帆, 王传宽, 王兴昌, 等. 帽儿山温带落叶阔叶林通量塔风浪区生物量空间格局[J]. 生态学报, 2016, 36(20): 6506–6519. DOI: 10.5846/stxb201502270392. [LIU F, WANG C K, WANG X C, et al. Spatial patterns of biomass in the temperate broadleaved deciduous forest within the fetch of the Maoershan flux tower[J]. Acta Ecologica Sinica, 2016, 36(20): 6506–6519. DOI: 10.5846/stxb201502270392.]   
[12] AUBINET M, VESALA T, PAPALE D. Eddy Covariance: A Practical Guide to Measurement and Data Analysis[M]. Dordrecht: Springer, 2012. DOI: 10.1007/978-94-007-2351-1.   
[13] WANG X C, WANG C K, GUO Q X, et al. Improving the $\mathrm { C O } _ { 2 }$ storage measurements with a single profile system in a tall-dense-canopy temperate forest[J]. Agricultural and Forest Meteorology, 2016, 228/229: 327–338. DOI: 10.1016/j.agrformet.2016.07.020.   
[14] FALGE E, BALDOCCHI D, OLSON R, et al. Gap filling strategies for defensible annual sums of net ecosystem exchange[J]. Agricultural and Forest Meteorology, 2001, 107(1): 43–69. DOI: 10.1016/S0168- 1923(00)00225-2.

[15] VAN GORSEL E, DELPIERRE N, LEUNING R, et al. Estimating nocturnal ecosystem respiration from the vertical turbulent flux and change in storage of $\mathrm { C O } _ { 2 } [ \mathrm { J } ]$ . Agricultural and Forest Meteorology, 2009, 149(11): 1919–1930. DOI: 10.1016/j.agrformet.2009.06.020.

[16] NOORMETS A, DESAI A R, COOK B D, et al. Moisture sensitivity of ecosystem respiration: comparison of 14 forest ecosystems in the Upper Great Lakes Region, USA[J]. Agricultural and Forest Meteorology, 2008, 148(2): 216–230. DOI: 10.1016/j.agrformet.2007.08.002.

[17] LLOYD J, TAYLOR J A. On the temperature dependence of soil respiration[J]. Functional Ecology, 1994, 8(3): 315–323. DOI: 10.2307/2389824.

[18] 龚元, 纪小芳, 花雨婷, 等. 基于涡动相关技术的森林生态系统二氧化碳通量研究进展[J]. 浙江农林大学学报, 2020, 37(3): 593–604. DOI: 10.11833/j.issn.2095-0756.20190412. [GONG Y, JI X F, HUA

Y T, et al. Research progress of $\mathrm { C O } _ { 2 }$ flux in forest ecosystem based on eddy covariance technique: a review[J].Journal of Zhejiang A&F University, 2020, 37(3): 593–604. DOI: 10.11833/j.issn.2095-0756.20190412.][19] 李轩然, 孙晓敏, 张军辉, 等. 温度对中国典型森林生态系统碳通量季节动态及其年际变异的影响[J]. 第四纪研究, 2014, 34(4): 752–761. DOI: 10.3969/j.issn.1001-7410.2014.04.07. [LI X R, SUN X M,

ZHANG J H, et al. Effects of temperature on the seasonal dynamics and interannual variability of carbon flux in China’s typical forests[J]. Quaternary Sciences, 2014, 34(4): 752–761. DOI: 10.3969/j.issn.1001- 7410.2014.04.07.]

[20] 朱苑, 刘帆, 王传宽, 等. 帽儿山温带落叶阔叶林净生态系统碳交换的日变化及光响应特征[J]. 应用生态学报, 2020, 31(1): 72–82. DOI: 10.13287/j.1001-9332.201910.003. [ZHU Y, LIU F, WANG C K, et al. Diurnal variation and light response characteristics of carbon exchange in net ecosystem of temperate deciduous broad-leaved forest in Maoershan[J]. Chinese Journal of Applied Ecology, ,2020, 31(1): 72–82. DOI: 10.13287/j.1001-9332.201910.003.]

[21] 吴家兵, 关德新, 王安志, 等. 2003—2010 年长白山阔叶红松林碳水通量观测数据集[J/OL]. 中 国科学数据, 2021, 6(1). (2020-11-06). DOI: 10.11922/csdata.2020.0041.zh. [WU J B, GUAN D X, WANG A Z, et al. A dataset of carbon and water flux observation in a broad-leaved red pine forest in Changbai Mountain(2003-2010)[J/OL]. China Scientific Data, 2021, 6(1). (2020-11-06). DOI: 10.11922/csdata.2020.0041.zh.]

[22] 张雷明, 罗艺伟, 刘敏, 等. 2003—2005 年中国通量观测研究联盟(China FLUX)碳水通量观测数据集[J/OL]. 中国科学数据, 2019, 4(1). (2018-12-29). DOI: 10.11922/csdata.2018.0028.zh. [ZHANG L M,LUO Y W, LIU M, et al. Carbon and water fluxes observed by the Chinese Flux Observation and ResearchNetwork(2003-2005)[J/OL]. China Scientific Data, 2019, 4(1). (2018-12-29). DOI:10.11922/csdata.2018.0028.zh.]

# 论文引用格式

王兴昌, 胡可铭, 刘帆, 等. 2016–2018 年帽儿山站落叶阔叶林碳通量观测数据集[J/OL]. 中国科学数据, 2023, 8(2). (2023-06-16). DOI: 10.11922/11-6035.csd.2023.0024.zh.

# 数据引用格式

王兴昌, 胡可铭, 刘帆, 等. 2016–2018 年帽儿山站落叶阔叶林碳通量观测数据集[DS/OL]. ScienceData Bank, 2023. (2023-01-16). DOI: 10.57760/sciencedb.o00119.00075.

# A dataset of carbon fluxes of the deciduous broad-leaved forest at Maoershan Station from 2016 to 2018

WANG Xingchang1, HU Keming2, LIU Fan3, ZHU Yuan1, ZHANG Quanzhi1, WANG Chuankuan1\*

1. Center for Ecological Research, Northeast Forestry University, Harbin 150040, P. R. China

2. Aulin College, Northeast Forestry University, Harbin 150040, P. R. China

3. Center for Agricultural Resources Research, IGDB, CAS, Shijiazhuang 050022, P. R. China

\*Email: wangck-cf@nefu.edu.cn

Abstract: Forest ecosystem dominates the terrestrial ecosystem carbon (C) cycle, thus the accurate estimation of C flux in the forest ecosystem is essential to understanding the impact of global change on global C cycle. Based on the micrometeorology theory, the eddy covariance technique is one of the standard methods for C flux monitoring in terrestrial ecosystems, which has been widely used in the long-term monitoring of C flux in forests, grasslands, croplands and other ecosystems. Heilongjiang Maoershan Forest Ecosystem National Observation and Research Station has a continental monsoon climate, dominated by natural secondary forests (temperate deciduous broad-leaved forestd) which are typical in the montane forests of Northeast China. In this dataset, we compiled the measured C flux data and routine meteorological data of a deciduous broad-leaved forest at Maoershan Station from 2016 to 2018, including gross primary productivity, ecosystem respiration, net ecosystem exchange, incoming solar radiation, incoming photosynthetically active radiation, air temperature, soil temperature, soil moisture and precipitation. The dataset is divided into four time scales: half-hourly, daily, monthly and yearly. The establishment and sharing of this dataset will provide necessary, accurate and reliable data to support the evaluation of the role of natural secondary forests in the regional C cycle and the optimization of C cycle models.

Keywords: eddy covariance; flux data; carbon cycle; deciduous broad-leaved forest

# Dataset Profile

<table><tr><td colspan="1" rowspan="1">Title</td><td colspan="1" rowspan="1">A dataset of carbon fluxes of the deciduous broad-leaved forest at Maoershan Stationfrom 2016 to 2018</td></tr><tr><td colspan="1" rowspan="1">Data corresponding author</td><td colspan="1" rowspan="1">WANG Chuankuan (wangck-cf@nefu.edu.cn)</td></tr><tr><td colspan="1" rowspan="1">Data author(s)</td><td colspan="1" rowspan="1">WANG Xingchang,HU Keming,LIU Fan, ZHU Yuan, ZHANG Quanzhi, WANGChuankuan</td></tr><tr><td colspan="1" rowspan="1">Time range</td><td colspan="1" rowspan="1">2016-2018</td></tr><tr><td>Geographical scope</td><td>Heilongjiang Maoershan Forest Ecosystem National Observation and Research Station (45°25.002'N,127°40.070'E)</td></tr><tr><td>Data volume</td><td>8.18 MB</td></tr><tr><td>Data format</td><td>*.xlsx</td></tr><tr><td>Data service system</td><td>https://doi.org/10.57760/sciencedb.o00119.00075</td></tr><tr><td>Source(s) of funding</td><td>National Natural Science Foundation of China (32171765, 41503071)</td></tr><tr><td rowspan="7">Dataset composition</td><td>The dataset consists of 2 data folders: (1) the meteorological data folder of deciduous</td></tr><tr><td>broad-leaved forest contains the conventional meteorological data at half-hourly,daily,</td></tr><tr><td>monthly and annual scales from 2016 to 2018 (incoming solar radiation,incoming</td></tr><tr><td>photosynthetically active radiation,air temperature, soil temperature,soil moisture and</td></tr><tr><td>precipitation),with 12 EXCEL files and a data volume of 5.16 MB;(2) the flux data</td></tr><tr><td>folder of deciduous broad-leaved forest contains the flux data at half-hourly,daily,</td></tr><tr><td>monthly and annual scales from 2016 to 2018(gross primary productivity,ecosystem respiration,net ecosystem exchange)，with 12 EXCEL spreadsheet files and a data</td></tr></table>