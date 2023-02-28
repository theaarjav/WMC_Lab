clc;
clear all;
close all;
 
img =imread('cameraman.tif');
imshow(img);
[row,col] = size(img);
n = row*col;
 
% making a single row bit array
bitArray = reshape(img,1,n);
bitArray = de2bi(bitArray);
n = n*8;
bitArray = reshape(bitArray,1,n);
 
% BERArrayPerM = [];
 
% rayleigh constant
sigma = 1/sqrt(2);
mag = raylrnd(sigma);
phase = rand*2*pi;
 
h = mag*(cos(phase) + 1j*sin(phase))
h_ = mag*(cos(phase) - 1j*sin(phase))
% p = abs(h)
% ang = angle(h)*180/pi
% h = 1
 
% for different orders
% for m = [4,8,16,32,64]
for m = 4
    m
    BERArray = [];
    SNRArray = [];
    
    BERArrayN = [];
    SNRArrayN = [];
    
    BERArrayA = [];
    SNRArrayA = [];
    
    % for multiple SNRs
    % for SNR = -10:10
    for SNR = -10:2:30
        %SNR
        % zero padding
        t = log2(m); %no of bits per symbol
        p = t- mod((row*col*8),t); %no of zeros need to be added
        x1 = [zeros(1,p),bitArray]; %adding zeros and concatinating
        nob = length(x1); %updating the length of matrix
        %disp(x1);
 
        y = reshape(x1,[t,nob/t]); %converting input to matrix
        reshapedArray = transpose(y); %transpose of matrix
        %disp(y);  %displaying matrix
        %disp(y1); %displaying transposed matrix
 
        % modulation %
        decArray = bi2de(reshapedArray);
        decArray = double(decArray);
        y = pskmod(decArray,m); % psk mod
        % y = qammod(decArray,m); % Qam mod
        
        % normalising power
        meanPower = mean(abs(y).^2);
        y = y/sqrt(meanPower);
        
        % adding noise %
        % for only awgn
        x = y;
        
        %chan = rayleighchan(ts,fd,tau,pdb);
        y = y*h; % adding rayleigh noise
        y = awgn(y,SNR);
        
        % Normalising the Image again with eq
        z = y;
        
        
        
        % WithOut eq
        
 
        % demodulation %
y1 = pskdemod(y,m); % psk demod
        % y1 = qamdemod(y,m); % Qam demod
        d2b = de2bi(y1);
 
        % reshape again %
        y2 = transpose(d2b);
        %disp(y2);
        y3 = reshape(y2,[1,nob]);
        % disp(y3);
        y4 = y3(p+1:end); %removing padding
        %disp(y4);
        y5 = reshape(y4, [row*col, 8]);
        % disp(y4);
        y6 = bi2de(y5);
        y7 = reshape(y6, [row,col]);
        %disp(y7);
        y8 = uint8(y7);
 
        % checking/adding no of error %
        [no, rat] = biterr(img, y8);
        BERArray = [BERArray,rat];
        SNRArray = [SNRArray,SNR];
        
        
        % With eq. 
        z = z*h_/(mag*mag);
        % demodulation %
        z1 = pskdemod(z,m); % psk demod
        % y1 = qamdemod(y,m); % Qam demod
        d2b = de2bi(z1);
 
        % reshape again %
        z2 = transpose(d2b);
        %disp(y2);
        z3 = reshape(z2,[1,nob]);
        % disp(y3);
        z4 = z3(p+1:end); %removing padding
        %disp(y4);
        z5 = reshape(z4, [row*col, 8]);
        % disp(y4);
        z6 = bi2de(z5);
        z7 = reshape(z6, [row,col]);
        %disp(y7);
        z8 = uint8(z7);
 
        % checking/adding no of error %
        [noN, ratN] = biterr(img, z8);
        BERArrayN = [BERArrayN,ratN];
        SNRArrayN = [SNRArrayN,SNR];
        
        % With H = 1
        % x = y;
        x = awgn(x,SNR);
 
        % demodulation %
        x1 = pskdemod(x,m); % psk demod
        % y1 = qamdemod(y,m); % Qam demod
        d2b = de2bi(x1);
 
        % reshape again %
        x2 = transpose(d2b);
        %disp(y2);
        x3 = reshape(x2,[1,nob]);
        % disp(y3);
        x4 = x3(p+1:end); %removing padding
        %disp(y4);	
x5 = reshape(x4, [row*col, 8]);
        % disp(y4);
        x6 = bi2de(x5);
        x7 = reshape(x6, [row,col]);
        %disp(y7);
        x8 = uint8(x7);
 
        % checking/adding no of error %
        [noA, ratA] = biterr(img, x8);
        BERArrayA = [BERArrayA,ratA];
        SNRArrayA = [SNRArrayA,SNR];
    end;
    semilogy(SNRArray,BERArray);
    grid on;
    hold on;
    semilogy(SNRArrayN,BERArrayN);
    grid on;
    hold on;
    semilogy(SNRArrayA,BERArrayA);
    grid on;
    hold on;
end;
title('SNR vs BER Semilog Graph (U20EC099)');
xlabel('SNR');
ylabel('Bit Error Rate');
% legend('M = 4','M = 8','M = 16','M = 32','M = 64');
legend('Without Eq','With Eq','With H = 1');
