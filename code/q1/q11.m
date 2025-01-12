clc; clear; close all;
%% 导入初始数据
df = readtable('../../data/近二十年各行业生产总值数据-en', 'Sheet', 'Sheet1');
format long
% 删除年份列
df(:, {'Years'}) = [];
% 显示更新后的前五行数据
head(df, 5)

%% 数据处理
% 初始化增长率表格
growth_rate = table;

% 获取列名并转换为字符串数组
varNames = string(df.Properties.VariableNames);

% 计算每个变量的逐年增长率
for var = varNames
    if isnumeric(df.(var))
        growth_rate.(var) = diff(df.(var)) ./ df.(var)(1:end-1);
    end
end

% 计算相关矩阵
correlation_matrix = corr(table2array(growth_rate));
%% 颜色定义
map = slanCM('Reds'); % 使用'slanCM'函数定义颜色映射
% map = flipud(map); % 反转颜色

%% 图片尺寸设置（单位：厘米）
figureUnits = 'centimeters';
figureWidth = 16;
figureHeight = 12;

%% 窗口设置
figureHandle = figure;
set(gcf, 'Units', figureUnits, 'Position', [0 0 figureWidth figureHeight]);

%% 绘制热图
string_name = {'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8', 'S9', 'S10'};
xvalues = string_name;
yvalues = string_name;


% 绘制热图
h = heatmap(xvalues, yvalues, correlation_matrix, ...
    'FontSize', 10, 'FontName', 'Arial', ...
    'CellLabelFormat', '%.2f', ... % 显示小数点后两位
    'Colormap', map, ...
    'CellLabelColor', 'k', ... % 单元格数字颜色为黑色
    'ColorLimits', [-1 1]); % 设置颜色范围

% h.Title = 'Growth Rate Correlation Matrix'; % 可选添加标题
h.GridVisible = 'on'; % 显示网格线

%% 细节优化
% 设置背景颜色为白色
set(gcf, 'Color', [1 1 1]);

%% 图片输出
figW = figureWidth;
figH = figureHeight;
set(figureHandle, 'PaperUnits', figureUnits);
set(figureHandle, 'PaperPosition', [0 0 figW figH]);
fileout = 'q1_Growth_Rate_Correlation_Matrix20';
print(figureHandle, ['../../img/', fileout, '.png'], '-r500', '-dpng');