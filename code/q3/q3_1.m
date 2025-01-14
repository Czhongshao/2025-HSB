clc; clear; close all;
% 所有行业最优投资分配以及最高GDP
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

%% 绘图
x = data_year;
num_industries = size(investment_returns, 2); % 行业数量

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

% 设置画布大小
figureWidth = 20; % 画布宽度 (厘米)
figureHeight = 15; % 画布高度 (厘米)

for i = 1:num_industries
    y = investment_returns{:, i}; % 取每个行业的投资回报率
    p = polyfit(x, y, 1); % 线性拟合，p(1)是斜率，p(2)是截距
    y_fit = polyval(p, x); % 计算拟合值
    
    % 创建新的图形窗口，并设置名称和大小
    figure('Name', sprintf('S%d 投资回报率的线性拟合', i + 1), 'NumberTitle', 'off', ...
           'Units', 'centimeters', 'Position', [0 0 figureWidth figureHeight]);
    hold on;
    
    % 绘制数据点
    plot(x, y, 'o', 'Color', colors(i, :), 'MarkerFaceColor', colors(i, :), 'MarkerSize', 4); % 画出原始数据点
    
    % 绘制拟合曲线
    plot_handle = plot(x, y_fit, '-', 'Color', colors(i, :), 'LineWidth', 2); % 画出拟合直线
    
    % 设置图形标题和标签
    xlabel('Years');
    ylabel('ROI %');
    % title(sprintf('S%d 投资回报率的线性拟合', i + 1));
    
    % 调整 x 轴标签旋转角度以确保完全显示
    set(gca, 'XTick', x, 'XTickLabelRotation', 45);
    
    % 显示拟合方程
    formula = sprintf('y = %.4fx + %.4f', p(1), p(2));
    legend(plot_handle, formula, 'Location', 'best', 'FontSize', 12); % 仅显示拟合线的方程
    fprintf('S%d 的线性拟合方程: %s\n', i + 1, formula);
    legend('boxoff');


    % 保存图像到指定文件夹，设置DPI和命名格式
    % savePath = sprintf('../../img/q3_S%d_fitfun.png', i + 1);
    % print('-dpng', savePath, '-r600'); % 使用print函数保存图像，设置DPI为600
    
    hold off;
end
%% 预测下一年每个行业的投资回报率
next_year = max(x) + 1; % 下一年

% 创建一个数组来存储每个行业下一年的预测投资回报率
next_year_returns = zeros(1, num_industries);

for i = 1:num_industries
    y = investment_returns{:, i}; % 取每个行业的投资回报率
    p = polyfit(x, y, 1); % 线性拟合，p(1)是斜率，p(2)是截距
    
    % 预测下一年的投资回报率
    next_year_returns(i) = polyval(p, next_year);
end

% 输出下一年每个行业的投资回报率数值
fprintf('\n预测下一年每个行业的投资回报率:\n');
for i = 1:num_industries
    fprintf('S%d: %.4f\n', i + 1, next_year_returns(i));
end

%% 绘制折线图
figure('Name', '下一年各行业的投资回报率预测', 'NumberTitle', 'off', 'Units', 'centimeters', 'Position', [0 0 20 15]);

% 绘制折线图，使用实心点表示数据点
hold on; % 保持当前图形，以便在同一图上绘制多条线
for i = 1:num_industries
    plot(i, next_year_returns(i), 'o', 'MarkerFaceColor', colors(i,:), 'MarkerEdgeColor', colors(i,:), 'LineWidth', 2, 'MarkerSize', 6);
end

% 设置图形标题和标签
xlabel('Industry');
ylabel('Predicted ROI (%)');
% title('Predicted Investment Return Rate by Industry for Next Year');

% 设置 x 轴标签为行业名称
set(gca, 'XTick', 1:num_industries, 'XTickLabel', data_investment.Properties.VariableNames, 'XTickLabelRotation', 45, 'FontName', 'Arial', 'FontSize', 12);

% 添加网格线
grid on;

% 添加图例，使用预估数据作为标签
legendInfo = arrayfun(@(x) sprintf(': %.2f%%', next_year_returns(x)), 1:num_industries, 'UniformOutput', false);
legend(legendInfo, 'Location', 'bestoutside', 'Orientation', 'vertical', 'Box', 'off', 'FontName', 'Arial', 'FontSize', 14);