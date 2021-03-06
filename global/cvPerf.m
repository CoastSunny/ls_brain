function [res]=cvPerf(Y,dv,dims,fIdxs,lossType,hpNms)
% cross-validate classifier performance computation
%
% [conf]=cvPerf(Y,dv,dims,fIdxs,lossType,hpNms)
%
% Inputs:
%  Y    -- [size(dv,dim(1:end-2) x nSubProb] set of true labels
%  dv   -- [n-d] set of decision values
%  dims -- [3 x 1] indicator of where different types of dimension are in dv:
%          dims(1:end-2) = trial dims
%          dims(end-1)   = binary sub-prob dim
%          dims(end)     = folds dim (train/test splits)
%  fIdxs-- [N x nFolds] set of -1/0/+1 fold membership indicators, as 
%          generated by gennFold/cvtrainFn ([-ones(N,1)])
%          OR
%          [N x nSubProb x nFolds] for per-sub-prob folding
%  hpNms- {str} names for the hyper-parameters
% Outputs:
% res       - results structure with fields
%   |.fold - per fold results
%   |     |.di      - dimInfo structure describing the contents of the matrices
%   |     |.soln    - {nSp x nHps x nFold} the solution for this fold (if recSoln if true)
%   |     |.f       - [N x nSp x nHps x nFold] classifiers predicted decision value
%   |     |.trnauc  - [1 x nSp x nHps x nFold] training set Area-Under-Curve value
%   |     |.tstauc  - [1 x nSp x nHps x nFold] testing set AUC
%   |     |.trnconf - [4 x nSp x nHps x nFold] training set binary confusion matrix
%   |     |.tstconf - [4 x nSp x nHps x nFold] testing set binary confusion matrix
%   |     |.trnbin  - [1 x nSp x nHps x nFold] training set binary classification performance
%   |     |.tstbin  - [1 x nSp x nHps x nFold] testing set binary classification performance
%   |.opt   - cv-optimised classifer parameters
%   |   |.soln - cv-optimal solution
%   |   |.f    - [N x nSp] cv-optimal predicted decision values
%   |   |.C    - [1x1] cv-optimal hyperparameter
%   |.di    - dimInfo structure describing contents of over folds ave matrices
%   |.f        - [N x nSp x nHps] set of full data solution decision values
%   |.soln     - {nSp x nHps} set of add data solutions
%   |.trnauc   - [1 x nSp x nHps] average over folds training set Area-Under-Curve value
%   |.trnauc_se- [1 x nSp x nHps] training set AUC standard error estimate
%   |.tstauc   - [1 x nSp x nHps] average over folds testing set AUC
%   |.tstauc_se- [1 x nSp x nHps] testing set AUC standard error estimate
%   |.trnconf  - [4 x nSp x nHps] training set binary confusion matrix
%   |.tstconf  - [4 x nSp x nHps] testing set binary confusion matrix
%   |.trnbin   - [1 x nSp x nHps] average over folds training set binary classification performance
%   |.trnbin_se- [1 x nSp x nHps] training set binary classification performance std error
%   |.tstbin   - [1 x nSp x nHps] testing set binary classification performance
%   |.tstbin_se- [1 x nSp x nHps] testing set binary classification performance std error
if ( nargin<3 || isempty(dims) ) dims=1:3; end;
if ( nargin<4 ) fIdxs=1; end;
if ( nargin<5 || isempty(lossType) ) lossType='bin'; end;
if ( nargin<6 || isempty(hpNms) ) hpNms={}; for i=1:ndims(dv)-numel(dims); hpNms{i}=sprintf('hp_%d',i); end; end;
if ( size(Y,1)~=size(dv,1) ) 
   error('decision values and targets must be the same size');
end
if(ndims(fIdxs)<=ndims(Y)) fIdxs=reshape(fIdxs,[size(fIdxs,1),1,size(fIdxs,2)]); end; %include subProb dim
trD=dims(1:end-2); spD=dims(end-1); fldD=dims(end); hpD=setdiff(1:ndims(dv),dims);
nFolds=size(dv,fldD);
nSubProbs=size(dv,spD);
szdv=size(dv); szdv(end+1:max([hpD,fldD]))=1;%dv=reshape(dv,[szdv(1) prod(szdv(2:end))]); % 2-d ify

% compress the multiple trial dims into a single one
otrD=trD;
if ( numel(trD)>1 ) 
  if ( max(trD)~=numel(trD) ) error('Not imp yet!'); end;
  dv=reshape(dv,[prod(szdv(trD)),szdv(setdiff(1:end,trD))]);
  oszdv=szdv; szdv=size(dv); szdv(end+1:max([hpD,fldD]))=1;
  szY=size(Y); 
  Y =reshape(Y,[prod(szY(1:numel(trD))) szY(numel(trD)+1:end) 1]);
  szfIdxs=size(fIdxs); 
  %include subProb dim, if not already there
  if(ndims(fIdxs)<=numel(trD)+1) szfIdxs=[szfIdxs(1:end-1) 1 szfIdxs(end)]; fIdxs=reshape(fIdxs,szfIdxs); end; 
  fIdxs = repmat(fIdxs,[szY(1:numel(trD))./szfIdxs(1:numel(trD)) 1]); % up-scale singlentons first
  fIdxs = reshape(fIdxs,[prod(szY(1:numel(trD))) szfIdxs(numel(trD)+1:end)]); % make 3-d
  % compute new dim locations
  trD=1; spD=spD-numel(otrD)+1; fldD=fldD-numel(otrD)+1; hpD=hpD-numel(otrD)+1;
end

% alloc space for results
trnconf=zeros([4,size(Y,2),szdv([hpD,fldD])]); tstconf=trnconf;
trnbin =zeros([1,size(Y,2),szdv([hpD,fldD])]); tstbin =trnbin;
trnauc =zeros([1,size(Y,2),szdv([hpD,fldD])]); tstauc =trnauc;
idx={};for d=1:ndims(dv); idx{d}=1:size(dv,d); end; % index expr extract-dv & store the result

% Next compute the per-fold values
for foldi=1:size(fIdxs,ndims(fIdxs));
  idx{fldD}=foldi;
   for spi=1:nSubProbs; % loop over sub-problems
     idx{spD}=spi;
     
      % get the training test split (possibly sub-prob specific)
      trnInd=fIdxs(:,min(end,spi),foldi)<0;  % training points
      tstInd=fIdxs(:,min(end,spi),foldi)>0;  % testing points
      exInd =fIdxs(:,min(end,spi),foldi)==0; % excluded points
      
      Ytrn  =Y(:,spi); Ytrn(tstInd)=0; Ytrn(exInd)=0;
      Ytst  =Y(:,spi); Ytst(trnInd)=0; Ytst(exInd)=0;
         
      trnconf(:,spi,idx{hpD},foldi) = dv2conf(Ytrn,dv(idx{:}));
      tstconf(:,spi,idx{hpD},foldi) = dv2conf(Ytst,dv(idx{:}));
      trnbin (:,spi,idx{hpD},foldi) = conf2loss(trnconf(:,spi,idx{hpD},foldi),1,lossType);
      tstbin (:,spi,idx{hpD},foldi) = conf2loss(tstconf(:,spi,idx{hpD},foldi),1,lossType);
      trnauc (:,spi,idx{hpD},foldi) = dv2auc(Ytrn,dv(idx{:}));
      tstauc (:,spi,idx{hpD},foldi) = dv2auc(Ytst,dv(idx{:}));
   end % loop over sub-problems
end;
szRes=size(trnauc); szRes(end+1:3)=1; % ensure is at least 3 dims
if (numel(dims)>3) % multiple trial dims
  szRes(end+1:max(dims)-1)=1; 
else szRes(end+1:max(dims)-1)=1; % 1 trial dim
end;
% make dimInfo to describe the results
di=mkDimInfo(szRes);
di(1).name='perf';di(2).name='subProb';
for i=1:numel(hpNms); di(i+2).name=hpNms{i}; end; 
di(end-1).name='fold';di(end).name='dv';

foldD=n2d(di,'fold');
[di(foldD).extra.fIdxs]=num2csl(fIdxs,1);
di(foldD).info.fIdxs=fIdxs;
res.fold.f =dv;
res.fold.di=di;
res.fold.trnconf=trnconf;res.fold.tstconf=tstconf;
res.fold.trnbin =trnbin; res.fold.tstbin =tstbin;
res.fold.trnauc =trnauc; res.fold.tstauc =tstauc;


res.di     = di(setdiff(1:end,foldD)); 
res.trnconf= sum(res.fold.trnconf,foldD);
res.tstconf= sum(res.fold.tstconf,foldD);
res.trnbin = mean(res.fold.trnbin,foldD);
res.trnbin_se=sqrt((sum(res.fold.trnbin.^2,foldD)/nFolds-(res.trnbin.^2))/nFolds);
res.tstbin = mean(res.fold.tstbin,foldD);
res.tstbin_se=sqrt((sum(res.fold.tstbin.^2,foldD)/nFolds-(res.tstbin.^2))/nFolds);
res.trnauc = mean(res.fold.trnauc,foldD);
res.trnauc_se=sqrt((sum(res.fold.trnauc.^2,foldD)/nFolds-(res.trnauc.^2))/nFolds);
res.tstauc = mean(res.fold.tstauc,foldD);
res.tstauc_se=sqrt((sum(res.fold.tstauc.^2,foldD)/nFolds-(res.tstauc.^2))/nFolds);
return;
%----------------------------------------------------------
function testCase();
L=4;
Yl=floor(rand(100,1)*L);
Y =lab2ind(Yl);
fIdxs=gennFold(Y,10);
dv=randn([size(Y) 10]);
[res]=cvPerf(Y,dv,[1 2 3],fIdxs);

dims=n2d(res.prep(end).info.res.fold.di,{'perf' 'subProb' 'fold'});
[res]=cvPerf(res.Y,res.prep(end).info.res.fold.f,dims,res.prep(end).info.res.fold.di(dims(3)).info.fIdxs);
