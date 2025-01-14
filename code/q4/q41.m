clc; clear; close all;
% 所有行业最优投资分配以及最高GDP
%% 导入初始数据
% 工资增长率
data_1 = readtable('../../data/行业年均工资及其增长率.xlsx', 'Sheet', 'Sheet3', 'VariableNamingRule', 'preserve');
% 行业工资平均值
data_2 = readtable('../../data/行业年均工资及其增长率.xlsx', 'Sheet', 'Sheet4', 'VariableNamingRule', 'preserve');
% 行业就业人口
data_3 = readtable('../../data/近十年就业人口数据.xlsx', 'Sheet', 'Sheet2', 'VariableNamingRule', 'preserve');
% 行业投资值
data_investment = readtable('../../data/近二十年各产业投资情况数据表.xlsx', 'Sheet', 'Sheet2', 'VariableNamingRule', 'preserve');
format long

%% 数据处理

% 删除部分投资年份
data_investment(1:10, :) = [];
% 删除年份
data_investment(1, :) = [];
data_3(1, :) = [];
data_2(1, :) = [];

% 删除投资总额
data_investment(:, "SUM") = [];

% 删除多余列
data_2(:, 'AVG') = [];
data_3(:, 'AVG-People') = [];

% 删除年份
data_3(:, 1) = [];
data_2(:, 1) = [];
data_1(:, 1) = [];
data_investment(:, 1) = [];

disp('工资增长率');
head(data_1, 10);
disp('行业工资平均值');
head(data_2, 10);
disp('行业就业人口');
head(data_3, 10);
disp('行业投资总值');
head(data_investment, 10);

%% 计算各行业的就业弹性和工资弹性
% 就业弹性 = (就业增长率) / (投资增长率)
% 工资弹性 = (工资增长率) / (投资增长率)

employment_growth_rate = diff(table2array(data_3)) ./ table2array(data_3(1:end-1, :));
wage_growth_rate = diff(table2array(data_2)) ./ table2array(data_2(1:end-1, :));
investment_growth_rate = diff(table2array(data_investment)) ./ table2array(data_investment(1:end-1, :));

employment_elasticity = employment_growth_rate ./ investment_growth_rate;
wage_elasticity = wage_growth_rate ./ investment_growth_rate;

% 计算平均就业弹性和工资弹性
mean_employment_elasticity = mean(employment_elasticity, 'omitnan');
mean_wage_elasticity = mean(wage_elasticity, 'omitnan');

% 标准化弹性值（归一化到0~1之间）
norm_employment_elasticity = (mean_employment_elasticity - min(mean_employment_elasticity)) / (max(mean_employment_elasticity) - min(mean_employment_elasticity));
norm_wage_elasticity = (mean_wage_elasticity - min(mean_wage_elasticity)) / (max(mean_wage_elasticity) - min(mean_wage_elasticity));

% 计算综合弹性值（就业弹性和工资弹性均衡权重）
combined_elasticity = (norm_employment_elasticity + norm_wage_elasticity) / 2;

% 分配1万亿投资资金到各行业
total_investment = 10000; % 1万亿
investment_allocation = combined_elasticity / sum(combined_elasticity) * total_investment;

% 如果限制投资到三个行业，选择综合弹性最高的三个行业
[sorted_elasticity, sorted_indices] = sort(combined_elasticity, 'descend');
selected_indices = sorted_indices(1:3);
selected_investment_proportion = combined_elasticity(selected_indices) / sum(combined_elasticity(selected_indices));

%% 输出结果
disp('各行业的投资分配（单位：亿元）：');
disp(array2table(investment_allocation, 'VariableNames', data_investment.Properties.VariableNames));

disp('限制投资到三个行业的投资分配比例：');
disp(array2table(selected_investment_proportion, 'VariableNames', data_investment.Properties.VariableNames(selected_indices)));


%% 可视化
% 设置颜色组
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

%% 绘制针状图1
X = 1:length(data_investment.Properties.VariableNames);

% 定义因变量
Y1 = mean_employment_elasticity;
Y2 = mean_wage_elasticity;

% 图片尺寸设置（单位：厘米）
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = 15;

% 窗口设置
% figureHandle = figure;
set(gcf, 'Units', figureUnits, 'Position', [0 0 figureWidth figureHeight]);
hold on

% 多组针状图绘制
% 定义绘图参数
MarkerSize = 8;
LineWidth = 1.5;

% 绘制就业弹性
st1 = stem(X, Y1, 'filled', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
set(st1, 'Color', colors(4,:), 'MarkerEdgeColor', colors(4,:), 'MarkerFaceColor', colors(4,:));

% 绘制工资弹性
st2 = stem(X + 0.2, Y2, 'filled', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
set(st2, 'Color', colors(7,:), 'MarkerEdgeColor', colors(7,:), 'MarkerFaceColor', colors(7,:));

% 设置标题和标签
% hTitle = title('Average Employment Elasticity and Wage Elasticity by Industry');
hXLabel = xlabel('Industry');
hYLabel = ylabel('Elasticity Value');

% 设置 x 轴标签
set(gca, 'XTick', X, 'XTickLabel', data_investment.Properties.VariableNames, 'XTickLabelRotation', 45);

% 细节优化
% 坐标轴美化
set(gca, 'Box', 'on', ...                                         % 边框
         'XGrid', 'on', 'YGrid', 'on', ...                        % 网格
         'TickDir', 'in', 'TickLength', [.015 .015], ...          % 刻度
         'XMinorTick', 'on', 'YMinorTick', 'on', ...              % 小刻度
         'XColor', [.1 .1 .1],  'YColor', [.1 .1 .1],...          % 坐标轴颜色
         'XLim', [0.5, length(X) + 0.5],...                       % 坐标区范围
         'YLim', [0, max([Y1, Y2]) + 0.1])                        % Y轴范围
     
legend([st1, st2], 'Average Employment Elasticity', 'Average Wage Elasticity', 'Location', 'NorthEast')

% 字体和字号
set(gca, 'FontName', 'Helvetica')
set([hXLabel, hYLabel], 'FontName', 'AvantGarde')
set(gca, 'FontSize', 10)
set([hXLabel, hYLabel], 'FontSize', 11)
% set(hTitle, 'FontSize', 12, 'FontWeight' , 'bold')

% 背景颜色
set(gcf,'Color',[1 1 1])

hold off
%% 绘制双Y轴柱状图（左边综合弹性，右边投资分配情况）
% 定义自变量
X = 1:length(data_investment.Properties.VariableNames);

% 定义因变量
Y1 = combined_elasticity;             % 综合弹性
Y2 = investment_allocation;           % 投资分配

% 设置颜色（可以手动调整）
leftColor = [63/255 178/255 238/255];  % 左侧颜色
rightColor = [249/255 149/255 136/255]; % 右侧颜色

% 图片尺寸设置（单位：厘米）
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = 15;

% 窗口设置
figureHandle = figure;
set(gcf, 'Units', figureUnits, 'Position', [0 0 figureWidth figureHeight]); % 设置图像尺寸
hold on

% 定义左轴
yyaxis left
bar1 = bar(X - 0.2, Y1, 0.4, 'FaceColor', leftColor, 'EdgeColor', 'none'); % 绘制综合弹性柱状图
hYLabel1 = ylabel('Combined Elasticity');
set(gca, 'YColor', 'k', ...                            % 坐标轴颜色
          'YLim', [0, max(Y1) + 0.1]);                        % 设置 Y 轴范围

% 定义右轴
yyaxis right
bar2 = bar(X + 0.2, Y2, 0.4, 'FaceColor', rightColor, 'EdgeColor', 'none'); % 绘制投资分配柱状图
hYLabel2 = ylabel('Investment Allocation');
set(gca, 'YColor', 'k', ...                            % 坐标轴颜色
         'YLim', [0, max(Y2) + 5]);                           % 设置 Y 轴范围

% 设置标题和 X 轴标签
% hTitle = title({'Combined Elasticity and Investment Allocation', 'by Industry'});
hXLabel = xlabel('Industry');
set(gca, 'XTick', X, 'XTickLabel', data_investment.Properties.VariableNames, 'XTickLabelRotation', 45); % 设置 X 轴标签

% 细节优化
% 坐标轴美化
set(gca, 'Box', 'on', ...                                      % 边框
         'XGrid', 'off', 'YGrid', 'on', ...                    % 网格
         'TickDir', 'in', 'TickLength', [.015 .015], ...       % 刻度
         'XMinorTick', 'on', 'YMinorTick', 'on', ...           % 小刻度
         'XColor', 'k',  'YColor', 'k',...                     % 坐标轴颜色
         'XLim', [0.5, length(X) + 0.5]);                      % 设置 X 轴范围

% 字体和字号
set(gca, 'FontName', 'Helvetica')
set([hXLabel, hYLabel1, hYLabel2], 'FontName', 'AvantGarde')
set(gca, 'FontSize', 12)
set([hXLabel, hYLabel1, hYLabel2], 'FontSize', 11)
% set(hTitle, 'FontSize', 12, 'FontWeight', 'bold')

% 背景颜色
set(gcf, 'Color', [1 1 1])

% 添加图例
hLegend = legend([bar1, bar2], 'Average Employment Elasticity', 'Average Wage Elasticity', 'Location', 'northeast', 'Orientation', 'vertical');

hold off

%% 可视化限制投资到三个行业的投资分配比例
figure;
% 选择前三个行业的颜色
selected_colors = colors(selected_indices, :);

% 生成标签，包含百分比
labels = arrayfun(@(x) sprintf('%s: %.2f%%', data_investment.Properties.VariableNames{selected_indices(x)}, selected_investment_proportion(x) * 100), 1:length(selected_investment_proportion), 'UniformOutput', false);

% 绘制饼图
pie(selected_investment_proportion, labels);

% 设置颜色
colormap(selected_colors);


% 添加图例
hLegend = legend(data_investment.Properties.VariableNames(selected_indices), ...
                 'Position', [0.85 0.15 0.1 0.3]);
hLegend.ItemTokenSize = [5 5];
legend('boxoff');

% 字体和字号
th = findobj(gca, 'Type', 'text');
set(th, 'FontName', 'Arial', 'FontSize', 11)
set(hLegend, 'FontName', 'Arial', 'FontSize', 9)
% set(hTitle, 'FontSize', 12, 'FontWeight', 'bold')

% 在饼图内显示投资金额
investment_labels = arrayfun(@(x) sprintf('%.2f Billion Yuan', selected_investment_proportion(x) * total_investment), 1:length(selected_investment_proportion), 'UniformOutput', false);
textHandles = findobj(gca, 'Type', 'text');
for i = 1:length(investment_labels)
    textHandles(i).String = investment_labels{i};
end

