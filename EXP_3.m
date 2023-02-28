clc;
clear all;
close all;
sigma=1/sqrt(2);
% h=raylrnd(sigma)
% ang=rand()*2*pi
% ch_coef=h.*(cos(ang)+j.*sin(ang));
M=64;
BER=zeros(1,21);
SNR=zeros(1,21);
cnt=1;
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
for i=1:21
    Z=qammod(YY,M);
    X=sqrt(mean(abs(Z).^2));
    Z=Z./X;
    % %s=scatterplot(Z);
    % ss=scatterplot(T);
    h=raylrnd(sigma);
    ang=rand()*2*pi;
    ch_coef=h.*(cos(ang)+j.*sin(ang));
    T=Z.*ch_coef;
    Z=T;
    G=awgn(Z,SNR(i));
    ZZ=qamdemod(G,M);
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
semilogy(SNR,BER);
