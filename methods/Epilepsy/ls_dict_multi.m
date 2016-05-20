Ns=size(fXs,1);Ni=size(fXi,1);
trn=1:round(size(x,3));
rtrn=1:round(size(rx,3));
% trn=1:30;
%tst=(round(size(Xi,2)/2)+1):size(Xi,2);
% KSRDL
optionKSRDL.lambda=0.1;
optionKSRDL.SCMethod='nnqpAS'; % can be nnqpAS, l1qpAS, nnqpIP, l1qpIP, l1qpPX, nnqpSMO, l1qpSMO
optionKSRDL.dicPrior='uniform'; % can be uniform, Gaussian
optionKSRDL.kernel='linear';
optionKSRDL.param=2^0;
optionKSRDL.iter=20;
optionKSRDL.dis=0;
optionKSRDL.residual=1e-4;
optionKSRDL.tof=1e-4;

s = RandStream('swb2712','Seed',1);
RandStream.setGlobalStream(s);
k=5;
%
%  x=xi;
% 
% % fX=[fXs;fXi];
% % Hc=computeKernelMatrix(fX(:,trn),fX(:,trn),optionKSRDL);
% % [DtDc,Yc,Dc,pinvYc]=KSRDL(fX(:,trn),Hc,k,optionKSRDL);
% % Ds=Dc(1:size(fXs,1),:);
% % Ds=normc(Ds);
% % disp(['The final residual2 is ',num2str(norm(fXs-Ds*Yc,'fro'))]);
% 
H=randn(size(x,1),size(x,3));
for trial=trn
Xs(:,trial)=pinv(H(:,trial))*rx(:,:,trial);
end
Xs=normc(Xs);
Ks=computeKernelMatrix(Xs(:,trn),Xs(:,trn),optionKSRDL);
[DtDs,Ys,Ds,pinvYs,Hs]=KSRDL_multi(Xs(:,trn),rx(:,:,trn),Ks,k,H,Ds,optionKSRDL);
xout=[];
for trial=trn
    xout(:,:,trial)=Hs(:,trial)*(Ds*Ys(:,trial))';
%     for channel=1:size(xout,1)
%         xout(channel,:,trial)=xout(channel,:,trial)/norm(xout(channel,:,trial));
%     end
end

% Hrs=computeKernelMatrix(rXs(:,rtrn),rXs(:,rtrn),optionKSRDL);
% [DtDrs,Yrs,Drs,pinvYrs]=KSRDL(rXs(:,rtrn),Hrs,k,optionKSRDL);
% 
% Dsrs=[Ds Drs];Dsrs=normc(Dsrs);





