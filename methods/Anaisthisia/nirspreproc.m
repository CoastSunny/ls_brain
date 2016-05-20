% names = { 'C1'    'C2'    'C3'    'C4'    'C6'    'C7'    'C8'    'C9'    'C10'    'C11'};% 4 5 6 7 8
% names = { 'C4'    'C6'    'C7'    'C8'    'C9'                                          };% 4 5 6 7 8

% names={ 'T5'    'T6'    'T7'    'T8'    'T9'    'T10'    'T1'    'T2'    'T3'    'T4'};% 1 5 7 8 9 10
% names={ 'T5'        'T9'       'T1'    'T2'    'T3'    'T4'};% 1 5 7 8 9 10

%names={  'T2' 'T3' 'T4' 'T5' 'T6' 'T9' 'T10'  };%bad timing for T7 T8 and no hbbb for T1
names={ 'C4' 'C6' 'C7' 'C8' 'C9' 'C10' 'C11' };%no timing for C1 C2 C3,%missing files for C5 C12

baselinesec=5;
presec=5;
postsec=25;
fs=250;
baseline_samples=fs*baselinesec;
post_samples=fs*postsec;
pre_samples=fs*presec;
sync_manual=Csync_manual;
NIRS=CNIRS_full.copy;
aG=CG;

for j=1:7  
    
    j
    
    %%clear stuff
    clear hhb_slicedA hhb_slicedB hhb_slicedC hhb_slicedD
    clear o2hb_slicedA o2hb_slicedB o2hb_slicedC o2hb_slicedD
    %%
    
    %%read values
    eval(['OD=aG.' names{j} '.OD;']);
    eval(['xmlInfo=aG.' names{j} '.xmlInfo;']);
    eval(['q=NIRS.' names{j} '.default;']);
    eval(['ADvalues=aG.' names{j} '.ADvalues;']);
    %%
    
    %%beer-lambert conversion
    [t,O2HbA,HHbA]=single_ch(OD,xmlInfo,1,1,[1,2]);
    [t,O2HbB,HHbB]=single_ch(OD,xmlInfo,2,1,[3,4]);
    [t,O2HbC,HHbC]=single_ch(OD,xmlInfo,3,2,[5,6]);
    [t,O2HbD,HHbD]=single_ch(OD,xmlInfo,4,2,[7,8]);
    %%
    
    %%synchronise eeg-nirs
    nirs_sample = sync_manual(j,1);
    nirs_number = sync_manual(j,2);
    eeg_trials_shifted = (round(q.data.cfg.trl(:,1)/2048*250)-round(q.data.cfg.trl(1,1)/2048*250))'+1;
    nirs_trials_workable = eeg_trials_shifted + nirs_sample - eeg_trials_shifted(nirs_number) + pre_samples;
    %%
    
    %%create channels for nirs into louk structure
    q.data.label{10}='nirs_hhba';
    q.data.label{11}='nirs_o2hba';
    q.data.label{12}='nirs_hhbb';
    q.data.label{13}='nirs_o2hbb';
    %%
                
    %%filter concetration changes before rereferencing
    HHbA=filtfilt(lpf_nirs,1,HHbA);
    HHbB=filtfilt(lpf_nirs,1,HHbB);
    HHbC=filtfilt(lpf_nirs,1,HHbC);
    HHbD=filtfilt(lpf_nirs,1,HHbD);
    O2HbA=filtfilt(lpf_nirs,1,O2HbA);
    O2HbB=filtfilt(lpf_nirs,1,O2HbB);
    O2HbC=filtfilt(lpf_nirs,1,O2HbC);
    O2HbD=filtfilt(lpf_nirs,1,O2HbD);
    %%
    
    %%referencing
    preprotime=15000;
    if (nirs_trials_workable(1)<15000)
        preprotime=nirs_trials_workable(1)-1;
    end
    
    vhba=std(HHbA(nirs_trials_workable(1)-preprotime:nirs_trials_workable(1)-1));
    vhbb=std(HHbB(nirs_trials_workable(1)-preprotime:nirs_trials_workable(1)-1));
    vo2hba=std(O2HbA(nirs_trials_workable(1)-preprotime:nirs_trials_workable(1)-1));
    vo2hbb=std(O2HbB(nirs_trials_workable(1)-preprotime:nirs_trials_workable(1)-1));
    vhbc=std(HHbC(nirs_trials_workable(1)-preprotime:nirs_trials_workable(1)-1));
    vhbd=std(HHbD(nirs_trials_workable(1)-preprotime:nirs_trials_workable(1)-1));
    vo2hbc=std(O2HbC(nirs_trials_workable(1)-preprotime:nirs_trials_workable(1)-1));
    vo2hbd=std(O2HbD(nirs_trials_workable(1)-preprotime:nirs_trials_workable(1)-1));    
    HHbA=vhbb/vhba*HHbA-HHbB;
    HHbC=vhbd/vhbc*HHbC-HHbD;
    O2HbA=vo2hbb/vo2hba*O2HbA-O2HbB;
    O2HbC=vo2hbd/vo2hbc*O2HbC-O2HbD;            
    
    for i=1:size(q.data.cfg.trl,1)
      
        beg_sample=nirs_trials_workable(i);              
        
        hhb_slicedA(:,:,i)=HHbA(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbA(beg_sample-baseline_samples:beg_sample-1));
        o2hb_slicedA(:,:,i)=O2HbA(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbA(beg_sample-baseline_samples:beg_sample-1));
        hhb_slicedB(:,:,i)=HHbB(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbB(beg_sample-baseline_samples:beg_sample-1));
        o2hb_slicedB(:,:,i)=O2HbB(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbB(beg_sample-baseline_samples:beg_sample-1));
        hhb_slicedC(:,:,i)=HHbC(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbC(beg_sample-baseline_samples:beg_sample-1));
        o2hb_slicedC(:,:,i)=O2HbC(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbC(beg_sample-baseline_samples:beg_sample-1));
        hhb_slicedD(:,:,i)=HHbD(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbD(beg_sample-baseline_samples:beg_sample-1));
        o2hb_slicedD(:,:,i)=O2HbD(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbD(beg_sample-baseline_samples:beg_sample-1));
               
    end
    
    for i=1:size(q.data.cfg.trl,1)
        
        q.data.trial{i}(10,:)=hhb_slicedA(:,:,i);
        q.data.trial{i}(11,:)=o2hb_slicedA(:,:,i);
        q.data.trial{i}(12,:)=hhb_slicedC(:,:,i);
        q.data.trial{i}(13,:)=o2hb_slicedC(:,:,i);               
        
    end
    
    q.filter_channel(10:13,[0 .2]);
    
end