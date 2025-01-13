clc; clear; close all;
% 拟合行业GDP增长率和行业投资增长率的关系
%% 导入初始数据
data_investment = readtable('../../data/20y-investment增长率.xlsx', 'Sheet', 'Sheet1', 'VariableNamingRule', 'preserve');
data_GDPs = readtable('../../data/20y-GDPs增长率.xlsx', 'Sheet', 'Sheet1', 'VariableNamingRule', 'preserve');
format long

% 删除无用列
data_GDPs(:, 1) = [];
data_GDPs(:, 2) = [];
data_investment(:, 1) = [];

disp('行业投资增长率');
head(data_investment, 5);
disp('行业GDP增长率');
head(data_GDPs, 5);

%% 数据导入
% 导入时间数据 2003-2007年
X_data_time = data_investment.Years; 
% 选择特定行业
Chanye = 'S2';
% 提取投资值和GDP值
X_data_investment = data_investment{:, Chanye};
Y_data_GDP = data_GDPs{:, Chanye};

%% 建立回归模型
% 调用自定义函数
[fitresult, gof] = investment_fun2(Chanye, X_data_investment, Y_data_GDP);

% 显示拟合结果
disp('拟合结果：');
disp(fitresult);

% 显示拟合优度
disp('拟合优度 (R^2)：');
disp(gof.rsquare);

% 提取拟合参数
coeffs = coeffvalues(fitresult); % 拟合参数
disp('拟合参数值 ：');
fprintf('斜率 (β): %.4f\n', coeffs(1));
fprintf('截距: %.4f\n', coeffs(2));

%% 拟合投资总值与各行业GDP值
function [fitresult, gof] = investment_fun2(name, X_data_investment, Y_data_GDP)

    % 数据准备
    [xData, yData] = prepareCurveData(X_data_investment, Y_data_GDP);
    
    % 设置拟合类型和选项
    ft = fittype('poly2'); % 二次多项式
    opts = fitoptions('Method', 'LinearLeastSquares');
    opts.Robust = 'LAR'; % 对异常值的鲁棒回归
    
    % 执行拟合
    [fitresult, gof] = fit(xData, yData, ft, opts);
    
    % 绘制拟合结果
    figure('Name', [name ' GDP vs. Investment']);
    h = plot(fitresult, xData, yData);
    legend(h, [name ' Actual Values'], [name ' Fitted Curve'], ...
           'Location', 'NorthEast', 'Interpreter', 'none');
    
    % 增加图像美化
    xlabel('Investment Amount', 'Interpreter', 'none', 'FontSize', 12);
    ylabel('GDP Value', 'Interpreter', 'none', 'FontSize', 12);
    grid on;
    
    % 调整线条和点样式
    h(1).Marker = '.';       % 数据点的形状
    h(1).MarkerSize = 10;     % 数据点大小
    h(1).LineStyle = '-'; % 数据点无连接线
    h(2).LineWidth = 2;      % 拟合曲线的线宽
    
    % 设置坐标轴样式
    set(gca, 'LineWidth', 1.5, 'FontSize', 12);
    
    % 调整 x 和 y 轴范围以确保图形美观
    xlim([min(xData) - 0.05 * range(xData), max(xData) + 0.05 * range(xData)]);
    ylim([min(yData) - 0.05 * range(yData), max(yData) + 0.05 * range(yData)]);
    
    % 显示拟合结果的参数
    disp('Fitted parameters (a, b, c):');
    disp(coeffvalues(fitresult));
end