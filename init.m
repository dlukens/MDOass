%Variables


global inits;
inits.W_TO = 170500; %[kg]
inits.W_fuel = 56330; %[kg]
inits.rho = 0.389; % [kg/m^3] double check this
inits.V = 234.587; %[m/s]
inits.area = 260; %[m^2]
inits.h = 10668; %[m]
inits.M = inits.V/297.4;
inits.MAC = 6.44; %[m]
inits.Re = inits.rho * inits.V * inits.MAC / 3.706e-5; %[-]
inits.b = 44.84;
inits.c_r = 10; %[m]
inits.c_t = inits.c_r/3; %[m]
inits.sweep = 28; %[deg]
inits.CLCD = 16;


%% Inititalise airfoil - naca
order = 5;
A = airfoilgen(order);

%% Find CD_A-w
CL = (2 * Ldes(inits.W_TO, inits.W_fuel) * 9.81)/(inits.rho * inits.V^2 * inits.area);

[Res, copy] = Q3Dvis(CL, A, A, inits.c_r, inits.c_t, inits.b, inits.sweep);
CLwing = Res.CLwing;
CDwing = Res.CDwing;

inits.CD_AW = CLwing/inits.CLCD - CDwing;

%% Find W_str

EMWETmain;

inits.W_str = weight.total;

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

figure;
hold on;
plot(airfoil_upper(:, 1), airfoil_upper(:, 2), '-');
plot(airfoil_lower(:, 1), airfoil_lower(:, 2), '-r');


%% Optimisation
M = (order + 1)  * 2;
x0 = 1 * ones(M, 1);
options=optimset('Display', 'Iter');

x = fminunc(@(x)CST_objective(x, airfoil), x0);

Au = x(1:length(x)/2);
Al = x(length(x)/2 + 1:length(x));
A = [Au; Al];                               %potential refactor here

[Xtu,~] = D_airfoil2(Au, Al, airfoil_xu);
[~,Xtl] = D_airfoil2(Au, Al, airfoil_xl);

plot(Xtu(:,1),Xtu(:,2),'xb');    %plot upper surface airfoilds
plot(Xtl(:,1),Xtl(:,2),'xr');    %plot lower surface airfoilds
axis([0,1,-0.5,0.5]);

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
