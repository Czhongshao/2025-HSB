clc; clear; close all;
% 拟合年份与投资增长率之间的关系
%% 导入初始数据
data_investment = readtable('../../data/近二十年各产业投资情况数据表.xlsx', 'Sheet', 'Sheet2', 'VariableNamingRule', 'preserve');
data_GDPs = readtable('../../data/近二十年各行业生产总值数据-en.xlsx', 'Sheet', 'Sheet1', 'VariableNamingRule', 'preserve');
format long

% 删除GDPs当中的总GDP列
data_GDPs(:, 2) = [];

disp('行业投资总值');
head(data_investment, 5);
disp('行业GDP总值');
head(data_GDPs, 5);

%% 数据导入
% 导入时间数据 2003-2023年
X_data_time = data_investment.Years - 2002; 
% 因变量
Chanye = 'S2'; % S2-S10
y_data = data_investment{:, Chanye};
y_data2 = data_GDPs{:, Chanye};

% 拟合函数
[fitresult, gof] = investment_fun1(Chanye, X_data_time, y_data);

% 显示拟合结果
disp('拟合结果：');
disp(fitresult);

% 显示拟合优度
disp('拟合优度 (R^2)：');
disp(gof.rsquare);

% 提取拟合参数
coeffs = coeffvalues(fitresult); % 拟合参数
disp('拟合参数值 ：');
disp(Chanye);
fprintf('斜率 (β): %.4f\n', coeffs(1));
fprintf('截距: %.4f\n', coeffs(2));
%% 拟合某行业的投资增长率随年份变化
function [fitresult, gof] = investment_fun1(name, X_data_time, Y_data_investment1)

    % 要进行拟合某行业的投资增长率随年份变化数据:
    % X 输入: X_data_time
    % Y 输出: Y_data_investment1
    % 输出:
    % fitresult: 表示拟合的拟合对象。
    % gof: 带有拟合优度信息的结构体。
    
    [xData, yData] = prepareCurveData(X_data_time, Y_data_investment1);
    
    % 设置 fittype 和选项
    ft = fittype('poly1');
    opts = fitoptions('Method', 'LinearLeastSquares');
    opts.Robust = 'LAR';
    
    % 对数据进行模型拟合
    [fitresult, gof] = fit(xData, yData, ft, opts);
    
    % 绘制数据拟合图
    figure('Name', [name ' Investment Growth Rate over Years']);
    h = plot(fitresult, xData, yData);
    legend(h, [name ' Actual Investment Growth Rate'], [name ' Fitted Curve'], 'Location', 'NorthEast', 'Interpreter', 'none');
    
    % 设置点和线的属性
    h(1).Marker = '.';       % 数据点的形状为点
    h(1).MarkerSize = 10;     % 数据点大小
    h(1).LineStyle = '-'; % 取消连接线（仅显示点）
    h(2).LineWidth = 2;      % 拟合曲线的线宽
    
    % 为坐标区加标签
    xlabel('Year', 'Interpreter', 'none', 'FontSize', 12);
    ylabel('Investment Growth Rate (%)', 'Interpreter', 'none', 'FontSize', 12);
    grid on;
    
    % 设置 x 轴的刻度均匀分布
    num_ticks = 10; % 设定希望的刻度数量
    x_min = min(X_data_time);
    x_max = max(X_data_time);
    xtick_positions = linspace(x_min, x_max, num_ticks); % 均匀分布的刻度位置
    xtick_labels = round(xtick_positions + 2002); % 转换为实际年份
    
    xticks(xtick_positions);
    xticklabels(xtick_labels);
    
    % 设置坐标轴样式
    set(gca, 'LineWidth', 1.5, 'FontSize', 12);

    % 调整 x 轴和 y 轴范围以确保显示更美观
    xlim([x_min - 0.5, x_max + 0.5]);
    ylim([min(yData) - 0.05 * range(yData), max(yData) + 0.05 * range(yData)]);
    
    % 显示拟合结果中的参数
    disp('Fitted parameters (slope and intercept):');
    disp(coeffvalues(fitresult));
end