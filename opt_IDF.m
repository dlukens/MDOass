function [f] = opt_IDF(x)

%     1   2     3     4    5      6     7    8
%x = [b, sweep, c_r, c_t, phi_r, phi_t, A_r, A_t];
x

b = x(1);
sweep = x(2);
c_r = x(3);
c_t = x(4);
phi_r = x(5);
phi_t = x(6);
A_r = x(7:16);
A_t = x(17:26);


CL = 0.5;
[cl, cm] = Q3Dinv(CL, A_r, A_t, inits.c_r, inits.c_t, inits.b, inits.sweep);
W_str = EMWET(y1_c, z1, z2);
CLCD = Q3Dvis(CL, A_r, A_t, inits.c_r, inits.c_t, inits.b, inits.sweep);
W_fuel = Breguet(y1_c, z1, z2);

f = objective(W_TO_0, W_AW, W_fuel, W_str);

global copy;
copy.W_fuel = W_fuel;
copy.W_str = W_str;
copy.W_TO = W_TO;
copy.cl = cl;
copy.cd = cd;
copy.CLCD = CLCD;

end