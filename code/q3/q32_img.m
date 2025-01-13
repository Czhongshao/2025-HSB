clc; clear; close all;
% 绘制投资回报率图像
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

%% 绘制柱状图
% 设置颜色映射
color_map = slanCM('jet');
idx = linspace(1, size(color_map, 1), length(average_investment_returns));
idx = round(idx);
color_map = color_map(idx, :); % 为每个行业定义颜色

% 窗口设置
figureUnits = 'centimeters';
figureWidth = 16;
figureHeight = 16;
figure('Units', figureUnits, 'Position', [0 0 figureWidth figureHeight]);

% 绘制竖向多色柱状图
bars = bar(average_investment_returns, 0.9, 'EdgeColor', 'k');
bars.FaceColor = 'flat';
for i = 1:length(average_investment_returns)
    bars.CData(i, :) = color_map(i, :); % 为每个柱子设置对应颜色
end

% 添加数据标签
for i = 1:length(average_investment_returns)
    text(i, average_investment_returns(i), sprintf('%.2f%%', average_investment_returns(i)), ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
        'FontSize', 12, 'FontName', 'Arial', 'Color', 'black');
end

% 设置图表标题和标签
xlabel('Industry');
ylabel('Average ROI (%)');
% title('Average Investment Return Rate by Industry', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'Box', 'off', ...
         'XTick', 1:length(average_investment_returns), ...
         'XTickLabel', data_investment.Properties.VariableNames, ...
         'XTickLabelRotation', 0, ...
         'FontName', 'Arial', 'FontSize', 12);

grid off;

%% 绘制饼图
figure('Units', figureUnits, 'Position', [0 0 figureWidth figureHeight]);

% 使用行业名称作为饼图的标签
labels = data_investment.Properties.VariableNames;

% 绘制饼图并设置比例标签，但不显示标签
pie_handle = pie(investment_return_proportion);

% 为饼图分区设置颜色并调整引线
for i = 1:2:length(pie_handle)
    pie_handle(i).FaceColor = color_map(ceil(i / 2), :); % 使用统一的颜色映射
end

% 删除饼图中的所有文本标签
th = findobj(gca, 'Type', 'text');
delete(th); % 删除标签文本

% 在饼图旁边绘制标签和比例数据
legend_labels = strcat(labels, ' (', arrayfun(@(x) sprintf('%.2f%%', x), investment_return_proportion, 'UniformOutput', false), ')');
hLegend = legend(pie_handle(1:2:end), legend_labels, 'Location', 'eastoutside'); % 标签位于图例外侧

% 细节优化：去除图例的边框
legend('boxoff');

% 设置图表标题
% hTitle = title('Proportion of Investment Return Rate by Industry', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'FontName', 'Arial', 'FontSize', 10);

% 设置图例字体和样式
hLegend.ItemTokenSize = [10, 10]; % 调整图例标记大小
set(hLegend, 'FontName', 'Arial', 'FontSize', 12); % 设置图例字体

% 背景颜色
set(gcf, 'Color', [1 1 1]);