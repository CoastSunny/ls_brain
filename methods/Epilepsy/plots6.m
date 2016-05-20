%  figure,hold on
% plot(5:10,a05(5:10),'b','Linewidth',4)
% plot(5:10,a03(5:10),'r','Linewidth',4)
% plot(5:10,a01(5:10),'g','Linewidth',4)
% % plot(5:10,a006(5:10),'k','Linewidth',4)
% 
% plot(5:10,b05(5:10),'b-.','Linewidth',4)
% plot(5:10,b03(5:10),'r-.','Linewidth',4)
% plot(5:10,b01(5:10),'g-.','Linewidth',4)
% % plot(5:10,b006(5:10),'k-.','Linewidth',4)
% % 
% figure,hold on
% plot(5:10,c05(5:10),'b','Linewidth',4)
% plot(5:10,c03(5:10),'r','Linewidth',4)
% plot(5:10,c01(5:10),'g','Linewidth',4)
% % plot(5:10,c006(5:10),'k','Linewidth',4)
% 
% d05=b05./a05;
% d03=b03./a03;
% d01=b01./a01;
% figure,hold on
% plot(5:10,d05(5:10),'b','Linewidth',4)
% plot(5:10,d03(5:10),'r','Linewidth',4)
% plot(5:10,d01(5:10),'g','Linewidth',4)

thth=399;
detect_perf5
% TPR=TPR([0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 1 1 0 1 1 1 1]>0,:);
% FP=FP([0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 1 1 0 1 1 1 1]>0);
mean(TPR),mean(FP)/20
a1=nanmean(Pspec_pred);
b1=nanmean(Pspec_vis);
c1=nanmean(Pspec_vis2);
d1=nanmean(Pspec_nvis);
sa1=nanstd(Pspec_pred);
sb1=nanstd(Pspec_vis);
sc1=nanstd(Pspec_vis2);
sd1=nanstd(Pspec_nvis);
TPR1=TPR;
FP1=FP;
TPX1=TPX;TPRX1=TPRX;
vD1=vD;pD1=pD;NV1=nV;NNV1=nnV;DP1=DP;DRP1=DRP;
thth=699;
detect_perf5
% TPR=TPR([0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 1 1 0 1 1 1 1]>0,:);
% FP=FP([0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 1 1 0 1 1 1 1]>0);
mean(TPR),mean(FP)/20
a2=nanmean(Pspec_pred);
b2=nanmean(Pspec_vis);
c2=nanmean(Pspec_vis2);
d2=nanmean(Pspec_nvis);
sa2=nanstd(Pspec_pred);
sb2=nanstd(Pspec_vis);
sc2=nanstd(Pspec_vis2);
sd2=nanstd(Pspec_nvis);
TPR2=TPR;
FP2=FP;
TPX2=TPX;TPRX2=TPRX;
vD2=vD;pD2=pD;NV2=nV;NNV2=nnV;DP2=DP;DRP2=DRP;
thth=999;
detect_perf5
% TPR=TPR([0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 1 1 0 1 1 1 1]>0,:);
% FP=FP([0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 1 1 0 1 1 1 1]>0);
mean(TPR),mean(FP)/20
a3=nanmean(Pspec_pred);
b3=nanmean(Pspec_vis);
c3=nanmean(Pspec_vis2);
d3=nanmean(Pspec_nvis);
sa3=nanstd(Pspec_pred);
sb3=nanstd(Pspec_vis);
sc3=nanstd(Pspec_vis2);
sd3=nanstd(Pspec_nvis);
TPR3=TPR;
FP3=FP;
TPX3=TPX;TPRX3=TPRX;
vD3=vD;pD3=pD;NV3=nV;NNV3=nnV;DP3=DP;DRP3=DRP;

thth=1999;
detect_perf5
% TPR=TPR([0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 1 1 0 1 1 1 1]>0,:);
% FP=FP([0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 1 1 0 1 1 1 1]>0);
mean(TPR),mean(FP)/20
a4=nanmean(Pspec_pred);
b4=nanmean(Pspec_vis);
c4=nanmean(Pspec_vis2);
d4=nanmean(Pspec_nvis);
sa4=nanstd(Pspec_pred);
sb4=nanstd(Pspec_vis);
sc4=nanstd(Pspec_vis2);
sd4=nanstd(Pspec_nvis);
TPR4=TPR;
FP4=FP;
TPX4=TPX;TPRX4=TPRX;
vD4=vD;pD4=pD;NV4=nV;NNV4=nnV;DP4=DP;DRP4=DRP;

thth=3999;
detect_perf5
% TPR=TPR([0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 1 1 0 1 1 1 1]>0,:);
% FP=FP([0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 1 1 0 1 1 1 1]>0);
mean(TPR),mean(FP)/20
a5=nanmean(Pspec_pred);
b5=nanmean(Pspec_vis);
c5=nanmean(Pspec_vis2);
d5=nanmean(Pspec_nvis);
sa5=nanstd(Pspec_pred);
sb5=nanstd(Pspec_vis);
sc5=nanstd(Pspec_vis2);
sd5=nanstd(Pspec_nvis);
TPR5=TPR;
FP5=FP;
TPX5=TPX;TPRX5=TPRX;
vD5=vD;pD5=pD;NV5=nV;NNV5=nnV;DP5=DP;DRP5=DRP;





% CL=[mean(rfSS001); mean(rfSS005);mean(rfSS01);mean(rfSS02);mean(rfSS03);mean(rfSS04);mean(rfSS05)];