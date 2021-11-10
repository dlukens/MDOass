function [c, ceq] = constraints_IDF(x, y)

rho_fuel = 0.81715e3; %[kg/m3]
f_tank = 0.93;

global copy;
global inits;
W_fuel = copy.W_fuel;
W_str = copy.W_str;
W_TO = copy.W_TO;

b = x(1);
sweep = x(2);
c_r = x(3);
c_t = x(4);
phi_k = x(5);
phi_t = x(6);
A_r = x(7:18);
A_t = x(19:30);

W_TO = y(1);
W_str = y(2);
W_fuel = y(3);
CLCD = y(4);
ccldist = y(5:18);
cmdist = y(19:32);
Yst = y(33:46);
chords = y(47:60);

%%
x_t = tand(sweep) * b/2;
x_k = tand(sweep) * b/2*0.4;
c_k = c_r - x_k;

A1 = ((c_r + c_k) * 0.4 * b / 2) / 2;
A2 = (c_k + c_t) * (x_t - x_k) / 2;
area = A1 + A2;

V_fuel = W_fuel/rho_fuel;
V_tank = area * 0.2;
c(1) = V_fuel/(V_tank * f_tank) - 1;
c(2) = (W_TO / area)/(inits.W_TO/inits.area) - 1;

ceq(1) = abs(copy.W_TO - W_TO);
ceq(2) = abs(copy.W_str - W_str);
ceq(3) = abs(copy.W_fuel - W_fuel);
ceq(4) = abs(copy.CLCD - CLCD);
ceq(5:18) = abs(copy.ccldist - ccldist);
ceq(19:32) = abs(copy.cmdist - cmdist);
ceq(33:46) = abs(copy.Yst - Yst);
ceq(47:60) = abs(copy.chords - chords);


end