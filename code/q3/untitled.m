clc; clear; close all;
% 拟合年份与利润（GDP与投资值的差值）的关系
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

% data_investment{[1, 6, 20], "S5"} = NaN;
% data_GDPs{[1, 6, 20], "S5"} = NaN;

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

% 计算每个行业的投资回报率的平均值
average_investment_returns = mean(investment_returns, 1, 'omitnan');

% 输出每个行业的投资回报率的平均值
disp('每个行业的投资回报率的平均值：');
disp(average_investment_returns);

average_investment_returns = table2array(average_investment_returns);

% 绘制每个行业的投资回报率的平均值的柱状图
figure;
bar(average_investment_returns);
title('各行业投资回报率的平均值');
xlabel('行业');
ylabel('投资回报率的平均值');
xticklabels(data_investment.Properties.VariableNames);
% xtickangle(45); % 旋转x轴标签，使其更易读
grid on;