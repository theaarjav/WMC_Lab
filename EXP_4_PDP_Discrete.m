clc;
close all;
Ps = [-20 -10 -10 0] ; %Power values in dBm
Taus = [0 1e-6 2e-6 5e-6]; %Time delays
P_i = 10.^(Ps/10); %Power values in Watt
sum1 = sum(P_i);
sum2 = sum(P_i .* Taus);
%Mean Excess delay
Mean_Excess_Delay = sum2/sum1;
%RMS Dealy
Taus1 = Taus.*Taus;
second_moment = sum(P_i.*Taus1)/sum(P_i);
RMS_Delay = sqrt(second_moment - (Mean_Excess_Delay*Mean_Excess_Delay));
%Symbol Rate
symbolRate = 1/(10*RMS_Delay);
%Coherence Bandwidth
coherenceBW = 1/(50*RMS_Delay);

disp('Mean excess delay: ');
disp(Mean_Excess_Delay);
disp('RMS excess delay: ');
disp(RMS_Delay);
disp('Symbol Rate: ');
disp(symbolRate);
disp('Coherence Bandwidth: ');
disp(coherenceBW);
stem(Taus, Ps, 'linewidth',2);
title('Discrete Power Delay Profile (U20EC099)');
xlabel('Excess Delay(in s)');
ylabel('Received Signal Level (in dBm)');