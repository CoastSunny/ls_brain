% clear imtpr1 imtpr2 imtpr3 amtpr1 amtpr2 amtpr3 imfpr1 imfpr2 imfpr3 dv_neg2 dv_pos2
% clear imtpr_trans1 imtpr_trans2 imtpr_trans3 amtpr_trans1 amtpr_trans2 amtpr_trans3
% clear imfpr_trans1 imfpr_trans2 imfpr_trans3 amfpr_trans1 amfpr_trans2 amfpr_trans3

%fpr_target=0.5;
bias_target=-0;
tau=1:173;
%cheating_bias=0;30;69;44;140;8;54;

for si=1:10;%[1 8 5 2 3 4 6 7 9 10]
    %si
    
%    sgresds2_nrow{si}=dec_methods(gzerds2{si},t2,-1,1,'nrow',1,mt2,mn2);
    %smgresds2_nrow{si}=dec_methods(gzerds2{si},4,-1,1,'nrow_switch',1,mt2,mn2);
    idx_fpr=find(sgresds2_nrow{si}(2).out.fpr.nrow(m2,:)<=fpr_target);
    %idx_fpr=5001;
    idx_fpr=find(sgresds2_nrow{si}(2).out.bias<=-bias_nrow(si));
    %idx_fpr=find(sgresds2{si}(2).out.bias<=bias_target);
    
    amfpr2(si)=sgresds2_nrow{si}(2).out.fpr.nrow(m2,idx_fpr(end)-cheating_bias);
    amfpr22(si)=sgresds2_nrow{si}(2).out.fpr.nrow2(m2,idx_fpr(end)-cheating_bias);
    amtpr2(si)=sgresds2_nrow{si}(2).out.tpr.nrow(m2,idx_fpr(end)-cheating_bias);
    
    imfpr2(si)=sgresds2_nrow{si}(1).out.fpr.nrow(m2,idx_fpr(end)-cheating_bias);
    imfpr22(si)=sgresds2_nrow{si}(1).out.fpr.nrow2(m2,idx_fpr(end)-cheating_bias);
    imtpr2(si)=sgresds2_nrow{si}(1).out.tpr.nrow(m2,idx_fpr(end)-cheating_bias);
    %
  %  amtpr_nswitch{si}=cell2mat( smgresds2_nrow{si}(2).out.tpr.nrow(m2,idx_fpr(end)-cheating_bias,:));
end


% 
% amtpr2
% amfpr2
% % amfpr22
