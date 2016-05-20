

%subj={'D_J' 'C_C' 'C_D' 'A_S' 'B_G' 'E_N' 'C_R' 'D_L' };
%subj={'B_G' 'E_N' 'C_R' 'D_L' };
%subj={'D_J' 'C_C' 'C_D' 'B_G' 'E_N' 'C_R' 'D_L' 'A_S' 'F_A'};
% subj={ 'L_K' 'B_A' 'L_M' 'O_T' 'P_L' 'P_N' 'H_S' 'D_J' 'C_C' 'C_D'...
%        'B_G' 'E_N' 'C_R' 'D_L' 'F_A' 'B_A' 'BR_R'...
%        'C_B' 'Q_D' 'R_D' 'R_I' 'R_R' 'S_M' 'S_S' 'W_G' 'W_S'};
subj={ 'B_G' 'BR_R'  'C_B' 'C_C' 'C_D' 'C_R' 'D_J' 'D_L'...
       'E_N' 'F_A' 'H_S' 'L_M' 'O_T' 'P_L' 'R_D' 'S_M' 'S_S' 'W_S'};
%subj={'P_N'};
%aaa=[11 17 18 9 10 13 8 14 12 15 7 3 4 5 20 23 24 26];
R=[];
data=[];
Itest=6%:numel(subj)
for ci=Itest
    fprintf(num2str(ci))
    try cd D:\Raw\Epilepsy
    catch err
        cd([home '/Documents/Epilepsy/'])
    end
    load(subj{ci})
    eval(['X=' subj{ci} ';'])
    cd([home '/Dropbox/Spikes/'])
    load([subj{ci} 'data'])
    eval([subj{ci} '_spikes=spikes;']);
    slicespikes_new
   
    eval([subj{ci} '_sEEG=sEEG;']);
    eval([subj{ci} '_rsEEG=rsEEG;']);
    eval([subj{ci} '_fsEEG=fsEEG;']);
    eval([subj{ci} '_frsEEG=frsEEG;']);
    eval([subj{ci} '_fwsEEG=fwsEEG;']);
    eval([subj{ci} '_fwrsEEG=fwrsEEG;']);
    eval([subj{ci} '_cEEG=cEEG;']);
    eval([subj{ci} '_rcEEG=rcEEG;']);
    eval([subj{ci} '_ciEEG=ciEEG;']);
    eval([subj{ci} '_rciEEG=rciEEG;']);
    eval([subj{ci} '_sy=sy;']);
    eval([subj{ci} '_rsy=rsy;']);
    eval([subj{ci} '_iEEG=iEEG;']);
    eval([subj{ci} '_riEEG=riEEG;']);
    eval([subj{ci} '_fwiEEG=fwiEEG;']);
    eval([subj{ci} '_fwriEEG=fwriEEG;']);
    eval([subj{ci} '_fiEEG=fiEEG;']);
    eval([subj{ci} '_friEEG=friEEG;']);
    eval([subj{ci} '_fsEEG=fsEEG;']);
    eval([subj{ci} '_frsEEG=frsEEG;']);
  
    eval([subj{ci} '_idx_iEEG=idx_iEEG;']);
    %     eval([subj{ci} '_fsEEG2=fsEEG2;']);
    %     eval([subj{ci} '_frsEEG2=frsEEG2;']);
    
%     eval([subj{ci} '_HOF=HOF;']);
%     
%     eval([subj{ci} '_XHOF=XHOF;']);
    
    eval([subj{ci} '_tr_examples=tr_examples;']);
    eval([subj{ci} '_rtr_examples=rtr_examples;']);
    eval([subj{ci} 'spikes=spikes;']);
    eval([subj{ci} 'idx_iEEG=idx_iEEG;']);
    
    eval([subj{ci} '_SP=SP;']);
    eval([subj{ci} '_iSP2=iSP2;']);
    eval([subj{ci} '_iSP3=iSP3;']);
    eval([subj{ci} '_pSP=pSP;']);
    %     %train_epilepsy_classifier
    %     epilepsy_classifier
    %     R(ci,:)=[sperf.trnbin sperf.tstbin fsperf.trnbin fsperf.tstbin...
    %         cperf.trnbin cperf.tstbin fcperf.trnbin fcperf.tstbin...
    %         iperf.trnbin iperf.tstbin fiperf.trnbin fiperf.tstbin];
    %     eval([ subj{ci} 'sperf' '=sperf;'])
    %     eval([ subj{ci} 'fsperf' '=fsperf;'])
    %     eval([ subj{ci} 'cperf' '=cperf;'])
    %     eval([ subj{ci} 'fcperf' '=fcperf;'])
    %     eval([ subj{ci} 'iperf' '=iperf;'])
    %     eval([ subj{ci} 'fiperf' '=fiperf;'])
    %
    % %     eval([ subj{ci} 'sclsfr' '=sclsfr;'])
    % %     eval([ subj{ci} 'fsclsfr' '=fsclsfr;'])
    % %     eval([ subj{ci} 'fsclsfr2'  '=fsclsfr2;'])
    %
    %
    %    % apply_epilepsy_classifier
    %    % R(ci,:)=Res;
    
end
% 3. scalp-deep but visible at scalp only by looking at the deep electrodes.
% 4. scalp-deep but visible at scalp without needing the deep electrodes
