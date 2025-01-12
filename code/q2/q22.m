clc; clear; close all;
%% 导入初始数据
data_investment = readtable('../../data/近二十年各产业投资情况数据表.xlsx', 'Sheet', 'Sheet2', 'VariableNamingRule', 'preserve');
data_GDPs = readtable('../../data/近二十年各行业生产总值数据-en.xlsx', 'Sheet', 'Sheet1', 'VariableNamingRule', 'preserve');
format long

% 删除GDPs当中的总GDP列
data_GDPs(:, 3) = [];

disp('行业投资总值');
head(data_investment, 5);
disp('行业GDP总值');
head(data_GDPs, 5);

%% 数据导入
% 导入时间数据 2004-2023年
X_data_time = data_investment.Years; 
% 因变量
Chanye = 'S3';
y_data = data_investment{:, Chanye};
y_data2 = data_GDPs{:, Chanye};

% 拟合函数
[fitresult, gof] = investment_fun1(Chanye, X_data_time, y_data);

% 显示拟合结果
disp('拟合结果:');
disp(fitresult);

% 显示拟合优度
disp('拟合优度:');
disp(gof);

%% 拟合某行业的投资增长率随年份变化
function [fitresult, gof] = investment_fun1(name, X_data_time, Y_data_investment1)

    %  要进行拟合某行业的投资增长率随年份变化数据:
    %      X 输入: X_data_time
    %      Y 输出: Y_data_investment1
    %  输出:
    %      fitresult: 表示拟合的拟合对象。
    %      gof: 带有拟合优度信息的结构体。
    
    [xData, yData] = prepareCurveData( X_data_time, Y_data_investment1 );
    
    % 设置 fittype 和选项。
    ft = fittype( 'poly1' );
    opts = fitoptions( 'Method', 'LinearLeastSquares' );
    opts.Robust = 'LAR';
    
    % 对数据进行模型拟合。
    [fitresult, gof] = fit( xData, yData, ft, opts );
    
    % 绘制数据拟合图。
    figure( 'Name', [name ' 行业投资增长率随年份变化'] );
    h = plot( fitresult, xData, yData );
    legend( h, [name '  实际投资数据'], [name '  拟合曲线'], 'Location', 'NorthEast', 'Interpreter', 'none' );
    % 为坐标区加标签
    xlabel( '年份', 'Interpreter', 'none' );
    ylabel( '投资增长率 (%)', 'Interpreter', 'none' );
    grid on

    % 显示拟合结果中的参数
    disp('拟合参数:');
    disp(coeffvalues(fitresult));

end