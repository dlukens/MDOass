function f = objective(W_fuel, W_str)

global inits;

f_0 = inits.W_AW + W_fuel + W_str;
f = f_0/inits.W_TO;

end