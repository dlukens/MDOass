function [] = EMWETwrite(W_TO, W_fuel, b, c_r, c_t, area, sweep, L_poly, M_poly)
%% Routine to write the input file for the EMWET procedure

MTOW        =    W_TO;         %[kg]
MZF         =    W_TO - W_fuel;         %[kg]
nz_max      =    2.5;   
span        =    b;         %[m]
wing_surf   =    area;
spar_front  =    0.2;
spar_rear   =    0.8;
ftank_start =    0.1;
ftank_end   =    0.70;
eng_num     =    1;
eng_ypos    =    0.359;
eng_mass    =    4273;         %kg
E_al        =    7E10;       %N/m2
rho_al      =    2800;         %kg/m3
Ft_al       =    2.95E8;        %N/m2
Fc_al       =    2.95E8;        %N/m2
pitch_rib   =    0.5;          %[m]
eff_factor  =    0.96;             %Depend on the stringer type
Airfoil_root=    'FOIL_root';
Airfoil_tip =    'FOIL_tip';
section_num =    3;
airfoil_num =    2;


x_t = tand(sweep) * b/2;
x_k = tand(sweep) * b/2*0.4;
y_k = b/2*0.4;
y_t = b/2;
c_k = c_r - x_k;


fid = fopen('A300.init','wt');
fprintf(fid, '%g %g \n',MTOW,MZF);
fprintf(fid, '%g \n',nz_max);

fprintf(fid, '%g %g %g %g \n',wing_surf,span,section_num,airfoil_num);

fprintf(fid, '0   %s \n',Airfoil_root);
fprintf(fid, '1   %s \n',Airfoil_tip);
fprintf(fid, '%g %g %g %g %g %g \n',c_r,0,0,0,spar_front,spar_rear);
fprintf(fid, '%g %g %g %g %g %g \n',c_k, x_k ,y_k,0,spar_front,spar_rear);
fprintf(fid, '%g %g %g %g %g %g \n',c_t,x_t,y_t,0,spar_front,spar_rear);

fprintf(fid, '%g %g \n',ftank_start,ftank_end);

fprintf(fid, '%g \n', eng_num);
fprintf(fid, '%g  %g \n', eng_ypos,eng_mass);

fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);

fprintf(fid,'%g %g \n',eff_factor,pitch_rib);
fprintf(fid,'0 \n');
fclose(fid);

%% Writing .load file

points = linspace(0,1,15);
L_dist = polyval(L_poly, points*b/2);
M_dist = polyval(M_poly, points*b/2);


B = [points; L_dist; M_dist];
fid = fopen('A300.load','wt');
fprintf(fid, '%g %g %g \n',B);
fclose(fid);

end
