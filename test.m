clc
clear variables
close all


% OFDM = ifft([zeros(100,1); randi([0 1],824-256,1).*2-1;zeros(100,1)]);
fsamp = 20e6;
freq = 5e6;
f2 = 5e3;
pLevel = -20;
dur = 4e-4;
t = 1/fsamp : 1/fsamp : dur;
sine = sin(2*pi*freq*t);
twosine = sin(2*pi*f2*t) + sin(2*pi*2*f2*t);
twosine1 = twosine .* sine;

% figure; 
% plot(t, twosine);

cxg = CXG('USB0::0x0957::0x1F01::MY59100546::0::INSTR');
cxg.load_data(twosine1, freq, fsamp, pLevel);

