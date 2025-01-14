clc; clear; close all;
% 绘制投资回报率图像
%% 导入初始数据
data_investment = readtable('../../data/近二十年各产业投资情况数据表.xlsx', 'Sheet', 'Sheet2', 'VariableNamingRule', 'preserve');
data_GDPs = readtable('../../data/近二十年各行业生产总值数据-en.xlsx', 'Sheet', 'Sheet1', 'VariableNamingRule', 'preserve');
format long

data_year = data_investment.Year;
% 删除总GDP列与年份
data_GDPs(:, 1:2) = [];
data_investment(:, 1:2) = [];

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

%% 选取投资回报率最高的三个产业
[~, sorted_indices] = sort(investment_return_proportion, 'descend');
top_3_indices = sorted_indices(1:3);
top_3_proportions = investment_return_proportion(top_3_indices);
top_3_labels = data_investment.Properties.VariableNames(top_3_indices);

%% 绘制饼图
figure;
explode = [1 1 1]; % 突出显示所有部分
colors = lines(3); % 使用线条颜色方案

% 绘制饼图
pie_handle = pie(top_3_proportions, explode);

% 设置饼图颜色
for i = 1:2:length(pie_handle)
    pie_handle(i).FaceColor = colors(ceil(i/2), :);
end


th = findobj(gca, 'Type', 'text');
% delete(th); % 删除标签文本

% 在饼图旁边绘制标签和比例数据
legend_labels = strcat(top_3_labels);
hLegend = legend(pie_handle(1:2:end), legend_labels, 'Location', 'eastoutside'); % 标签位于图例外侧

% 细节优化：去除图例的边框
legend('boxoff');

% 设置图表标题
% title('Top 3 Industries by Investment Return Proportion', 'FontSize', 14, 'FontWeight', 'bold');

% 设置图例字体和样式
hLegend.ItemTokenSize = [10, 10]; % 调整图例标记大小
set(hLegend, 'FontName', 'Arial', 'FontSize', 12); % 设置图例字体

% 背景颜色
set(gcf, 'Color', [1 1 1]);

% 设置图表字体
set(gca, 'FontName', 'Arial', 'FontSize', 10);