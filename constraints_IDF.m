function [c, ceq] = constraints(x,y)

W_to=y(1);
W_str=y(2);
W_fuel=y(3);
CLCD=y(4);

y1_c = x(4);
y2_c = x(5);

rho_fuel = 0.81715e3; %[kg/m3]
f_tank = 0.93;

V_fuel = W_fuel/rho_fuel;

c(1) = V_fuel/(V_tank * f_tank) - 1;
c(2) = (W_TO / S)/(W_TO_0/S_0) - 1;

ceq(1) = abs(y1 - y1_c);
ceq(2) = abs(y2 - y2_c);
end