clc
clear
close all
%AIRBUS A300-600R

%% Initialization
fprintf('\t ---- Initialising ---- \n')
tic;
init;

%% Variables
global copy;
copy = inits;

x0 = [copy.b; 
    copy.c_r;
    copy.tr_k;
    copy.tr_t;
    copy.phi_k;
    copy.phi_t;
    copy.A;
    copy.A;
    copy.W_str;
    copy.W_fuel;
    copy.CLCD;
    copy.L_poly';
    copy.M_poly'];

x0 = ones(length(x0),1);

lb = ones(length(x0),1);
lb(1) = 0.8;    %span
lb(2) = 0.8;  %root
lb(3) = 0.5;    %kink taper ratio
lb(4) = 0.5;    %tip taper ratio
lb(5) = -1;  %twist kink
lb(6) = -1;  %twist tip
lb(7:30) = 0.8;  %cst coefficients
lb(31) = 0.1; %W_str
lb(32) = 0.1; %W_fuel
lb(33) = 0.1; % CLCD
lb(34:end) = -1.5; % L and M polynomials

ub = ones(length(x0),1);
ub(1) = 2;    %span
ub(2) = 1.2;  %root
ub(3) = 1.5;    % kink taper ratio
ub(4) = 1.5;    % tip taper ratio
ub(5) = 5;  %twist kink
ub(6) = 5;  %twist tip
ub(7:30) = 1.2;  %cst coefficients
ub(31) = 1.2; %W_str
ub(32) = 1.2; %W_fuel
ub(33) = 1.2; % CLCD
ub(34:end) = 1.5; % L and M polynomials

toc;

%% FMINCON
options.Display = 'iter-detailed';
options.Algorithm = 'sqp';
% options.OutputFcn = 'funccount';  that doesnt work
options.PlotFcns = {'optimplotfval',@optimplotfval, @optimplotx, @optimplotfunccount};
options.FunValCheck = 'off'; 
options.DiffMaxChange = 0.5;           %max 50 percent change in design variable
options.DiffMinChange = 0.05;           %min 1% change in function while gradient searching
options.TolFun = 0.001;       % convergence criteria is when the minimized weight is withing 1 percent of original
options.TolX = 0.0005;         % end optimization if design variable only changes by 0.05 percent
options.TolCon = 0.0001;       % constraint convergence criteria
% options = optimoptions(@fmincon,'Display','iter-detailed','Algorithm','sqp', 'FunValCheck', 'off');
copy.iter = 1;

[x,FVAL,EXITFLAG,OUTPUT] = fmincon(@(x)opt_IDF(x),x0,[],[],[],[],lb,ub,@(x)constraints_IDF(x),options);