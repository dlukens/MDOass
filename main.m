clc
clear
close all

%AIRBUS A300-600R

%% Initialization

init;

return;
%% Variables

b       = 6; %[m]
sweep   = 1; %[deg]
c_r     = 1; %[m]
c_t     = 1; %[m]
phi_r   = 1; %[deg]
phi_t   = 1; %[deg]
A_r     = A; %[-]
A_t     = A; %[-]

x0 = [b;    ...
    sweep;  ...
    c_r;    ...
    c_t;    ...
    phi_r;  ...
    phi_t;  ...
    A_r;    ...
    A_t];   %Design Vector

lb =[-10, ... b,      
     -10, ... sweep,  
     -10, ... c_r,    
     -10, ... c_t,    
     -10, ... phi_r,  
     -10, ... phi_t,  
     -10, ... A_r,    
     -10];%   A_t Lower bounds
 
ub =[10, ... b,     
     10, ... sweep,  
     10, ... c_r,    
     10, ... c_t,    
     10, ... phi_r,  
     10, ... phi_t,  
     10, ... A_r,    
     10];%   A_t Upper bounds
 

% Y_0 - Initial values
global copy;
copy.W_str  = 1;
copy.W_fuel = 1;
copy.CLCD   = 1;
copy.cl     = 1;
copy.cd     = 1;

%% FMINCON
options.Display = 'iter-detailed';
options.Algorithm = 'sqp';

[x,FVAL,EXITFLAG,OUTPUT] = fmincon(@(x)opt_IDF(x),x0,[],[],[],[],lb,ub,@(x)constraints_IDF(x),options);