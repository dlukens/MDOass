function [c, ceq] = constraints_IDF(x)

rho_fuel = 0.81715e3; %[kg/m3]
f_tank = 0.93;

global copy;
global inits;

b = x(1)*inits.b;
c_r = x(2)*inits.c_r;
tr_k = x(3)*inits.tr_k;
tr_t = x(4)*inits.tr_t;
% phi_k = x(5)*inits.phi_k;
% phi_t = x(6)*inits.phi_t;
A_r = x(7:18).*inits.A;
A_t = x(19:30).*inits.A;
W_str = x(31)*inits.W_str;
W_fuel = x(32)*inits.W_fuel;
CLCD = x(33)*inits.CLCD;
L_poly = x(34:37).*inits.L_poly';
M_poly = x(38:end).*inits.M_poly';

%%
sweep = atand((c_r - c_r*tr_k)/(b * 0.4 * 0.5));
x_t = tand(sweep) * b/2;
x_k = tand(sweep) * b/2*0.4;
c_k = c_r * tr_k;
c_t = c_r * tr_t;

area1 = ((c_r + c_k) * 0.4 * b / 2) / 2;
area2 = (c_k + c_t) * (x_t - x_k) / 2;
area = area1 + area2;

V_fuel = W_fuel/rho_fuel;

%% Fuel tank
ftank_start = 0.2; %chordwise
ftank_end = 0.6;
ftank_limit = 0.85; %spanwise

points = linspace(0,1,11)'; %don't change this

%root
[Xtur, Xtlr] = D_airfoil2(A_r(1:end/2),A_r(end/2+1:end),points);
Thr = (Xtur(:, 2) - Xtlr(:, 2)) * c_r;
BrL = Thr(ftank_start*10+1);
BrT = Thr(ftank_end*10+1);
Br = (BrL + BrT) * (ftank_end - ftank_start) * c_r / 2; % area of tank at root

%tip
[Xtut, Xtlt] = D_airfoil2(A_t(1:end/2),A_t(end/2+1:end),points); %this can be refactored...
Tht = (Xtut(:, 2) - Xtlt(:, 2)) * c_t;
BtL = Tht(ftank_start*10+1);
BtT = Tht(ftank_end*10+1);
Bt = (BtL + BtT) * (ftank_end - ftank_start) * c_t / 2; % area of tank at tip

Be = interp1([0, 1], [Br, Bt], ftank_limit); % area of end tank

V_tank = 1/3 * ftank_limit * b/2 * (Br + Be + sqrt(Br + Be)) * 2; %for both wings

W_TO = W_str + W_fuel + inits.W_AW;

%%
c(1) = V_fuel/(V_tank * f_tank) - 1;
c(2) = (W_TO / 2 * area)/(inits.W_TO/inits.area) - 1;

ceq(1) = W_TO/copy.W_TO - 1;
ceq(2) = W_str/copy.W_str - 1;
ceq(3) = W_fuel/copy.W_fuel - 1;
ceq(4) = CLCD/copy.CLCD - 1;
ceq(5:8) = L_poly./copy.L_poly' - 1;
ceq(9:12) = M_poly./copy.M_poly' - 1;

end