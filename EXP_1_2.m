clc;
clear all;
close all;
order=64;
M=order;
img=imread('cameraman.tif');
subplot(121);  
imshow(img);  
title('Input Image (U20EC099)'); 
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
    %G=awgn(Z,SNR(i));
    G=Z;
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
    subplot(122);  
    imshow(uint8(yt));
    title('Output Image (U20EC099)');  