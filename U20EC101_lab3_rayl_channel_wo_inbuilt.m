clc
close all
clear all

%%
%chan=rayleighchan(fs,fd,fau,pdb)
%fs=input sample period;
%fd=
%
x_dec=imread('cameraman.tif');
%imshow(x_dec);
%title('Input');
x_t=transpose(x_dec);%Transpose of Input Matrix
re_x=reshape(x_t, length(x_t)*length(x_t),1); %Reshapes the matrix into length(x)x1 matrix
x_dec_row=transpose(re_x); 
x=de2bi(x_dec_row);
re_x_2=reshape(x, length(x)*8,1);
te_t=transpose(re_x_2);

M=16;
m=log2(M);
p=mod(length(te_t),m);
z=[te_t zeros(1, (m-p))];  %Zero padding 
X=reshape(z, m,length(z)/m);    
Y=transpose(X);
K=bi2de(Y);
k_d=double(K);
Mod=qammod(k_d,M);
rms=sqrt(mean(abs(Mod).^2));
Mod=Mod./rms;

%sk=scatterplot(Mod.*h);
y=[];
ber=zeros(1,7);
snr=0:5:30;
for k=1:length(snr)
    k
    ber_temp=zeros(1, 100);
    for k_temp=1:100
    H=raylrnd(0.707);
ang=2*pi*rand();
h=H.*(cos(ang)+j.*sin(ang));
%h=1;
noised=awgn(Mod.*h,snr(k));
noised=(noised.*conj(h))./(abs(h)*abs(h));
noised=noised.*rms;
DModed=qamdemod(noised,M);
DK=de2bi(DModed);
DKt=transpose(DK);
DInp=reshape(DKt, length(z), 1);
InpDem=transpose(DInp);
Dem_ep_zp=InpDem(1:length(InpDem)-(m-p));

%%
%Not decoding till 256x256 as we don't need it
%%

error_bits=sum(te_t~=uint8(Dem_ep_zp));
ber_temp(k_temp)=error_bits/length(te_t);

end
%snr=-10:1:10;
ber(k)=mean(ber_temp);
end
figure(2);
semilogy(snr,ber);
%axis([-20 20 -0.0001 0]);
grid on;
hold on;
