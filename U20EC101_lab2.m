clc;
close all;
clear all;
x_dec=imread('cameraman.tif');
%n=input('enter the value of n');
%x=round(rand(1,n))
x_t=transpose(x_dec);%Transpose of Input Matrix
re_x=reshape(x_t, length(x_t)*length(x_t),1); %Reshapes the matrix into length(x)x1 matrix
x_dec_row=transpose(re_x); 
x=de2bi(x_dec_row);
re_x_2=reshape(x, length(x)*8,1);
te_t=transpose(re_x_2);
%x=randi([0 1],1,1000)
M=32;
m=log2(M);
p=mod(length(te_t),m);
z=[te_t zeros(1, (m-p))];  %Zero padding 
X=reshape(z, m,length(z)/m);    
Y=transpose(X);
K=bi2de(Y);
k=double(K);
Mod=pskmod(k,M);
sk=scatterplot(Mod);
DModed=pskdemod(Mod,M);
DK=de2bi(DModed);
DKt=transpose(DK);
DInp=reshape(DKt, length(z), 1);
InpDem=transpose(DInp);
Dem_em_zp=InpDem(1:find(InpDem, 1, 'last'));
Dem_ep_zp2=[Dem_em_zp zeros(1, length(te_t)-length(Dem_em_zp))];
RevT=transpose(Dem_ep_zp2);
res_Dem=reshape(RevT, length(x),8);
res_dec=bi2de(res_Dem);
res_one_row=transpose(res_dec);
dem_Im=reshape(res_one_row, length(x_t), length(x_t));
final=uint8(transpose(dem_Im));

imshow(final);

%imshow(DInp)
if(res_one_row == re_x) 
    'yes'
end