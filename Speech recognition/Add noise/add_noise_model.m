%--------------------------------------------------------------------------
% noise doenload wedsite
%   http://spib.linse.ufsc.br/noise.html
%--------------------------------------------------------------------------
clc;
clear;
close all;
%--------------------------读取语音文件-------------------------------------
[filename,pathname]=uigetfile('try.wav','请选择语音文件：');
[x,fs1]=audioread([pathname filename]);%读取干净语音信号
SNR = 3;
%x是干净语音信号
%n是噪声信号
%SNR是信噪比
%-----------------------------加载噪声--------------------------------------
% load white.mat white  
% n = white;
%-----------------------
load babble.mat babble 
n = babble;
%--------------------------------------------------------------------------
nx=size(x,1);  %语音信号长度
noise=n(1:nx);
noise=noise-mean(noise);    %噪声信号取均值
signal_power=1/nx*sum(x.*x); %语音信号平均功率
noise_variance=signal_power/(10^(SNR/10));    %按信噪比计算加入噪声的方差
noise=sqrt(noise_variance)/std(noise)*noise;   %噪声信号标准差为std(noise)，随机数的标准差为sqrt(noise_variance)，求出需要加入噪声的随即序列
y=(x(:)+ noise(:));  %干净语音信号叠加噪声信号
audiowrite(['signal+noisy_' filename],y,fs1); %以SNR信噪比合成之后的信号写入*.wav文件中
%------------------------------可视化---------------------------------------
n_fft=length(x);  %选取变换的点数 
y_p=fft(x,n_fft);
y_p2=fft(y,n_fft);

figure(1)
subplot(2,2,1);
plot(x);                    %语音信号的时域波形图
title('wav');
xlabel('time')
ylabel('A')

subplot(2,2,2);
plot(abs(y_p(1:n_fft/2)));     %语音信号的频谱图
title('wav-fft');
xlabel('Hz');
ylabel('A''');

subplot(2,2,3);
plot(y);                    %语音信号的时域波形图
title('wav+noise');
xlabel('time')
ylabel('A')

subplot(2,2,4);
plot(abs(y_p2(1:n_fft/2)));     %语音信号的频谱图
title('wav+noise-fft');
xlabel('Hz');
ylabel('A''');