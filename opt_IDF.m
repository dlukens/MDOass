function f = opt_IDF(x)
tic

global copy;
global inits;

fprintf('\t ---- F-count: %d/%d ---- \n', copy.iter, length(x));

disp(x)  %for monitoring
copy.papi = x;

b = x(1)*inits.b;
c_r = x(2)*inits.c_r;
tr_k = x(3)*inits.tr_k;
tr_t = x(4)*inits.tr_t;
phi_k = x(5)*inits.phi_k;
phi_t = x(6)*inits.phi_t;
A_r = x(7:18).*inits.A;
A_t = x(19:30).*inits.A;
W_TO = x(31)*inits.W_TO;
W_str = x(32)*inits.W_str;
W_fuel = x(33)*inits.W_fuel;
CLCD = x(34)*inits.CLCD;
L_poly = x(35:39).*inits.L_poly';
M_poly = x(40:44).*inits.M_poly';

sweep = atand((c_r - c_r*tr_k)/(b * 0.4 * 0.5));
x_t = tand(sweep) * b/2;
x_k = tand(sweep) * b/2*0.4;
y_k = b/2*0.4;
y_t = b/2;
c_k = c_r * tr_k;
c_t = c_r * tr_t;

A1 = ((c_r + c_k) * 0.4 * b / 2) / 2;
A2 = (c_k + c_t) * (x_t - x_k) / 2;
area = A1 + A2;

%% Blocks

CL = 0.5; %This must be computed.
[copy.L_poly, copy.M_poly] = Q3Dinv(CL, A_r, A_t, c_r, tr_k, tr_t, b);

[copy.W_str, Yu_r, Yl_r, Yu_t, Yl_t] = EMWETmain(W_TO, W_fuel, b, c_r, c_t, area, sweep, A_r, A_t, L_poly, M_poly);

[CLwing, CDwing] = Q3Dvis(CL, A_r, A_t, c_r, tr_k, tr_t, b);
copy.CLCD = CLwing/CDwing;
 
[copy.W_fuel, copy.V_fuel] = Breguet(W_TO, CLCD);

f = double(objective(copy.W_fuel, copy.W_str));

copy.iter = copy.iter + 1;

%% Plots

if mod(copy.iter,1) == 0
    figure
        subplot(3,1,1)
            title('Planform')
            hold on
            axis ij
            axis equal
            %  [y1, y2], [x1,x2]
            plot([0,    y_k], [0,          x_k]);
            plot([y_k,  y_t], [x_k,        x_t]);
            plot([y_t,  y_t], [x_t,  x_t + c_t]);
            plot([y_t,  y_k], [x_t + c_t,  c_r]);
            plot([y_k,  0],   [c_r,        c_r]);
            axis([0,30,-2,20])
        subplot(3,1,2)
            title('Root airfoil')
            hold on
            plot(Yu_r(:,1),Yu_r(:,2),'b');
            plot(Yl_r(:,1),Yl_r(:,2),'r');
            axis([0,1,-0.25,0.25])
        subplot(3,1,3)
            title('Tip Airfoil')
            hold on
            plot(Yu_t(:,1),Yu_t(:,2),'b');
            plot(Yl_t(:,1),Yl_t(:,2),'r');
            axis([0,1,-0.25,0.25])
end

toc
end