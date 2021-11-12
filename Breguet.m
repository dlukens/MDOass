function [W_fuel, V_fuel] = Breguet(W_str, W_fuel, CLCD)

global inits;
Ct = 1.8639e-4;
rho_fuel = 0.81715e3;

WR_cruise = exp(inits.range*Ct/(inits.V*CLCD));

W_TO = W_str + inits.W_AW + W_fuel;
W_fuel_ = W_TO*(1-0.938*WR_cruise);
V_fuel = W_fuel_/rho_fuel;

end

