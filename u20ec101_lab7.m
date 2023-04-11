clc;
clear all;
close all;

N=1101;
x=round(rand(1,N));
x=transpose(x)
H=commsrc.pn('GenPoly', [3 2 0], 'InitialStates',[0 0 1],'Currentstates', [0 0 1], 'Mask',[0 0 1], 'NumBitsOut', 8);
pn=generate(H);
R=repmat(x, [1, 8]);
[r,c] =size(R);
for i=1:r
    for j=1:8
        x_xor(i,j)=xor(R(i,j), pn(j));
    end%x_xor(i)=xor(x, R(i))
end
x_re=reshape(x_xor, 1,N*8);
%x_xor=xor(x, R);
%x_xor=reshape(x_xor, 40,1);
order=2
SNR=-10:1:10
for snr=1:length(SNR)
    ber_sum=[]
x_re=transpose(x_re);
%y=bi2de(x_re);
mod=pskmod(double(x_re), order);
s=scatterplot(mod);
noised=awgn(mod, SNR(snr));
demod=pskdemod(noised, order);
demod_bi=de2bi(demod);
t=transpose(demod_bi);
demod_re=reshape(t, N, 8);
%disp(demod_re);
for i=1:r
    for j=1:8
        despread(i,j)=xor(demod_re(i,j), pn(j));
    end%x_xor(i)=xor(x, R(i))
end
ber=[]
for i=1:r
    ber(i)=sum(despread(i)~=R(i))/length(despread(i));
end
ber_sum(snr(i)+11)=sum(ber)/length(ber)
end
plot(SNR, ber_sum);