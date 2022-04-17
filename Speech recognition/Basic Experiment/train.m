function hmm=train()
clear;
clc;
vn=3;%识别词个数
sn=3;%每个识别词的训练样本个数
for i=1:vn
    for j=1:sn
        fname = sprintf('.\\train\\%d\\%d.wav', i,j);
        temp=audioread(fname);
        temp=0.2*temp/max(temp);%幅度统一化
        samples{i}{j}=temp;
    end
end

for i=1:length(samples)
	sample=[];
	for k=1:length(samples{i})
		sample(k).wave=samples{i}{k};
		sample(k).data=[];
    end
    str = sprintf('现在训练第%d个HMM模型', i);
    disp(str);
	hmm{i}=trainhmm(sample,[3 3 3 3]);
    disp(['第' int2str(i) '个HMM模型训练完毕！']);
end
save myhmm_enhanced hmm;
clear str i k j sample;