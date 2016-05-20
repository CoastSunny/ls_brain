for si=1:10
    
    y=Y{si};
    dvAMval=decision_values{si}(outfIdxs{si}==-1 & y(:,2)~=0,2);
    yy=Y{si}(outfIdxs{si}==-1 & y(:,2)~=0,2);
    vout{si}=rocCalibrate(dvAMval,yy,-1,opts);
    
    dvAMasynch=decision_values{si}(outfIdxs{si}==1 & y(:,2)~=0,2);
    yy=Y{si}(outfIdxs{si}==1 & y(:,2)~=0,2);
    aout{si}=rocCalibrate(dvAMasynch,yy,-1,opts);

end