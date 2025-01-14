clc; clear; close all;

% 最佳三行业的投资分配以及最高GDP
%% 导入初始数据
data_investment = readtable('../../data/近二十年各产业投资情况数据表.xlsx', 'Sheet', 'Sheet2', 'VariableNamingRule', 'preserve');
data_GDPs = readtable('../../data/近二十年各行业生产总值数据-en.xlsx', 'Sheet', 'Sheet1', 'VariableNamingRule', 'preserve');
format long

Money_investment = 10000;

data_investment(1, :) = [];
data_year = data_investment.Year;
% 删除总GDP列与年份
data_GDPs(:, 1:2) = [];
data_investment(:, 1: 2) = [];
data_GDPs(1, :) = [];

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

%% 拟合投资回报率与投资额的关系
num_industries = size(investment_returns, 2); % 行业数量

% 创建一个数组来存储每个行业的拟合函数系数
fit_coefficients = zeros(num_industries, 2);

for i = 1:num_industries
    x = data_investment{:, i}; % 取每个行业的投资额
    y = investment_returns{:, i}; % 取每个行业的投资回报率
    
    % 线性拟合
    p = polyfit(x, y, 1); % p(1)是斜率，p(2)是截距
    fit_coefficients(i, :) = p;
    
    % 输出拟合函数
    fprintf('行业 S%d 的线性拟合函数: ROI = %.4f * Investment + %.4f\n', i + 1, p(1), p(2));
end

% 输出拟合函数系数
disp('拟合函数系数:');
disp(fit_coefficients);

clc; clear; close all;

% 最佳三行业的投资分配以及最高GDP
%% 导入初始数据
data_investment = readtable('../../data/近二十年各产业投资情况数据表.xlsx', 'Sheet', 'Sheet2', 'VariableNamingRule', 'preserve');
data_GDPs = readtable('../../data/近二十年各行业生产总值数据-en.xlsx', 'Sheet', 'Sheet1', 'VariableNamingRule', 'preserve');
format long

Money_investment = 10000;

data_investment(1, :) = [];
data_year = data_investment.Year;
% 删除总GDP列与年份
data_GDPs(:, 1:2) = [];
data_investment(:, 1: 2) = [];
data_GDPs(1, :) = [];

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

%% 拟合投资回报率与投资额的关系
num_industries = size(investment_returns, 2); % 行业数量

% 创建一个数组来存储每个行业的拟合函数系数
fit_coefficients = zeros(num_industries, 2);

for i = 1:num_industries
    x = data_investment{:, i}; % 取每个行业的投资额
    y = investment_returns{:, i}; % 取每个行业的投资回报率
    
    % 线性拟合
    p = polyfit(x, y, 1); % p(1)是斜率，p(2)是截距
    fit_coefficients(i, :) = p;
    
    % 输出拟合函数，使用科学计数法格式化
    if abs(p(1)) < 1e-2 || abs(p(2)) < 1e-2
        fprintf('行业 S%d 的线性拟合函数: ROI = %.4e * Investment + %.4e\n', i + 1, p(1), p(2));
    else
        fprintf('行业 S%d 的线性拟合函数: ROI = %.4f * Investment + %.4f\n', i + 1, p(1), p(2));
    end
end

% 输出拟合函数系数
disp('拟合函数系数:');
disp(fit_coefficients);

%% 绘制拟合函数图

colors = [
    63/255 178/255 238/255; % #63b2ee
    118/255 218/255 145/255; % #76da91
    248/255 203/255 127/255; % #f8cb7f
    249/255 149/255 136/255; % #f89588
    124/255 214/255 207/255; % #7cd6cf
    145/255 146/255 171/255; % #9192ab
    120/255 152/255 225/255; % #7898e1
    239/255 166/255 102/255; % #efa666
    237/255 221/255 134/255; % #eddd86
    153/255 135/255 206/255  % #9987ce
];

for i = 1:num_industries
    x = data_investment{:, i}; % 取每个行业的投资额
    y = investment_returns{:, i}; % 取每个行业的投资回报率
    
    % 线性拟合
    p = fit_coefficients(i, :);
    y_fit = polyval(p, x); % 计算拟合值
    
    % 创建新的图形窗口，并设置名称和大小
    figure('Name', sprintf('S%d 投资回报率与投资额的线性拟合', i + 1), 'NumberTitle', 'off', ...
           'Units', 'centimeters', 'Position', [0 0 20 15]);
    hold on;
    
    % 绘制数据点
    plot(x, y, 'o', 'Color', colors(i, :), 'MarkerFaceColor', colors(i, :), 'MarkerSize', 4); % 画出原始数据点
    
    % 绘制拟合曲线
    plot_handle = plot(x, y_fit, '-', 'Color', colors(i, :), 'LineWidth', 2); % 画出拟合直线
    
    % 设置图形标题和标签
    xlabel('Investment');
    ylabel('ROI %');
    title(sprintf('S%d 投资回报率与投资额的线性拟合', i + 1));
    
    % 显示拟合方程，使用科学计数法格式化
    if abs(p(1)) < 1e-2 || abs(p(2)) < 1e-2
        formula = sprintf('ROI = %.4e * Investment + %.4e', p(1), p(2));
    else
        formula = sprintf('ROI = %.4f * Investment + %.4f', p(1), p(2));
    end
    legend(plot_handle, formula, 'Location', 'best', 'FontSize', 12); % 仅显示拟合线的方程
    legend('boxoff');
    
    hold off;
end