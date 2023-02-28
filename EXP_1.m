clc;
clear all;
close all;
M=64;
x=randi([0 1],1,1000);
n=log2(M);
if(mod(length(x),n)~=0)
    x=[zeros(1,n-mod(length(x),n)),x];
end
x
b=reshape(x,[n length(x)/n]);
B=transpose(b);
y=bi2de(B);
z=pskmod(y,M);
s=scatterplot(z);
Z=pskdemod(z,M);
Y=de2bi(Z);
ans=transpose(Y);
out=reshape(ans,[1 length(x)])
title('Constellation for M = ' + string(M) + ' (U20EC099)');

