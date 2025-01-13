clc;
clear;
close all;

% 各行业的投资回报率
S = [12.9983654483323, 0.636020380770955, 5.88642340151705, 6.00970398680209, ...
     0.510267404135663, 2.22567840375023, 67.4657142638317, 0.288901095708213, 0.569974325583096];

% 初始投资金额
I0 = repmat(10, 1, 9);  % 初始投资金额设置为 10

% 目标函数：总GDP（需要传入投资金额），并乘上对应的投资回报率
objective = @(I) -gdp_function(I, S);

% 计算目标函数在初始点的值，确保目标函数可计算
disp('目标函数在初始点的值：');
disp(objective(I0));

% 约束条件
% 1. 所有投资金额不得小于 10
lb = repmat(10, 1, 9);  % 每个变量的下界是 10

% 2. 投资金额的总和不超过 10000
A = ones(1, 9);   % 系数矩阵，要求所有投资金额之和小于等于 10000
b = 10000;        % 约束条件右侧值是 10000

% 选择非线性规划求解方法
options = optimoptions('fmincon', 'Display', 'off');  % 不显示优化过程

% 调用 fmincon 进行求解
[opt_investment, max_GDP] = fmincon(objective, I0, A, b, [], [], lb, [], [], options);

% 计算最优的总GDP值
fprintf('最优投资金额：\n');
disp(opt_investment);

fprintf('最大GDP值：\n');
disp(-max_GDP);

% 目标函数实现
function total_GDP = gdp_function(I, S)
    % 限制指数项的输入，避免数值溢出
    max_exp = 700;  % 设置指数项的最大允许输入值（避免exp溢出）
    
    % 各项GDP函数（使用投资回报率 S 进行加权）
    GDP2 = S(1) * (1.66 * I(1) + 23419.39);
    GDP3 = S(2) * (40290.48 * I(2)^2 + 1.17 * I(2) - 9.35e-7);
    GDP4 = S(3) * (46808.84 * exp(1.54e6 * min(I(3), max_exp)) - 66777.28 * exp(5.57e-4 * min(I(3), max_exp)));
    GDP5 = S(4) * (-160800.24 * exp(1.83e-4 * min(I(4), max_exp)) + 133611.89 * exp(2.44e-5 * min(I(4), max_exp)));
    GDP6 = S(5) * (8147.80 * I(5)^2 + 0.28 * I(5) + 3.86e-6);
    GDP7 = S(6) * (3711.69 * I(6)^2 + 0.35 * I(6) + 2.88e-4);
    GDP8 = S(7) * (5.54e8 * exp(-6.69e-4 * min(I(7), max_exp)) - 5.54e8 * exp(-6.70e-4 * min(I(7), max_exp)));
    GDP9 = S(8) * (-518.15 * I(8)^2 + 0.45 * I(8) - 6.46e-7);
    GDP10 = S(9) * (205295.60 * exp(2.83e-7 * min(I(9), max_exp)) - 190772.57 * exp(-9.04e-6 * min(I(9), max_exp)));
    
    % 计算加权后的总GDP
    total_GDP = -(GDP2 + GDP3 + GDP4 + GDP5 + GDP6 + GDP7 + GDP8 + GDP9 + GDP10);
end
