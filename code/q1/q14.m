clc; clear; close all;
%% 导入初始数据
df = readtable('../../data/近二十年各行业生产总值数据-en.xlsx', 'Sheet', 'Sheet1', 'VariableNamingRule', 'preserve');
format long
df(:, 1) = [];
head(df, 5);
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

%% 绘制每个产业的年增长率折线图
figure; % 创建一个新的图形窗口
hold on; % 保持图形，以便在同一图上绘制多条线

% 获取年份
years = (2004:2023)'; % 数据从2004年开始



colors = [
    0.0, 0.4470, 0.7410; % 蓝色
    0.8500, 0.3250, 0.0980; % 深橙色
    1.0000, 0.6000, 0.0; % 亮黄色
    0.9290, 0.6940, 0.1250; % 金色
    0.4660, 0.6740, 0.1880; % 鲜绿色
    0.3010, 0.7450, 0.9330; % 青色
    0.6350, 0.0780, 0.1840; % 深红色
    0.4510, 0.1240, 0.3930; % 深紫色
    0.6350, 0.6350, 0.6350; % 灰色
    0.8500, 0.3250, 0.0980; % 橙色
];

% 绘制每个变量的增长率
for idx = 1:length(varNames) % 跳过第一列，假设第一列是年份
    if isnumeric(growth_rate.(varNames(idx)))
        plot(years(1:end), growth_rate.(varNames(idx)), '-o', 'Color', colors(idx, :), 'LineWidth', 0.75,'DisplayName', varNames(idx)); % 绘制增长率折线图
    end
end

% 设置图例
legend('show');

% 设置标题和轴标签
% title('Annual Growth Rate of Each Industry');
xlabel('Year');
ylabel('Growth Rate');

% 设置网格
grid on;

% 解除保持状态
hold off;
