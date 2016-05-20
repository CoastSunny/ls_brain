
% first multi channel and then single channel
% fpr tpr by thresholding, spatial info etc
%
% subj={'C_C' 'A_S' 'B_G' 'E_N' 'C_R' 'D_L'};

R=[];fSS=[];tfSS=[];fSSauc=[];
Itest=[1 6 8:16];
% for ci=Itest    
%         
%     eval(['spikes=' subj{ci} 'spikes;'])
%     si=ci;
%     catall2
%     kk=2:6;
%     for iko=1:numel(kk)
%     k0=kk(iko);
%     ls_dict4
%     epilepsy_classifier_dict
%     tmp(iko)=[dres.tstbin(dres.opt.Ci)];
%     tmpres(iko,:)=[sperf.perf dperf.perf];
%     [ii mm]=max(tmp);
%     end
%    
%     R(ci,:)=[tmpres(mm,:)];% ...
%     
%     
%     
% end
k0=15;
for ci=Itest    
        
    eval(['spikes=' subj{ci} 'spikes;'])
    si=ci;
    catall2   
    ls_spams
    epilepsy_classifier_dict
    R(ci,:)=[sperf.perf dperf.perf];% ...
    eval([ subj{ci} 'sclsfr' '=sclsfr;'])
    eval([ subj{ci} 'dclsfr' '=dclsfr;'])
    eval([ subj{ci} 'Dsr' '=Dsr;'])
    eval([ subj{ci} 'Yout_pre' '=Yout_pre;'])
    eval([ subj{ci} 'rYout_pre' '=rYout_pre;'])
            
end