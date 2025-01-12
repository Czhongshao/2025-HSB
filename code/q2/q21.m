clc; clear; close all;
%% 导入初始数据
data_investment = readtable('../../data/20y-investment增长率.xlsx', 'Sheet', 'Sheet1', 'VariableNamingRule', 'preserve');
data_GDPs = readtable('../../data/20y-GDPs增长率.xlsx', 'Sheet', 'Sheet1', 'VariableNamingRule', 'preserve');
format long

% 删除GDPs当中的总GDP列
data_GDPs(:, 3) = [];

disp('行业投资增长率%');
head(data_investment, 5);
disp('行业GDP增长率%');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
head(data_GDPs, 5);

% 导入时间数据 2004-2023年
% X_data_time = data_investment.Var1; 

% Y_data_investment1 = data_investment.S2;
Y_data_investment = data_investment{:, 3:end};
Y_data_GDPs = data_GDPs{:, 3:end};







%% 投资模型1


