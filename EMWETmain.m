function W_str = EMWETmain(W_TO, W_fuel, b, c_r, c_t, area, sweep, Yst, ccldist, cmdist, chords)
    %% Write .init and .load file

    EMWETwrite(W_TO, W_fuel, b, c_r, c_t, area, sweep, Yst, ccldist, cmdist, chords);

    %% Run EMWET

    EMWET A300;

    %% Read .weight file
%     global weight;

    fid = fopen('A300.weight');
        W_str = cell2mat(textscan(fid, 'Wing total weight(kg)%d'));
%     weight.total = cell2mat(textscan(fid, 'Wing total weight(kg)%d'));
%     weight.header = textscan(fid, '%s',6);
%     weight.fields = cell2mat(textscan(fid, '%f %f %f %f %f %f'));
    fclose(fid);
end