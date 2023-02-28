clc;
clear all;
close all;
order=[4,8,16,32,64];
for k=1:5
M=order(k);
BER=zeros(1,21);
SNR=zeros(1,21);
cnt=0;
for i=1:21
    SNR(i)=cnt;
    cnt=cnt+1;
end;
img=imread('cameraman.tif');
%imshow(img);
z=reshape(img,1,[]);
y=de2bi(z);
x=reshape(y,1,[]);
inp1=x;
l1=length(x);
n=log2(M);
if(mod(length(x),n)~=0)
    x=[zeros(1,n-mod(length(x),n)),x];
end
x;
l2=length(x);
b=reshape(x,[n length(x)/n]);
B=transpose(b);
Y=bi2de(B);
YY=double(Y);
Z=pskmod(YY,M);
%s=scatterplot(Z);
for i=1:21
    G=awgn(Z,SNR(i));
    %G=Z;
    %s=scatterplot(G);
    ZZ=pskdemod(G,M);
    YYY=de2bi(ZZ);
    anss=transpose(YYY);
    out=reshape(anss,[1 length(x)]);
    diff=l2-l1;
    org=zeros(1,l1);
    for j=diff+1:l2
        org(j-diff)=out(j);
    end
    org;
    inp2=org;
    uy=reshape(org,length(org)/8,[]);
    uu=bi2de(uy);
    uuy=transpose(uu);
    yt=reshape(uuy,256,[]);
    %imshow(uint8(yt));
    BER(i)=(sum(inp1~=inp2))/length(inp1);
end
semilogy(SNR,BER,'linewidth',2);
hold on;
end
legend('M = 4', 'M = 8', 'M = 16', 'M = 32', 'M = 64'); 
xlabel('SNR in dB');
ylabel('Bit Error Rate');
title('SNR vs BER Curve (U20EC099)'); 
