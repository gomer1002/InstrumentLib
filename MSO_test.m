clc
clear variable
close all

RIGOL_id = 'USB0::0x1AB1::0x0515::MS5A244909354::0::INSTR';
rig = MSO(RIGOL_id);
disp(rig.idn())
rig.autoscale();

rig.set_time_per_div(200e-6);

rig_fsamp = rig.get_samplerate();
[preabmle, osc_data] = rig.read_data();


figure
plot(osc_data)
disp(max(osc_data) - min(osc_data))


