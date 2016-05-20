%clear C1 P1 Residual1 C2 P2 Residual2 C3 P3 Residual3 P4 Aaf Aad Aao Residual4 f
 %fO2HbA=[];fHHbA=[];fO2HbC=[];fHHbC=[];
 nL=200;
for iLfinder=1:nL
    
    L=iLfinder+9;
        
    fullprepr
    Aaf{iLfinder}=A;
    Aad{iLfinder}=Ad;
    Aao{iLfinder}=Ao;
    
    
    C1{iLfinder}=CO1;
    P1{iLfinder}=PO1;
    Residual1{iLfinder}=RO1;
    
    C2{iLfinder}=CO2;
    P2{iLfinder}=PO2;
    Residual2{iLfinder}=RO2;
    
    C3{iLfinder}=CH1;
    P3{iLfinder}=PH1;
    Residual3{iLfinder}=RH1;
    
    C4{iLfinder}=CH2;
    P4{iLfinder}=PH2;
    Residual4{iLfinder}=RH2;
    
    Trn{iLfinder}=N;
    PSD{iLfinder}={FO1 FO2 FH1 FH2};

end

for j=1:nL
% 
%     residual1(j)=mean(mean(squeeze(cell2mat(cat(3,Residual1{j}{:})))));
%     residual2(j)=mean(mean(squeeze(cell2mat(cat(3,Residual2{j}{:})))));
%     residual3(j)=mean(mean(squeeze(cell2mat(cat(3,Residual3{j}{:})))));
%     residual4(j)=mean(mean(squeeze(cell2mat(cat(3,Residual4{j}{:})))));
    f(j)=mean(Aaf{j});
    o(j)=mean(Aao{j});
    rd(j)=mean(Aad{j});
    fT(j)=mean(Trn{j}(5:6));
    fTo(j)=mean(Trn{j}(1:2));
    fTd(j)=mean(Trn{j}(3:4));
%     corrs1(j)=mean(mean(squeeze(cell2mat(cat(3,C1{j}{:})))));
%     pvals1(j)=mean(mean(squeeze(cell2mat(cat(3,P1{j}{:})))));
%     corrs2(j)=mean(mean(squeeze(cell2mat(cat(3,C2{j}{:})))));
%     pvals2(j)=mean(mean(squeeze(cell2mat(cat(3,P2{j}{:})))));
%     corrs3(j)=mean(mean(squeeze(cell2mat(cat(3,C3{j}{:})))));
%     pvals3(j)=mean(mean(squeeze(cell2mat(cat(3,P3{j}{:})))));
%     corrs4(j)=mean(mean(squeeze(cell2mat(cat(3,C4{j}{:})))));
%     pvals4(j)=mean(mean(squeeze(cell2mat(cat(3,P4{j}{:})))));
end

