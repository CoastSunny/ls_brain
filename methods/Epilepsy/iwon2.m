
vD=vD1;DP=DP1;DRP=DRP1;
threshold=100;
sel=100;
clear ndn ndp ddp VNV VNV2 IP IN tpx tprx

for i=1:numel(subj)
    
    temp=vD{i}(vD{i}>0);
    if ~isempty(temp)
        dtp{i}=temp(Mx{i}<threshold);        
        VNV(i,:)=[sum(dtp{i}==2) sum(dtp{i}==4) sum(dtp{i}==3)];
    else
        dtp{i}=0;
    end
    dfp(i)=numel(Mrx{i}(Mrx{i}<threshold));
    PP{i}={DP{i}(Mx{i}<threshold) DRP{i}(Mrx{i}<threshold)};
    dddp{i}=DP{i}(Mx{i}<threshold);
    dddrp{i}=DRP{i}(Mrx{i}<threshold);
    temp=[PP{i}{1} PP{i}{2}];
    [x idx]=sort(temp);    
    if ~isempty(temp) & dtp{i}~=0
        ddp{i}=x(end-min(sel,numel(temp))+1:end);
        temp2=idx(end-min(sel,numel(temp))+1:end);
        idx_p=temp2(temp2<=numel(DP{i}(Mx{i}<threshold)));
        idx_n=temp2(temp2>numel(DP{i}(Mx{i}<threshold)));
        ndp(i)=sum(temp2<=numel(DP{i}(Mx{i}<threshold)));
        ndn(i)=sum(temp2>numel(DP{i}(Mx{i}<threshold)));       
        VNV2(i,:)=[sum(dtp{i}(idx_p)==2) sum(dtp{i}(idx_p)==4) sum(dtp{i}(idx_p)==3)];
        IP{i}=idx_p;
        IN{i}=idx_n-numel(DP{i}(Mx{i}<threshold));
        temp=TPX{i}(:,:,Mx{i}<threshold);
        tpx{i}=temp(:,:,idx_p);
        temp=TPRX{i}(:,:,Mrx{i}<threshold);
        tprx{i}=temp(:,:,idx_n-numel(DP{i}(Mx{i}<threshold)));
    elseif ~isempty(temp) & i~=14
        ndn(i)=min(sel,numel(temp));        
        temp2=idx(end-min(sel,numel(temp))+1:end);
        temp=TPRX{i}(:,:,Mrx{i}<threshold);
        tprx{i}=temp(:,:,temp2);
    end

end