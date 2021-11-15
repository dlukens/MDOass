
A = airfoilgen2(5);
c_r = 10;
b = 44.84;
tr_k = 0.5;
tr_t = 0.3;
phi_k = 1.24;
phi_t = 1.02;

sweep = atand((c_r - c_r*tr_k)/(b * 0.4 * 0.5));
x_t = tand(sweep) * b/2;
x_k = tand(sweep) * b/2*0.4;
y_k = b/2 * 0.4;
y_t = b/2;
c_k = c_r * tr_k - 0.001;
c_t = c_r * tr_t;
tr_kt = tr_t / tr_k;

area1 = ((c_r + c_k) * 0.4 * b / 2) / 2;
area2 = (c_k + c_t) * (x_t - x_k) / 2;
area = area1 + area2; %for one wing

MAC1 = 2/3 * c_r * (1 + tr_k + tr_k^2)/(1 + tr_k);
MAC2 = 2/3 * c_k * (1 + tr_kt + tr_kt^2)/(1 + tr_kt);
MAC = (MAC1*area1 + MAC2*area2)/area;

W_TO = 131677;
W_fuel = 28165;

rho = 0.38;
V = 230;
h = 10500;
n_max = 2.5;

M = 0.7;

% CL = Ldes(W_TO, W_fuel) / (0.5 * rho * V^2 * area * 2)
CL = W_TO * n_max / (0.5 * rho * V^2 * area * 2);
CL = 2;

sweep = atand((c_r - c_r*tr_k)/(b * 0.4 * 0.5));
x_t = tand(sweep) * b/2;
x_k = tand(sweep) * b/2*0.4;
y_k = b/2*0.4;
y_t = b/2;
c_k = c_r * tr_k - 0.001;
c_t = c_r * tr_t;

q = 0.5 * rho * V^2;

% Wing planform geometry 
%                x      y       z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [0       0       0     c_r         0;
               x_k      y_k     0     c_k         phi_k;
               x_t      y_t     0     c_t         phi_t];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;   
            
% Airfoil coefficients input matrix
%           | ->     upper curve coeff.    <-|  | ->   lower curve coeff.    <-| 
AC.Wing.Airfoils   =   [A';
                        A'];
                  
AC.Wing.eta = [0;0.4;1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = 1;              % 0 for inviscid and 1 for viscous analysis
AC.Aero.MaxIterIndex = 150;    %Maximum number of Iteration for the
                                %convergence of viscous calculation          
% Flight Condition
AC.Aero.V     = V;       % flight speed (m/s)
AC.Aero.rho   = rho;         % air density  (kg/m3)
AC.Aero.alt   = h;             % flight altitude (m)
% AC.Aero.Re    = Re;        % reynolds number (based on mean aerodynamic chord) THIS CHANGES WITH MAC!!!
AC.Aero.M     = M;           % flight Mach number 
AC.Aero.CL    = CL;          % lift coefficient - comment this line to run the code for given alpha%
% AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 


%% 
Res = Q3D_solver(AC);

figure
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