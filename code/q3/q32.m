clc; clear; close all;
% 拟合年份与利润（GDP与投资值的差值）的关系
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

% 初始化表格用于存储拟合结果
T = table('Size', [9 4], 'VariableTypes', {'string', 'double', 'double', 'double'}, 'VariableNames', {'Industry', 'Slope', 'Intercept', 'R_value'});

% 对S2-S10进行循环拟合
for i = 2:10
    Chanye = ['S', num2str(i)]; % S2-S10
    
    % 检查投资数据中的0值或NaN，并将其对应的GDP值设置为NaN，避免除以0
    invalid_indices = data_investment{:, Chanye} == 0 | isnan(data_investment{:, Chanye});
    data_GDPs{invalid_indices, Chanye} = NaN;

    % 现在进行安全的除法运算
    y_data = data_GDPs{:, Chanye} ./ data_investment{:, Chanye};

    % 拟合函数
    [fitresult, gof] = investment_fun1(Chanye, X_data_time, y_data);

    % 提取拟合参数
    coeffs = coeffvalues(fitresult); % 拟合参数
    
    % 将拟合结果添加到表格中
    T(i-1, :) = {Chanye, coeffs(1), coeffs(2), gof.rsquare};
end

% 显示拟合结果表格
disp('拟合结果表格：');
disp(T);

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
    opts.Robust = 'Bisquare';
    
    % 对数据进行模型拟合
    [fitresult, gof] = fit(xData, yData, ft, opts);
end