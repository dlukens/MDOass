function [W_fuel, V_fuel] = Breguet(W_TO,CLCD)

global inits;
Ct = 1.8639e-4;
rho_fuel = 0.81715e3;

WR_cruise = exp(inits.range*Ct/(inits.V*CLCD));

W_fuel = W_TO*(1-0.938*WR_cruise);
V_fuel = W_fuel/rho_fuel;

end

