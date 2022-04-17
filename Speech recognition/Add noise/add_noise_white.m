clc;
clear;
close all;

[filename,pathname]=uigetfile('try.wav','请选择语音文件：');

[wav,fs]=audioread([pathname filename]); %读入声音文件
%--------------------------------------------------------------------------
noisewav(1:size(wav))=0;

for i=1:size(wav)

noisewav(i)=rand*(-1)^randi(1:2); %使用随机数对每一帧生成均匀分布的白噪音

end

wav2 = (wav(:)*0.95 + noisewav(:)*0.05); %按一定比例添加噪音，0.05的噪音已经足够了
%--------------------------------------------------------------------------
% %SNR dB
% SNR=3;   %可以修改信噪比
% NOISE=randn(size(wav));
% 
% NOISE=NOISE-mean(NOISE);
% 
% signal_power = 1/length(wav)*sum(wav.*wav);
% 
% noise_variance = signal_power / ( 10^(SNR/10) );
% 
% NOISE=sqrt(noise_variance)/std(NOISE)*NOISE;
% wav2 = wav+NOISE;
% % --------------------------------------------------------------------------


audiowrite(['add_noisy_' filename],wav2 ,fs);
%------------------------------可视化---------------------------------------
n_fft=length(wav);  %选取变换的点数 
y_p=fft(wav,n_fft);
y_p2=fft(wav2,n_fft);

figure(1)
subplot(2,2,1);
plot(wav);                    %语音信号的时域波形图
title('wav');
xlabel('time')
ylabel('A')

subplot(2,2,2);
plot(abs(y_p(1:n_fft/2)));     %语音信号的频谱图
title('wav-fft');
xlabel('Hz');
ylabel('A''');

subplot(2,2,3);
plot(wav2);                    %语音信号的时域波形图
title('wav+noise');
xlabel('time')
ylabel('A')

subplot(2,2,4);
plot(abs(y_p2(1:n_fft/2)));     %语音信号的频谱图
title('wav+noise-fft');
xlabel('Hz');
ylabel('A''');