clc
clear
close all
%AIRBUS A300-600R

%% Initialization
fprintf('\t ---- Initialising ----')
tic;
init;

%% Variables
global copy;
copy = inits;

copy.iter = 1;


x0 = [copy.b;    
    copy.sweep;  
    copy.c_r;    
    copy.c_t;  
    copy.phi_k;
    copy.phi_t;
    copy.A;
    copy.A;
    copy.W_TO;
    copy.W_str;
    copy.W_fuel;
    copy.CLCD;
    copy.L_poly';
    copy.M_poly'];

x0 = ones(length(x0),1);

lb = ones(length(x0),1);
lb(1) = 0.1;    %span
lb(2) = 0.001;  %sweep
lb(3) = 0.1;    %root
lb(4) = 0.1;    %tip
lb(5) = -2;  %twist kink
lb(6) = -2;  %twist tip
lb(7:30) = 0;  %cst coefficients
lb(31:end) = -1; % Y vector  %Probably wanna tighten this

ub = ones(length(x0),1);
ub(1) = 2;    %span
ub(2) = 2;  %sweep
ub(3) = 2;    %root
ub(4) = 2;    %tip
ub(5) = 10;  %twist kink
ub(6) = 10;  %twist tip
ub(7:30) = 2;  %cst coefficients
ub(31:end) = 2; % Y vector %Probably wanna tighten this

toc;
fprintf('\t ---- FMINCON Start ----')

%% FMINCON
options.Display = 'iter-detailed';
options.Algorithm = 'sqp';
options.OutputFcn = 'funccount'; 
options.PlotFcns = {'optimplotfval',@optimplotfval, @optimplotx, @optimplotfirstorderopt, @optimplotconstrviolation, @optimplotfunccount};
options.FunValCheck = 'off'; 
options.DiffMaxChange = 0.5;           %max 50 percent change in design variable
options.DiffMinChange = 0.05;           %min 5% change in function while gradient searching
options.TolFun = 0.01;       % convergence criteria is when the minimized weight is withing 1 percent of original
options.TolX = 0.0005;         % end optimization if design variable only changes by 0.05 percent
options.TolCon = 0.001;       % constraint convergence criteria
% options = optimoptions(@fmincon,'Display','iter-detailed','Algorithm','sqp', 'FunValCheck', 'off');

[x,FVAL,EXITFLAG,OUTPUT] = fmincon(@(x)opt_IDF(x),x0,[],[],[],[],lb,ub,@(x)constraints_IDF(x),options);