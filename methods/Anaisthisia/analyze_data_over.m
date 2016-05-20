global bciroot;
bciroot = { '/Volumes/BCI_Data/' '/media/LoukStorage/' };

expt='combined_eeg_nirs_2011';
subjects={ 'C4' 'C6' 'C7' 'C8' 'C9' 'C10' 'C11' };%'T2' 'T3' 'T4' 'T5' 'T6' 'T9' 'T10' };
clear folds
clear decisionvalues

for si=1:numel(subjects);
    
    subj=subjects{si};
    
    z=jf_load(expt,subj,'control');
    z=jf_reref(z,'dim','time');
    
    z=jf_reref(z,'dim','ch','wght','robust');
    z=jf_detrend(z,'dim','time');
    
    for seg=1:50
        oz=z;
        z=jf_retain(z,'dim','time','range','between','vals',[(seg-11)*500 (seg-11)*500+1000],'valmatch','nearest','summary','1s win');
        
        z=jf_addClassInfo(z,'markerdict',struct('marker',[1 2 3],'label',{{'rest' 'AM' 'IM'}}));
        z=jf_addClassInfo(z,'spType',{{{'rest'} {'AM'}}...
            {{'rest'} {'IM'}}},'summary','rest vs move');
        
        z.foldIdxs=gennFold(z.Y,10);
        
        z=jf_welchpsd(z,'width_ms',250,'log',1,'detrend',1);
        
        z=jf_retain(z,'dim','freq','range','between','vals',[8 24], 'valmatch','nearest');
        
       % jf_disp(z)
        
        z=jf_cvtrain(jf_compKernel(z),'mcPerf',0);
        temp=squeeze(z.prep(end).info.res.tstbin(1,:,:));
        perf{si}(seg,:)=max(temp');
        z=oz;
    end
    
    
end
