clc; clear; close all;
% 拟合行业GDP总值和行业投资总值的关系（指数拟合）
%% 导入初始数据
data_investment = readtable('../../data/近二十年各产业投资情况数据表.xlsx', 'Sheet', 'Sheet2', 'VariableNamingRule', 'preserve');
data_GDPs = readtable('../../data/近二十年各行业生产总值数据-en.xlsx', 'Sheet', 'Sheet1', 'VariableNamingRule', 'preserve');
format long

% 导入时间数据 2003-2023年
X_data_time = data_investment.Year; 

% 删除总GDP列与年份
data_GDPs(:, 1:2) = [];
% % data_year = data_investment.Years;
data_investment(:, 1: 2) = [];


disp('行业投资总值');
head(data_investment, 20);
disp('行业GDP总值');
head(data_GDPs, 20);
%% 数据导入与预处理

% 初始化表格用于存储拟合结果
T = table('Size', [9 8], 'VariableTypes', {'string', 'double', 'double', 'double', 'double', 'double', 'double', 'double'}, 'VariableNames', {'产业', '系数1', '指数系数1', '系数2', '指数系数2', 'R方（拟合系数）', 'MAE（平均绝对误差）', 'RMSE（均方根误差）'});

% 对S2-S10进行循环拟合
for i = 2:10
    Chanye = ['S', num2str(i)]; % S2-S10
    
    % 提取投资值和GDP值
    X_data_investment = data_investment{:, Chanye};
    Y_data_GDP = data_GDPs{:, Chanye};

    % 拟合函数
    [fitresult, gof] = investment_fun2(Chanye, X_data_investment, Y_data_GDP);

    % 提取拟合参数
    coeffs = coeffvalues(fitresult); % 拟合参数
    
    % 计算MAE和RMSE，忽略NaN值
    y_fit = feval(fitresult, X_data_investment);
    residuals = Y_data_GDP - y_fit;
    MAE = nanmean(abs(residuals));
    RMSE = sqrt(nanmean(residuals.^2));
    
    % 将拟合结果添加到表格中
    T(i-1, :) = {Chanye, coeffs(1), coeffs(2), coeffs(3), coeffs(4), gof.rsquare, MAE, RMSE};
end

% 显示拟合结果表格
disp('指数拟合 行业GDP总值 和 行业投资总值 结果表格：');
disp(T);

%% 拟合投资总值与各行业GDP值
function [fitresult, gof] = investment_fun2(name, X_data_investment, Y_data_GDP)
    % 数据准备
    [xData, yData] = prepareCurveData(X_data_investment, Y_data_GDP);
    
    % 设置 fittype 和选项
    ft = fittype('exp2');
    opts = fitoptions('Method', 'NonlinearLeastSquares');
    opts.Display = 'Off';
    opts.StartPoint = [188694.008547169 3.80072414342679e-07 -108018.804215204 -4.08200053097371e-06];
    
    % 对数据进行模型拟合
    [fitresult, gof] = fit(xData, yData, ft, opts);
    
    % 绘制拟合结果
    figure('Name', [name ' GDP vs. Investment']);
    h = plot(fitresult, xData, yData);
    legend(h, [name ' Actual Values'], [name ' Fitted Curve'], 'Location', 'NorthEast', 'Interpreter', 'none');
    
    % 增加图像美化
    xlabel('Investment Amount', 'Interpreter', 'none', 'FontSize', 12);
    ylabel('GDP Value', 'Interpreter', 'none', 'FontSize', 12);
    grid on;
    
    % 调整线条和点样式
    h(1).Marker = '.';       % 数据点的形状
    h(1).MarkerSize = 10;     % 数据点大小
    h(1).LineStyle = '-';    % 数据点连接线
    h(2).LineWidth = 2;      % 拟合曲线的线宽
    
    % 设置坐标轴样式
    set(gca, 'LineWidth', 1.5, 'FontSize', 12);
    
    % 调整 x 和 y 轴范围以确保图形美观
    xlim([min(xData) - 0.05 * range(xData), max(xData) + 0.05 * range(xData)]);
    ylim([min(yData) - 0.05 * range(yData), max(yData) + 0.05 * range(yData)]);
    
    % 显示拟合结果的参数
    disp('拟合参数（系数）：');
    coeffs = coeffvalues(fitresult);
    disp(['指数系数1：', num2str(coeffs(1))]);
    disp(['指数系数2：', num2str(coeffs(2))]);
    disp(['截距1：', num2str(coeffs(3))]);
    disp(['截距2：', num2str(coeffs(4))]);
end