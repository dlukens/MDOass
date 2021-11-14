global inits;
inits.W_TO = 170500; %[kg]
inits.W_fuel = 56330; %[kg]
inits.rho = 0.38; % [kg/m^3] double check this
inits.V = 230; %[m/s]
inits.area = 260/2; %[m^2] one wing
inits.h = 10668; %[m]
inits.M = inits.V/300;
inits.MAC = 6.44; %[m]
inits.b = 44.84;
inits.c_r = 10; %[m]
inits.tr_k = 0.4;
inits.tr_t = 0.3;
inits.CLCD = 16;
inits.phi_k = 1;
inits.phi_t = 2;
inits.range = 7408000;
inits.n_max = 2.5;
inits.dihedral = 5; %deg


%% Inititalise airfoil - naca
order = 5;
inits.A = airfoilgen2(order);

%% Find CD_A-w

CLinv = inits.W_TO * 9.81 * inits.n_max / (0.5 * inits.rho * inits.V^2 * inits.area*2);
CLvis = Ldes(inits.W_TO, inits.W_fuel) / (0.5 * inits.rho * inits.V^2 * inits.area*2);

[inits.CLwing, inits.CDwing] =  Q3Dvis(CLvis, inits.A, inits.A, inits.c_r, inits.tr_k, inits.tr_t, inits.phi_k, inits.phi_t, inits.b);
[inits.L_poly, inits.M_poly] =  Q3Dinv(CLinv, inits.A, inits.A, inits.c_r, inits.tr_k, inits.tr_t, inits.phi_k, inits.phi_t, inits.b, inits.MAC);

inits.CD_AW = inits.CLwing/inits.CLCD - inits.CDwing;

%% Find W_str

inits.W_str = EMWETmain(inits.W_TO, inits.W_fuel, inits.b, inits.c_r, inits.tr_k, inits.tr_t, ...
                        inits.area, inits.A, inits.A, inits.L_poly, inits.M_poly);

inits.W_AW = inits.W_TO - inits.W_fuel - inits.W_str;


