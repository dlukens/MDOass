%% Read .weight file

formatSpec = [Inf Inf];

fid = fopen('A300.weight');
S = textscan(fid, '%s');
fclose(fileID);