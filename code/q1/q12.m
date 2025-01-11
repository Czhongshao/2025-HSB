clc; clear; close all;
% 三维柱状图
%% 导入数据
df = readtable('../../data/近十年各行业生产总值数据-en', 'Sheet', 'Sheet1');
format long
% 显示前5行数据
head(df, 5);

%% 数据预处理
years = df.Years; % 提取年份
industrys = df.Properties.VariableNames(3:end); % 行业名（剔除年份）
data = table2array(df(:, 3:end)); % 数值部分

%% 颜色定义
map = slanCM('viridis'); % 定义颜色映射

%% 图片尺寸设置
figureUnits = 'centimeters';
figureWidth = 15;
figureHeight = 15;

%% 绘制三维柱状图
figureHandle = figure;
b = bar3(data', 0.5); % 数据转置后，列表示行业，行为年份
for n = 1:numel(b)
    % 每组柱形的颜色
    cdata = get(b(n), 'zdata');
    cdata = repmat(max(cdata, [], 2), 1, 4); % 将颜色与柱形高度关联
    set(b(n), 'cdata', cdata, 'facecolor', 'flat');
end
%% 添加坐标轴和标签
hXLabel = xlabel('Years'); % X轴表示年份
hYLabel = ylabel('Each Industries'); % Y轴表示行业
hZLabel = zlabel('GDPs(\fontname{宋体}￥)'); % Z轴表示GDP数值

set(gca, 'XTickLabel', string(years), 'XTick', 1:numel(years)); % 设置年份标签
set(gca, 'YTickLabel', arrayfun(@(x) ['S', num2str(x+1)], 1:numel(industrys), 'UniformOutput', false), 'YTick', 1:numel(industrys)); % 设置行业标签为S2 - S10
%% 美化图表
% 赋色
colormap(map);

% 坐标轴美化
set(gca, 'Box', 'on', ...                                                   % 边框
         'XGrid', 'on', 'YGrid', 'on', 'ZGrid', 'on', ...                   % 网格
         'TickDir', 'out', 'TickLength', [.01 .01], ...                     % 刻度方向和长度
         'XMinorTick', 'off', 'YMinorTick', 'off', 'ZMinorTick', 'off', ... % 关闭小刻度
         'XColor', [.1 .1 .1], 'YColor', [.1 .1 .1], 'ZColor', [.1 .1 .1]); % 坐标轴颜色

% 字体和字号
set(gca, 'FontName', 'Arial', 'FontSize', 10);
set([hXLabel, hYLabel, hZLabel], 'FontName', 'Arial', 'FontSize', 10);

% 设置背景颜色
set(gcf, 'Color', [1 1 1]);

%% 输出图片
figW = figureWidth;
figH = figureHeight;
set(figureHandle, 'PaperUnits', figureUnits);
set(figureHandle, 'PaperPosition', [0 0 figW figH]);
fileout = 'q1_EveryData_Bar';
print(figureHandle, ['../../img/', fileout, '.png'], '-r500', '-dpng');
