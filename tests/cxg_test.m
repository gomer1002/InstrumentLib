clc
clear variables
close all

addpath("C:\Users\boas\Documents\GitHub\InstrumentLib")

fsamp = 30e6;
freq = 1000e6;
pLevel = -5;

% data = qammod(randi(4,(824-256),1), 4);
% OFDM = ifft([zeros(100,1); data; zeros(100,1)]);
OFDM = ifft(fftshift([zeros(100,1); 0.7071.*((randi([0 1],824-0,1).*2-1)+1i*(randi([0 1],824-0,1).*2-1));zeros(100,1)]).');
figure
plot(abs(fft(OFDM)))
sig_down = ifft(fftshift(fft(load("sig_down.mat").sig_down)));
sig_up = ifft(fftshift(fft(load("sig_up.mat").sig_up)));

figure
plot(real(sig_down))
figure
plot(real(sig_up))

cxg = CXG('USB0::0x0957::0x1F01::MY59100546::0::INSTR');
cxg.load_data(OFDM, freq, fsamp, pLevel);

pream_d_s = 28268;
pream_d_e = 722676;

sym1_d_s = 727837; % 2201
sym1_d_e = 865217; % 139581

sym2_d_s = 870441; % 2858
sym2_d_e = 1007757; % 140174

sym3_d_s = 1012986; % 2985
sym3_d_e = 1122828; % 112827


pream_u_s = 25510;
pream_u_e = 719390;

sym1_u_s = 724606;
sym1_u_e = 862108;

sym2_u_s = 867345;
sym2_u_e = 1005010;

sym3_u_s = 1010230;
sym3_u_e = 1120420;


pream_d = sig_down(pream_d_s:pream_d_e);
sym1_d = sig_down(sym1_d_s:sym1_d_e);
sym2_d = sig_down(sym2_d_s:sym2_d_e);
sym3_d = sig_down(sym3_d_s:sym3_d_e);

pream_u = sig_up(pream_u_s:pream_u_e);
sym1_u = sig_up(sym1_u_s:sym1_u_e);
sym2_u = sig_up(sym2_u_s:sym2_u_e);
sym3_u = sig_up(sym3_u_s:sym3_u_e);

figure
subplot(4,1,1)
plot(real(pream_d))
subplot(4,1,2)
plot(real(sym1_d))
subplot(4,1,3)
plot(real(sym2_d))
subplot(4,1,4)
plot(real(sym3_d))

figure
subplot(4,1,1)
plot(real(pream_u))
subplot(4,1,2)
plot(real(sym1_u))
subplot(4,1,3)
plot(real(sym2_u))
subplot(4,1,4)
plot(real(sym3_u))










