% names = { 'C1'    'C2'    'C3'    'C4'    'C6'    'C7'    'C8'    'C9'    'C10'    'C11'};% 4 5 6 7 8
% names = { 'C4'    'C6'    'C7'    'C8'    'C9'                                          };% 4 5 6 7 8

% names={ 'T5'    'T6'    'T7'    'T8'    'T9'    'T10'    'T1'    'T2'    'T3'    'T4'};% 1 5 7 8 9 10
% names={ 'T5'        'T9'       'T1'    'T2'    'T3'    'T4'};% 1 5 7 8 9 10

%names={ 'T2' 'T3' 'T4' 'T5' 'T6' 'T9' 'T10' };%bad timing for T7 T8 and no hbbb for T1

baselinesec=5;
presec=5;
postsec=25;
fs=10;
baseline_samples=fs*baselinesec;
post_samples=fs*postsec;
pre_samples=fs*presec;

NIRS=G.copy;


for j=no_subj
    j
    count=count+1
    iLfinder
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
    cfg.resamplefs=fs;
    cfg.detrend='no';
    if (q.data.fsample~=fs)
        NIRS.(names{j}).default.data=ft_resampledata(cfg,NIRS.(names{j}).default.data);
    end
    %%beer-lambert conversion
    if iLfinder==1
    [t,O2HbA,HHbA]=single_ch(OD,xmlInfo,1,1,[1,2]);
  %  [t,O2HbB,HHbB]=single_ch(OD,xmlInfo,2,1,[3,4]);
    [t,O2HbC,HHbC]=single_ch(OD,xmlInfo,3,2,[5,6]);
  %  [t,O2HbD,HHbD]=single_ch(OD,xmlInfo,4,2,[7,8]);
    fO2HbA{count}=O2HbA;
    fHHbA{count}=HHbA;
    fO2HbC{count}=O2HbC;
    fHHbC{count}=HHbC;
    else
    O2HbA=fO2HbA{count};
    HHbA=fHHbA{count};
    O2HbC=fO2HbC{count};
    HHbC=fHHbC{count};
    end
       
    %%
%         HHbA=decimate(decimate(HHbA,5),5);
%         HHbB=decimate(decimate(HHbB,5),5);
%         HHbC=decimate(decimate(HHbC,5),5);
%         HHbD=decimate(decimate(HHbD,5),5);
%         O2HbA=decimate(decimate(O2HbA,5),5);
%         O2HbB=decimate(decimate(O2HbB,5),5);
%         O2HbC=decimate(decimate(O2HbC,5),5);
%         O2HbD=decimate(decimate(O2HbD,5),5);
    
    HHbA=subsample(HHbA,numel(HHbA)/25);
%    HHbB=subsample(HHbB,numel(HHbB)/25);
    HHbC=subsample(HHbC,numel(HHbC)/25);
%    HHbD=subsample(HHbD,numel(HHbD)/25);
    O2HbA=subsample(O2HbA,numel(O2HbA)/25);
%    O2HbB=subsample(O2HbB,numel(O2HbB)/25);
    O2HbC=subsample(O2HbC,numel(O2HbC)/25);
%    O2HbD=subsample(O2HbD,numel(O2HbD)/25);
    
    %%synchronise eeg-nirs
    nirs_sample = round(sync_manual(j,1)/25);
    nirs_number = sync_manual(j,2);
    eeg_trials_0shifted = (round(q.data.cfg.previous.trl(:,1)/2048*fs)-round(q.data.cfg.previous.trl(1,1)/2048*fs))'+1;
    nirs_trials_workable = eeg_trials_0shifted + nirs_sample - eeg_trials_0shifted(nirs_number)-1;% + pre_samples;
    %%
    
    %%create channels for nirs into louk structure
    q.data.label{10}='nirs_hhba';
    q.data.label{11}='nirs_o2hba';
    q.data.label{12}='nirs_hhbb';
    q.data.label{13}='nirs_o2hbb';
    %%
%         HHbA=filtfilt(SOSbp,Gbp,HHbA);
%         HHbB=filtfilt(SOSbp,Gbp,HHbB);
%         HHbC=filtfilt(SOSbp,Gbp,HHbC);
%         HHbD=filtfilt(SOSbp,Gbp,HHbD);
%         O2HbA=filtfilt(SOSbp,Gbp,O2HbA);
%         O2HbB=filtfilt(SOSbp,Gbp,O2HbB);
%         O2HbC=filtfilt(SOSbp,Gbp,O2HbC);
%         O2HbD=filtfilt(SOSbp,Gbp,O2HbD);
% %         
%         HHbA=filtfilt(SOSlpA,GlpA,HHbA);
%         HHbB=filtfilt(SOSlpA,GlpA,HHbB);
%         HHbC=filtfilt(SOSlpA,GlpA,HHbC);
%         HHbD=filtfilt(SOSlpA,GlpA,HHbD);
%         O2HbA=filtfilt(SOSlpA,GlpA,O2HbA);
%         O2HbB=filtfilt(SOSlpA,GlpA,O2HbB);
%         O2HbC=filtfilt(SOSlpA,GlpA,O2HbC);
%         O2HbD=filtfilt(SOSlpA,GlpA,O2HbD);
%  %  filtfilt concetration changes before rereferencing
%         freqband=[0.00 0.2];
%         fs=10;
%         len=size(HHbA,2);
%         filt=mkFilter(freqband,floor(len/2),fs/len);
%         HHbA=fftfilter(HHbA,filt,[0 len],2,1);
%         HHbB=fftfilter(HHbB,filt,[0 len],2,1);
%         HHbC=fftfilter(HHbC,filt,[0 len],2,1);
%         HHbD=fftfilter(HHbD,filt,[0 len],2,1);
%         O2HbA=fftfilter(O2HbA,filt,[0 len],2,1);
%         O2HbB=fftfilter(O2HbB,filt,[0 len],2,1);
%         O2HbC=fftfilter(O2HbC,filt,[0 len],2,1);
%         O2HbD=fftfilter(O2HbD,filt,[0 len],2,1);
    
    %% Rereferencing
    
    %% koen
    %preprotime=600;
    
%    nirs_trials_workable(1)
%    
%     L=100;
%     oO2HbA=O2HbA;oO2HbC=O2HbC;oHHbA=HHbA;oHHbC=HHbC;oO2HbB=O2HbB;oO2HbD=O2HbD;oHHbB=HHbB;oHHbD=HHbD;
%     for sample=max(2000,nirs_trials_workable(1)):50:numel(O2HbA)        
%     
%         O2HbA(sample-2000+1:sample)=ssa(oO2HbA(sample-2000+1:sample)',L);
%         O2HbC(sample-2000+1:sample)=ssa(oO2HbC(sample-2000+1:sample)',L);
%         HHbA(sample-2000+1:sample)=ssa(oHHbA(sample-2000+1:sample)',L);
%         HHbC(sample-2000+1:sample)=ssa(oHHbC(sample-2000+1:sample)',L);                     
%       
%     end 

    nirs_trials_workable(1)
    groups=6;
    trials=13;
    Lo=L;
    Lh=L;
    oO2HbA=O2HbA;oO2HbC=O2HbC;oHHbA=HHbA;oHHbC=HHbC;oO2HbB=O2HbB;oO2HbD=O2HbD;oHHbB=HHbB;oHHbD=HHbD;
    for i_ssa=1:groups%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	
        index_start=(i_ssa-1)*trials+1;
        index_end=(i_ssa-1)*trials+trials;
%          index_start=i_ssa;
%          index_end=i_ssa;
        offset_start=0;1700;%1000;
        offset_end=-300;
       
        if (nirs_trials_workable(index_start)>1)
             selection=nirs_trials_workable(index_start)-offset_start:nirs_trials_workable(index_end)-offset_end;
                [O2HbA(selection) FOA{i_ssa} COA{i_ssa} POA{i_ssa} ROA{i_ssa}]=ssa(oO2HbA(selection)',Lo);
                [O2HbC(selection) FOC{i_ssa} COB{i_ssa} POB{i_ssa} ROB{i_ssa}]=ssa(oO2HbC(selection)',Lo);
                [HHbA(selection) FHA{i_ssa} CHA{i_ssa} PHA{i_ssa} RHA{i_ssa}]=ssa(oHHbA(selection)',Lh);
                [HHbC(selection) FHC{i_ssa} CHB{i_ssa} PHB{i_ssa} RHB{i_ssa}]=ssa(oHHbC(selection)',Lh);        

%                 O2HbB(selection)=ssa(oO2HbB(selection)',L);
%                 O2HbD(selection)=ssa(oO2HbD(selection)',L);
%                 HHbB(selection)=ssa(oHHbB(selection)',L);
%                 HHbD(selection)=ssa(oHHbD(selection)',L);               
        end
%         beg_sample=nirs_trials_workable(i_ssa);        
%         hhb_slicedA(:,:,i_ssa)=HHbA(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbA(beg_sample-baseline_samples:beg_sample-1));
%         o2hb_slicedA(:,:,i_ssa)=O2HbA(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbA(beg_sample-baseline_samples:beg_sample-1));
%         hhb_slicedB(:,:,i_ssa)=HHbB(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbB(beg_sample-baseline_samples:beg_sample-1));
%         o2hb_slicedB(:,:,i_ssa)=O2HbB(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbB(beg_sample-baseline_samples:beg_sample-1));
%         hhb_slicedC(:,:,i_ssa)=HHbC(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbC(beg_sample-baseline_samples:beg_sample-1));
%         o2hb_slicedC(:,:,i_ssa)=O2HbC(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbC(beg_sample-baseline_samples:beg_sample-1));
%         hhb_slicedD(:,:,i_ssa)=HHbD(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbD(beg_sample-baseline_samples:beg_sample-1));
%         o2hb_slicedD(:,:,i_ssa)=O2HbD(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbD(beg_sample-baseline_samples:beg_sample-1));
    end 
%  % saager
%         HHbA=HHbA-(HHbA*HHbB'/(HHbB*HHbB'))*HHbB;
%         HHbC=HHbC-(HHbC*HHbD'/(HHbD*HHbD'))*HHbD;
%         O2HbA=O2HbA-(O2HbA*O2HbB'/(O2HbB*O2HbB'))*O2HbB;
%         O2HbC=O2HbC-(O2HbC*O2HbD'/(O2HbD*O2HbD'))*O2HbD;
% % %     % SSA
    
    %     beg=nirs_trials_workable(1);
    %     L=200;
    %     for i=beg:1000:(size(HHbA,2)-1000)
    %         HHbA(i:i+1000-1)=ls_ssa(HHbA(i:i+1000-1),HHbB(i:i+1000-1),L);
    %         HHbC(i:i+1000-1)=ls_ssa(HHbC(i:i+1000-1),HHbD(i:i+1000-1),L);
    %         O2HbA(i:i+1000-1)=ls_ssa(O2HbA(i:i+1000-1),O2HbB(i:i+1000-1),L);
    %         O2HbC(i:i+1000-1)=ls_ssa(O2HbC(i:i+1000-1),O2HbD(i:i+1000-1),L);
    %     end
% %     
%         freqband2=[0 0.2];
%         fs=10;
%         len=size(HHbA,2);
%         filt=mkFilter(freqband2,floor(len/2),fs/len);
%         HHbA=fftfilter(HHbA,filt,[0 len],2,1);
%         HHbB=fftfilter(HHbB,filt,[0 len],2,1);
%         HHbC=fftfilter(HHbC,filt,[0 len],2,1);
%         HHbD=fftfilter(HHbD,filt,[0 len],2,1);
%         O2HbA=fftfilter(O2HbA,filt,[0 len],2,1);
%         O2HbB=fftfilter(O2HbB,filt,[0 len],2,1);
%         O2HbC=fftfilter(O2HbC,filt,[0 len],2,1);
%         O2HbD=fftfilter(O2HbD,filt,[0 len],2,1);
%         HHbA=filtfilt(f02,1,HHbA);
%         HHbB=filtfilt(f02,1,HHbB);
%         HHbC=filtfilt(f02,1,HHbC);
%         HHbD=filtfilt(f02,1,HHbD);
%         O2HbA=filtfilt(f02,1,O2HbA);
%         O2HbB=filtfilt(f02,1,O2HbB);
%         O2HbC=filtfilt(f02,1,O2HbC);
%         O2HbD=filtfilt(f02,1,O2HbD);
    for i=1:78
        
        beg_sample=nirs_trials_workable(i);
      %  beg_sample=randi(size(HHbA))-300;
    %    if (beg_sample<300); beg_sample=300;end;
        
        hhb_slicedA(:,:,i)=HHbA(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbA(beg_sample-baseline_samples:beg_sample-1));
        o2hb_slicedA(:,:,i)=O2HbA(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbA(beg_sample-baseline_samples:beg_sample-1));
%         hhb_slicedB(:,:,i)=HHbB(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbB(beg_sample-baseline_samples:beg_sample-1));
%         o2hb_slicedB(:,:,i)=O2HbB(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbB(beg_sample-baseline_samples:beg_sample-1));
        hhb_slicedC(:,:,i)=HHbC(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbC(beg_sample-baseline_samples:beg_sample-1));
        o2hb_slicedC(:,:,i)=O2HbC(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbC(beg_sample-baseline_samples:beg_sample-1));
%         hhb_slicedD(:,:,i)=HHbD(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbD(beg_sample-baseline_samples:beg_sample-1));
%         o2hb_slicedD(:,:,i)=O2HbD(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbD(beg_sample-baseline_samples:beg_sample-1));
        
    end
    
    for i=1:78
        
        q.data.trial{i}(10,:)=hhb_slicedA(:,:,i);
        q.data.trial{i}(11,:)=o2hb_slicedA(:,:,i);
        q.data.trial{i}(12,:)=hhb_slicedC(:,:,i);
        q.data.trial{i}(13,:)=o2hb_slicedC(:,:,i);
        
    end
    
   FO1{end+1}=FOA; 
   FO2{end+1}=FOC; 
   FH1{end+1}=FHA; 
   FH2{end+1}=FHC; 
   CO1{end+1}=COA;PO1{end+1}=POA;RO1{end+1}=ROA;   
   CO2{end+1}=COB;PO2{end+1}=POB;RO2{end+1}=ROB;   
   CH1{end+1}=CHA;PH1{end+1}=PHA;RH1{end+1}=RHA;  
   CH2{end+1}=CHB;PH2{end+1}=PHB;RH2{end+1}=RHB;
    
end