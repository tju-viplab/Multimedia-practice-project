clc;
clear;
close all;

[filename,pathname]=uigetfile('try.wav','��ѡ�������ļ���');

[wav,fs]=audioread([pathname filename]); %���������ļ�
%--------------------------------------------------------------------------
noisewav(1:size(wav))=0;

for i=1:size(wav)

noisewav(i)=rand*(-1)^randi(1:2); %ʹ���������ÿһ֡���ɾ��ȷֲ��İ�����

end

wav2 = (wav(:)*0.95 + noisewav(:)*0.05); %��һ���������������0.05�������Ѿ��㹻��
%--------------------------------------------------------------------------
% %SNR dB
% SNR=3;   %�����޸������
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
%------------------------------���ӻ�---------------------------------------
n_fft=length(wav);  %ѡȡ�任�ĵ��� 
y_p=fft(wav,n_fft);
y_p2=fft(wav2,n_fft);

figure(1)
subplot(2,2,1);
plot(wav);                    %�����źŵ�ʱ����ͼ
title('wav');
xlabel('time')
ylabel('A')

subplot(2,2,2);
plot(abs(y_p(1:n_fft/2)));     %�����źŵ�Ƶ��ͼ
title('wav-fft');
xlabel('Hz');
ylabel('A''');

subplot(2,2,3);
plot(wav2);                    %�����źŵ�ʱ����ͼ
title('wav+noise');
xlabel('time')
ylabel('A')

subplot(2,2,4);
plot(abs(y_p2(1:n_fft/2)));     %�����źŵ�Ƶ��ͼ
title('wav+noise-fft');
xlabel('Hz');
ylabel('A''');