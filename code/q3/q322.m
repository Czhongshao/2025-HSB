clc; clear; close all;
% 计算金额分配
%% 导入初始数据
data_investment = readtable('../../data/近二十年各产业投资情况数据表.xlsx', 'Sheet', 'Sheet2', 'VariableNamingRule', 'preserve');
data_GDPs = readtable('../../data/近二十年各行业生产总值数据-en.xlsx', 'Sheet', 'Sheet1', 'VariableNamingRule', 'preserve');
format long

% 删除总GDP列与年份
data_GDPs(:, 1:2) = [];
data_year = data_investment.Years;
data_investment(:, 1) = [];

data_investment{[6, 11, 12], "S8"} = NaN;
data_GDPs{[6, 11, 12], "S8"} = NaN;

data_investment{[1, 6, 20], "S5"} = NaN;
data_GDPs{[1, 6, 20], "S5"} = NaN;

disp('行业投资总值');
head(data_investment, 20);
disp('行业GDP总值');
head(data_GDPs, 20);

%% 计算投资回报率

% 计算利润（GDP与投资值的差值）
profits = data_GDPs - data_investment;

% 计算投资回报率
investment_returns = profits ./ data_investment;

% 显示计算结果
disp('行业投资总值');
head(data_investment, 5);
disp('行业GDP总值');
head(data_GDPs, 5);
disp('利润（GDP与投资值的差值）');
head(profits, 5);
disp('投资回报率');
head(investment_returns, 5);

%% 计算每个行业的投资回报率的平均值
average_investment_returns = mean(investment_returns, 1, 'omitnan');

% 输出每个行业的投资回报率的平均值
disp('每个行业的投资回报率的平均值：');
disp(average_investment_returns);

% 转化数据
average_investment_returns = table2array(average_investment_returns);
%% 计算所有行业投资回报率的总和
total_investment_return = sum(average_investment_returns);

% 计算各行业投资回报率占所有投资回报率的比例
investment_return_proportion = average_investment_returns * 100  ./ total_investment_return;

% 将比例转换为表，并设置变量名称
investment_return_proportion_table = array2table(investment_return_proportion, 'VariableNames', data_investment.Properties.VariableNames);

% 输出各行业投资回报率占所有投资回报率的比例
disp('各行业投资回报率占所有投资回报率的比例：');
disp(investment_return_proportion_table);


%% 分配资金
% 总资金金额
total_funds = 10000; % 1万亿资金

% 计算各行业分配的资金（单位：亿元）
allocated_funds = investment_return_proportion * total_funds / 100;

% 转换为亿元
allocated_funds_in_billion = allocated_funds;

% 将结果转换为表格并设置变量名称
allocated_funds_table = array2table(allocated_funds_in_billion, 'VariableNames', data_investment.Properties.VariableNames);

% 输出各行业分配的资金（单位：亿元）
disp('各行业分配的资金（单位：亿元）：');
disp(allocated_funds_table);


%% 绘制柱状图

% 绘制各行业投资回报率占所有投资回报率的比例的柱状图
figure;
bar(investment_return_proportion_table{1,:});
title('各行业投资回报率占所有投资回报率的比例');
xlabel('行业');
ylabel('比例（%）');
xtickangle(45); % 旋转x轴刻度标签，使其更易读
xticklabels(data_investment.Properties.VariableNames); % 设置x轴刻度标签为行业名称

% 绘制各行业分配的资金（单位：亿元）的柱状图
figure;
bar(allocated_funds_table{1,:});
title('各行业分配的资金（单位：亿元）');
xlabel('行业');
ylabel('资金（亿元）');
xtickangle(45); % 旋转x轴刻度标签，使其更易读
xticklabels(data_investment.Properties.VariableNames); % 设置x轴刻度标签为行业名称