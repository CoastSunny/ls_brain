function [clsfr,res,X]=train_erp_clsfr(X,Y,varargin)
% train a simple ERP classifer.
% 
% [clsfr,res,X]=train_erp_clsfr(X,Y....);
%
% Inputs:
%  X         - [ ch x time x epoch ] data set
%  Y         - [ nEpoch x 1 ] set of data class labels
% Options:
%  ch_pos    - [3 x nCh] 3-d co-ordinates of the data electrodes
%              OR
%              {str} cell array of strings which label each channel in *1010 system*
%  fs        - sampling rate of the data
%  freqband  - [2 x 1] or [3 x 1] or [4 x 1] band of frequencies to use
%              EMPTY for *NO* spectral filter
%  spatialfilter -- [str] one of 'slap','car','none'  ('slap')
%  badchrm   - [bool] do we do bad channel removal    (1)
%  badchthresh - [float] threshold in std-dev units to id channel as bad (3.5)
%  badtrrm   - [bool] do we do bad trial removal      (1)
%  badtrthresh - [float] threshold in std-dev units to id trial as bad (3)
%  detrend   - [bool] do we detrend the data          (1)
%  visualize - [int] visualize the data
%               0 - don't visualize
%               1 - visualize, but don't wait
%               2 - visualize, and wait for user before continuing
%  verb      - [int] verbosity level
%  ch_names  - {str} cell array of strings which label each channel
% Outputs:
%  clsfr  - [struct] structure contining the stuff necessary to apply the trained classifier
%  res    - [struct] results structure
%  X      - [size(X)] the pre-processed data
opts=struct('fs',[],'freqband',[],'detrend',1,'spatialfilter','car',...
    'badchrm',1,'badchthresh',3.1,'badchscale',2,...
    'badtrrm',1,'badtrthresh',3,'badtrscale',2,...
    'ch_pos',[],'ch_names',[],'verb',0,'capFile','1010','visualize',2,...
    'badCh',[],'nFold',10);
[opts,varargin]=parseOpts(opts,varargin);

di=[]; ch_pos=opts.ch_pos; ch_names=opts.ch_names;
if ( iscell(ch_pos) && isstr(ch_pos{1}) ) ch_names=ch_pos; ch_pos=[]; end;
if ( isempty(ch_pos) && ~isempty(ch_names) ) % convert names to positions
  di = addPosInfo(ch_names,opts.capFile); % get 3d-coords
  ch_pos=cat(2,di.extra.pos3d); ch_names=di.vals; % extract pos and channels names
end

%1) Detrend
if ( opts.detrend )
  fprintf('1) Detrend\n');
  X=detrend(X,2); % detrend over time
end

%2) Bad channel identification & removal
isbadch=[]; chthresh=[];
if ( opts.badchrm || ~isempty(opts.badCh) )
  fprintf('2) bad channel removal, ');
  isbadch = false(size(X,1),1);
  if ( ~isempty(opts.badCh) )
      isbadch(opts.badCh)=true;
      goodCh=find(~isbadch);
      if ( opts.badchrm ) 
          [isbad2,chstds,chthresh]=idOutliers(X(goodCh,:,:),1,opts.badchthresh);
          isbadch(goodCh(isbad2))=true;
      end
  elseif ( opts.badchrm ) [isbadch,chstds,chthresh]=idOutliers(X,1,opts.badchthresh); 
  end;
  X=X(~isbadch,:,:);
  ch_names=ch_names(~isbadch(1:numel(ch_names)));
  ch_pos  =ch_pos(:,~isbadch(1:size(ch_pos,2)));
  fprintf('%d ch removed\n',sum(isbadch));
end

%3) Spatial filter
R=[];
if ( size(X,1)> 5 ) % only spatial filter if enough channels
  switch lower( opts.spatialfilter )
   case 'slap';
    fprintf('3) Slap\n');
    R=sphericalSplineInterpolate(ch_pos,ch_pos,[],[],'slap');%pre-compute the SLAP filter we'll use
   case 'car';
    fprintf('3) CAR\n');
    R=eye(size(X,1))-(1./size(X,1));
   case {'whiten','wht'};
    fprintf('3) whiten\n');
    R=whiten(X,1,1,0,0,1); % symetric whiten
   case 'none';
   otherwise; warning(sprintf('Unrecog spatial filter type: %s. Ignored!',opts.spatialfilter ));
  end
end
if ( ~isempty(R) ) % apply the spatial filter
  X=tprod(X,[-1 2 3],R,[1 -1]); 
end

%4) spectrally filter to the range of interest
filt=[];
fs=opts.fs;
if ( ~isempty(opts.freqband) && size(X,2)>10 && ~isempty(fs) ) 
  fprintf('4) filter\n');
  len=size(X,2);
  filt=mkFilter(opts.freqband,floor(len/2),opts.fs/len);
  X   =fftfilter(X,filt,[0 len],2,1);
end

%4.5) Bad trial removal
trthresh=[];
if ( opts.badtrrm )
  fprintf('3.5) bad trial removal');
  [isbadtr,trstds,trthresh]=idOutliers(X,3,opts.badtrthresh);
  X=X(:,:,~isbadtr);
  Y=Y(~isbadtr);
  fprintf(' %d tr removed\n',sum(isbadtr));
end;

%5.5) Visualise the input?
if ( opts.visualize && ~isempty(ch_pos) )
   uY=unique(Y);sidx=[];
   for ci=1:numel(uY);
      mu(:,:,ci)=mean(X(:,:,Y==uY(ci)),3);
      if(~(ci>1 && numel(uY)<=2)) [auc(:,:,ci),sidx]=dv2auc((Y==uY(ci))*2-1,X,3,sidx); end;
      labels{ci}=sprintf('%d',uY(ci));
   end
   times=(1:size(mu,2))/opts.fs;
   erpfig=figure('Name','Data Visualisation: ERP');
   if ( ~isempty(di) ) xy=cat(2,di.extra.pos2d); % use the pre-comp ones if there
   else xy = xyz2xy(ch_pos);
   end
   image3d(mu,1,'plotPos',xy,'xlabel','ch','Xvals',ch_names,'ylabel','time(s)','Yvals',times,'zlabel','class','Zvals',labels,'disptype','plot','ticklabs','sw');
   zoomplots;
   aucfig=figure('Name','Data Visualisation: ERP AUC');
   image3d(auc,1,'plotPos',xy,'xlabel','ch','Xvals',ch_names,'ylabel','time(s)','Yvals',times,'zlabel','class','Zvals',labels,'disptype','imaget','ticklabs','sw','clim',[.2 .8]);
   colormap ikelvin; zoomplots;
   drawnow;
end

%6) train classifier
fprintf('6) train classifier\n');
[clsfr, res]=cvtrainLinearClassifier(X,Y,5.^(3:-1:-3),opts.nFold,'zeroLab',1,varargin{:});

%7) combine all the info needed to apply this pipeline to testing data
clsfr.fs          = fs;   % sample rate of training data
clsfr.isbad       = isbadch;% bad channels to be removed
clsfr.spatialfilt = R;    % spatial filter used for surface laplacian
clsfr.filt        = filt; % filter weights for spectral filtering
clsfr.badtrthresh = []; if ( ~isempty(trthresh) ) clsfr.badtrthresh = trthresh(end)*opts.badtrscale; end
clsfr.badchthresh = []; if ( ~isempty(chthresh) ) clsfr.badchthresh = chthresh(end)*opts.badchscale; end
% record some dv stats which are useful
tstf = res.tstf(:,res.opt.Ci); % N.B. this *MUST* be calibrated to be useful
clsfr.dvstats.N   = [sum(Y>0) sum(Y<=0) numel(Y)]; % [pos-class neg-class pooled]
clsfr.dvstats.mu  = [mean(tstf(Y>0)) mean(tstf(Y<=0)) mean(tstf)];
clsfr.dvstats.std = [std(tstf(Y>0))  std(tstf(Y<=0))  std(tstf)];
%  bins=[-inf -200:5:200 inf]; clf;plot([bins(1)-1 bins(2:end-1) bins(end)+1],[histc(tstf(Y>0),bins) histc(tstf(Y<=0),bins)]); 
sprintf('Classifier performance : %4.1f',res.tstbin(res.opt.Ci)*100)
if ( opts.visualize > 1  && ~isempty(ch_pos) ) 
   b=msgbox({sprintf('Classifier performance : %4.1f',res.tstbin(res.opt.Ci)*100) 'OK to continue!'},'Results');
   while ( ishandle(b) ) pause(.1); end; % wait to close auc figure
   if ( ishandle(aucfig) ) close(aucfig); end;
   if ( ishandle(erpfig) ) close(erpfig); end;
   if ( ishandle(b) ) close(b); end;
   drawnow;
end
return;


%---------------------------------
function xy=xyz2xy(xyz)
% utility to convert 3d co-ords to 2-d ones
% search for center of the circle defining the head
cent=mean(xyz,2); cent(3)=min(xyz(3,:)); 
f=inf; fstar=inf; tstar=0; 
for t=0:.05:1; % simple loop to find the right height..
   cent(3)=t*(max(xyz(3,:))-min(xyz(3,:)))+min(xyz(3,:));
   r2=sum(repop(xyz,'-',cent).^2); 
   f=sum((r2-mean(r2)).^2); % objective is variance in distance to the center
   if( f<fstar ) fstar=f; centstar=cent; end;
end
cent=centstar;
r = abs(max(abs(xyz(3,:)-cent(3)))*1.1); if( r<eps ) r=1; end;  % radius
h = xyz(3,:)-cent(3);  % height
rr=sqrt(2*(r.^2-r*h)./(r.^2-h.^2)); % arc-length to radial length ratio
xy = [xyz(1,:).*rr; xyz(2,:).*rr];
return
