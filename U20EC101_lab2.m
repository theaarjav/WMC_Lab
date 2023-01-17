clc;
close all;
clear all;
x_dec=imread('cameraman.tif');
%imshow(x_dec);
%title('Input');
x_t=transpose(x_dec);%Transpose of Input Matrix
re_x=reshape(x_t, length(x_t)*length(x_t),1); %Reshapes the matrix into length(x)x1 matrix
x_dec_row=transpose(re_x); 
x=de2bi(x_dec_row);
re_x_2=reshape(x, length(x)*8,1);
te_t=transpose(re_x_2);
order=[4,16,32,64];
for asdf=1:length(order)
M=order(asdf);
m=log2(M);
p=mod(length(te_t),m);
z=[te_t zeros(1, (m-p))];  %Zero padding 
X=reshape(z, m,length(z)/m);    
Y=transpose(X);
K=bi2de(Y);
k=double(K);
Mod=pskmod(k,M);
y=[];
ber=[];
snr=-10:1:10;
for k=1:length(snr)
    
    noised=awgn(Mod,snr(k));
%sk=scatterplot(Mod);
DModed=pskdemod(noised,M);
DK=de2bi(DModed);
DKt=transpose(DK);
DInp=reshape(DKt, length(z), 1);
InpDem=transpose(DInp);
Dem_ep_zp=InpDem(1:length(InpDem)-(m-p));

%Dem_ep_zp2=[Dem_em_zp zeros(1, length(te_t)-length(Dem_em_zp))];
RevT=transpose(Dem_ep_zp);
res_Dem=reshape(RevT, length(x),8);
res_dec=bi2de(res_Dem);
res_one_row=transpose(res_dec);
dem_Im=reshape(res_one_row, length(x_t), length(x_t));
final=uint8(transpose(dem_Im));
%figure(3);
%imshow(final);
%title('Output');
error_bits=sum(te_t~=uint8(Dem_ep_zp));
ber(k)=error_bits/length(te_t);
end
snr=-10:1:10;
semilogy(snr,ber)
grid on;
hold on;
end

