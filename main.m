clc
clear all
close all

%AIRBUS A300-600R

%% Initialization

init;

%% Variables
global copy;
copy = inits;
A       = copy.A;
b       = copy.b; %[m]
sweep   = copy.sweep; %[deg]
c_r     = copy.c_r; %[m]
c_t     = copy.c_t; %[m]
phi_k   = copy.phi_k; %[deg]
phi_t   = copy.phi_t; %[deg]

x0 = [b;    
    sweep;  
    c_r;    
    c_t;  
    phi_k;
    phi_t;
    A;
    A];

% x = ones(length(x0),1);   %beginning values non-dimensional

lb = ones(30,1);
lb(1) = 10;    %span
lb(2) = 1;  %sweep
lb(3) = 2;    %root
lb(4) = 1;    %tip
lb(5) = -5;  %twist kink
lb(6) = -5;  %twist tip
lb(7:30) = -1;  %cst coefficients

ub = ones(30,1);
ub(1) = 50;    %span
ub(2) = 40;  %sweep
ub(3) = 10;    %root
ub(4) = 5;    %tip
ub(5) = 25;  %twist kink
ub(6) = 40;  %twist tip
ub(7:30) = 1;  %cst coefficients

y = zeros(32, 1, 'double');
y(1) = copy.W_TO;
y(2) = copy.W_str;
y(3) = copy.W_fuel;
y(4) = copy.CLCD;
y(5:18) = copy.ccldist;
y(19:32) = copy.cmdist;
y(33:46) = copy.Yst;
y(47:60) = copy.chords;



%% FMINCON
options.Display = 'iter-detailed';
options.Algorithm = 'sqp';
options.PlotFcns = {@optimplotfval, @optimplotx, @optimplotfirstorderopt, @optimplotconstrviolation, @optimplotfunccount};
options.FunValCheck = 'off'; 
options.DiffMaxChange = 0.5;           %max 50 percent change in design variable
options.DiffMinChange = 0.05;           %min 5% change in function while gradient searching
options.TolFun = 0.01;       % convergence criteria is when the minimized weight is withing 1 percent of original
options.TolX = 0.0005;         % end optimization if design variable only changes by 0.05 percent
options.TolCon = 0.001;       % constraint convergence criteria

[x,FVAL,EXITFLAG,OUTPUT] = fmincon(@(x)opt_IDF(x,y),x0,[],[],[],[],lb,ub,@(x)constraints_IDF(x,y),options);