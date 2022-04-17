%--------------------------------------------------------------------------
% noise doenload wedsite
%   http://spib.linse.ufsc.br/noise.html
%--------------------------------------------------------------------------
clc;
clear;
close all;
%--------------------------��ȡ�����ļ�-------------------------------------
[filename,pathname]=uigetfile('try.wav','��ѡ�������ļ���');
[x,fs1]=audioread([pathname filename]);%��ȡ�ɾ������ź�
SNR = 3;
%x�Ǹɾ������ź�
%n�������ź�
%SNR�������
%-----------------------------��������--------------------------------------
% load white.mat white  
% n = white;
%-----------------------
load babble.mat babble 
n = babble;
%--------------------------------------------------------------------------
nx=size(x,1);  %�����źų���
noise=n(1:nx);
noise=noise-mean(noise);    %�����ź�ȡ��ֵ
signal_power=1/nx*sum(x.*x); %�����ź�ƽ������
noise_variance=signal_power/(10^(SNR/10));    %������ȼ�����������ķ���
noise=sqrt(noise_variance)/std(noise)*noise;   %�����źű�׼��Ϊstd(noise)��������ı�׼��Ϊsqrt(noise_variance)�������Ҫ�����������漴����
y=(x(:)+ noise(:));  %�ɾ������źŵ��������ź�
audiowrite(['signal+noisy_' filename],y,fs1); %��SNR����Ⱥϳ�֮����ź�д��*.wav�ļ���
%------------------------------���ӻ�---------------------------------------
n_fft=length(x);  %ѡȡ�任�ĵ��� 
y_p=fft(x,n_fft);
y_p2=fft(y,n_fft);

figure(1)
subplot(2,2,1);
plot(x);                    %�����źŵ�ʱ����ͼ
title('wav');
xlabel('time')
ylabel('A')

subplot(2,2,2);
plot(abs(y_p(1:n_fft/2)));     %�����źŵ�Ƶ��ͼ
title('wav-fft');
xlabel('Hz');
ylabel('A''');

subplot(2,2,3);
plot(y);                    %�����źŵ�ʱ����ͼ
title('wav+noise');
xlabel('time')
ylabel('A')

subplot(2,2,4);
plot(abs(y_p2(1:n_fft/2)));     %�����źŵ�Ƶ��ͼ
title('wav+noise-fft');
xlabel('Hz');
ylabel('A''');