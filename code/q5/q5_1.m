clc; clear; close all;
% 最优投资分配以及最高GDP
%% 导入初始数据
% 工资增长率
data_1 = readtable('../../data/行业年均工资及其增长率.xlsx', 'Sheet', 'Sheet3', 'VariableNamingRule', 'preserve');
% 行业工资平均值
data_2 = readtable('../../data/行业年均工资及其增长率.xlsx', 'Sheet', 'Sheet4', 'VariableNamingRule', 'preserve');
% 行业就业人口
data_3 = readtable('../../data/近十年就业人口数据.xlsx', 'Sheet', 'Sheet2', 'VariableNamingRule', 'preserve');
% 行业投资值
data_investment = readtable('../../data/近二十年各产业投资情况数据表.xlsx', 'Sheet', 'Sheet2', 'VariableNamingRule', 'preserve');
data_GDPs = readtable('../../data/近二十年各行业生产总值数据-en.xlsx', 'Sheet','Sheet1', 'VariableNamingRule', 'preserve');
format long

disp(data_1);
disp(data_2);
disp(data_3);
disp(data_investment);
disp(data_GDPs);

%% 数据处理

avg_investment = sum(data_investment.SUM) ./ 21;
max_investment = max(data_investment.SUM);

data_investment(1:11, :) = [];
data_year = data_investment(:, "Year");
% 删除年份
data_investment(:, "Year") = [];
data_GDPs(:, "Years") = [];
% 删除部分投资、GDP年份
data_GDPs(1:11, :) = [];
data_investment(:, 1) = [];
data_GDPs(:, "S1") = [];

data_3(1, :) = [];
data_2(1, :) = [];

% 删除多余列
data_2(:, 'AVG') = [];
data_3(:, 'AVG-People') = [];

% 删除年份
data_3(:, 1) = [];
data_2(:, 1) = [];
data_1(:, 1) = [];
%% 数据展示
disp('行业投资总值');
head(data_investment, 10);
disp('行业GDP');
head(data_GDPs, 10);
disp('工资增长率');
head(data_1, 10);
disp('行业工资平均值');
head(data_2, 10);
disp('行业就业人口');
head(data_3, 10);


%% 计算投资回报率、就业弹性和工资弹性
gdp_growth = diff(table2array(data_GDPs));
investment_growth = diff(table2array(data_investment));
employment_growth = diff(table2array(data_3));
wage_growth = diff(table2array(data_1));

investment_return_rate = gdp_growth ./ investment_growth;
employment_elasticity = employment_growth ./ investment_growth;
wage_elasticity = wage_growth ./ investment_growth;

%% 计算投资回报率、就业弹性和工资弹性
gdp_growth = diff(table2array(data_GDPs));
investment_growth = diff(table2array(data_investment));
employment_growth = diff(table2array(data_3));
wage_growth = diff(table2array(data_1));

investment_return_rate = gdp_growth ./ investment_growth;
employment_elasticity = employment_growth ./ investment_growth;
wage_elasticity = wage_growth ./ investment_growth;

%% 计算投资回报率、就业弹性和工资弹性
gdp_growth = diff(table2array(data_GDPs));
investment_growth = diff(table2array(data_investment));
employment_growth = diff(table2array(data_3));
wage_growth = diff(table2array(data_1));

investment_return_rate = gdp_growth ./ investment_growth;
employment_elasticity = employment_growth ./ investment_growth;
wage_elasticity = wage_growth ./ investment_growth;

%% 构建线性规划问题
