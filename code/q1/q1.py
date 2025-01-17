# 导入相关模块
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn as sns

# 防止绘图中文乱码
mpl.rcParams['font.family'] = 'SimHei'  # 使用黑体
mpl.rcParams['axes.unicode_minus'] = False  # 正确显示负号

# 移除SettingWithCopyWarning警告
pd.options.mode.chained_assignment = None

# 导入初始相关数据
df=pd.read_excel('../../data/近十年各行业生产总值数据表.xlsx',sheet_name='Sheet1')

# 选择特定的列来创建一个新的DataFrame
df1 = df[['国内生产总值', '农林牧渔业', '工业', '建筑业', '批发和零售业', '交通运输、仓储和邮政业', '住宿和餐饮业', '金融业', '房地产业', '其他']]

# 中英文列标题对照
industry_names1 = {
    '国内生产总值': 'GDP',
    '农林牧渔业': 'Farming, Forestry,\n Livestock and Fishing',
    '工业': 'Industry',
    '建筑业': 'Construction',
    '批发和零售业': 'Wholesale and\nRetail Trade',
    '交通运输、仓储和邮政业': 'Transportation, Warehousing,\nand Postal Services',
    '住宿和餐饮业': 'Accommodation and\nCatering',
    '金融业': 'Finance',
    '房地产业': 'Real Estate',
    '其他': 'Others'
}

# 使用映射将中文列标题转换为英文
df1.rename(columns=industry_names1, inplace=True)

# 相关性分析1：根据经济的具体数值进行相关性分析

correlation_matrix = df1.corr()
plt.figure(figsize=(12,10))
sns.heatmap(correlation_matrix, vmax=1, square=True,annot=True,cmap='YlOrRd')
# plt.title("Industry Correlation Matrix")
# 保存图像
plt.savefig("../../img/Industry_Correlation_Matrix.png", dpi=500)
# plt.show()


# 相关性分析2：根据经济的增长率数值进行相关性分析
# 计算各行业的同比增长率
df_growth = df1.pct_change().dropna()

# 计算相关矩阵
correlation_growth = df_growth.corr()

# 绘制增长率的相关性热力图
plt.figure(figsize=(12, 10))
sns.heatmap(correlation_growth, vmax=1, vmin=-1, square=True, annot=True, cmap='coolwarm', linewidths=0.5)
# plt.title("Growth Rate Correlation Matrix")
# 保存图像
plt.savefig("../../img/Growth_Rate_Correlation_Matrix.png", dpi=500)
# plt.show()
