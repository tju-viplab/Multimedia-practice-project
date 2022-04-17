function test(hmm)
clc;
clear;
close all;
load mylabel-1.mat;
% load mylabel.mat; %空标签文件 
load myhmm.mat;
% load myhmm_enhanced.mat
%----------------------------------
% tn=98;%测试样本个数
% num=length(label);%模版个数,类别
%----------------------------------
tn=21;%测试样本个数
num=3;%模版个数,类别
ccount=0;%识别正确的命令个数
for i=1:tn
	fname = sprintf('test_nenhance\\%d.wav',i);
	x = audioread(fname);
% 	[x1 x2] = vad(x);  %端点检测
    x=0.2*x/max(x);%幅度统一化
	m = mfcc(x);
% 	m = m(x1-2:x2-2,:); %用端点限制音频
	for j=1:num
		pout(j) = viterbi(hmm{j}, m);
	end
	[d,n] = max(pout);
    %n = mod(n, 10);
   fprintf('第%d个命令, 识别为%s%s \n', i,label(n,1),label(n,2));
   fprintf('\n');
   aa=ceil(i/7);
   if aa==n
       ccount=ccount+1;
   end
   cp=ccount/tn;
  
end
ccount
fprintf('此次识别的正确率为%d',cp*100);
clear i d n x x1 x2 m j pout fname k sample;