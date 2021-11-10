function f = opt_IDF(x,y)
global copy;
global inits;
%     1   2     3     4    5      6     7    8
%x = [b, sweep, c_r, c_t, phi_k, phi_t, A_r, A_t];

%     1       2       3     4       5      6    
%y = [W_TO, W_str, W_fuel, CLCD, cldist, cmdist];

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

x_t = tand(sweep) * b/2;
x_k = tand(sweep) * b/2*0.4;
c_k = c_r - x_k;

A1 = ((c_r + c_k) * 0.4 * b / 2) / 2;
A2 = (c_k + c_t) * (x_t - x_k) / 2;
area = A1 + A2;

CL = 0.5; %This must be computed.
ResInv = Q3Dinv(CL, A_r, A_t, c_r, c_t, b, sweep);
    copy.cldist = ResInv.Wing.cl;
    copy.ccldist = ResInv.Wing.ccl;
    copy.cmdist = ResInv.Wing.cm_c4;
    copy.chords = ResInv.Wing.chord;
    copy.Yst = ResInv.Wing.Yst;

copy.W_str = EMWETmain(W_TO, W_fuel, b, c_r, c_t, area, sweep, Yst, ccldist, cmdist, chords);

ResVis = Q3Dvis(CL, A_r, A_t, c_r, c_t, b, sweep);
copy.CLCD = ResVis.CLwing/ResVis.CDwing;
 
copy.W_fuel, copy.V_fuel = Breguet(W_TO,CLCD);

f = double(objective(inits.W_TO, inits.W_AW, copy.W_fuel, copy.W_str));

end