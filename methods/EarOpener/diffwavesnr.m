G=APLO3;
clear SNRdw SNRs SNRd
rand_ind=randperm(300);
members=sort(properties(G));
for k=1:3%numel(members)
    
    S=G.(members{k}).copy;
    [dw Dwt]=S.default.diff_wave('trials','all','classes',{{22};{16}},'channels',1:64,'time',1:64,'blocks_in',1:4,'vis','off');
    if (size(Dwt,2)>1);Dwt=mean(Dwt,2);end;
    [avs]=S.default.plot('trials','all','classes',{{22}},'channels',1:64,'time',1:64,'blocks_in',1:4,'vis','off');
    if (size(avs.full.trial,2)>1);avs.full.trial=mean(avs.full.trial,2);end;
    avs.avg=mean(avs.avg);
    [avd]=S.default.plot('trials','all','classes',{{16}},'channels',1:64,'time',1:64,'blocks_in',1:4,'vis','off');
    avd.avg=mean(avd.avg);
    if (size(avd.full.trial,2)>1);avd.full.trial=mean(avd.full.trial,2);end;
    for trav=1:20;
        dwt=[];avst=[];avdt=[];
        for i=1:trav:(300-trav+1)
            
            dwt(end+1,:)=mean(Dwt( i:i+(trav-1),:,: ),1);
            avst(end+1,:)=mean(avs.full.trial( i:i+(trav-1),:,1:64),1);
            avdt(end+1,:)=mean(avd.full.trial( i:i+(trav-1),:,1:64),1);
            
        end
        Noisedw=repop(dwt,'-',dw);
        Noises=repop(avst,'-',mean(avs.avg));
        Noised=repop(avdt,'-',mean(avd.avg));
        
        SNRdw(trav,k) = var(dw)./mean(var(Noisedw',0,1));
        SNRs(trav,k) = var(avs.avg)./mean(var(Noises',0,1));
        SNRd(trav,k) = var(avd.avg)./mean(var(Noised',0,1));
        
    end
end
