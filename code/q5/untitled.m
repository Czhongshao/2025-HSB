clc; clear; close all;

data_1 = readtable('../../data/aa.xlsx', 'Sheet', 'Sheet2', 'VariableNamingRule', 'preserve');

x1 = data_1.("投资金额9");
y1 = data_1.("占比9");

[fitresult, gof] = createFit(x1, y1);

% 在命令窗口中显示拟合参数和拟合优度
disp('拟合参数：');
disp(fitresult);
disp('拟合优度：');
disp(gof);

function [fitresult, gof] = createFit(x, y)
    [xData, yData] = prepareCurveData( x, y );
    
    % 设置 fittype 和选项。
    ft = fittype( 'poly1' );
    
    % 对数据进行模型拟合。
    [fitresult, gof] = fit( xData, yData, ft );
    
    % 绘制数据拟合图。
    figure( 'Name', '无标题拟合 1' );
    h = plot( fitresult, xData, yData );
    legend( h, 'y vs. x', '无标题拟合 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
    % 为坐标区加标签
    xlabel( '投资金额', 'Interpreter', 'none' );
    ylabel( '占比', 'Interpreter', 'none' );
    grid on
end