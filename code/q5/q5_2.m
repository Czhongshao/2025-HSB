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

data_investment(1:10, :) = [];
data_year = data_investment(:, "Year");
% 删除年份
data_investment(:, "Year") = [];
data_GDPs(:, "Years") = [];
% 删除部分投资、GDP年份
data_GDPs(1:10, :) = [];
data_investment(:, 1) = [];
data_GDPs(:, "S1") = [];


% 删除多余列
data_2(:, 'AVG') = [];
data_3(:, 'AVG_People') = [];

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
%% 数据计算
% 转换表格为矩阵形式
% investment_matrix = table2array(data_investment(:, 2:end));
% gdp_matrix = table2array(data_GDPs(:, 2:end));
% employment_matrix = table2array(data_employment(:, 2:end));
% wage_growth_matrix = table2array(data_wage_growth(:, 2:end));

data_GDPs = table2array(data_GDPs(:, 2:end));
data_investment = table2array(data_investment(:,  2:end));
data_3 = table2array(data_3(:, 2:end));
data_1 = table2array(data_1(:, 2:end));

% 计算增长率
gdp_growth = diff(data_GDPs);                % GDP增长率
investment_growth = diff(data_investment);  % 投资增长率
employment_growth = diff(data_3);  % 就业增长率
wage_growth = data_1;       % 工资增长率

% 计算弹性和回报率
investment_return_rate = gdp_growth ./ investment_growth;  % 投资回报率
employment_elasticity = employment_growth ./ investment_growth; % 就业弹性
wage_elasticity = wage_growth ./ investment_growth;       % 工资弹性

%% 数据展示
disp('投资回报率:');
disp(investment_return_rate);
disp('就业弹性:');
disp(employment_elasticity);
disp('工资弹性:');
disp(wage_elasticity);

%% 构建优化模型
% 投资预算和约束条件
I_total = 10000; % 总投资预算
I_min = 10;      % 每个行业最低投资金额
n = size(investment_return_rate, 2); % 行业数量

% 目标函数权重
w1 = 0.5; % GDP权重
w2 = 0.3; % 就业权重
w3 = 0.2; % 工资权重

% 目标函数系数
f = -(w1 * mean(investment_return_rate, 1) + ...
      w2 * mean(employment_elasticity, 1) + ...
      w3 * mean(wage_elasticity, 1));

% 约束条件
A = ones(1, n); % 总投资限制
b = I_total;    % 总投资预算
lb = ones(n, 1) * I_min; % 每个行业最小投资
ub = []; % 无上界限制

% 初始投资分配
I0 = ones(n, 1) * (I_total / n); % 均匀分配初始投资

% 求解优化问题
options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter', ...
    'MaxIterations', 500, 'MaxFunctionEvaluations', 1000);
[I_optimal, Z_max] = fmincon(@(I) f * I, I0, A, b, [], [], lb, ub, [], options);

%% 结果展示
disp('最优投资分配:');
disp(I_optimal);
disp('优化后的目标函数值:');
disp(-Z_max);
