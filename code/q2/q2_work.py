import pandas as pd

# 清空环境（Python 中通常不需要这一步，但为了完整性保留）
# 导入初始数据
data_investment = pd.read_excel('../../data/近二十年各产业投资情况数据表.xlsx', sheet_name='Sheet2')
data_GDPs = pd.read_excel('../../data/近二十年各行业生产总值数据-en.xlsx', sheet_name='Sheet1')

# 显示更新后的前五行数据
print('每一年的投资总值')
print(data_investment.head())
print('GDP总值')
print(data_GDPs.head())

# 提取年份列
years_investment = data_investment.iloc[:, 0]
years_GDPs = data_GDPs.iloc[:, 0]

# 计算各行业的同比增长率
investment_growth = data_investment.iloc[:, 1:].pct_change().dropna()
GDPs_growth = data_GDPs.iloc[:, 1:].pct_change().dropna()

# 将年份列重新添加到结果DataFrame中
investment_growth.insert(0, 'Years', years_investment[1:])
GDPs_growth.insert(0, 'Years', years_GDPs[1:])


# 显示增长率
print('投资增长率 (%)')
print(investment_growth)
print('GDPs增长率 (%)')
print(GDPs_growth)


# 保存增长率表
output_path = '../../data/'
investment_growth.to_excel(output_path+'20y-investment增长率.xlsx')
GDPs_growth.to_excel(output_path+'20y-GDPs增长率.xlsx')





