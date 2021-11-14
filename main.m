clc
clear
close all
%AIRBUS A300-600R

%% Initialization
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

copy.iter = 1;

[x,FVAL,EXITFLAG,OUTPUT] = fmincon(@(x)opt_IDF(x),x0,[],[],[],[],lb,ub,@(x)constraints_IDF(x),options);

%% Plotting

global inits;

b = x(1)*inits.b;
c_r = x(2)*inits.c_r;
tr_k = x(3)*inits.tr_k;
tr_t = x(4)*inits.tr_t;
phi_k = x(5)*inits.phi_k;
phi_t = x(6)*inits.phi_t;
A_r = x(7:18).*inits.A;
A_t = x(19:30).*inits.A;
W_str = x(31)*inits.W_str;
W_fuel = x(32)*inits.W_fuel;
CLCD = x(33)*inits.CLCD;
L_poly = x(34:37).*inits.L_poly';
M_poly = x(38:end).*inits.M_poly';

sweep = atand((c_r - c_r*tr_k)/(b * 0.4 * 0.5));
x_t = tand(sweep) * b/2;
x_k = tand(sweep) * b/2*0.4;
y_k = b/2*0.4;
y_t = b/2;
c_k = c_r * tr_k;
c_t = c_r * tr_t;
tr_kt = tr_t / tr_k;

figure
    subplot(2,2,[1 3])
        title('Planform')
        hold on
        axis ij
        axis equal
        %    [y1, y2],    [x1,x2]
        plot([0,    y_k], [0,          x_k]);
        plot([y_k,  y_t], [x_k,        x_t]);
        plot([y_t,  y_t], [x_t,  x_t + c_t]);
        plot([y_t,  y_k], [x_t + c_t,  c_r]);
        plot([y_k,  0],   [c_r,        c_r]);
        axis([0,26,0,20])
    subplot(2,2,2)
        title('Root airfoil')
        hold on
        plot(copy.Yu_r(:,1),copy.Yu_r(:,2),'b');
        plot(copy.Yl_r(:,1),copy.Yl_r(:,2),'r');
        axis([0,1,-0.25,0.25])
    subplot(2,2,4)
        title('Tip Airfoil')
        hold on
        plot(copy.Yu_t(:,1),copy.Yu_t(:,2),'b');
        plot(copy.Yl_t(:,1),copy.Yl_t(:,2),'r');
        axis([0,1,-0.25,0.25])