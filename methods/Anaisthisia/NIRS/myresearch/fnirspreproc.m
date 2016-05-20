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
    [t,O2HbB,HHbB]=single_ch(OD,xmlInfo,2,1,[3,4]);
    [t,O2HbC,HHbC]=single_ch(OD,xmlInfo,3,2,[5,6]);
    [t,O2HbD,HHbD]=single_ch(OD,xmlInfo,4,2,[7,8]);
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
       
    
    HHbA=subsample(HHbA,numel(HHbA)/25);
   % HHbB=subsample(HHbB,numel(HHbB)/25);
    HHbC=subsample(HHbC,numel(HHbC)/25);
    %HHbD=subsample(HHbD,numel(HHbD)/25);
    O2HbA=subsample(O2HbA,numel(O2HbA)/25);
    %O2HbB=subsample(O2HbB,numel(O2HbB)/25);
    O2HbC=subsample(O2HbC,numel(O2HbC)/25);
    %O2HbD=subsample(O2HbD,numel(O2HbD)/25);
    
%     freqband=[0.0 0.055 ];
%     fs=10;
%     len=size(HHbA,2);
%     filt=mkFilter(freqband,floor(len/2),fs/len);
%     tmp=...
%       fftfilter([HHbA;HHbB;HHbC;HHbD;O2HbA;O2HbB;O2HbC;O2HbD],filt,[0 len],2,1);
%     HHbA=tmp(1,:);HHbB=tmp(2,:);HHbC=tmp(3,:);HHbD=tmp(4,:);
%     O2HbA=tmp(5,:);O2HbB=tmp(6,:);O2HbC=tmp(7,:);O2HbD=tmp(8,:);
    %% synchronise eeg-nirs
    nirs_sample = round(sync_manual(j,1)/25);
    nirs_number = sync_manual(j,2);
    eeg_trials_0shifted = (round(q.data.cfg.previous.trl(:,1)/2048*fs)-round(q.data.cfg.previous.trl(1,1)/2048*fs))'+1;
    nirs_trials_workable = eeg_trials_0shifted + nirs_sample - eeg_trials_0shifted(nirs_number)-1;% + pre_samples;
    %%
    
    %% create channels for nirs into louk structure
    q.data.label{10}='nirs_hhba';
    q.data.label{11}='nirs_o2hba';
    q.data.label{12}='nirs_hhbb';
    q.data.label{13}='nirs_o2hbb';
    %%

    nirs_trials_workable(1)
    groups=6;
    trials=13;
    Lo=L;
    Lh=L;
    oO2HbA=O2HbA;oO2HbC=O2HbC;oHHbA=HHbA;oHHbC=HHbC;%oO2HbB=O2HbB;oO2HbD=O2HbD;oHHbB=HHbB;oHHbD=HHbD;
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
        end

    end 
   FO1{end+1}=FOA; 
   FO2{end+1}=FOC; 
   FH1{end+1}=FHA; 
   FH2{end+1}=FHC; 
   CO1{end+1}=COA;PO1{end+1}=POA;RO1{end+1}=ROA;   
   CO2{end+1}=COB;PO2{end+1}=POB;RO2{end+1}=ROB;   
   CH1{end+1}=CHA;PH1{end+1}=PHA;RH1{end+1}=RHA;  
   CH2{end+1}=CHB;PH2{end+1}=PHB;RH2{end+1}=RHB;
   
    for i=1:78
        
        beg_sample=nirs_trials_workable(i);          
        hhb_slicedA(:,:,i)=HHbA(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbA(beg_sample-baseline_samples:beg_sample-1));
        o2hb_slicedA(:,:,i)=O2HbA(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbA(beg_sample-baseline_samples:beg_sample-1));
      %  hhb_slicedB(:,:,i)=HHbB(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbB(beg_sample-baseline_samples:beg_sample-1));
      %  o2hb_slicedB(:,:,i)=O2HbB(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbB(beg_sample-baseline_samples:beg_sample-1));
        hhb_slicedC(:,:,i)=HHbC(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbC(beg_sample-baseline_samples:beg_sample-1));
        o2hb_slicedC(:,:,i)=O2HbC(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbC(beg_sample-baseline_samples:beg_sample-1));
       % hhb_slicedD(:,:,i)=HHbD(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(HHbD(beg_sample-baseline_samples:beg_sample-1));
       % o2hb_slicedD(:,:,i)=O2HbD(beg_sample-pre_samples:beg_sample+post_samples-1)-mean(O2HbD(beg_sample-baseline_samples:beg_sample-1));
        
    end
    
    for i=1:78
        
        q.data.trial{i}(10,:)=hhb_slicedA(:,:,i);
        q.data.trial{i}(11,:)=o2hb_slicedA(:,:,i);
        q.data.trial{i}(12,:)=hhb_slicedC(:,:,i);
        q.data.trial{i}(13,:)=o2hb_slicedC(:,:,i);
        
    end
    
 
    
end