function ccc = mfcc(x)
% %----------------------------单独运行本文件时去掉此段注释
% % 读取一个音频文件
% x=audioread('.\try.wav');
% %----------------------------

% 归一化mel滤波器组系数
bank=melbankm(24,256,8000,0,0.5,'m');
bank=full(bank);
bank=bank/max(bank(:));

% DCT系数,12*24
for k=1:12
  n=0:23;
  dctcoef(k,:)=cos((2*n+1)*k*pi/(2*24));
end

% 归一化倒谱提升窗口
w = 1 + 6 * sin(pi * [1:12] ./ 12);
w = w/max(w);

% 预加重滤波器
xx=double(x);
xx=filter([1 -0.9375],1,xx);

% 语音信号分帧
xx=enframe(xx,256,80);

% 计算每帧的MFCC参数
for i=1:size(xx,1)
  y = xx(i,:);
  s = y' .* hamming(256);
  t = abs(fft(s));
  t = t.^2;
  c1=dctcoef * log(bank * t(1:129));
  c2 = c1.*w';
  m(i,:)=c2';
end

%差分系数
dtm = zeros(size(m));
for i=3:size(m,1)-2
  dtm(i,:) = -2*m(i-2,:) - m(i-1,:) + m(i+1,:) + 2*m(i+2,:);
end
dtm = dtm / 3;

%合并mfcc参数和一阶差分mfcc参数
ccc = [m dtm];
%去除首尾两帧，因为这两帧的一阶差分参数为0
ccc = ccc(3:size(m,1)-2,:);

 
% %------------------------单独运行本文件时去掉此段注释
% %将处理前后的结果进行作图比较
% wav_length=length(x);
% subplot(2,1,1);
% plot(x);grid on;
% title('wav in');
% axis([1 wav_length -1 1]);
% 
% m_length=length(m);
% subplot(2,1,2);
% plot(m);grid on;
% title('mfcc');
% axis([1 m_length -1 1]);
% %------------------------