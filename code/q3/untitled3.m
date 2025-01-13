clc; clear; close all;
[optimal_investments, optimal_GDP] = optimize_GDP();
disp('Optimal Investments:');
disp(optimal_investments);
disp('Optimal GDP:');
disp(optimal_GDP);

%% SQP 序列二次规划算法
function [optimal_investments, optimal_GDP] = optimize_GDP()
    % 定义投资变量 I2, I3, ..., I10
    % 投资金额是未知的，需要优化
    syms I2 I3 I4 I5 I6 I7 I8 I9 I10;
    
    % GDP 函数的定义（根据你的代码）
    GDP2 = 1.66 * I2 + 23419.39;
    GDP3 = 40290.48 * I3^2 + 1.17 * I3 - 9.35e-7;
    GDP4 = 46808.84 * exp(1.54e6 * I4) - 66777.28 * exp(5.57e-4 * I4);
    GDP5 = -160800.24 * exp(1.83e-4 * I5) + 133611.89 * exp(2.44e-5 * I5);
    GDP6 = 8147.80 * I6^2 + 0.28 * I6 + 3.86e-6;
    GDP7 = 3711.69 * I7^2 + 0.35 * I7 + 2.88e-4;
    GDP8 = 5.54e8 * exp(-6.69e-4 * I8) - 5.54e8 * exp(-6.70e-4 * I8);
    GDP9 = -518.15 * I9^2 + 0.45 * I9 - 6.46e-7;
    GDP10 = 205295.60 * exp(2.83e-7 * I10) - 190772.57 * exp(-9.04e-6 * I10);
    
    % 总 GDP
    GDP_Total = GDP2 + GDP3 + GDP4 + GDP5 + GDP6 + GDP7 + GDP8 + GDP9 + GDP10;
    
    % 目标函数 (需要最大化)
    objective_func = @(x) -calculate_GDP(x);

    % 约束条件
    % I2, I3, ..., I10 >= 10
    lb = [10, 10, 10, 10, 10, 10, 10, 10, 10];
    % I2 + I3 + ... + I10 <= 10000
    A = ones(1, 9); % 单一的总和约束
    b = 10000;
    
    % 设置初始猜测值
    initial_guess = [10, 10, 10, 10, 10, 10, 10, 10, 10];
    
    % 使用 fmincon 来解决问题
    options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'off');
    [optimal_investments, optimal_GDP_value] = fmincon(objective_func, initial_guess, A, b, [], [], lb, [], [], options);
    
    % 计算优化后的GDP
    optimal_GDP = -optimal_GDP_value; % 目标函数是负值，最大化需要取负
end

%% 计算GDP的函数
function GDP_value = calculate_GDP(x)
    % 为了避免溢出，限制指数函数的输入值
    I4_limit = min(x(3), 10);  % 限制 I4 的范围
    I5_limit = min(x(4), 10);  % 限制 I5 的范围
    I8_limit = min(x(7), 10);  % 限制 I8 的范围
    I10_limit = min(x(9), 10); % 限制 I10 的范围
    
    % 计算 GDP
    GDP_value = 1.66 * x(1) + 23419.39 + ...
                40290.48 * x(2)^2 + 1.17 * x(2) - 9.35e-7 + ...
                46808.84 * exp(1.54e6 * I4_limit) - 66777.28 * exp(5.57e-4 * I4_limit) + ...
                -160800.24 * exp(1.83e-4 * I5_limit) + 133611.89 * exp(2.44e-5 * I5_limit) + ...
                8147.80 * x(5)^2 + 0.28 * x(5) + 3.86e-6 + ...
                3711.69 * x(6)^2 + 0.35 * x(6) + 2.88e-4 + ...
                5.54e8 * exp(-6.69e-4 * I8_limit) - 5.54e8 * exp(-6.70e-4 * I8_limit) + ...
                -518.15 * x(8)^2 + 0.45 * x(8) - 6.46e-7 + ...
                205295.60 * exp(2.83e-7 * I10_limit) - 190772.57 * exp(-9.04e-6 * I10_limit);
    
    % 如果结果超出有效范围，设置为一个非常大的惩罚值
    if isinf(GDP_value) || isnan(GDP_value)
        GDP_value = 1e10; % 大惩罚值
    end
end
