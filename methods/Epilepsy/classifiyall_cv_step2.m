addpath ~/Dropbox/ls_bci/methods/Epilepsy/
%% first multi channel and then single channel
%% fpr tpr by thresholding, spatial info etc
%% 
% subj={'C_C' 'A_S' 'B_G' 'E_N' 'C_R' 'D_L'};

R=[];fSS=[];tfSS=[];fSSauc=[];

for ci=14:numel(subj)
    % ci
    
    eval(['sEEG=' subj{ci} '_sEEG;']);            
    eval(['fsEEG=' subj{ci} '_fsEEG;']);            
    eval(['tr_examples=' subj{ci} '_tr_examples;']);
    eval(['rtr_examples=' subj{ci} '_rtr_examples;']);
    if ci==14
      fsEEG=fsEEG(:,:,:,1:1000);
      sEEG=sEEG(:,:,1:1000);
      tr_examples=tr_examples(1:1000);
      rtr_examples=rtr_examples(1:1000);
    end
    rsEEG=detrend(ls_whiten(RX{si}(:,:,1:size(sEEG,3)),5,0),2);
    frsEEG=spectrogram(rsEEG,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
  
    epilepsy_classifier_cv
    R(ci,:)=[fsperf.trnbin];
    
    eval([ subj{ci} 'fsclsfr' '=fsclsfr;'])
    eval([ subj{ci} 'labels=labels;'])
    
    
end