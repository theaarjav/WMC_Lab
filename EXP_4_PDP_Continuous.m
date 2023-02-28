clc;
close all;
Taus = 0:1e-10:1e-5;
P_tau = exp(-Taus/1e-5);
P_tau_dBm = 10*log10(P_tau/1e-3);
fun = @(tau) exp(-tau/0.00001); %given PDP equation
[meanDelay, rmsDelay, symbolRate, coherenceBW] = meas_continuous_PDP (fun, 0, 10e-6);
disp('Mean excess delay: ');
disp(meanDelay);
disp('RMS excess delay: ');
disp(rmsDelay);
disp('Symbol Rate: ');
disp(symbolRate);
disp('Coherence Bandwidth: ');
disp(coherenceBW);
plot(Taus,P_tau);
title('Continuous Power Delay Profile (U20EC099)');
xlabel('Excess Delay(in s)');
ylabel('Received Signal Level (in dBm)');

function [meanDelay, rmsDelay, symbolRate, coherenceBW] = meas_continuous_PDP (fun, lowerLim, upperLim)
moment_1 = @(x) x.*fun(x);
meanDelay = integral (moment_1, lowerLim, upperLim)/integral (fun, lowerLim, upperLim);
moment_2 = @(y) ((y-meanDelay).^2).*fun(y);
rmsDelay = sqrt(integral (moment_2, lowerLim, upperLim)/integral (fun, lowerLim, upperLim ));
symbolRate = 1/(10*rmsDelay); %maximum symbol rate to avoid ISI
coherenceBW = 1/(50*rmsDelay); %for 0.9 correlation
%coherenceBW = 1/(5*rmsDelay);%for 0.5 correlation
end