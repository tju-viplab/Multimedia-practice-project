function hmm=train()
clear;
clc;
vn=3;%ʶ��ʸ���
sn=3;%ÿ��ʶ��ʵ�ѵ����������
for i=1:vn
    for j=1:sn
        fname = sprintf('.\\train\\%d\\%d.wav', i,j);
        temp=audioread(fname);
        temp=0.2*temp/max(temp);%����ͳһ��
        samples{i}{j}=temp;
    end
end

for i=1:length(samples)
	sample=[];
	for k=1:length(samples{i})
		sample(k).wave=samples{i}{k};
		sample(k).data=[];
    end
    str = sprintf('����ѵ����%d��HMMģ��', i);
    disp(str);
	hmm{i}=trainhmm(sample,[3 3 3 3]);
    disp(['��' int2str(i) '��HMMģ��ѵ����ϣ�']);
end
save myhmm_enhanced hmm;
clear str i k j sample;