clc; clear; close all;
%% 导入初始数据
data_investment = readtable('../../data/近二十年各产业投资情况数据表', 'Sheet', 'Sheet2', 'VariableNamingRule', 'preserve');
data_GDPs = readtable('../../data/近二十年各行业生产总值数据-en', 'Sheet', 'Sheet1', 'VariableNamingRule', 'preserve');
format long






