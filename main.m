clc
clear
close all

%AIRBUS A300-600R

%% Initialization

init;

return;
%% Variables
global inits;
A=inits.A;
b       = 44.84; %[m]
sweep   = 28; %[deg]
c_r     = 9.2; %[m]
c_t     = 2.76; %[m]
phi_k   = 1; %[deg]
phi_t   = 2; %[deg]

A_ru1   = A(1);
A_ru2   = A(2);
A_ru3   = A(3);
A_ru4   = A(4);
A_ru5   = A(5);
A_ru6   = A(6);


A_rl1   = A(7);
A_rl2   = A(8);
A_rl3   = A(9);
A_rl4   = A(10);
A_rl5   = A(11);
A_rl6   = A(12);

A_tu1=A_ru1;
A_tu2=A_ru2;
A_tu3= A_ru3;
A_tu4=A_ru4;
A_tu5=A_ru5;
A_tu6=A_ru6;

A_tl1=A_rl1;
A_tl2=A_rl2;
A_tl3=A_rl3;
A_tl4=A_rl4;
A_tl5=A_rl5;
A_tl6=A_rl6;

x0_ = [b;    ...
    sweep;  ...
    c_r;    ...
    c_t;    ...
    phi_k;  ...
    phi_t;  ...
    A_ru1;    ...
    A_ru2;
    A_ru3;
    A_ru4;
    A_ru5;
    A_ru6;
    A_rl1;
    A_rl2;
    A_rl3;
    A_rl4;
    A_rl5;
    A_rl6;
    A_tu1;
    A_tu2;
    A_tu3;
    A_tu4;
    A_tu5;
    A_tu6;
    A_tl1;
    A_tl2;
    A_tl3;
    A_tl4;
    A_tl5;
    A_tl6];   %beginning values dimensional


inits.x0_=x0_;

x0 = ones(length(x),1);   %beginning values non-dimensional

lb = ones(30,1);
lb(1) = 0.1;    %span
lb(2) = 0.001;  %sweep
lb(3) = 0.1;    %root
lb(4) = 0.1;    %tip
lb(5) = 0;  %twist kink
lb(6) = 0;  %twist tip
lb(7:30) = -1;  %cst coefficients

ub = ones(30,1);
ub(1) = 2;    %span
ub(2) = 2;  %sweep
ub(3) = 2;    %root
ub(4) = 4;    %tip
ub(5) = 10;  %twist kink
ub(6) = 10;  %twist tip
ub(7:30) = 1;  %cst coefficients

% Y_0 - Initial values
global copy;
copy.y=0

W_to=inits.W_TO;
W_str=inits.W_str;
W_fuel=inits.W_fuel;
CLCD=inits.CLCD;
cl=1;
cm=1;


y0 = [W_to;
    W_str;
    W_fuel;
    CLCD;
    cl;
    cm];

inits.y0=y0;


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


[x,FVAL,EXITFLAG,OUTPUT] = fmincon(@(x)opt_IDF(x,y0),x0,[],[],[],[],lb,ub,@(x)constraints_IDF(x,y),options);