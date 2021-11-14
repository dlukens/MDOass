function f = opt_IDF(x)
tic;

global copy;
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
y_k = b/2*0.4;
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

[CLwing, CDwing] = Q3Dvis(CLvis, A_r, A_t, c_r, tr_k, tr_t, phi_k, phi_t, b);
copy.CLCD = CLwing/CDwing;
 
[copy.W_fuel, copy.V_fuel] = Breguet(W_TO, CLCD);

f = objective(copy.W_fuel, copy.W_str);

t = toc;
fprintf('f-eval %g -> \t f = %g in %gs \n', copy.iter, f, t);

copy.iter = copy.iter + 1;

%% Plots
if mod(copy.iter,1) == 0
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