function [Res, copy] = Q3Dvis(CL, A_r, A_t, c_r, c_t, b, sweep)
%% Aerodynamic solver setting
global inits;
x_t = tand(sweep) * b/2;
x_k = tand(sweep) * b/2*0.4;
y_k = b/2*0.4;
y_t = b/2;
c_k = c_r - x_k - 0.00001;

% Wing planform geometry 
%                x      y       z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [0       0       0     c_r         0;
               x_k      y_k     0     c_k         0;
               x_t      y_t     0     c_t         0];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;   
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.    <-|  | ->   lower curve coeff.    <-| 
AC.Wing.Airfoils   =   [A_r' ;
                        A_t'];
                  
AC.Wing.eta = [0;0.4;1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = 1;              % 0 for inviscid and 1 for viscous analysis
AC.Aero.MaxIterIndex = 150;    %Maximum number of Iteration for the
                                %convergence of viscous calculation          
% Flight Condition
AC.Aero.V     = inits.V;       % flight speed (m/s)
AC.Aero.rho   = inits.rho;         % air density  (kg/m3)
AC.Aero.alt   = inits.h;             % flight altitude (m)
AC.Aero.Re    = inits.Re;        % reynolds number (based on mean aerodynamic chord) THIS CHANGES WITH MAC!!!
AC.Aero.M     = inits.M;           % flight Mach number 
AC.Aero.CL    = CL;          % lift coefficient - comment this line to run the code for given alpha%
% AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 


%% 
tic
Res = Q3D_solver(AC);
toc

%%
figure
    hold on
    axis ij
    axis equal
    %  [y1, y2], [x1,x2]
    plot([0,    y_k], [0,          x_k]);
    plot([y_k,  y_t], [x_k,        x_t]);
    plot([y_t,  y_t], [x_t,  x_t + c_t]);
    plot([y_t,  y_k], [x_t + c_t,  c_r]);
    plot([y_k,  0],   [c_r,        c_r]);
    
%%

global copy;
copy.x_k = x_k;
copy.x_t = x_t;
copy.y_k = y_k;
copy.y_t = y_t;
copy.c_k = c_k;
copy.c_r = c_r;
copy.c_t = c_t;

copy.Yst = Res.Wing.Yst;
copy.ccl = Res.Wing.ccl;
copy.cmc4 = Res.Wing.cm_c4;
    

end


