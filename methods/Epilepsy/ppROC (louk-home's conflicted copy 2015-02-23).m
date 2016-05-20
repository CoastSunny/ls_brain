% th=0.5;
% detect_perf5
% ppi=50:50:2500;
% for roci=31:numel(ppi)
% 
%     ppcount=ppi(roci);
%     oneclEp
%     mppTP(roci)=mean(ppTP);
%     mppFP(roci)=mean(ppFP);
%     mnTP(roci)=mean(nTP);
%     mnFP(roci)=mean(nFP);
%     
% end

pi=0.5:0.1:.9;
for roci=1:numel(pi)

    th=pi(roci);
    detect_perf5
    mpTP2(roci)=mean(TPR(:,1));
    mpFP2(roci)=mean(FP)/240000;
    
end

