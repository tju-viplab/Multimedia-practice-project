%本程序应用多窗谱法估计的语音信号功率谱密度（PSD）来进行谱减语音增强

clc;
clear;
a=2;      %过减因子
b=0.01;     %增益补偿因子
c=0;        %c=0时，不对增益矩阵进行开方，c=1时，进行开方运算

%读取语音文件---------------------------------------------------------------
[filename,pathname]=uigetfile('SNR_0-增大.wav','请选择语音文件：');
[wavin_t,fs]=audioread([pathname filename]);
wav_length=length(wavin_t);

%基音周期最大为20ms，为使ifft还原后语音失真尽量小，帧长至少要为基音周期的2倍
%根据fs选择帧长： 
% switch fs
%     case 8000
%         frame_len=320;step_len=160; 
%     case 10000
%         frame_len=400;step_len=200;
%     case 12000
%         frame_len=480;step_len=240;
%     case 16000
%         frame_len=640;step_len=320;
%     case 44100
%         frame_len=1800;step_len=900;
%     otherwise
%         frame_len=1800;step_len=900;
% end;
frame_len=320;step_len=160;
frame_num=ceil((wav_length-step_len)/step_len);
wavin=zeros(1,frame_num*frame_len);
wavin(1:wav_length)=wavin_t(:);
inframe=zeros(frame_len,frame_num);
for i=1:frame_num;
    inframe(:,i)=wavin(((i-1)*step_len+1):((i-1)*step_len+frame_len));
end;
%inframe=(ENFRAME(wavin,frame_len,step_len))';   %分帧
%frame_num=size(inframe,2);          %求帧数
window=hamming(frame_len);          %定义汉明窗

%分别对每帧fft，求幅值，求相角-----------------------------------------------
for i=1:frame_num;
    fft_frame(:,i)=fft(window.*inframe(:,i));
    abs_frame(:,i)=abs(fft_frame(:,i));
    ang_frame(:,i)=angle(fft_frame(:,i));
end;

%每相邻三帧平滑-------------------------------------------------------------
abs_frame_f=abs_frame;
for i=2:frame_num-1;
    abs_frame_f(:,i)=mean(abs_frame(:,(i-1):(i+1)),2);
end;
abs_frame=abs_frame_f;

%求增益矩阵-----------------------------------------------------------------
%矩阵中每一元素为：
%g(k)=(Py(k)-a*Pn(k))/Py(k)
%Py和Pn分别为带噪语音和噪声的功率谱估计，都用MATLAB中自带的pmtm函数来估计
%可根据需要调节a的大小，来得到更好的效果

%用多窗谱法法对每一帧数据进行功率谱估计
for i=1:frame_num;
    per_PSD(:,i)=pmtm(inframe(:,i),3,frame_len,'twosided');
end;

%对功率谱的每相邻三帧进行平滑
per_PSD_f=per_PSD;
for i=2:frame_num-1;
    per_PSD_f(:,i)=mean(per_PSD(:,(i-1):(i+1)),2);
end;
per_PSD=per_PSD_f;

%取前20帧作为噪声帧，取其平均作为噪声的功率谱估计
noise_PSD=mean(per_PSD(:,1:20),2);

%求增益矩阵
for k=1:frame_num;
    g(:,k)=(per_PSD(:,k)-a*noise_PSD)./per_PSD(:,k);
end;

%求增益补偿阈值，凡是小于该阈值的增益系数军用阈值来代替，这样可减少音乐噪声
spec_floor=b*noise_PSD./per_PSD(:,k);
spec_floor=spec_floor(:,ones(1,frame_num));
[I,J]=find(g<spec_floor);
gf=g;
gf(sub2ind(size(gf),I,J))=spec_floor(sub2ind(size(gf),I,J));
if c==0;
    g=gf;
else g=gf.^0.5;
end;

%谱减----------------------------------------------------------------------
sub_frame=g.*abs_frame;

% % 非语音帧衰减------------------------------------------------------------
% T=20*log10(mean(sub_frame./(abs_noise*ones(1,frame_num))));
% T_noise=mean(T(:,1:20),2);
% c=10^(-2/3);            %衰减系数为 10^(-1.5)
% noise_frame=find(T<T_noise);
% sub_frame(:,noise_frame)=c*sub_frame(:,noise_frame);

%将语音信号还原至时域-------------------------------------------------------
wavout=zeros(1,(frame_num-1)*step_len+frame_len);
j=sqrt(-1);
i=1;
for t=1:step_len:((frame_num-1)*step_len+1);
    wavout(:,t:(t+frame_len-1))=wavout(:,t:(t+frame_len-1))+real(ifft(sub_frame(:,i).*exp(j*ang_frame(:,i))))';
    i=i+1;
end;

%将处理结果输出为'wav'文件--------------------------------------------------
if c==0;
    audiowrite([num2str(frame_len) 'fnm_' num2str(a) '_' num2str(b) '_' filename],wavout,fs);
else
    audiowrite(['m_' num2str(a) '_' num2str(b) '_' filename],wavout,fs);
end;

%将处理前后的结果进行作图比较
subplot(2,1,1);
plot(wavin);grid on;
title('wav in');
axis([1 wav_length -1 1]);

subplot(2,1,2);
plot(wavout);grid on;
title('wav out');
axis([1 wav_length -1 1]);
sound(wavin);
sound(wavout);