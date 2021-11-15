clc
clear
close all
%AIRBUS A300-600R

%% Initialization
tic;
init;

%% Variables
global inits;

delete *.xls;

inits.iter = 1;

x0 = [inits.b; 
    inits.c_r;
    inits.tr_k;
    inits.tr_t;
    inits.phi_k;
    inits.phi_t;
    inits.A;
    inits.A;
    inits.W_str;
    inits.W_fuel;
    inits.CLCD;
    inits.L_poly';
    inits.M_poly'];

x0 = ones(length(x0),1);

lb = ones(length(x0),1);
lb(1) = 0.8;    %span
lb(2) = 0.8;  %root
lb(3) = 0.8;    %kink taper ratio
lb(4) = 0.8;    %tip taper ratio
lb(5) = 0;  %twist kink
lb(6) = 0;  %twist tip
lb(7:30) = 0.8;  %cst coefficients
lb(31) = 0.5; %W_str
lb(32) = 0.5; %W_fuel
lb(33) = 0.5; % CLCD
lb(34:end) = -1; % L and M polynomials

ub = ones(length(x0),1);
ub(1) = 1.2;    %span
ub(2) = 1.2;  %root
ub(3) = 1.2;    % kink taper ratio
ub(4) = 1.2;    % tip taper ratio
ub(5) = 2;  %twist kink
ub(6) = 2;  %twist tip
ub(7:30) = 1.2;  %cst coefficients
ub(31) = 1.5; %W_str
ub(32) = 1.5; %W_fuel
ub(33) = 1.5; % CLCD
ub(34:end) = 2; % L and M polynomials

t = toc;
fprintf('Initialised in %gs \n\n', t);

%% FMINCON
% options.Display = 'iter-detailed';
% options.Algorithm = 'sqp';
% % options.OutputFcn = 'funccount';  that doesnt work
% options.PlotFcns = {'optimplotfval',@optimplotfval, @optimplotx, @optimplotfunccount};
% options.FunValCheck = 'off'; 
% options.DiffMaxChange = 0.5;           %max 50 percent change in design variable
% options.DiffMinChange = 0.05;           %min 1% change in function while gradient searching
% options.TolFun = 0.001;       % convergence criteria is when the minimized weight is withing 1 percent of original
% options.TolX = 0.0005;         % end optimization if design variable only changes by 0.05 percent
% options.TolCon = 0.0001;       % constraint convergence criteria

options.Display         = 'iter-detailed';
options.Algorithm       = 'sqp';
options.FunValCheck     = 'off';
options.DiffMinChange   = 0.05;
options.DiffMaxChange   = 1;
options.TolCon          = 1e-3;
options.TolFun          = 1e-3;
options.TolX            = 1e-5;
options.PlotFcns        = {@optimplotfval, @optimplotx, @optimplotfirstorderopt,@optimplotstepsize, @optimplotconstrviolation, @optimplotfunccount};
options.MaxIter         = 10;
options.ScaleProblem    = 'false';
options.FiniteDifferenceType = 'forward';

[x,FVAL,EXITFLAG,OUTPUT] = fmincon(@(x)opt_IDF(x),x0,[],[],[],[],lb,ub,@(x)constraints_IDF(x),options);