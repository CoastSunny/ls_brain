% clear  TTD sTTD 
% clear imtpr_trans1 imtpr_trans2 imtpr_trans3 amtpr_trans1 amtpr_trans2 amtpr_trans3 
% clear imfpr_trans1 imfpr_trans2 imfpr_trans3 amfpr_trans1 amfpr_trans2 amfpr_trans3
% count=0;
%fpr_target=0.1;
%bias_target=-.5;
tau=1:173;
% cheating_bias=0;-280;44;141;
try close(h2)
catch err
end
%h2=figure;hold on,
dmsav=dmsavAd_nrow;
dmsav2=dmsavAd2_nrow;
dmsav_switch=dmsavAdnrow_switch;
dmsav_switch2=dmsavAdnrow_switch2;
for si=1:numel(dmsavA)%[1 2 3 4 5]% 6:10]%[9 5 1 2 3 4 6 7 8 10]
    si;
    %count=count+1;
       
   % idx_fpr=find(out{si}.out.fpr.sav2(m2,:)<=fpr_target);
    %idx_fpr=find(out{si}.out.fpr.sav(m2,:)<=fpr_target);
  %
  %idx_fpr=5001;
  %  idx_fpr=find(out{si}.out.bias<=bias_target);
    idx_fpr=find(dmsav{si}.out.bias<=-bias_nrowA(si));
%
    if (empirical==1)
        idx_fpr=find(dmsav2{si}.out.fpr.nrow(m2,:)<=fpr_target);
    end
    % out{si}.out.bias(idx_fpr(end))-out{si}.out.bias(idx_fpr(end)-cheating_bias)
%     out{si}.out.bias(idx_fpr(end)-cheating_bias)
    amfpr2(si)=dmsav2{si}.out.fpr.nrow(m2,idx_fpr(end)-cheating_bias);
    amtpr2(si)=dmsav2{si}.out.tpr.nrow(m2,idx_fpr(end)-cheating_bias);
  %  amfpr3(count)=out{si}.out.fpr.sav3(m2,idx_fpr(end)-cheating_bias);
    amfpr(si)=dmsav{si}.out.fpr.nrow(m2,idx_fpr(end)-cheating_bias);
    amtpr(si)=dmsav{si}.out.tpr.nrow(m2,idx_fpr(end)-cheating_bias);
    %amtpr_nrow(si)=out{si}.out.tpr.nrow(m2,idx_fpr(end)-cheating_bias);
%     amfpr_nrow(count)=out{si}.out.fpr.nrow(m2,idx_fpr(end)-cheating_bias);
    % amtpr_trans{si}=cell2mat(out_trans{si}.out.tpr.sav_trans(m2,idx_fpr(end)-cheating_bias,:));

% %     amfpr_trans(count)=out_trans{si}.out.fpr.sav_trans(m2,idx_fpr(end)-cheating_bias,:);
% %     amtpr_trans_nrow(count)=out_trans{si}.out.tpr.nrow(m2,idx_fpr(end)-cheating_bias);
%      dv_neg{si}=out{si}.out.fpr.dv_neg{m2,idx_fpr(end)-cheating_bias};
%      dv_pos{si}=out{si}.out.tpr.dv_pos{m2,idx_fpr(end)-cheating_bias};
% %     dv_negC{count}=out{si}.out.fpr.dv_negC{mt2,idx_fpr(end)-cheating_bias};
% %     dv_posC{count}=out{si}.out.tpr.dv_posC{mt2,idx_fpr(end)-cheating_bias};
%    % plot(dv_neg{count},'r'),plot(dv_pos{count},'g')
% %     mDVn(count)=mean(dv_neg{count});
% %     stdDVn(count)=std(dv_neg{count});
% %     mDVCn(count)=mean(dv_negC{count});
% %     stdDVCn(count)=std(dv_negC{count});
% %     mDVp(count)=mean(dv_pos{count});
% %     stdDVp(count)=std(dv_pos{count});
% %     mDVCp(count)=mean(dv_posC{count});
% %     stdDVCp(count)=std(dv_posC{count});

     amtpr_switch{si}=cell2mat(dmsav_switch{si}.out.tpr.nrow(m2,idx_fpr(end)-cheating_bias,:));
     N2=min( numel( amtpr_switch{si} ) , m2 );
     tpr=[squeeze(amtpr_switch{si}(1:N2-1)) repmat(amtpr(si),1,173-numel(amtpr_switch{si}(1:N2-1)))];
     TPR(si,:)=tpr;
     P=[tpr(1) tpr(2:end).*cumprod(1-tpr(1:end-1))];
     if sum(P)>0.99
     nTTD(si)=sum(P.*tau);
     else
         nTTD(si)=nan;
     end
     sTTD(si)=sqrt(sum( (tau-TTD(si)).^2.*P ));
     
     amtpr_switch2{si}=cell2mat(dmsav_switch2{si}.out.tpr.nrow(m2,idx_fpr(end)-cheating_bias,:));
     N2=min( numel( amtpr_switch2{si} ) , m2 );
     tpr=[squeeze(amtpr_switch2{si}(1:N2-1)) repmat(amtpr2(si),1,173-numel(amtpr_switch2{si}(1:N2-1)))];
     TPR(si,:)=tpr;
     P=[tpr(1) tpr(2:end).*cumprod(1-tpr(1:end-1))];
     if sum(P)>0.99
     nTTD2(si)=sum(P.*tau);
     else
         nTTD2(si)=nan;
     end
     sTTD2(si)=sqrt(sum( (tau-TTD(si)).^2.*P ));
         %sum(P)  
    
end
%close all
% 
  amtpr;
% TTD
  amfpr;mean(amfpr);
% amfprb
% % % %amfpr3
%  [min(TTD) min(TTD)/60]*6,[median(TTD) median(TTD)/60]*6,[max(TTD) max(TTD)/60]*6
 %round(TTD*1)
 %round(sTTD*6)
% mDVn
% %stdDV
% mDVCn
% mDVp
% mDVCp
%stdDVC
%amtpr_nrow
%amfpr_nrow
%amtpr_trans_nrow

