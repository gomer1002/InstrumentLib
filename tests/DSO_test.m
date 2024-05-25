clc
clear variable
close all

addpath("C:\Users\boas\Documents\GitHub\InstrumentLib")

DSOX_id = 'USB0::0x2A8D::0x1761::MY58490289::0::INSTR';
dsx = DSOX(DSOX_id);
disp(dsx.idn())

% dsx.set_time_per_div(50e-6);
% dsx.set_volt_per_div(1, 10e-3);

dsox_fsamp = dsx.get_samplerate();
[preabmle, osc_data] = dsx.read_data();

osc_data = osc_data ./ max(abs(osc_data));

% osc_data = osc_data(6080:15300);

figure
plot(osc_data)

figure
plot(abs((fft(osc_data))))


disp(max(osc_data) - min(osc_data))



