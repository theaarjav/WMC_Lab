%clc;
%close all;
%clear all;
%%zero forcing equalizer
b1=10000;
Nt=4;
Nr=1;

x1=randi([0 1], Nt, b1);
x2=x1.*2-1;
BER=zeros(5000, 41);
for i=1:10
    H=1/sqrt(2).*(randn(Nr, Nt) + 1j*randn(Nr, Nt));

    snr_db=-20:1:20;
    snr=10.^(snr_db/10);
    ber=[];
    for k=1:length(snr_db)
        x3=x2.*sqrt(snr(k)/sqrt(Nt));
        y_=H*x3 + sqrt(1/2)*(randn(Nr, b1)+1j*(randn(Nr,b1)));
        y_zf=pinv(H)*y_;

        %y_mmse=inv(H'*H+(1/snr(k).*eye(Nt)));
        qe_zf=real(y_zf>=0);
        ber_temp=sum(sum(qe_zf~=x1))/(Nt*b1);
        BER(i,k)=ber_temp;
        %ber(k)=error_bits
    end
end
ber_new=mean(BER);
semilogy(snr_db, ber_new);
legend('SISO', 'SIMO', 'MIMO', 'MISO');
hold on;
%H=1/sqrt(2).*(randn(Nr,Nt) + 1j*randn(Nr, Nt));
%Generating noise=> N=