clear Jsv_parvector Nsv_parvector dist_par JsvRes NsvRes;
ts=0.10;
td=0.01;
te=0.31;
distribution='tlocationscale';
no_trials=1260;
k=1;
for s=0.04;%0.01:0.002:0.08
for t=ts:td:te;
    
    j = t * inv ( td ) - ( ts * inv ( td ) - 1 );
    j=round(j);
    [D,y,r,w]=ls_tracking(JG,'LS',t,s);
    for i=1:no_trials;JsvRes(i,j)=D(i).res;end;
    [Jf(:,j) x]=ksdensity(JsvRes(:,j),'width',0.01);
    
    %JsvPD=fitdist(JsvRes(:,j),distribution);
    %Jsv_parvector(:,j) = [JsvPD.mu JsvPD.sigma JsvPD.nu];
   
    [D,y,r,w]=ls_tracking(NG,'LS',t,s);
    for i=1:no_trials;NsvRes(i,j)=D(i).res;end;
    [Nf(:,j) x]=ksdensity(NsvRes(:,j),'width', 0.01);
    
    %NsvPD=fitdist(NsvRes(:,j),distribution);
    %Nsv_parvector(:,j) = [NsvPD.mu NsvPD.sigma NsvPD.nu];
    
    dist_par(j,k)=norm(Jf(:,j)-Nf(:,j));
    %dist_par(j,k)=norm(Jsv_parvector(:,j)-Nsv_parvector(:,j));
    
end

k=k+1

end
