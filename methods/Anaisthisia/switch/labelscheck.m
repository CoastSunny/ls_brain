opts.fpr=0.05;
pc=-1;

for si=1:10

tmp=decision_values{si};
y=Y{si};
fpr=sum(tmp(outfIdxs{si}==1,1)<=0 & y(outfIdxs{si}==1,1)==1)/sum(y(outfIdxs{si}==1,1)==1);
tpr=sum(tmp(outfIdxs{si}==1,1)<=0 & y(outfIdxs{si}==1,1)==-1)/sum(y(outfIdxs{si}==1,1)==-1);
Res_Im(si,:)=[fpr tpr];

fpr=sum(tmp(outfIdxs{si}==1,2)<=0 & y(outfIdxs{si}==1,2)==1)/sum(y(outfIdxs{si}==1,2)==1);
tpr=sum(tmp(outfIdxs{si}==1,2)<=0 & y(outfIdxs{si}==1,2)==-1)/sum(y(outfIdxs{si}==1,2)==-1);
Res_Am(si,:)=[fpr tpr];

dv=tmp(outfIdxs{si}==1,1);
y=Y{si}(outfIdxs{si}==1,1);
roc=rocCalibrate(dv,y,pc,opts);
Cal_Im(si,:)=[roc.calfpr roc.caltpr];

dv=tmp(outfIdxs{si}==1,2);
y=Y{si}(outfIdxs{si}==1,2);
roc=rocCalibrate(dv,y,pc,opts);
Cal_Am(si,:)=[roc.calfpr roc.caltpr];

end


for si=1:10
    
    tmp=decision_values{si};
    y=Y{si};
    dvim=tmp(outfIdxs{si}==1 &  y(:,1)~=0);
    figure,hold,plot(y(outfIdxs{si}==1 & y(:,1)~=0,1))
    plot(dvim,'r'),title(['IM ' num2str(si)]),grid,axis([0 300 -2 2])
    dvam=tmp(outfIdxs{si}==1 &  y(:,2)~=0);
    figure,hold,plot(y(outfIdxs{si}==1 & y(:,2)~=0,2))
    plot(dvam,'r'),title(['AM ' num2str(si)]),grid,axis([0 300 -2 2])
    
end

figure,bar([Res_in; mean(Res_in)]),axis([0 13 0 1]),title('Validation set, 1sec '),legend({'IM' 'AM'}),grid
figure,bar([Res_out; mean(Res_out)]),axis([0 13 0 1]),title('Outer fold, asynch'),legend({'IM' 'AM'}),grid
figure,bar([Res_Im; mean(Res_Im)]),axis([0 13 0 1 ]),title('IM, fpr tpr'),legend({'FPR' 'TPR'}),grid
figure,bar([Res_Am; mean(Res_Am)]),axis([0 13 0 1 ]),title('AM, fpr tpr'),legend({'FPR' 'TPR'}),grid
figure,bar([Cal_Im; mean(Cal_Im)]),axis([0 13 0 1 ]),title('IMcal, fpr tpr'),legend({'FPR' 'TPR'}),grid
figure,bar([Cal_Am; mean(Cal_Am)]),axis([0 13 0 1 ]),title('AMcal, fpr tpr'),legend({'FPR' 'TPR'}),grid

for si=1:10
    
    tmp=decision_values{si};
    y=Y{si};
    dvim=tmp(outfIdxs{si}==-1 &  y(:,1)~=0);
    figure,hold,plot(y(outfIdxs{si}==-1 & y(:,1)~=0,1))
    plot(dvim,'r'),title(['IM ' num2str(si)]),grid,axis([0 300 -2 2])
    dvam=tmp(outfIdxs{si}==-1 &  y(:,2)~=0);
    figure,hold,plot(y(outfIdxs{si}==-1 & y(:,2)~=0,2))
    plot(dvam,'r'),title(['AM ' num2str(si)]),grid,axis([0 300 -2 2])
    
end
