function [W_str, Yu_r, Yl_r, Yu_t, Yl_t] = EMWETmain(W_str, W_fuel, b, c_r, tr_k, tr_t, area, A_r, A_t, L_poly, M_poly)
    %% Reconstruct airfoil
    airfoil_x = linspace(0,1,53)';
 
    [Yu_r, Yl_r] = D_airfoil2(A_r(1:end/2), A_r(end/2+1:end), airfoil_x);
    [Yu_t, Yl_t] = D_airfoil2(A_t(1:end/2), A_t(end/2+1:end), airfoil_x);

    file = fopen('FOIL_root.dat', 'wt');
        fprintf(file, '%g %g \n',Yu_r');
        fprintf(file, '%g %g \n',Yl_r');
    fclose(file);

    file = fopen('FOIL_tip.dat', 'wt');
        fprintf(file, '%g %g \n',Yu_t');
        fprintf(file, '%g %g \n',Yl_t');
    fclose(file);

    %% Write .init and .load file

    EMWETwrite(W_str, W_fuel, b, c_r, tr_k, tr_t, area, L_poly, M_poly);

    %% Run EMWET

    EMWET A300;

    %% Read .weight file
    fid = fopen('A300.weight');
        W_str = cell2mat(textscan(fid, 'Wing total weight(kg)%d'));
    fclose(fid);
end