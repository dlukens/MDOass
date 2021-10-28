%% Routine to write the input file for the EMWET procedure

namefile    =    char('A300');
MTOW        =    inits.W_TO;         %[kg]
MZF         =    inits.W_TO - inits.W_fuel;         %[kg]
nz_max      =    2.5;   
span        =    inits.b;         %[m]
root_chord  =    copy.c_r;           %[m]   
wing_surf   =    inits.area;
sweep_le    =    5;             %[deg]
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
Airfoil     =    'n64215';
section_num =    3;
airfoil_num =    3;


fid = fopen('A300.init','wt');
fprintf(fid, '%g %g \n',MTOW,MZF);
fprintf(fid, '%g \n',nz_max);

fprintf(fid, '%g %g %g %g \n',wing_surf,span,section_num,airfoil_num);

fprintf(fid, '0   %s \n',Airfoil);
fprintf(fid, '0.4 %s \n',Airfoil);
fprintf(fid, '1   %s \n',Airfoil);
fprintf(fid, '%g %g %g %g %g %g \n',copy.c_r,0,0,0,spar_front,spar_rear);
fprintf(fid, '%g %g %g %g %g %g \n',copy.c_k,copy.x_k,copy.y_k,0,spar_front,spar_rear);
fprintf(fid, '%g %g %g %g %g %g \n',copy.c_t,copy.x_t,copy.y_t,0,spar_front,spar_rear);

fprintf(fid, '%g %g \n',ftank_start,ftank_end);

fprintf(fid, '%g \n', eng_num);
fprintf(fid, '%g  %g \n', eng_ypos,eng_mass);

fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);

fprintf(fid,'%g %g \n',eff_factor,pitch_rib);
fprintf(fid,'1 \n');
fclose(fid);

%% Writing .load file
global copy;
global inits;

L = 0.5 * copy.ccl .* copy.Yst * inits.rho * inits.V ;


fid = fopen('A300test.load','wt');
fprintf(fid, '%g %g %g \n',MTOW,MZF);
fclose(fid);


