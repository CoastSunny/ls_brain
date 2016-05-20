
% first multi channel and then single channel
% fpr tpr by thresholding, spatial info etc
% 
% subj={'C_C' 'A_S' 'B_G' 'E_N' 'C_R' 'D_L'};

R=[];fSS=[];tfSS=[];fSSauc=[];

for ci=1:numel(subj)
    % ci
    
    eval(['sEEG=' subj{ci} '_sEEG;']);
    eval(['rsEEG=' subj{ci} '_rsEEG;']);
% %     eval(['fwsEEG=' subj{ci} '_fwsEEG;']);
% %     eval(['fwrsEEG=' subj{ci} '_fwrsEEG;']);
    eval(['fsEEG=' subj{ci} '_fsEEG;']);
    eval(['frsEEG=' subj{ci} '_frsEEG;']);
%     
%     eval(['iEEG=' subj{ci} '_iEEG;']);
%     eval(['riEEG=' subj{ci} '_riEEG;']);
% %     eval(['fwiEEG=' subj{ci} '_fwiEEG;']);
% %     eval(['fwriEEG=' subj{ci} '_fwriEEG;']);
%     eval(['fiEEG=' subj{ci} '_fiEEG;']);
%     eval(['friEEG=' subj{ci} '_friEEG;']);
%     
%     eval(['HOF=' subj{ci} '_HOF;']);
%     
%     eval(['sy=' subj{ci} '_sy;']);
%     eval(['rsy=' subj{ci} '_rsy;']);
%     
    eval(['tr_examples=' subj{ci} '_tr_examples;']);
    eval(['rtr_examples=' subj{ci} '_rtr_examples;']);
    
    %train_epilepsy_classifier
    epilepsy_classifier
 %   R(ci,:)=[sperf.tstbin fsperf.tstbin];% ...
    %R(ci,:)=[sperf.trnbin sperf.tstbin fsperf.trnbin fsperf.tstbin hofperf.trnbin hofperf.tstbin]
%    R(ci,:)=[sperf.tstbin sbperf.tstbin fsperf.tstbin iperf.tstbin fiperf.tstbin hofperf.tstbin];
    R(ci,:)=[sperf.tstbin fsperf.tstbin tperf.tstbin ftperf.tstbin]
     %  sRchtst(ci,:)=schstst;
     %  sRchtrn(ci,:)=schstrn;
     %  iRchtst(ci,:)=ichstst;
     %  iRchtrn(ci,:)=ichstrn;
    eval([ subj{ci} 'ftclsfr' '=ftclsfr;'])
    %eval([ subj{ci} 'sperf' '=sperf;'])
 %   eval([ subj{ci} 'fsperf' '=fsperf;'])
%     eval([ subj{ci} 'wsperf' '=wsperf;'])
%     eval([ subj{ci} 'wiperf' '=wiperf;'])
    %     eval([ subj{ci} 'cperf' '=cperf;'])
    %     eval([ subj{ci} 'fcperf' '=fcperf;'])
%     eval([ subj{ci} 'iperf' '=iperf;'])
%     eval([ subj{ci} 'fiperf' '=fiperf;'])
    %     eval([ subj{ci} 'ciperf' '=ciperf;'])
    %     eval([ subj{ci} 'fciperf' '=fciperf;'])
% % %     
% % %     eval([ subj{ci} 'sclsfr' '=sclsfr;'])
% % %     eval([ subj{ci} 'fsclsfr' '=fsclsfr;'])
% % %     eval([ subj{ci} 'iclsfr'  '=iclsfr;'])
% % %     eval([ subj{ci} 'ficlsfr'  '=ficlsfr;'])
% % %     eval([ subj{ci} 'SCfsclsfr' '=SCfsclsfr;'])
% % %     eval([ subj{ci} 'schstrn' '=schstrn;'])
% % %     eval([ subj{ci} '_F' '=f;';])
% % %     eval([ subj{ci} 'labels=labels;'])
%     
%     SS(ci,:)=[sperf.tstconf(4)/(sperf.tstconf(3)+sperf.tstconf(4))...
%         sperf.tstconf(1)/(sperf.tstconf(1)+sperf.tstconf(2))];
%     
%     SSauc(ci,:)=[sperf.trnauc];
%     
%     fSS(ci,:)=[fsperf.tstconf(4)/(fsperf.tstconf(3)+fsperf.tstconf(4))...
%         fsperf.tstconf(1)/(fsperf.tstconf(1)+fsperf.tstconf(2))];
%     
%     fSSauc(ci,:)=[fsperf.trnauc];
%     
%     eval([ subj{ci} '_schannels' '=schannels;'])
%     eval([ subj{ci} '_ichannels' '=ichannels;'])
    
end