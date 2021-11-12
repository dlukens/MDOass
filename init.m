global inits;
inits.W_TO = 170500; %[kg]
inits.W_fuel = 56330; %[kg]
inits.rho = 0.38; % [kg/m^3] double check this
inits.V = 230; %[m/s]
inits.V_max = 234.587;
inits.area = 260/2; %[m^2]
inits.h = 10668; %[m]
inits.M = inits.V/297.4;
inits.MAC = 6.44; %[m]
inits.Re = inits.rho * inits.V * inits.MAC / 1.437e-5; %[-]
inits.b = 44.84;
inits.c_r = 10; %[m]
inits.tr_k = 0.5;
inits.tr_t = 0.3;
inits.CLCD = 16;
inits.phi_k = 1;
inits.phi_t = 2;
inits.range = 7408000;
inits.n_max = 2.5;
inits.dihedral = 5; %deg


%% Inititalise airfoil - naca
order = 5;
inits.A = airfoilgen(order);

%% Find CD_A-w

CLinv = inits.W_TO * inits.n_max / (0.5 * inits.rho * inits.V^2 * inits.area);
CLvis = Ldes(inits.W_TO, inits.W_fuel) * inits.n_max / (0.5 * inits.rho * inits.V^2 * inits.area);

[inits.CLwing, inits.CDwing] =  Q3Dvis(CLvis, inits.A, inits.A, inits.c_r, inits.tr_k, inits.tr_t, inits.phi_k, inits.phi_t, inits.b);
[inits.L_poly, inits.M_poly] =  Q3Dinv(CLinv, inits.A, inits.A, inits.c_r, inits.tr_k, inits.tr_t, inits.phi_k, inits.phi_t, inits.b);

inits.CD_AW = inits.CLwing/inits.CLCD - inits.CDwing;

%% Find W_str

inits.W_str = EMWETmain(inits.W_TO, inits.W_fuel, inits.b, inits.c_r, inits.tr_k, inits.tr_t, ...
                        inits.area, inits.A, inits.A, inits.L_poly, inits.M_poly);

inits.W_AW = inits.W_TO - inits.W_fuel - inits.W_str;

function A = airfoilgen(order)
fid = fopen('n64215.dat', 'r');
global airfoil;
airfoil = fscanf(fid, '%g %g', [2 Inf])';
fclose(fid);

split = floor(length(airfoil)/2);

airfoil_upper = airfoil(1:split-1, :);
airfoil_xu = airfoil_upper(:, 1);
airfoil_lower = airfoil(split+1:end, :);
airfoil_xl = airfoil_lower(:, 1);

% figure;
% hold on;
% plot(airfoil_upper(:, 1), airfoil_upper(:, 2), '-');
% plot(airfoil_lower(:, 1), airfoil_lower(:, 2), '-r');

% Optimisation
M = (order + 1) * 2;
x0 = 1 * ones(M, 1);
options=optimset('Display', 'none');

x = fminunc(@(x)CST_objective(x, airfoil), x0, options);

Au = x(1:length(x)/2);
Al = x(length(x)/2 + 1:length(x));
A = [Au; Al];                               %potential refactor here

% [Xtu,~] = D_airfoil2(Au, Al, airfoil_xu);
% [~,Xtl] = D_airfoil2(Au, Al, airfoil_xl);

% plot(Xtu(:,1),Xtu(:,2),'xb');    %plot upper surface airfoilds
% plot(Xtl(:,1),Xtl(:,2),'xr');    %plot lower surface airfoilds
% axis([0,1,-0.5,0.5]);

%% Function
    function [error] = CST_objective(x, airfoil)

        Au = x(1:length(x)/2);
        Al = x(length(x)/2 + 1:length(x));

        split = floor(length(airfoil)/2);

        airfoil_upper = airfoil(1:split-1, :);
        airfoil_xu = airfoil_upper(:, 1);
        airfoil_lower = airfoil(split:end, :);
        airfoil_xl = airfoil_lower(:, 1);

        % Bernstein Curve
        [Xtu,~] = D_airfoil2(Au, Al, airfoil_xu);
        [~,Xtl] = D_airfoil2(Au, Al, airfoil_xl);

        diffu = sum((airfoil_upper(:, 2) - Xtu(:, 2)).^2);
        diffl = sum((airfoil_lower(:, 2) - Xtl(:, 2)).^2);
        error = diffu + diffl;
    end
end
