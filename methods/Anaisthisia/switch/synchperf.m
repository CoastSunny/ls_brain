clear imtpr1 imtpr2 imtpr3 amtpr1 amtpr2 amtpr3 imfpr1 imfpr2 imfpr3 
clear imtpr_trans1 imtpr_trans2 imtpr_trans3 amtpr_trans1 amtpr_trans2 amtpr_trans3 
clear imfpr_trans1 imfpr_trans2 imfpr_trans3 amfpr_trans1 amfpr_trans2 amfpr_trans3
count=0;
fpr_target=0.00;
bias_target=0;-.05;
%t1=6;t2=4;t3=2;
t1='all';t2='all';t3='all';
tr=6;
m1=6*tr;m2=4*tr;m3=2*tr;
mt1=6*tr;mt2=4*tr;mt3=2*tr;
mn1=6*tr;mn2=4*tr;mn3=2*tr;
cheating_bias=143;54;
for si=1:10%[1:3  5:10]
    si
     count=count+1;
% % %     sgresds1{count}=dec_methods(gzerds1{si},t1,-1,1,'sav',1,mt1,mn1);
%       sgresds2{count}=dec_methods(gzerds2{si},t2,-1,1,'sav',1,mt2,mn2);
% % %     sgresds3{count}=dec_methods(gzerds3{si},t3,-1,1,'sav',1,mt3,mn3);
% % %     
% % %     smgresds1{count}=dec_methods(gzerds1{si},t1,-1,1,'sav_trans',1,mt1,mn1);
%       smgresds2{count}=dec_methods(gzerds2{si},t2,-1,1,'sav_trans',1,mt2,mn2);
% % %     smgresds3{count}=dec_methods(gzerds3{si},t3,-1,1,'sav_trans',1,mt3,mn3);
% % %     
% % %     cgresds1{count}=dec_methods(gzerds1{si},t1,-1,1,'sav_fpr_check',1,mt1,mn1);
%       cgresds2{count}=dec_methods(gzerds2{si},t2,-1,1,'sav_fpr_check',1,mt2,mn2);
% % %     cgresds3{count}=dec_methods(gzerds3{si},t3,-1,1,'sav_fpr_check',1,mt3,mn3);
% % % % %     

%      
%     idx_fpr=find(sgresds1{count}(1).out.fpr.sav(m1,:)<=fpr_target);
%     idx_fpr=find(sgresds1{count}(1).out.bias<=bias_target);
%     imfpr1(count)=sgresds1{count}(1).out.fpr.sav(m1,idx_fpr(end)-cheating_bias);
%     imfpr12(count)=sgresds1{count}(1).out.fpr.sav2(m1,idx_fpr(end)-cheating_bias);
%     imtpr1(count)=sgresds1{count}(1).out.tpr.sav(m1,idx_fpr(end)-cheating_bias);    
%     imtpr_trans1{count}=smgresds1{count}(1).out.tpr.sav_trans(m1,idx_fpr(end)-cheating_bias,:);
%     imfpr_trans1(count)=smgresds1{count}(1).out.fpr.sav_trans(m1,idx_fpr(end)-cheating_bias,:);    
%     idx_fpr=find(sgresds2{count}(1).out.fpr.sav2(m2,:)<=fpr_target);
%     idx_fpr=find(sgresds2{count}(1).out.bias<=bias_target);
%     imfpr2(count)=sgresds2{count}(1).out.fpr.sav(m2,idx_fpr(end)-cheating_bias);
%     imfpr22(count)=sgresds2{count}(1).out.fpr.sav2(m2,idx_fpr(end)-cheating_bias);
%     imtpr2(count)=sgresds2{count}(1).out.tpr.sav(m2,idx_fpr(end)-cheating_bias);
%     imtpr_trans2{count}=smgresds2{count}(1).out.tpr.sav_trans(m2,idx_fpr(end)-cheating_bias,:);
%     imfpr_trans2(count)=smgresds2{count}(1).out.fpr.sav_trans(m2,idx_fpr(end)-cheating_bias,:);    
%     idx_fpr=find(sgresds3{count}(1).out.fpr.sav(m3,:)<=fpr_target);
%     idx_fpr=find(sgresds3{count}(1).out.bias<=bias_target);
%     imfpr3(count)=sgresds3{count}(1).out.fpr.sav(m3,idx_fpr(end)-cheating_bias);
%     imfpr32(count)=sgresds3{count}(1).out.fpr.sav2(m3,idx_fpr(end)-cheating_bias);
%     imtpr3(count)=sgresds3{count}(1).out.tpr.sav(m3,idx_fpr(end)-cheating_bias);
%     imtpr_trans3{count}=smgresds3{count}(1).out.tpr.sav_trans(m3,idx_fpr(end)-cheating_bias,:);
%     imfpr_trans3(count)=smgresds3{count}(1).out.fpr.sav_trans(m3,idx_fpr(end)-cheating_bias,:);    
    
%     idx_fpr=find(sgresds1{count}(2).out.fpr.sav(m1,:)<=fpr_target);
%     idx_fpr=find(sgresds1{count}(2).out.bias<=bias_target);
%     amfpr1(count)=sgresds1{count}(2).out.fpr.sav(m1,idx_fpr(end)-cheating_bias);
%     amfpr12(count)=sgresds1{count}(2).out.fpr.sav2(m1,idx_fpr(end)-cheating_bias);
%     amtpr1(count)=sgresds1{count}(2).out.tpr.sav(m1,idx_fpr(end)-cheating_bias);
%     amtpr_trans1{count}=smgresds1{count}(2).out.tpr.sav_trans(m1,idx_fpr(end)-cheating_bias,:);
%     amfpr_trans1(count)=smgresds1{count}(2).out.fpr.sav_trans(m1,idx_fpr(end)-cheating_bias,:);    
    idx_fpr=find(sgresds2{count}(2).out.fpr.sav2(m2,:)<=fpr_target);
    %idx_fpr=find(sgresds2{count}(2).out.bias<=bias_target);
    sgresds2{count}(2).out.bias(idx_fpr(end))-sgresds2{count}(2).out.bias(idx_fpr(end)-cheating_bias)
    amfpr2(count)=sgresds2{count}(2).out.fpr.sav(m2,idx_fpr(end)-cheating_bias);
    amfpr22(count)=sgresds2{count}(2).out.fpr.sav2(m2,idx_fpr(end)-cheating_bias);
    amtpr2(count)=sgresds2{count}(2).out.tpr.sav(m2,idx_fpr(end)-cheating_bias);
    amtpr2_nrow(count)=sgresds2{count}(2).out.tpr.nrow(m2,idx_fpr(end)-cheating_bias);
    amtpr_trans2{count}=smgresds2{count}(2).out.tpr.sav_trans(m2,idx_fpr(end)-cheating_bias,:);
    amfpr_trans2(count)=smgresds2{count}(2).out.fpr.sav_trans(m2,idx_fpr(end)-cheating_bias,:);    
%     idx_fpr=find(sgresds3{count}(2).out.fpr.sav(m3,:)<=fpr_target);
%     idx_fpr=find(sgresds3{count}(2).out.bias<=bias_target);
%     amfpr3(count)=sgresds3{count}(2).out.fpr.sav(m3,idx_fpr(end)-cheating_bias);
%     amfpr32(count)=sgresds3{count}(2).out.fpr.sav2(m3,idx_fpr(end)-cheating_bias);
%     amtpr3(count)=sgresds3{count}(2).out.tpr.sav(m3,idx_fpr(end)-cheating_bias);
%     amtpr_trans3{count}=smgresds3{count}(2).out.tpr.sav_trans(m3,idx_fpr(end)-cheating_bias,:); 
%     amfpr_trans3(count)=smgresds3{count}(2).out.fpr.sav_trans(m3,idx_fpr(end)-cheating_bias,:);
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
   
%     idx_fpr=find(cgresds1{count}(1).out.fpr.train(m1,:)<=fpr_target);   
%     trimfpr1(count)=cgresds1{count}(1).out.fpr.train(m1,idx_fpr(end)-cheating_bias);   
%     tsimfpr1(count)=cgresds1{count}(1).out.fpr.test(m1,idx_fpr(end)-cheating_bias);   
%     idx_fpr=find(cgresds2{count}(1).out.fpr.train(m2,:)<=fpr_target);   
%     trimfpr2(count)=cgresds2{count}(1).out.fpr.train(m2,idx_fpr(end)-cheating_bias);    
%     tsimfpr2(count)=cgresds2{count}(1).out.fpr.test(m2,idx_fpr(end)-cheating_bias);    
%     idx_fpr=find(cgresds3{count}(1).out.fpr.train(m3,:)<=fpr_target);   
%     trimfpr3(count)=cgresds3{count}(1).out.fpr.train(m3,idx_fpr(end)-cheating_bias);
%     tsimfpr3(count)=cgresds3{count}(1).out.fpr.test(m3,idx_fpr(end)-cheating_bias);
%     
%     idx_fpr=find(cgresds1{count}(2).out.fpr.train(m1,:)<=fpr_target);   
%     tramfpr1(count)=cgresds1{count}(2).out.fpr.train(m1,idx_fpr(end)-cheating_bias);   
%     tsamfpr1(count)=cgresds1{count}(2).out.fpr.test(m1,idx_fpr(end)-cheating_bias);   
    idx_fpr=find(cgresds2{count}(2).out.fpr.train(m2,:)<=fpr_target);   
    tramfpr2(count)=cgresds2{count}(2).out.fpr.train(m2,idx_fpr(end)-cheating_bias);    
    tsamfpr2(count)=cgresds2{count}(2).out.fpr.test(m2,idx_fpr(end)-cheating_bias);    
%     idx_fpr=find(cgresds3{count}(2).out.fpr.train(m3,:)<=fpr_target);   
%     tramfpr3(count)=cgresds3{count}(2).out.fpr.train(m3,idx_fpr(end)-cheating_bias);    
%     tsamfpr3(count)=cgresds3{count}(2).out.fpr.test(m3,idx_fpr(end)-cheating_bias);   
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%     tgt=5001;
%     
%     idx_fpr1  = find( svgresds1{count}(1).val.fpr.sav(m1,:)<=fpr_target );
% %     bias1 = svgresds1{count}(1).val.bias(idx_fpr1(end));
% %     idx_bias1_o = find( sgresds1{count}(1).out.bias<=bias1);
% %     imtpr1v(count)=sgresds1{count}(1).out.tpr.sav(m1,idx_bias1_o(end));
%     idx_cal=tgt;
%     imfpr1v(count)=sgresds1{count}(1).out.fpr.sav(m1,idx_cal);
%     imtpr1v(count)=sgresds1{count}(1).out.tpr.sav(m1,idx_cal);
%     
%     idx_fpr2=find(svgresds2{count}(1).val.fpr.sav(m2,:)<=fpr_target);
% %     bias2 = svgresds2{count}(1).val.bias(idx_fpr2(end));
% %     idx_bias2_o = find( sgresds2{count}(1).out.bias<=bias2);
%     idx_cal=tgt;
%     imfpr2v(count)=sgresds2{count}(1).out.fpr.sav(m2,idx_cal);
%     imtpr2v(count)=sgresds2{count}(1).out.tpr.sav(m2,idx_cal);
%     
%     idx_cal=tgt;
%     idx_fpr3=find(svgresds3{count}(1).val.fpr.sav(m3,:)<=fpr_target);
% %     bias3 = svgresds3{count}(1).val.bias(idx_fpr3(end));    
% %     idx_bias3_o = find( sgresds3{count}(1).out.bias<=bias3);
%     imfpr3v(count)=sgresds3{count}(1).out.fpr.sav(m3,idx_cal);
%     imtpr3v(count)=sgresds3{count}(1).out.tpr.sav(m3,idx_cal(end));
    
end

% SAV=[mean(imtpr1) mean(imtpr2) mean(imtpr3); ...
%      mean(amtpr1) mean(amtpr2) mean(amtpr3);... 
% %     mean(iamtpr1) mean(iamtpr2) mean(iamtpr3);...
% %     mean(aimtpr1) mean(aimtpr2) mean(aimtpr3);... 
%      mean(imfpr1) mean(imfpr2) mean(imfpr3); ...
%      mean(amfpr1) mean(amfpr2) mean(amfpr3);...
%      mean(imfpr12) mean(imfpr22) mean(imfpr32);...
%      mean(amfpr12) mean(amfpr22) mean(amfpr32);...
%     % mean(aimfpr1) mean(aimfpr2) mean(aimfpr3);...
% %     mean(imfpr_trans1) mean(imfpr_trans2) mean(imfpr_trans3);...
% %     mean(amfpr_trans1) mean(amfpr_trans2) mean(amfpr_trans3)
% ];
% %  
% FPRCHECK=[  mean(trimfpr1) mean(trimfpr2) mean(trimfpr3); ...
%             mean(tsimfpr1) mean(tsimfpr2) mean(tsimfpr3); ...
%             mean(tramfpr1) mean(tramfpr2) mean(tramfpr3);...
%             mean(tsamfpr1) mean(tsamfpr2) mean(tsamfpr3);...
%             ];
% SAV
% FPRCHECK
amtpr2
amfpr2
amfpr22
amtpr2_nrow
% imtpr2
% imfpr2
% imfpr22
% IMtrans1=[squeeze(mean(cat(4,imtpr_trans1{:}),4)); repmat(mean(imtpr1),36-size(squeeze(mean(cat(4,imtpr_trans1{:}),4)),1),1)];
%IMtrans2=[squeeze(mean(cat(4,imtpr_trans2{:}),4)); repmat(mean(imtpr2),24-size(squeeze(mean(cat(4,imtpr_trans2{:}),4)),1),1)];
% IMtrans3=[squeeze(mean(cat(4,imtpr_trans3{:}),4)); repmat(mean(imtpr3),12-size(squeeze(mean(cat(4,imtpr_trans3{:}),4)),1),1)];
% AMtrans1=[squeeze(mean(cat(4,amtpr_trans1{:}),4)); repmat(mean(amtpr1),36-size(squeeze(mean(cat(4,imtpr_trans1{:}),4)),1),1)];
AMtrans2=[squeeze(mean(cat(4,amtpr_trans2{:}),4)); repmat(mean(amtpr2),24-size(squeeze(mean(cat(4,amtpr_trans2{:}),4)),1),1)];
% AMtrans3=[squeeze(mean(cat(4,amtpr_trans3{:}),4)); repmat(mean(amtpr3),12-size(squeeze(mean(cat(4,imtpr_trans3{:}),4)),1),1)];
% idx1=(1:(6*6))*4/60;idx2=(1:(4*6))*6/60;idx3=(1:(2*6))*12/60;
% figure,hold on, plot(idx1,IMtrans1,'r'),plot(idx2,IMtrans2,'g'),plot(idx3,IMtrans3,'b')
% axis([0 2.5 0 1]),xlabel('time in minutes'),ylabel('tpr'),title('tpr for fpr=0, IM'),legend({'1sec','3sec','9sec'})
% figure,hold on, plot(idx1,AMtrans1,'r'),plot(idx2,AMtrans2,'g'),plot(idx3,AMtrans3,'b')
% axis([0 2.5 0 1]),xlabel('time in minutes'),ylabel('tpr'),title('tpr for fpr=0, AM'),legend({'1sec','3sec','9sec'})
clear imtpr1 imtpr2 imtpr3 amtpr1 amtpr2 amtpr3 

count=0;

for si=[1:3 5:10]
    si
    count=count+1;
    ngresds1{count}=dec_methods(gzerds1{si},t1,-1,1,'nrow',1,mt1,mn1);
    ngresds2{count}=dec_methods(gzerds2{si},t2,-1,1,'nrow',1,mt2,mn2);
    ngresds3{count}=dec_methods(gzerds3{si},t3,-1,1,'nrow',1,mt3,mn3);
%     
    idx_fpr=find(ngresds1{count}(1).out.fpr.nrow(m1,:)<=fpr_target);
    imfpr1(count)=ngresds1{count}(1).out.fpr.nrow(m1,idx_fpr(end));
    imtpr1(count)=ngresds1{count}(1).out.tpr.nrow(m1,idx_fpr(end));    
    imtpr_trans1(count)=ngresds1{count}(1).out.tpr_trans.nrow(m1,idx_fpr(end));    
    idx_fpr=find(ngresds2{count}(1).out.fpr.nrow(m2,:)<=fpr_target);
    imfpr2(count)=ngresds2{count}(1).out.fpr.nrow(m2,idx_fpr(end));
    imtpr2(count)=ngresds2{count}(1).out.tpr.nrow(m2,idx_fpr(end));
    imtpr_trans2(count)=ngresds2{count}(1).out.tpr_trans.nrow(m2,idx_fpr(end));
    idx_fpr=find(ngresds3{count}(1).out.fpr.nrow(m3,:)<=fpr_target);
    imfpr3(count)=ngresds3{count}(1).out.fpr.nrow(m3,idx_fpr(end));
    imtpr3(count)=ngresds3{count}(1).out.tpr.nrow(m3,idx_fpr(end));
    imtpr_trans3(count)=ngresds3{count}(1).out.tpr_trans.nrow(m3,idx_fpr(end));
    
    idx_fpr=find(ngresds1{count}(2).out.fpr.nrow(m1,:)<=fpr_target);
    amfpr1(count)=ngresds1{count}(2).out.fpr.nrow(m1,idx_fpr(end));
    amtpr1(count)=ngresds1{count}(2).out.tpr.nrow(m1,idx_fpr(end));
    amtpr_trans1(count)=ngresds1{count}(2).out.tpr_trans.nrow(m1,idx_fpr(end));
    idx_fpr=find(ngresds2{count}(2).out.fpr.nrow(m2,:)<=fpr_target);
    amfpr2(count)=ngresds2{count}(2).out.fpr.nrow(m2,idx_fpr(end));
    amtpr2(count)=ngresds2{count}(2).out.tpr.nrow(m2,idx_fpr(end));
    amtpr_trans2(count)=ngresds2{count}(2).out.tpr_trans.nrow(m2,idx_fpr(end));
    idx_fpr=find(ngresds3{count}(2).out.fpr.nrow(m3,:)<=fpr_target);
    amfpr3(count)=ngresds3{count}(2).out.fpr.nrow(m3,idx_fpr(end));
    amtpr3(count)=ngresds3{count}(2).out.tpr.nrow(m3,idx_fpr(end));
    amtpr_trans3(count)=ngresds3{count}(2).out.tpr_trans.nrow(m3,idx_fpr(end));
      
    idx_fpr=find(ngresds1{count}(3).out.fpr.nrow(m1,:)<=fpr_target);
    iamfpr1(count)=ngresds1{count}(3).out.fpr.nrow(m1,idx_fpr(end));
    iamtpr1(count)=ngresds1{count}(3).out.tpr.nrow(m1,idx_fpr(end));
    iamtpr_trans1(count)=ngresds1{count}(3).out.tpr_trans.nrow(m1,idx_fpr(end));
    idx_fpr=find(ngresds2{count}(3).out.fpr.nrow(m2,:)<=fpr_target);
    iamfpr2(count)=ngresds2{count}(3).out.fpr.nrow(m2,idx_fpr(end));
    iamtpr2(count)=ngresds2{count}(3).out.tpr.nrow(m2,idx_fpr(end));
    iamtpr_trans2(count)=ngresds2{count}(3).out.tpr_trans.nrow(m2,idx_fpr(end));
    idx_fpr=find(ngresds3{count}(3).out.fpr.nrow(m3,:)<=fpr_target);
    iamfpr3(count)=ngresds3{count}(3).out.fpr.nrow(m3,idx_fpr(end));
    iamtpr3(count)=ngresds3{count}(3).out.tpr.nrow(m3,idx_fpr(end));
    iamtpr_trans3(count)=ngresds3{count}(3).out.tpr_trans.nrow(m3,idx_fpr(end));
    
    idx_fpr=find(ngresds1{count}(4).out.fpr.nrow(m1,:)<=fpr_target);
    aimfpr1(count)=ngresds1{count}(4).out.fpr.nrow(m1,idx_fpr(end));
    aimtpr1(count)=ngresds1{count}(4).out.tpr.nrow(m1,idx_fpr(end));
    aimtpr_trans1(count)=ngresds1{count}(4).out.tpr_trans.nrow(m1,idx_fpr(end));
    idx_fpr=find(ngresds2{count}(4).out.fpr.nrow(m2,:)<=fpr_target);
    aimfpr2(count)=ngresds2{count}(4).out.fpr.nrow(m2,idx_fpr(end));
    aimtpr2(count)=ngresds2{count}(4).out.tpr.nrow(m2,idx_fpr(end));
    aimtpr_trans2(count)=ngresds2{count}(4).out.tpr_trans.nrow(m2,idx_fpr(end));
    idx_fpr=find(ngresds3{count}(4).out.fpr.nrow(m3,:)<=fpr_target);
    aimfpr3(count)=ngresds3{count}(4).out.fpr.nrow(m3,idx_fpr(end));
    aimtpr3(count)=ngresds3{count}(4).out.tpr.nrow(m3,idx_fpr(end));
    aimtpr_trans3(count)=ngresds3{count}(4).out.tpr_trans.nrow(m3,idx_fpr(end));
    
    
end
NROW=[mean(imtpr1) mean(imtpr2) mean(imtpr3); ...
    mean(amtpr1) mean(amtpr2) mean(amtpr3);...   
    mean(iamtpr1) mean(iamtpr2) mean(iamtpr3);...
    mean(aimtpr1) mean(aimtpr2) mean(aimtpr3);...
    mean(imtpr_trans1) mean(imtpr_trans2) mean(imtpr_trans3);...
    mean(amtpr_trans1) mean(amtpr_trans2) mean(amtpr_trans3);...
    mean(imfpr1) mean(imfpr2) mean(imfpr3); ...
    mean(amfpr1) mean(amfpr2) mean(amfpr3);...
    mean(aimfpr1) mean(aimfpr2) mean(aimfpr3);];

% for si=1:10
%     
%     resds1{si}=dec_methods(zerds1{si},6,-1,-1,'nrow',-1)
%     resds2{si}=dec_methods(zerds2{si},4,-1,-1,'nrow',-1)
%     resds3{si}=dec_methods(zerds3{si},2,-1,-1,'nrow',-1)
%     
% end