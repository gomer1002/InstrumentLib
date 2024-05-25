clc
clear variables
close all


% OFDM = ifft([zeros(100,1); randi([0 1],824-256,1).*2-1;zeros(100,1)]);

fsamp = 30e6;
freq = 0.9e9;
% freq = 2.22e9;
pLevel = -20;
sig = [];
for i = 1:5
    sig2 = awgn(zeros(1, 2048), 20);
    sig = [sig ifft(sig2)];
end

Dispersia = var(sig);
MatOjidanie = mean(sig);
Mediana = median(sig);
% sig = awgn(zeros(1, 1024), -10);
% sig(sig > lim) = sig(sig > lim)*0.5;
% sig(sig < -lim) = sig(sig < -lim)*0.5;
% 
% figure; 
% plot(real(sig2));


set(0,'DefaultAxesFontSize',14, ...
'DefaultAxesFontName','Times New Roman');

figure
plot(real(sig))
hold on
plot(imag(sig))
xlabel("Временные отсчеты")
ylabel("Амплитуда")

figure
plot(real(fft(sig)))
hold on
plot(imag(fft(sig)))
xlabel("Частотные отсчеты")
ylabel("Амплитуда")


cxg = CXG('USB0::0x0957::0x1F01::MY59100546::0::INSTR');
cxg.load_data(sig, freq, fsamp, pLevel);



