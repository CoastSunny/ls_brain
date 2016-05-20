global bciroot;
bciroot = { '/Volumes/BCI_Data/' '/media/LoukStorage/' };

expt='combined_eeg_nirs_2011';
subjects={ 'C4' 'C6' 'C7' 'C8' 'C9' 'C10' 'C11' 'T2' 'T3' 'T4' 'T5' 'T6' 'T9' 'T10' };
clear folds
clear decisionvalues

% 
% for si=1:numel(subjects)
%     
%     subj=subjects{si};
%     
%     z=jf_load(expt,subj,'control');
%     z=jf_reref(z,'dim','time'); % remove DC offset
%     
%     z=jf_reref(z,'dim','ch','wght','robust');
%     z=jf_detrend(z,'dim','time');
%     
%     z=jf_retain(z,'dim','time','range','between','vals',[0 15000],'valmatch','nearest','summary','1s win');
%     
%     z=jf_addClassInfo(z,'markerdict',struct('marker',[1 2 3],'label',{{'rest' 'AM' 'IM'}}));
%     z=jf_addClassInfo(z,'spType',{{{'rest'} {'AM'}}...
%         {{'rest'} {'IM'}}},'summary','rest vs move');    
%     
%     z=jf_windowData(z,'dim','time','width_ms',3000,'overlap',0);
%     z.Y=repmat(reshape(z.Y,[size(z.Y,1) 1 size(z.Y,2)]),[1,size(z.X,n2d(z,'window'))]);
%     z.Ydi=mkDimInfo(size(z.Y),{'epoch','window','subProb'});
%     
%     z.foldIdxs=gennFold(z.Y,10);
%     
%     z=jf_welchpsd(z,'width_ms',250,'log',1,'detrend',1);
%     
%     z=jf_retain(z,'dim','freq','range','between','vals',[8 24], 'valmatch','nearest');
%     
%     jf_disp(z)
%     zz(si)=z;
%     
% end
% 
% zall=jf_cat(zz,'dim','epoch');

for si=1:numel(subjects)       
    
z = zall;
trnInd = floor([z.di(n2d(z,'epoch')).extra.src])~=si;
z.outfIdxs = zeros(size(z.Y,1),1); z.outfIdxs(trnInd)=-1; z.outfIdxs(~trnInd)=1; % outer-fold 
z = jf_cvtrain(jf_compKernel(z),'mcPerf',0);

%     if ( isfield(z,'outfIdxs') ) % compute outer fold performance info
%         z.prep(end).info.res.opt.res = cvPerf(z.Y,z.prep(end).info.res.opt.f,[1 2 3],z.outfIdxs);
%         z.prep(end).info.res.opt.res.di(2) = z.prep(end).info.res.di(2); % update subprob info
%     end

SIdecisionvalues{si} = z.prep(end).info.res.tstf(:,:,z.prep(end).info.res.opt.Ci); 

try
G.(subjects{si}).default.addprop('SIeeg');
catch err
end

temp=repmat(trnInd,5,1);
outI=~temp(:);

dv=SIdecisionvalues{si}(outI,:);

am=dv(:,1);
am=reshape(am,36,5);
im=dv(:,2);
im=reshape(im,36,5);

G.(subjects{si}).default.SIeeg.fam=am(1:24,:);
G.(subjects{si}).default.SIeeg.fim=im([1:12 25:36],:);

dvtrain=SIdecisionvalues{si}(~outI,:);

am=dvtrain(:,1);
am=reshape(am,468,5);
im=dvtrain(:,2);
im=reshape(im,468,5);

amI=repmat([ones(1,24) zeros(1,12)],1,13);
imI=repmat([ones(1,12) zeros(1,12) ones(1,12)],1,13);

G.(subjects{si}).default.SIeeg.tfam=am(logical(amI),:);
G.(subjects{si}).default.SIeeg.tfim=im(logical(imI),:);

end
