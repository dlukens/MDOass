function f = objective(W_TO_0, W_AW, W_fuel, W_str)

f_0 = W_AW + W_fuel + W_str;
f = f_0/W_TO_0;

end