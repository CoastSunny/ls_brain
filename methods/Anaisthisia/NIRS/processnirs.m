function out=processnirs(subject,eeg_dataset)

OD=subject.OD;
xmlInfo=subject.xmlInfo;
ADvalues=subject.ADvalues;
postsec=25;
fs=250;
no_samples=fs*postsec;
q=eeg_dataset;

[t,O2HbA,HHbA]=single_ch(OD,xmlInfo,1,1,[1,2]);
[t,O2HbB,HHbB]=single_ch(OD,xmlInfo,2,1,[3,4]);
[t,O2HbC,HHbC]=single_ch(OD,xmlInfo,3,2,[5,6]);
[t,O2HbD,HHbD]=single_ch(OD,xmlInfo,4,2,[7,8]);

tmp=find(ADvalues(1,:)<-0.5);
tmp2=diff(tmp);
tmp3=tmp2<50;
tmp4=[1 ~tmp3];
nirs_events=tmp(logical(tmp4));

q.data.label{10}='nirs_hhba';
q.data.label{11}='nirs_o2hba';
q.data.label{12}='nirs_hhbb';
q.data.label{13}='nirs_o2hbb';

for i=1:size(q.data.cfg.trl,1)
    
    beg_sample=nirs_events(i);
        
    hhb_slicedA(:,:,i)=HHbA(beg_sample:beg_sample+no_samples-1);
    o2hb_slicedA(:,:,i)=O2HbA(beg_sample:beg_sample+no_samples-1);
    hhb_slicedB(:,:,i)=HHbB(beg_sample:beg_sample+no_samples-1);
    o2hb_slicedB(:,:,i)=O2HbB(beg_sample:beg_sample+no_samples-1);
    hhb_slicedC(:,:,i)=HHbC(beg_sample:beg_sample+no_samples-1);
    o2hb_slicedC(:,:,i)=O2HbC(beg_sample:beg_sample+no_samples-1);
    hhb_slicedD(:,:,i)=HHbD(beg_sample:beg_sample+no_samples-1);
    o2hb_slicedD(:,:,i)=O2HbD(beg_sample:beg_sample+no_samples-1);
    
end

for i=1:size(q.data.cfg.trl,1)
    
    q.data.trial{i}(10,:)=detrend(hhb_slicedA(:,:,i),2);
    q.data.trial{i}(11,:)=detrend(o2hb_slicedA(:,:,i),2);
    q.data.trial{i}(12,:)=detrend(hhb_slicedC(:,:,i),2);
    q.data.trial{i}(13,:)=detrend(o2hb_slicedC(:,:,i),2);    
    
end
q.default.filter_channel(10:13,[0 .2]);

end