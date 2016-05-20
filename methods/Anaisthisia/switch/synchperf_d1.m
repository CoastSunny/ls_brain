% clear imtpr1 imtpr2 imtpr3 amtpr1 amtpr2 amtpr3 imfpr1 imfpr2 imfpr3 dv_neg2 dv_pos2
% clear imtpr_trans1 imtpr_trans2 imtpr_trans3 amtpr_trans1 amtpr_trans2 amtpr_trans3
% clear imfpr_trans1 imfpr_trans2 imfpr_trans3 amfpr_trans1 amfpr_trans2 amfpr_trans3
% si=0;
%fpr_target=0.10;
%bias_target=-0;
tau=1:173;
% cheating_bias=0;
%h1=figure;hold on,
for si=1:10;%[1 8 5 2 3 4 6 7 9 10]
   % si
    %
  %   sgresds2{si}=dec_methods(gzerds2{si},t2,-1,1,'sav',1,mt2,mn2);
 
   %  smgresds2{si}=dec_methods(gzerds2{si},4,-1,1,'sav_switch',1,mt2,mn2);
    %  cgresds2{si}=dec_methods(gzerds2{si},t2,-1,1,'sav_fpr_check',1,mt2,mn2);
    
    idx_fpr=find(sgresds2{si}(2).out.fpr.sav(m2,:)<=fpr_target);
  % idx_fpr=5001;
    idx_fpr=find(sgresds2{si}(2).out.bias<=-bias_sav(si));
  %   idx_fpr=find(sgresds2{si}(2).out.bias<=bias_target);
    %  sgresds2{si}(2).out.bias(idx_fpr(end))-sgresds2{si}(2).out.bias(idx_fpr(end)-cheating_bias)
    amfpr2(si)=sgresds2{si}(2).out.fpr.sav(m2,idx_fpr(end)-cheating_bias);
    amfpr2b(si)=sgresds2{si}(2).out.fpr.sav2(m2,idx_fpr(end)-cheating_bias);
    amtpr2(si)=sgresds2{si}(2).out.tpr.sav(m2,idx_fpr(end)-cheating_bias);
    dv_neg2{si}=sgresds2{si}(2).out.fpr.dv_neg{m2,idx_fpr(end)-cheating_bias};
    dv_pos2{si}=sgresds2{si}(2).out.tpr.dv_pos{m2,idx_fpr(end)-cheating_bias};
%     dv_neg2C{si}=sgresds2{si}(2).out.fpr.dv_negC{mt2,idx_fpr(end)-cheating_bias};
%     dv_pos2C{si}=sgresds2{si}(2).out.tpr.dv_posC{mt2,idx_fpr(end)-cheating_bias};
%     
%     idx_fpr=find(sgresds2{si}(1).out.fpr.sav(m2,:)<=fpr_target);
%     %idx_fpr=5001;
%     idx_fpr=find(sgresds2{si}(1).out.bias<=bias_target);
%     imfpr2(si)=sgresds2{si}(1).out.fpr.sav(m2,idx_fpr(end)-cheating_bias);
%     imfpr22(si)=sgresds2{si}(1).out.fpr.sav2(m2,idx_fpr(end)-cheating_bias);
%     imtpr2(si)=sgresds2{si}(1).out.tpr.sav(m2,idx_fpr(end)-cheating_bias);
    %  amtpr2_nrow(si)=sgresds2{si}(2).out.tpr.nrow(m2,idx_fpr(end)-cheating_bias);
    %  amfpr2_nrow(si)=sgresds2{si}(2).out.fpr.nrow(m2,idx_fpr(end)-cheating_bias);
    %  amtpr_trans2{si}=cell2mat(smgresds2{si}(2).out.tpr.sav_trans(m2,idx_fpr(end)-cheating_bias,:));
    %  amtpr_trans2_nrow(si)=smgresds2{si}(2).out.tpr.nrow(m2,idx_fpr(end)-cheating_bias);
     % amfpr_trans2(si)=smgresds2{si}(2).out.fpr.sav_trans(m2,idx_fpr(end)-cheating_bias,:);
%  amtpr_switch2{si}=cell2mat(smgresds2{si}(2).out.tpr.sav(m2,idx_fpr(end)-cheating_bias,:));
%     %  idx_fpr=find(cgresds2{si}(2).out.fpr.train(m2,:)<=fpr_target);
%     %  tramfpr2(si)=cgresds2{si}(2).out.fpr.train(m2,idx_fpr(end)-cheating_bias);
%     %  tsamfpr2(si)=cgresds2{si}(2).out.fpr.test(m2,idx_fpr(end)-cheating_bias);
%     %  plot(dv_neg2{si},'r'),plot(dv_pos2{si},'g')
%     %  
%     %mDV2(si)=mean(dv_neg2{si});
%     %stdDV2(si)=std(dv_neg2{si});
%     % mDV2C(si)=mean(dv_neg2C{si});
%     % stdDV2C(si)=std(dv_neg2C{si});
%     tpr=[squeeze(amtpr_switch2{si})' repmat(amtpr2(si),1,173-numel(amtpr_switch2{si}))];
%     P=[tpr(1) tpr(2:end).*cumprod(1-tpr(1:end-1))];
%     if sum(P)>0.99
%     TTD2(si)=sum(P.*tau);
%     else
%         TTD2(si)=nan;
%     end
%     sTTD2(si)=sqrt(sum( (tau-TTD2(si)).^2.*P ));
%     
end

%close all

%  amtpr2
%  amfpr2
%  amfpr2b
 
% imtpr2
% imfpr2
% imfpr22
%amtpr2_nrow
%amfpr2_nrow
% %amtpr_trans2_nrow
% [min(TTD2) min(TTD2)/60]*6,[mean(TTD2) mean(TTD2)/60]*6,[max(TTD2) max(TTD2)/60]*6
%  AMtrans2=[squeeze(mean(cat(4,amtpr_trans2{:}),4)); repmat(mean(amtpr2),24-size(squeeze(mean(cat(4,amtpr_trans2{:}),4)),1),1)];
%  round(TTD2*6)
%  round(sTTD2*6)
% mDV2
% %stdDV2
% mDV2C
%stdDV2C
