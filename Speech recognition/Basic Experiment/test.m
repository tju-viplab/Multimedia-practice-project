function test(hmm)
clc;
clear;
close all;
load mylabel-1.mat;
% load mylabel.mat; %�ձ�ǩ�ļ� 
load myhmm.mat;
% load myhmm_enhanced.mat
%----------------------------------
% tn=98;%������������
% num=length(label);%ģ�����,���
%----------------------------------
tn=21;%������������
num=3;%ģ�����,���
ccount=0;%ʶ����ȷ���������
for i=1:tn
	fname = sprintf('test_nenhance\\%d.wav',i);
	x = audioread(fname);
% 	[x1 x2] = vad(x);  %�˵���
    x=0.2*x/max(x);%����ͳһ��
	m = mfcc(x);
% 	m = m(x1-2:x2-2,:); %�ö˵�������Ƶ
	for j=1:num
		pout(j) = viterbi(hmm{j}, m);
	end
	[d,n] = max(pout);
    %n = mod(n, 10);
   fprintf('��%d������, ʶ��Ϊ%s%s \n', i,label(n,1),label(n,2));
   fprintf('\n');
   aa=ceil(i/7);
   if aa==n
       ccount=ccount+1;
   end
   cp=ccount/tn;
  
end
ccount
fprintf('�˴�ʶ�����ȷ��Ϊ%d',cp*100);
clear i d n x x1 x2 m j pout fname k sample;