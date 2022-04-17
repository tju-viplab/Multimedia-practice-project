%������Ӧ�öര�׷����Ƶ������źŹ������ܶȣ�PSD���������׼�������ǿ

clc;
clear;
a=2;      %��������
b=0.01;     %���油������
c=0;        %c=0ʱ���������������п�����c=1ʱ�����п�������

%��ȡ�����ļ�---------------------------------------------------------------
[filename,pathname]=uigetfile('SNR_0-����.wav','��ѡ�������ļ���');
[wavin_t,fs]=audioread([pathname filename]);
wav_length=length(wavin_t);

%�����������Ϊ20ms��Ϊʹifft��ԭ������ʧ�澡��С��֡������ҪΪ�������ڵ�2��
%����fsѡ��֡���� 
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
%inframe=(ENFRAME(wavin,frame_len,step_len))';   %��֡
%frame_num=size(inframe,2);          %��֡��
window=hamming(frame_len);          %���庺����

%�ֱ��ÿ֡fft�����ֵ�������-----------------------------------------------
for i=1:frame_num;
    fft_frame(:,i)=fft(window.*inframe(:,i));
    abs_frame(:,i)=abs(fft_frame(:,i));
    ang_frame(:,i)=angle(fft_frame(:,i));
end;

%ÿ������֡ƽ��-------------------------------------------------------------
abs_frame_f=abs_frame;
for i=2:frame_num-1;
    abs_frame_f(:,i)=mean(abs_frame(:,(i-1):(i+1)),2);
end;
abs_frame=abs_frame_f;

%���������-----------------------------------------------------------------
%������ÿһԪ��Ϊ��
%g(k)=(Py(k)-a*Pn(k))/Py(k)
%Py��Pn�ֱ�Ϊ���������������Ĺ����׹��ƣ�����MATLAB���Դ���pmtm����������
%�ɸ�����Ҫ����a�Ĵ�С�����õ����õ�Ч��

%�öര�׷�����ÿһ֡���ݽ��й����׹���
for i=1:frame_num;
    per_PSD(:,i)=pmtm(inframe(:,i),3,frame_len,'twosided');
end;

%�Թ����׵�ÿ������֡����ƽ��
per_PSD_f=per_PSD;
for i=2:frame_num-1;
    per_PSD_f(:,i)=mean(per_PSD(:,(i-1):(i+1)),2);
end;
per_PSD=per_PSD_f;

%ȡǰ20֡��Ϊ����֡��ȡ��ƽ����Ϊ�����Ĺ����׹���
noise_PSD=mean(per_PSD(:,1:20),2);

%���������
for k=1:frame_num;
    g(:,k)=(per_PSD(:,k)-a*noise_PSD)./per_PSD(:,k);
end;

%�����油����ֵ������С�ڸ���ֵ������ϵ��������ֵ�����棬�����ɼ�����������
spec_floor=b*noise_PSD./per_PSD(:,k);
spec_floor=spec_floor(:,ones(1,frame_num));
[I,J]=find(g<spec_floor);
gf=g;
gf(sub2ind(size(gf),I,J))=spec_floor(sub2ind(size(gf),I,J));
if c==0;
    g=gf;
else g=gf.^0.5;
end;

%�׼�----------------------------------------------------------------------
sub_frame=g.*abs_frame;

% % ������֡˥��------------------------------------------------------------
% T=20*log10(mean(sub_frame./(abs_noise*ones(1,frame_num))));
% T_noise=mean(T(:,1:20),2);
% c=10^(-2/3);            %˥��ϵ��Ϊ 10^(-1.5)
% noise_frame=find(T<T_noise);
% sub_frame(:,noise_frame)=c*sub_frame(:,noise_frame);

%�������źŻ�ԭ��ʱ��-------------------------------------------------------
wavout=zeros(1,(frame_num-1)*step_len+frame_len);
j=sqrt(-1);
i=1;
for t=1:step_len:((frame_num-1)*step_len+1);
    wavout(:,t:(t+frame_len-1))=wavout(:,t:(t+frame_len-1))+real(ifft(sub_frame(:,i).*exp(j*ang_frame(:,i))))';
    i=i+1;
end;

%�����������Ϊ'wav'�ļ�--------------------------------------------------
if c==0;
    audiowrite([num2str(frame_len) 'fnm_' num2str(a) '_' num2str(b) '_' filename],wavout,fs);
else
    audiowrite(['m_' num2str(a) '_' num2str(b) '_' filename],wavout,fs);
end;

%������ǰ��Ľ��������ͼ�Ƚ�
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