
% first multi channel and then single channel
% fpr tpr by thresholding, spatial info etc
% 
% subj={'C_C' 'A_S' 'B_G' 'E_N' 'C_R' 'D_L'};

R=[];fSS=[];tfSS=[];fSSauc=[];

for ci=Itest
    % ci
    
    eval(['sEEG=' subj{ci} '_sEEG;']);
    eval(['rsEEG=' subj{ci} '_rsEEG;']);

    eval(['fsEEG=' subj{ci} '_fsEEG;']);
    eval(['frsEEG=' subj{ci} '_frsEEG;']);
    
    eval(['iEEG=' subj{ci} '_iEEG;']);
    eval(['riEEG=' subj{ci} '_riEEG;']);

    eval(['fiEEG=' subj{ci} '_fiEEG;']);
    eval(['friEEG=' subj{ci} '_friEEG;']);
    
    eval(['tr_examples=' subj{ci} '_tr_examples;']);
    eval(['rtr_examples=' subj{ci} '_rtr_examples;']);
    
  
    eval(['spikes=' subj{ci} 'spikes;']) 
    
    epilepsy_classifier_tcv
    R(ci,:)=[fsperf.trnbin ftsperf.trnbin];% fiperf.trnbin ftiperf.trnbin];% ...

    eval([ subj{ci} 'fsclsfr' '=fsclsfr;'])  
%     eval([ subj{ci} 'ficlsfr' '=ficlsfr;'])  

    eval([ subj{ci} 'ftsclsfr' '=ftsclsfr;'])
%     eval([ subj{ci} 'fticlsfr' '=fticlsfr;'])
    eval([ subj{ci} 'ftsclsfrsf' '=ftsclsfrsf;'])
     eval([ subj{ci} 'ftsclsfrst' '=ftsclsfrst;'])
     eval([ subj{ci} 'ftsclsfrss' '=ftsclsfrss;'])

    eval([ subj{ci} '_result' '=result;'])
    eval([ subj{ci} 'labels=labels;'])
    
    

    
end