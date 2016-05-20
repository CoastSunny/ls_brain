function [f,fraw,p]=apply_erp_clsfr(X,clsfr,verb)
% apply a previously trained classifier to the input data
% 
%  [f,fraw,p]=apply_erp_clsfr(X,clsfr,verb)
%
% Inputs:
%  X - [ ch x time (x epoch) ] data set
%  clsfr - [struct] trained classifier structure as given by train_1bitswitch
%  verb - [int] verbosity level
% Output:
%  f     - [size(X,epoch) x nCls] the classifier's raw decision value
%  fraw  - [size(X,dim) x nSp] set of pre-binary sub-problem decision values
%  p     - [size(X,epoch) x nCls] the classifier's assessment of the probablility of each class
if( nargin<3 || isempty(verb) ) verb=0; end;


%0) convert to singles (for speed)
%X=single(X);

% %0) bad channel removal
if ( isfield(clsfr,'isbad') && ~isempty(clsfr.isbad) )
  X=X(~clsfr.isbad,:,:,:);
end
% 
%1) Detrend
 %X=detrend(X,2); % detrend over time
% 
%2) Spatial filter
% if ( isfield(clsfr,'spatialfilt') && ~isempty(clsfr.spatialfilt) )
%   X=tprod(X,[-1 2 3 4],clsfr.spatialfilt,[1 -1]); % apply the SLAP
% end
% 
% %3) spectral filter
% if ( isfield(clsfr,'filt') && ~isempty(clsfr.filt) )
%   X=fftfilter(X,clsfr.filt,size(X,2),2,1);
% end

%6) apply classifier
[f, fraw]=applyLinearClassifier(X,clsfr);
% Pr(y==1|x,w,b), map to probability of the positive class
p = 1./(1+exp(-f)); 
if ( verb>0 ) fprintf('Classifier prediction:  %g %g\n', f,p); end;

return;
%------------------
function testCase();
X=oz.X;
fs=256; oz.di(2).info.fs;
width_samp=fs*250/1000;
wX=windowData(X,1:width_samp/2:size(X,2)-width_samp,width_samp,2); % cut into overlapping 250ms windows
[ans,f2]=apply_1bitswitch(wX,fs,clsfr);
f2=reshape(f2,[size(wX,3) size(wX,4) size(f2,2)]);