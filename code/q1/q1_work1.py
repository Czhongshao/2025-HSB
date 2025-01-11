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
df1 = df[['年份', '国内生产总值', '农林牧渔业', '工业', '建筑业', '批发和零售业', '交通运输、仓储和邮政业', '住宿和餐饮业', '金融业', '房地产业', '其他']]

# 中英文列标题对照
industry_names1 = {
    '年份': 'Years',
    '国内生产总值': 'GDP',
    '农林牧渔业': 'Farming_Forestry_Livestock_and_Fishing',
    '工业': 'Industry',
    '建筑业': 'Construction',
    '批发和零售业': 'Wholesale_and_Retail_Trade',
    '交通运输、仓储和邮政业': 'Transportation_Warehousing_and_Postal_Services',
    '住宿和餐饮业': 'Accommodation_and_Catering',
    '金融业': 'Finance',
    '房地产业': 'Real_Estate',
    '其他': 'Others'
}

# 使用映射将中文列标题转换为英文
df1.rename(columns=industry_names1, inplace=True)
# df1.head()
# 保存文件
df1.to_excel('../../data/近十年各行业生产总值数据-en.xlsx', index=False)