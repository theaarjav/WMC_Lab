clc;
close all;
Nt=input('Enter the number of transmitting antennas: ');
Nr=input('Enter the number of receiving antennas: ');
bl=input('Enter the number of message bits: ');
a=randn(Nt,Nr);                         
b=randn(Nt,Nr);             
c=randn(Nr,bl);
d=randn(Nr,bl);
Noise=(1/sqrt(2))*complex(c,d);         %noise function
H=(1/sqrt(2))*complex(a,b);             %channel function
snr1=-10:2:10;                          %defining SNR
ber_zf=zeros(1,length(snr1));           %array for zero forcing ber
ber_mmse=zeros(1,length(snr1));         %array for mmse ber 
snr=10.^(snr1/10);                      %db_to_linear
for p = 1 : 10000
    p
    for i=1:length(snr1)
        data=randi([0,1],Nt,bl);        %giving binary to numbers
        data1=2*data-1;                 %modulation
        data1=data1.*(sqrt(snr(i))/sqrt(Nt));%amplifying
        y=H*data1+Noise;                   %noise addition
        y_zf=pinv(H)*y;                    %zero_forcing
        y_mmse=inv(H'*H+((1/snr(i)).*eye(Nt)))*H'*y;%mmse equalizer
        eq_zf=real(y_zf>=0);                %hard decoding
        eq_mmse=real(y_mmse>=0);            %mmse equalizer
        [n_zf,r_zf]=biterr(data,eq_zf);     %ber calcualtion
        [n_mmse,r_mmse]=biterr(data,eq_mmse);
        ber_zf(i) = ber_zf(i) + r_zf;   %ber storage of zero forcing
        ber_mmse(i)= ber_mmse(i) + r_mmse;%ber storage of mmse
    end
end
ber_zf = ber_zf/10000;              
ber_mmse = ber_mmse/10000;
semilogy(snr1,ber_zf,snr1, ber_mmse); 
legend('zf equalizer','mmse equalizer');
title('BER vs SNR (U20EC099)');
ylabel('BER (in dB)');
xlabel('SNR (in dB)');