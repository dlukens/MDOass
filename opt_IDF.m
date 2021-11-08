function [f] = opt_IDF(x,y0)

global copy;

if copy.y==0;
    y=y0
    
else
    y=copy.y
    
global inits;
inits.y=y;
x0_=inits.x0_;

%     1   2     3     4    5      6     7    8
%x = [b, sweep, c_r, c_t, phi_k, phi_t, A_r, A_t];
x

x'=x*x0_;

b = x'(1);
sweep = x'(2);
c_r = x'(3);
c_t = x'(4);
phi_k = x'(5);
phi_t = x'(6);
A_r = x'(7:18);         % I am unsure if it takes all those spaces or if you inputted it as a vector
A_t = x'(19:30);


W_to=y(1);
W_str=y(2);
W_fuel=y(3);
CLCD=y(4);


CL = 0.5;
[cl, cm] = Q3Dinv(CL, A_r, A_t, c_r, c_t, b, sweep);
W_str = EMWET(y1_c, z1, z2);
CLCD = Q3Dvis(CL, A_r, A_t, c_r, c_t, b, sweep);
W_fuel, V_fuel = Breguet(W_to,CLCD);

f = objective(W_TO_0, W_AW, W_fuel, W_str);

yc= [W_TO;
    W_str;
    W_fuel;
    CLCD;
    cl;
    cd];

copy.y=yc;

end