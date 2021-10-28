%% Write .init and .load file

EMWETwrite;

%% Run EMWET

EMWET A300;

%% Read .weight file

global weight;

fid = fopen('A300.weight');
weight.total = cell2mat(textscan(fid, 'Wing total weight(kg)%d'));
weight.header = textscan(fid, '%s',6);
weight.fields = cell2mat(textscan(fid, '%f %f %f %f %f %f'));
fclose(fid);