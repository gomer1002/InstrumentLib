clc
clear variable
close all

DSOX_id = 'USB0::0x0957::0x179B::MY52447315::0::INSTR';
dsx = DSOX("USB0::0x0957::0x179B::MY52447315::0::INSTR");

% dsx.set_razvertka(100e-6);
dsx.set_time_per_div(50e-6);
% dsx.set_time_per_disp(1e-3);
dsx.set_volt_per_div(1, 10e-3);
% dsx.set_volt_per_disp(1, 1.6);

dsox_fsamp = dsx.get_samplerate();
[preabmle, osc_data] = dsx.read_data();

figure
plot(osc_data)