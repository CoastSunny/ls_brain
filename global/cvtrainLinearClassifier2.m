function [classifier,res]=cvtrainLinearClassifier2(X,Y,Cs,fIdxs,varargin)
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
            'balYs',0,'verb',0,'Cscale',[],'fIdxs',[],'calibrate',[],'w_template',[]);
[opts,varargin]=parseOpts(opts,varargin);
if( nargin < 3 ) Cs=[]; end;
if( nargin < 4 || isempty(fIdxs) ) fIdxs=10; end;

dim=opts.dim; if ( isempty(dim) ) dim=ndims(X); end;
dim(dim<0)=dim(dim<0)+ndims(X)+1; % convert negative to positive indicies

if( ndims(Y)==2 && size(Y,1)==1 && size(Y,2)>1 ) Y=Y'; end; % col vector only
correctY=Y;
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
%   if(isempty(spKey)) spKey=unique(Y); 
%      if ( ~opts.zeroLab ) spKey(spKey==0)=[]; 
%      elseif( isequal(spKey(:),[0 1]') ) spKey=[1 0];
%      end;
%      if(isequal(spKey(:),[-1 1]'))spKey=[1 -1];end; 
%   end;
%   if(isempty(spMx) ) spMx=mkspMx(spKey,opts.spType); end;
  [Y,spKey,spMx]=lab2ind(Y,spKey,spMx,opts.zeroLab); % convert to binary sub-problems
end
spDesc=mkspDesc(spMx,spKey);
  

% build a folding -- which is label aware, and aware of the sub-prob encoding type
if ( opts.balYs ) f2=balanceYs(Y,-1); Y(f2==0)=0; end;%[fIdxs] = balanceYs(Y,fIdxs); end % balance the folding if wanted
if ( numel(fIdxs)==1 ) fIdxs=gennFold(Y,fIdxs,'dim',numel(dim)+1); end;

% compute kernel
if ( opts.verb>0 ) fprintf('CompKernel..');  end;
%K = compKernel(X,[],'linear','dim',dim);
for li=1:size(X,3)
k=X(:,:,li);
kk=k';
K(:,li)=kk(:);
end
%K=reshape(X,size(X,1)*size(X,2),size(X,3));
if ( opts.verb>0 ) fprintf('..done\n'); end;

% estimate good range hype-params
Cscale=opts.Cscale;
if ( isempty(Cscale) || isequal(Cscale,'l2') )  Cscale=CscaleEst(K,2);
elseif ( isequal(Cscale,'l1') )                 Cscale=sqrt(CscaleEst(K,2));
end
if ( isempty(Cs) ) Cs=[5.^(3:-1:-3) 0]; end;

if ( numel(dim)>1 ) % make n-d problem into 1-d problem
  szK=size(K); K=reshape(K,[prod(szK(1:numel(dim))) prod(szK(1:numel(dim))) szK(2*numel(dim)+1:end)]);
  szY=size(Y); Y=reshape(Y,[prod(szY(1:numel(dim))) szY(numel(dim)+1:end) 1]);
  szF=size(fIdxs);
  
  % scale up fIdxs to Y size if necess
  if ( any(szF(1:numel(dim))==1) && any(szF(1:numel(dim))~=szY(1:numel(dim))) )
     fIdxs=repmat(fIdxs,[szY(1:numel(dim))./szF(1:numel(dim)) ones(1,ndims(fIdxs)-numel(dim))]);
     szF=size(fIdxs); % new size
  end
  fIdxs=reshape(fIdxs,[prod(szY(1:numel(dim))) szF(numel(dim)+1:end) 1]);
end

if (~isempty(opts.fIdxs))
    fIdxs=opts.fIdxs;
end
Y=correctY;
% call cvtrain to do the actual work
res=cvtrainFn2(opts.objFn,K,Y,Cscale*Cs,fIdxs,'dim',numel(dim)+(1:numel(dim)),varargin{:},'calibrate',opts.calibrate,'w_template',opts.w_template); 
res.Y=Y;

% Extract the classifier weight vector(s)
% best hyper-parameter for all sub-probs, N.B. use the same C for all sub-probs to ensure multi-class is OK
% [opttstbin,optCi]=max(mean(res.tstbin,2)+mean(res.tstauc,2),[],3); 
% for isp=1:size(Y,2); % get soln for each subproblem
%    if ( isfield(res,'opt') && isfield(res.opt,'soln') ) % optimal calibrated solution trained on all data
%       soln  = res.opt.soln{isp};
%    else
%       soln  = res.soln{isp,optCi(isp)}; 
%    end
%    szX=size(X);
%    alpha(:,isp) = reshape(soln(1:end-1,:),[prod(szX(dim)) 1]); b(isp)=soln(end); % parse the soln
% end
% if ( numel(dim)>1 ) alpha=reshape(alpha,[szX(dim) size(alpha,2)]); end;
% Xidx=1:ndims(X); Xidx(dim)=-dim; % convert from dual(alpha) to primal (W)
% W   = tprod(X,Xidx,alpha,[-dim ndims(X)+1]);
% 
% % put all the parameters into 1 structure
temp=res.soln{res.opt.Ci}(1:end-1);
W=reshape(temp,size(X,2),size(X,1))';
 classifier = struct('W',W,'b',res.soln{res.opt.Ci}(end),'dim',dim,'spMx',spMx,'spKey',spKey);
 
return;
%-----------------------------------------------------------------------------
function testCase()

[X,Y]=mkMultiClassTst([-1 0; 1 0; .2 .5],[400 400 50],[.3 .3; .3 .3; .2 .2],[],[-1 1 1]);[dim,N]=size(X);
[classifier,res]=cvtrainLinearClassifier(X,Y,[],10);

f2=applyLinearClassifier(X,classifier);

[ans,optCi]=max(res.tstbin,[],3);  % check the results are identical
clf;plot([res.f(:,1,optCi),f2(:)]);

% multi-class test
[X,Y]=mkMultiClassTst([-1 0; 1 0; .2 .5],[400 400 50],[.3 .3; .3 .3; .2 .2],[],[1 2 3]);[dim,N]=size(X);
[classifier,res]=cvtrainLinearClassifier(X,Y,[],10,'spType','1vR');
[classifier,res]=cvtrainLinearClassifier(X,Y,[],10,'spType','1v1');
fldD = n2d(res.fold.di,'fold'); spD = n2d(res.fold.di,'subProb');
cvmcPerf(Y,res.fold.f,[1 spD fldD],res.fold.di(fldD).info.fIdxs,classifier.spMx,classifier.spKey)