% names = { 'C1'    'C2'    'C3'    'C4'    'C6'    'C7'    'C8'    'C9'    'C10'    'C11'};% 4 5 6 7 8
% names = { 'C4'    'C6'    'C7'    'C8'    'C9'                                          };% 4 5 6 7 8

% names={ 'T5'    'T6'    'T7'    'T8'    'T9'    'T10'    'T1'    'T2'    'T3'    'T4'};% 1 5 7 8 9 10
 names={ 'T5'        'T9'       'T1'    'T2'    'T3'    'T4'};% 1 5 7 8 9 10

%names={ 'T1' 'T2' 'T3' 'T4' 'T5' 'T6' 'T7' 'T8' 'T9' 'T10' };

postsec=25;
fs=250;
no_samples=fs*postsec;

for j=1%1:numel(names)
    j
    %%clear stuff
    clear hhb_slicedA hhb_slicedB hhb_slicedC hhb_slicedD
    clear o2hb_slicedA o2hb_slicedB o2hb_slicedC o2hb_slicedD
    %%
    
    %%read values
    eval(['OD=TG.' names{j} '.OD;']);
    eval(['xmlInfo=TG.' names{j} '.xmlInfo;']);
    eval(['q=TNIRS.' names{j} '.default;']);
    eval(['ADvalues=TG.' names{j} '.ADvalues;']);
    %%
    
    %%beer-lambert conversion
    [t,O2HbA,HHbA]=single_ch(OD,xmlInfo,1,1,[1,2]);
    [t,O2HbB,HHbB]=single_ch(OD,xmlInfo,2,1,[3,4]);
    [t,O2HbC,HHbC]=single_ch(OD,xmlInfo,3,2,[5,6]);
    [t,O2HbD,HHbD]=single_ch(OD,xmlInfo,4,2,[7,8]);
    %%
    
    %%synchronise eeg-nirs
    tmp=find(ADvalues(1,:)<-0.2);
    tmp2=diff(tmp);
    tmp3=tmp2<50;
    tmp4=[1 ~tmp3];
    nirs_events=tmp(logical(tmp4));      
    eeg_events=round(q.data.cfg.trl(1:13:end,1)/2048*250);
    %%
    
    %%create channels for nirs into louk structure
    q.data.label{10}='nirs_hhba';
    q.data.label{11}='nirs_o2hba';
    q.data.label{12}='nirs_hhbb';
    q.data.label{13}='nirs_o2hbb';
    %%
                
    %%preprocessing
    preprotime=15000;
    if (nirs_events(1)<15000)
        preprotime=nirs_events(1)-1;
    end
    vhba=var(HHbA(nirs_events(1)-preprotime:nirs_events(1)-1));
    vhbb=var(HHbB(nirs_events(1)-preprotime:nirs_events(1)-1));
    vo2hba=var(O2HbA(nirs_events(1)-preprotime:nirs_events(1)-1));
    vo2hbb=var(O2HbB(nirs_events(1)-preprotime:nirs_events(1)-1));
    vhbc=var(HHbC(nirs_events(1)-preprotime:nirs_events(1)-1));
    vhbd=var(HHbD(nirs_events(1)-preprotime:nirs_events(1)-1));
    vo2hbc=var(O2HbC(nirs_events(1)-preprotime:nirs_events(1)-1));
    vo2hbd=var(O2HbD(nirs_events(1)-preprotime:nirs_events(1)-1));    
    HHbA=vhbb/vhba*HHbA-HHbB;
    HHbC=vhbd/vhbc*HHbC-HHbD;
    O2HbA=vo2hbb/vo2hba*O2HbA-O2HbB;
    O2HbC=vo2hbd/vo2hbc*O2HbC-O2HbD;    
    %%
    
    
    for i=1:size(q.data.cfg.trl,1)
        %if (i==78); keyboard;end;
        %beg_sample = nirs_events{ floor((i-1)/13)+1} ...
        %   + round(q.data.cfg.trl(i,1)/2048*250) - eeg_events(floor((i-1)/13)+1);
        beg_sample=nirs_events(i);
        
        %     hhba=HHbA(beg_sample:beg_sample+no_samples-1);hhbb=HHbB(beg_sample:beg_sample+no_samples-1);
        %     o2hba=O2HbA(beg_sample:beg_sample+no_samples-1);o2hbb=O2HbB(beg_sample:beg_sample+no_samples-1);
        %
        %     hhbc=HHbC(beg_sample:beg_sample+no_samples-1);hhbd=HHbD(beg_sample:beg_sample+no_samples-1);
        %     o2hbc=O2HbC(beg_sample:beg_sample+no_samples-1);o2hbd=O2HbD(beg_sample:beg_sample+no_samples-1);
        % %
        %     hhb_slicedA(:,:,i)=hhba-(hhba*hhbb')/(hhbb*hhbb')*hhbb;
        %     o2hb_slicedA(:,:,i)=o2hba-(o2hba*o2hbb')/(o2hbb*o2hbb')*o2hbb;
        %
        %     hhb_slicedB(:,:,i)=hhbc-(hhbc*hhbd')/(hhbd*hhbd')*hhbd;
        %     o2hb_slicedB(:,:,i)=o2hbc-(o2hbc*o2hbd')/(o2hbd*o2hbd')*o2hbd;
        
        %     hhb_slicedA(:,:,i)=HHbA(beg_sample:beg_sample+no_samples-1);
        %     o2hb_slicedA(:,:,i)=O2HbA(beg_sample:beg_sample+no_samples-1);
        %     hhb_slicedB(:,:,i)=HHbB(beg_sample:beg_sample+no_samples-1);
        %     o2hb_slicedB(:,:,i)=O2HbB(beg_sample:beg_sample+no_samples-1);
        %     hhb_slicedC(:,:,i)=HHbC(beg_sample:beg_sample+no_samples-1);
        %     o2hb_slicedC(:,:,i)=O2HbC(beg_sample:beg_sample+no_samples-1);
        %     hhb_slicedD(:,:,i)=HHbD(beg_sample:beg_sample+no_samples-1);
        %     o2hb_slicedD(:,:,i)=O2HbD(beg_sample:beg_sample+no_samples-1);
        
        hhb_slicedA(:,:,i)=HHbA(beg_sample:beg_sample+no_samples-1);
        o2hb_slicedA(:,:,i)=O2HbA(beg_sample:beg_sample+no_samples-1);
        hhb_slicedB(:,:,i)=HHbB(beg_sample:beg_sample+no_samples-1);
        o2hb_slicedB(:,:,i)=O2HbB(beg_sample:beg_sample+no_samples-1);
        hhb_slicedC(:,:,i)=HHbC(beg_sample:beg_sample+no_samples-1);
        o2hb_slicedC(:,:,i)=O2HbC(beg_sample:beg_sample+no_samples-1);
        hhb_slicedD(:,:,i)=HHbD(beg_sample:beg_sample+no_samples-1);
        o2hb_slicedD(:,:,i)=O2HbD(beg_sample:beg_sample+no_samples-1);
        
        %     hhb_slicedA(:,:,i)=HHb1(beg_sample:beg_sample+no_samples-1)-mean(HHb1(beg_sample-500:beg_sample-1));
        %     o2hb_slicedA(:,:,i)=O2Hb1(beg_sample:beg_sample+no_samples-1)-mean(O2Hb1(beg_sample-500:beg_sample-1));
        %     hhb_slicedB(:,:,i)=HHb2(beg_sample:beg_sample+no_samples-1)-mean(HHb2(beg_sample-500:beg_sample-1));
        %     o2hb_slicedB(:,:,i)=O2Hb2(beg_sample:beg_sample+no_samples-1)-mean(O2Hb2(beg_sample-500:beg_sample-1));
        %
    end
    
    for i=1:size(q.data.cfg.trl,1)
        
        q.data.trial{i}(10,:)=hhb_slicedA(:,:,i);
        q.data.trial{i}(11,:)=o2hb_slicedA(:,:,i);
        q.data.trial{i}(12,:)=hhb_slicedC(:,:,i);
        q.data.trial{i}(13,:)=o2hb_slicedC(:,:,i);
        
        %     q.data.trial{i}(10,:)=hhb_slicedB(:,:,i)-hhb_slicedA(:,:,i);
        %     q.data.trial{i}(11,:)=o2hb_slicedB(:,:,i)-o2hb_slicedA(:,:,i);
        %     q.data.trial{i}(12,:)=hhb_slicedD(:,:,i)-hhb_slicedC(:,:,i);
        %     q.data.trial{i}(13,:)=o2hb_slicedD(:,:,i)-o2hb_slicedC(:,:,i);
        %
        %     q.data.trial{i}(14,:)=hhb_slicedC(:,:,i);
        %     q.data.trial{i}(15,:)=o2hb_slicedC(:,:,i);
        %     q.data.trial{i}(16,:)=hhb_slicedD(:,:,i);
        %     q.data.trial{i}(17,:)=o2hb_slicedD(:,:,i);
        
    end
    q.filter_channel(10:13,[0 .5]);
end