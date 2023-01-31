clc;
close all;
clear all;

T=[0 : 100.*10^(-9): 20.*10^(-6)-100.*10^(-9)]
for t=1:length(T)/2
    p(t)=exp(-T(t)/0.00001);
end
for t=(length(T)/2+1):1:length(T)
    p(t)=0;
end
plot(T, p)
syms t;
tm=sqrt(int((exp(-t/0.00001)*t),0,10^(-5))./int(exp(-t/0.00001),0,10^(-5)))
syms t;
trms=sqrt(int(exp(-t/0.00001)*(t-tm)^2, 0, 10^(-5))./int(exp(-t/0.00001),0,10^(-5)))