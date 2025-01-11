# 导入相关模块
import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn as sns

# 防止绘图中文乱码
mpl.rcParams['font.family'] = 'SimHei'  # 使用黑体
mpl.rcParams['axes.unicode_minus'] = False  # 正确显示负号


df=pd.read_excel('../../data/近十年各行业生产总值数据表.xlsx',sheet_name='Sheet1')

# 选择特定的列来创建一个新的DataFrame
df1 = df[['国内生产总值', '农林牧渔业', '工业', '建筑业', '批发和零售业', '交通运输、仓储和邮政业', '住宿和餐饮业', '金融业', '房地产业', '其他']]


# 1. 相关分析

correlation_matrix = df1.corr()
plt.figure(figsize=(10,10))
sns.heatmap(correlation_matrix, vmax=1, square=True,annot=True,cmap='YlOrRd')
plt.title("Industry Correlation Matrix")
plt.show()