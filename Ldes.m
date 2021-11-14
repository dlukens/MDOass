function L = Ldes(W_TO, W_fuel)

    L = sqrt(double(W_TO * 9.81 *(W_TO - W_fuel) * 9.81));

end

