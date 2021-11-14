function A = airfoilgen2(order)
fid = fopen('n64215.dat', 'r');
airfoil = fscanf(fid, '%g %g', [2 Inf])';
fclose(fid);

split = floor(length(airfoil)/2);

airfoil_upper = airfoil(1:split-1, :);
airfoil_xu = airfoil_upper(:, 1);
airfoil_lower = airfoil(split+1:end, :);
airfoil_xl = airfoil_lower(:, 1);


% Optimisation
M = (order + 1) * 2;
x0 = 1 * ones(M, 1);
options=optimset('Display', 'none');

x = fminunc(@(x)CST_objective(x, airfoil), x0, options);

Au = x(1:length(x)/2);
Al = x(length(x)/2 + 1:length(x));
A = [Au; Al];                               %potential refactor here

% figure;
% hold on;
% plot(airfoil_upper(:, 1), airfoil_upper(:, 2), '-');
% plot(airfoil_lower(:, 1), airfoil_lower(:, 2), '-r');
% [Xtu,~] = D_airfoil2(Au, Al, airfoil_xu);
% [~,Xtl] = D_airfoil2(Au, Al, airfoil_xl);
% 
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