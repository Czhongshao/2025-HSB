clc; clear; close all;

%% 导入数据
df = readtable('../../data/近十年各行业生产总值数据-en', 'Sheet', 'Sheet1');
format long;

% 删除不需要的列（如年份列）
if ismember('Years', df.Properties.VariableNames)
    df.Years = [];
end

% 显示前五行数据
disp("数据前五行：");
disp(head(df, 5));

%% 数据处理
% 初始化增长率表格
growth_rate = table();

% 获取列名并确保列为数值类型
varNames = string(df.Properties.VariableNames);

% 计算每列逐年增长率
for var = varNames
    growth_rate.(var) = diff(df.(var)) ./ df.(var)(1:end-1);
end

% 计算相关矩阵
correlation_matrix = corr(table2array(growth_rate), 'Rows', 'complete');

%% 气泡图绘制
% 散点数据
[xx, yy] = meshgrid(1:length(varNames), 1:length(varNames));
bubble_size = abs(correlation_matrix(:)) * 200; % 气泡大小由绝对值决定
bubble_color = correlation_matrix(:);          % 气泡颜色由原始值决定

% 设置列标签
numVars = length(varNames);
labels = "S" + (1:numVars); % 生成 S1, S2, ..., S10 的标签

% 设置图片尺寸（单位：厘米）
figureUnits = 'centimeters';
figureWidth = 16;
figureHeight = 12;

figureHandle = figure;
set(gcf, 'Units', figureUnits, 'Position', [0 0 figureWidth figureHeight]);

scatter(xx(:), yy(:), bubble_size, bubble_color, 'filled');
colormap(slanCM('Reds')); % 或其他适用的色图，例如 parula, jet 等
colorbar;

% 设置坐标轴标签
xticks(1:numVars);
xticklabels(labels);
yticks(1:numVars);
yticklabels(labels);

% 坐标轴美化
ax = gca;
set(gca, 'Box', 'on', 'XGrid', 'on', 'YGrid', 'on', ...
         'TickDir', 'in', 'TickLength', [0 0], ...
         'FontName', 'Helvetica', 'FontSize', 10);
ax.YDir = 'reverse'; % 设置Y轴反转

%% 图片保存
figW = figureWidth;
figH = figureHeight;
set(figureHandle, 'PaperUnits', figureUnits);
set(figureHandle, 'PaperPosition', [0 0 figW figH]);
fileout = 'q1_Scatter_Heatmap';
print(figureHandle, ['../../img/', fileout, '.png'], '-r500', '-dpng');
