clc;
close all;
clear all;
x=imread('cameraman.tif');
x_t=transpose(x);
re_x=reshape(x_t, length(x),1);
x=transpose(re_x);
%x=randi([0 1],1,1000)
M=32;
m=log2(M);
p=mod(length(x),m);
z=[x zeros(1, p)];
X=reshape(z, m,length(z)/m);
Y=transpose(X);
K=bi2de(Y);
Mod=pskmod(K,M);
sk=scatterplot(Mod);
DModed=pskdemod(Mod,M);
DK=de2bi(DModed)
DKt=transpose(DK);
DInp=reshape(DKt, length(z), 1);
InpDem=transpose(DInp)

if(x==InpDem) 
    c='yes'
end