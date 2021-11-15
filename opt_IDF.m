function f = opt_IDF(x)
tic;

global copy; %these are actually not for copy variables
global inits;

% fprintf('\t ---- F-count: %d/%d ---- \n\n', copy.iter, length(x)+1);

copy.papi = x;

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

W_TO = double(W_str + W_fuel + inits.W_AW);

sweep = atand((c_r - c_r*tr_k)/(b * 0.4 * 0.5));
x_t = tand(sweep) * b/2;
x_k = tand(sweep) * b/2*0.4;
y_k = b/2 * 0.4;
y_t = b/2;
c_k = c_r * tr_k;
c_t = c_r * tr_t;
tr_kt = tr_t / tr_k;

area1 = ((c_r + c_k) * 0.4 * b / 2) / 2;
area2 = (c_k + c_t) * (x_t - x_k) / 2;
area = area1 + area2; %for one wing

MAC1 = 2/3 * c_r * (1 + tr_k + tr_k^2)/(1 + tr_k);
MAC2 = 2/3 * c_k * (1 + tr_kt + tr_kt^2)/(1 + tr_kt);
MAC = (MAC1*area1 + MAC2*area2)/area;

CLinv = W_TO * 9.81 * inits.n_max / (0.5 * inits.rho * inits.V^2 * area * 2);
CLvis = Ldes(W_TO, W_fuel) / (0.5 * inits.rho * inits.V^2 * area * 2);


%% Blocks

[copy.L_poly, copy.M_poly] = Q3Dinv(CLinv, A_r, A_t, c_r, tr_k, tr_t, phi_k, phi_t, b, MAC);

[copy.W_str, copy.Yu_r, copy.Yl_r, copy.Yu_t, copy.Yl_t] = EMWETmain(W_TO, W_fuel, b, c_r, tr_k, tr_t, area, A_r, A_t, L_poly, M_poly);

[copy.CLwing, copy.CDwing] = Q3Dvis(CLvis, A_r, A_t, c_r, tr_k, tr_t, phi_k, phi_t, b);
copy.CLCD = copy.CLwing/copy.CDwing;
 
[copy.W_fuel, copy.V_fuel] = Breguet(W_TO, CLCD);

f = objective(copy.W_fuel, copy.W_str);

t = toc;
fprintf('f-eval %g -> \t f = %g in %gs \n', inits.iter, f, t);

inits.iter = inits.iter + 1;

global xNow;
global wtoNow;

xNow = x(1:30)';
wtoNow = [f 0];

[0.800000059319802;0.800000059319802;0.800000000000000;0.800000000000000;1.24278308254502;0.514502205971810;0.946776425729390;0.937577379842215;0.905771242835556;0.906639572507863;0.879025211021414;0.806042069052262;0.926450429196527;0.951120398860078;0.904047711272502;0.892499362263742;0.979528684143455;0.885255912960129;0.892840040308495;0.889052060526512;0.837339886401382;0.939972778264467;1.05440437707574;1.17449794454700;1.00197371341935;0.978851636758389;0.950229678036517;0.930316378533599;0.827745777490256;1.07899874722962;0.500000059319807;0.500000059319804;1.50000000000000;0.541711432432320;0.952461297578592;1.64756635393844;1.27162017585555;1.35794642598843;1.21586620477269;1.03494576693283;0.708346029545906]


%% Plots
if mod(inits.iter,5) == 0
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
end

end