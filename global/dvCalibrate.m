function [Ab,f,dvAb]=dvCalibrate(Y,dv,cr,maxIter,tol,verb)
% calibrate decision values to return valid probabilities
%
% [Ab,f,dvAb]=dvCalibrate_Platt(Y,dv,cr,maxIter,tol,verb)
%
% Fit a standard logistic signmoid to the input dv and Y such that 
% the returned probabilities are valid in a max liklihood sense.
% Based on the method in:
%  J. Platt, â€œProbabilistic outputs for support vector machines and
%  comparisons to regularized likelihood methods,â€? in Advances in large
%  margin classifiers, 2000, pp. 61â€“74.
%
% Inputs:
%  Y - [N x nSp] set of binary labels
%  dv- [N x nSp] set of binary predictions
%  cr- [str] type of calibration; on-of
%       cr - normal calibration, bal - balanced calibration
%  maxIter - max iterations
%  tol  - convergence tolerance
%  verb - verbosity level
% Outputs
%  Ab- [2 x nSp] set of gain,offset pairs for each sub-problem
%  f - [1 x nSp] average predicted probability for each class
%  dvAb - [N x nSp] transformed input
if ( nargin < 3 || isempty(cr) ) cr='bal'; end;
if ( nargin < 4 || isempty(maxIter) ) maxIter=100; end;
if ( nargin < 5 || isempty(tol) ) tol=1e-4; end;
if ( nargin < 6 || isempty(verb) ) verb=0; end;

% adjust the target to regularise the fit and prevent overfitting
oY=Y;
for spi=1:size(Y,2); 
  np=sum(Y(:,spi)>0); nn=sum(Y(:,spi)<0);
  Y(Y(:,spi)>0,spi) =  (np+1)./(np+2); 
  Y(Y(:,spi)<0,spi) = -(nn+1)./(nn+2);
end

Ab=zeros(2,size(Y,2)); %Ab(2,:)=-mean([mean(dv(Y<0,:),1);mean(dv(Y>0,:),1)],1);%b=zeros(1,size(Y,2)); 
oAb=ones(size(Ab)); f=ones(1,size(Y,2));
% newton method root search for scaling parameter A
% N.B. we use dv' = dv*exp(A), so A has range -inf->+inf
for iter=1:maxIter
   of=f;
   dvb  = repop(dv,'+',Ab(2,:)); dvAb   =repop(dvb,'.*',exp(Ab(1,:))); %dvAb=repop(dvA,'+',Ab(2,:));
   [f,df]=lossFn(Y,dvAb);
   dAb=[sum(dv.*df,1); sum(df,1)]; % gradient
   
   if ( verb>0 )
      fprintf('%d) A=[%s]\tf=[%s]\tdAb=[%s]\n',iter,sprintf('%0.5f ',Ab(:,1:min(end,3))),sprintf('%0.5f ',f),sprintf('%0.5f ',dAb(:,1:min(end,3))));
   end
   % stabilise step size, but limiting rate of step growth, use Arjia step-size computation
   for i=1:size(Ab,2); % stabilize each sub-problem independently
      if( dAb(:,i)'*(Ab(:,i)-oAb(:,i))>0 ) % jumping back w.r.t. prev step = lower bound
         dAb(:,i)=.5*norm(Ab(:,i)-oAb(:,i))./norm(dAb(:,i))*dAb(:,i);
      elseif( norm(dAb(:,i))>2.*norm(Ab(:,i)-oAb(:,i)) )  % large step = upper bound
         dAb(:,i)=norm(Ab(:,i)-oAb(:,i))./norm(dAb(:,i))*dAb(:,i); 
      end
   end
   oAb=Ab;  Ab     = Ab - dAb;
   if ( abs(norm(oAb(:)-Ab(:)))<tol || norm(dAb(1,:))<tol || norm(f(:)-of(:))<tol*1e-2 ) break; end;
end
% return as a raw multplier, i.e. not log
Ab(1,:)=exp(Ab(1,:)); Ab(2,:)=Ab(2,:).*Ab(1,:);
if ( strcmp(cr,'bal') ) % shift bias again to have ave-class average = 0
   dvAb  = repop(repop(dv,'*',Ab(1,:)),'+',Ab(2,:));
   Ab(2,:) = Ab(2,:) - (mean(dvAb(Y>0))+mean(dvAb(Y<=0)))/2;
end
if ( nargout>2 )
   dvAb  = repop(repop(dv,'*',Ab(1,:)),'+',Ab(2,:));
end
return;

function [f,df]=lossFn(Y,dv,x)
g     = max(1./(1+exp(-(Y.*dv))),eps);   % Y.*P(Y|x,w,b,fp)
g(Y==0)=1; % remove excluded points, by effectively treating as perfectly correct
f     = -sum(log(g))./sum(Y~=0); % max-likelihood loss
df    = repop(-Y.*(1-g),'./',sum(Y~=0));
return;

%-----------------------------------------------------------------
function testCase()
Y=sign(randn(100,1));
Y=sign(randn(1000,1)-.9);%test with biased Y
dv=Y+randn(size(Y))*2e-0;
[Ab,f]=dvCalibrate(Y,dv,[],[],[],2)

% compute and plot a histogram of the prob correct
if ( exist('res','var') ) 
  dv=res.tstf(:,res.opt.Ci); Y=res.Y; 
  [Ab,f]=dvCalibrate(Y,dv,[],[],[],2)  
end;
clf;
bins=sort(dv(Y~=0),'ascend'); bins=bins(round(linspace(1,numel(bins),30)));% equal #points per bin
ps  =zeros(numel(bins)-1,1);
for i=1:numel(ps);
  idx   = dv>bins(i) & dv<=bins(i+1) & Y~=0;
  N(i)  = sum(idx);
  ps(i) = sum(Y(idx)>0)./N(i);
end
plot(bins(2:end),ps);xlabel('dv');ylabel('Pr(Y=1|dv)')
hold on;
plot(bins(2:end)*Ab(1)+Ab(2),ps,'r');
%plot(bins,1./(1+exp(-(bins*Ab(1)+Ab(1)*Ab(2)+Ab(2)))),'r');
xs=get(gca,'xlim');xs=linspace(xs(1),xs(2),50);plot(xs,1./(1+exp(-xs)),'g'); 
legend('Emp / UnCal','Cal','logistic','Location','NorthWest');

% test with excluded points
Y=sign(randn(100,1));  Y(1:10,:)=0;
dv=Y+randn(size(Y))*2e-0;
[Ab,f]=dvCalibrate(Y,dv,[],[],[],2); % mark as excluded
[Ab0,f0]=dvCalibrate(Y(Y~=0),dv(dv~=0),[],[],[],2); % remove excluded points

% cal set at once
Y=sign(randn(100,3));
dv=Y+randn(size(Y))*1e-2;
[Ab,f]=dvCalibrate(Y,dv,[],[],[],2)



