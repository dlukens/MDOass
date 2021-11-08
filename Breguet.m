function [W_fuel, V_fuel]=Breguet(W_to,LD)

global inits;

V=inits.V;
Ct=inits.Ct;
R=inits.R;
rho_fuel=inits.rho_fuel;

WR_cruise = exp(R*Ct/(V*LD));

W_fuel = W_to*(1-0.938*WR_cruise);

V_fuel = W_fuel/rho_fuel;

global copy;

copy.V_fuel=V_fuel;
copy.W_fuel=W_fuel;

end



