function [classifier,res]=cvtrainKernelClassifier(X,Y,Cs,fIdxs,varargin)
% train a regularised linear classifier with reg-parameter tuning by cross validation
% 
% [classifier,res]=trainLinearClassifier(X,Y,Cs,fIdxs,varargin)
%
% N.B. use applyLinearClassifier to apply the learned model to new data.
%
% Inputs:
%  X - [n-d float] the data to classify/train on
%  Y - [size(X,dim) x 1] set of 1:nSp per trial labels
%      OR
%      [size(X,dim) x nSp] set of -1/0/+1 per-subproblem labels, where 0 indicates an ignored point
%  Cs      - [1 x nCs] set of penalties to test                            ([10^(-3:3) 0])
%  fIdxs   - [size(Y,1) x nFold] logical matrix indicating which trials
%            to use in each fold, 
%               -1 = training trials, 0 = excluded trials,  1 = testing trials
%            OR
%            [1 x 1] number of folds to use (only for Y=trial labels).     (10)
%            or
%            [size(Y) x nFold x nCls] logical matrix indicating trials for each sub-prob per fold
% Options:
%  dim    - [int] the dimension(s) of X which contain the trials            (ndims(X))
%  objFn  - [str] which objetive function to optimise,                      ('klr_cg')
%  Cscale - [float] scaling parameter for the penalties                     (.1*var(X))
%             N.B. usually auto computed from the data, set to 1 to force input Cs  
%  balYs  - [bool] balance the labels of sets                               (0)
%  spType - [str] sub-problem decomposition to use for multi-class. one-of '1v1' '1vR' ('1v1')
%  spKey  - [Nx1] set of all possible label values                          ([])
%  spMx   - [nSp x nClass] encoding/decoding matrix to map from class labels to/from binary 
%           subProblems                                                     ([])
% Outputs:
%  classifier -- [struct] containing all the information about the linear classifier
%           |.w -- [size(X) x nSp] weighting over X (for each subProblem)
%           |.b -- [nSp x 1] bias term
%           |.dim -- [ind] dimensions of X which contain the trails
%  res   -- [struct] results structure as returned by cvtrainFn
opts=struct('objFn','klr_cg','dim',[],'spType','1v1','spKey',[],'spMx',[],'zeroLab',0,...
            'balYs',0,'verb',0,'Cscale',[],'compKernel',1,'par1',[],'par2',[],'kerType',[]);
if( nargin < 3 ) Cs=[]; end;
if( nargin < 4 || isempty(fIdxs) ) fIdxs=10; end;
opts=parseOpts(opts,varargin);
dim=opts.dim; if ( isempty(dim) ) dim=ndims(X); end;
dim(dim<0)=dim(dim<0)+ndims(X)+1; % convert negative to positive indicies

if( ndims(Y)==2 && size(Y,1)==1 && size(Y,2)>1 ) Y=Y'; end; % col vector only
% build a multi-class decoding matrix
spKey=opts.spKey; spMx =opts.spMx;
if ( ~(isempty(spKey) && isempty(spMx)) ) % sub-prob decomp already done, so trust it
  if ( ~all(Y(:)==-1 | Y(:)==0 | Y(:)==1) ) 
    error('spKey/spMx given but Y isnt an set of binary sub-problems');
  end
elseif ( size(Y,2)==1 && all(Y(:)==-1 | Y(:)==0 | Y(:)==1) && ~(opts.zeroLab && any(Y(:)==0)) ) % already a valid binary problem
    spKey=[1 -1]; % binary problem
    spMx =[1 -1];
else
  [Y,spKey,spMx]=lab2ind(Y,spKey,spMx,opts.zeroLab); % convert to binary sub-problems
end
spDesc=mkspDesc(spMx,spKey);
  
% build a folding -- which is label aware, and aware of the sub-prob encoding type
if ( numel(fIdxs)==1 ) fIdxs=gennFold(Y,fIdxs,'dim',numel(dim)+1); end;
if ( opts.balYs ) [fIdxs] = balanceYs(Y,fIdxs); end % balance the folding if wanted

% estimate good range hype-params
Cscale=opts.Cscale;
if ( isempty(Cscale) || isequal(Cscale,'l2') )  Cscale=CscaleEst(X,2,[],0);
elseif ( isequal(Cscale,'l1') )                 Cscale=sqrt(CscaleEst(X,2,[],0));
end
if ( isempty(Cs) ) Cs=[5.^(1:-1:-9)]; end;

oX=X; odim=dim; szX=size(X); szY=size(Y); szF=size(fIdxs);
if ( numel(dim)>1 ) % make n-d problem into 1-d problem
  X=reshape(X,[prod(szX(1:min(dim)-1)) prod(szX(dim))]);
  Y=reshape(Y,[prod(szY(1:numel(dim))) szY(numel(dim)+1:end) 1]);
  % scale up fIdxs to Y size if necess
  if ( any(szF(1:numel(dim))==1) && any(szF(1:numel(dim))~=szY(1:numel(dim))) )
     fIdxs=repmat(fIdxs,[szY(1:numel(dim))./szF(1:numel(dim)) ones(1,ndims(fIdxs)-numel(dim))]);
     szF=size(fIdxs); % new size
  end
  fIdxs=reshape(fIdxs,[prod(szY(1:numel(dim))) szF(numel(dim)+1:end) 1]);
  dim=2; % now trial dim is 2nd dimension
end

% compute the kernel if needed for kernel methods
if ( opts.compKernel ) 
   % compute kernel
   if ( opts.verb>0 ) fprintf('CompKernel..');  end;   
   kerType=opts.kerType;par1=opts.par1;par2=opts.par2;
   if strmatch('linear',kerType)
       X = compKernel(X,[],kerType,'dim',dim); %dim=2;  
   else
       X = compKernel(X,[],kerType,'dim',dim,par1,par2); %dim=2;  
   end
   if ( opts.verb>0 ) fprintf('..done\n'); end;
end

% call cvtrain to do the actual work
%res=cvtrainFn(opts.objFn,X,Y,Cscale*Cs,fIdxs,'dim',dim,varargin{:}); 
res=cvtrainFn(opts.objFn,X,Y,Cscale*Cs,fIdxs); 

% Extract the classifier weight vector(s)
% best hyper-parameter for all sub-probs, N.B. use the same C for all sub-probs to ensure multi-class is OK
[opttstbin,optCi]=max(mean(res.tstbin,2)+mean(res.tstauc,2),[],3); 
for isp=1:size(Y,2); % get soln for each subproblem
   if ( isfield(res,'opt') && isfield(res.opt,'soln') ) % optimal calibrated solution trained on all data
      soln  = res.opt.soln{isp};
   else
      soln  = res.soln{isp,optCi(isp)}; 
   end
   W(:,isp) = soln(1:end-1); b(isp)=soln(end);
end
if ( ~opts.compKernel ) % input space classifier, just extract
   W=reshape(W,[szX(1:min(odim)-1) size(W,2)]);    
else % kernel method. extract the weights
   if ( numel(odim)>1 ) W=reshape(W,[szX(odim) size(W,2)]); end;
   Xidx=1:ndims(oX); Xidx(odim)=-odim; % convert from dual(alpha) to primal (W)
   W   = tprod(oX,Xidx,W,[-odim ndims(oX)+1]);
end
if dim==4
    trX=oX(:,:,:,Y~=0);
elseif dim==2
    trX=oX(:,Y~=0);    
elseif dim==3
    trX=oX(:,:,Y~=0);
elseif dim==5
    trX=oX(:,:,:,:,Y~=0);
end
b=soln(end);
soln=soln(Y~=0);
% put all the parameters into 1 structure
classifier = struct('W',W,'b',b,'dim',dim,'spMx',spMx,'spKey',spKey,...
    'kerType',kerType,'alpha',[soln' b],'trX',trX,'par1',par1,'par2',par2);
return;
%-----------------------------------------------------------------------------
function testCase()

[X,Y]=mkMultiClassTst([-1 0 0 0; 1 0 0 0; .2 .5 0 0],[400 400 50],[.3 .3 0 0; .3 .3 0 0; .2 .2 0 0],[],[-1 1 1]);
[classifier,res]=cvtrainLinearClassifier(X,Y,[],10);
% 2d features
X=reshape(X,[2 2 size(X,2)]);
[classifier,res]=cvtrainLinearClassifier(X,Y,[],10);
[classifier,res]=cvtrainLinearClassifier(X,Y,[],10,'objFn','lr_cg','compKernel',0); % non-kernel method
% 2d epochs
szX=size(X); X=reshape(X,[szX(1:end-1) szX(end)/2 2]); Y=reshape(Y,size(Y,1)/2,2);
[classifier,res]=cvtrainLinearClassifier(X,Y,[],10,'dim',[-2 -1]);
[classifier,res]=cvtrainLinearClassifier(X,Y,[],10,'objFn','lr_cg','compKernel',0,'dim',[-2 -1]);

f=applyLinearClassifier(X,classifier);



[ans,optCi]=max(res.tstbin,[],3);  % check the results are identical
clf;plot([res.f(:,1,optCi),f2(:)]);

% multi-class test
[X,Y]=mkMultiClassTst([-1 0; 1 0; .2 .5],[400 400 50],[.3 .3; .3 .3; .2 .2],[],[1 2 3]);[dim,N]=size(X);
[classifier,res]=cvtrainLinearClassifier(X,Y,[],10,'spType','1vR');
[classifier,res]=cvtrainLinearClassifier(X,Y,[],10,'spType','1v1');
fldD = n2d(res.fold.di,'fold'); spD = n2d(res.fold.di,'subProb');
cvmcPerf(Y,res.fold.f,[1 spD fldD],res.fold.di(fldD).info.fIdxs,classifier.spMx,classifier.spKey)