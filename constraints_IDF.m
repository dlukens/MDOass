function [c, ceq] = constraints_IDF(x)

rho_fuel = 0.81715e3; %[kg/m3]
f_tank = 0.93;

global copy;
global inits;

b       = x(1)*inits.b;
sweep   = x(2)*inits.sweep;
c_r     = x(3)*inits.c_r;
c_t     = x(4)*inits.c_t;
phi_k   = x(5)*inits.phi_k;
phi_t   = x(6)*inits.phi_t;
A_r     = x(7:18).*inits.A;
A_t     = x(19:30).*inits.A;
W_TO    = x(31)*inits.W_TO;
W_str   = x(32)*inits.W_str;
W_fuel  = x(33)*inits.W_fuel;
CLCD    = x(34)*inits.CLCD;
L_poly  = x(35:39).*inits.L_poly';
M_poly  = x(40:44).*inits.M_poly';

%%
x_t = tand(sweep) * b/2;
x_k = tand(sweep) * b/2*0.4;
c_k = c_r - x_k;

A1 = ((c_r + c_k) * 0.4 * b / 2) / 2;
A2 = (c_k + c_t) * (x_t - x_k) / 2;
area = A1 + A2;

V_fuel = W_fuel/rho_fuel;
V_tank = area * 0.2; %needs to be changed

%%
c(1) = V_fuel/(V_tank * f_tank) - 1;
c(2) = (W_TO / area)/(inits.W_TO/inits.area) - 1;

ceq(1) = W_TO/copy.W_TO - 1;
ceq(2) = W_str/copy.W_str - 1;
ceq(3) = W_fuel/copy.W_fuel - 1;
ceq(4) = CLCD/copy.CLCD - 1;
ceq(5:9) = L_poly./copy.L_poly' - 1;
ceq(10:14) = M_poly./copy.M_poly' - 1;

end