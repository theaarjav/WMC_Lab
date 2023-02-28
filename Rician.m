clc;
clear all;
clear all;
%% Using inbuilt image as a reference 
legendInfo=cell(1,5);
x_in=imread('cameraman.tif');
[hi,wi]=size(x_in);
x=reshape(x_in,1,hi*wi);
x_bi=de2bi(x);
[hd,wd]=size(x_bi);
x_cmp1 = reshape(x_bi, 1, hd*wd);
M1=[4 8 16 32 64];
for order=1:length(M1) 
 M=M1(order);
 n=hd*wd;
 number=log2(M)-rem(hd*wd,log2(M));
temp=zeros(1,number);
 x_cmp=[x_cmp1 temp];
 n1=length(x_cmp);
 y=reshape(x_cmp,[log2(M),n1/log2(M)]);
 y=transpose(y);
 %% converting to decimal 
 z=bi2de(y);
 z = double(z);
%% Adding rician channel 
 ch = comm.RicianChannel(... 
 'SampleRate',1e6,... 
 'MaximumDopplerShift',5, ... 
 'KFactor',5,... 
 'PathDelays',[0 0.4 0.9]*1e-9,... 
 'AveragePathGains',[0 -15 20]);
 %% PSK Modulation 
 x1_psk = qammod(z,M); %use qammod(y,M) 
 x1_psk = step(ch,x1_psk);
 %% Adding AWGN Noise 
 snr=-10:1:10;
 res=[];
 for i=1:length(snr) 
 y=awgn(x1_psk,snr(i));
 % Demodulation 
 x1=uint8(qamdemod(y,M)); %use qamdemod(y,M) 
 % Converting to binary and reshaping 
 x2=de2bi(x1);
 y=transpose(x2);
 % output sequence 
 y_cmp=reshape(y,[1,n1]);
 y_out=y_cmp(1:n);
 y=reshape(y_out,[hi*wi,8]);
 y_bi=bi2de(y);
 y=transpose(y_bi);
 i1=reshape(y,[hi,wi]);
 [num,ratio] = biterr(x_cmp1,y_out);
 res=[res ratio];
 end 
 semilogy(snr,res,'linewidth',2);
 grid on;
 hold on;
end 
xlabel('SNR in dB');
ylabel('Bit Error Rate');
title('SNR vs BER Curve Rician channel (U20EC099)'); 
legend('M=4','M=8','M=16','M=32','M=64');
