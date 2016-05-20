function []=capFitting(varargin);
% simple EEG electrode quality check for cap fitting
%
% []=capFitting(varargin)
%
%Options:
%  updateInterval- [int] how often to redraw the electrode quality display in seconds (.5)
%  capFile       - [str] file to use to get electrode positions from ('1010')
%  overridechnms - [bool] capFile names over-ride buffer provided names (0)
%  verb          - [int] verbosity level (0)
%  mafactor      - [float] moving average factor for computing the electrode noise power  (.5)
%  noiseband     - [2x1] lower and upper frequency to include in the noise power computation ([45 55])
%  noiseThresholds - [2x1] lower and upper noise power thresholds for the [green and red] colors ([2 10])
%  badChThreshodl - [float] minimum noise power, below which we assume the channel is disconnected (1e-8)
%  timeOut_ms    - [int] timeOut to wait for data from the buffer (5000)
%  host,port     - [str] host and port where the buffer lives ('localhost',1972)
opts=struct('updateInterval',.5,'capFile','1010','overridechnms',0,'verb',1,'mafactor',.5,...
    'noiseband',[45 55],'noiseThresholds',[2 10],'offsetThresholds',[5 15],'badChThreshold',1e-8,'fig',[],...
    'host','localhost','port',1972,'timeOut_ms',5000);
[opts,varargin]=parseOpts(opts,varargin);
host=opts.host; port=opts.port;

% % % create the plot
% % fgr=opts.fig; if ( isempty(fgr) ) fgr=figure; end;
% % set(fgr,'MenuBar','none','Name','capFitting', 'Color',[1 1 1],'NumberTitle','off','Visible','on');
% % % use complete available figure area
% % set(get(fgr,'Children'),'Position',[0 0 1 1]);
% 
% % get channel info for plotting
% hdr=[];
% while ( isempty(hdr) || ~isstruct(hdr) || (hdr.nchans==0) ) % wait for the buffer to contain valid data
%     try 
%         hdr=buffer('get_hdr',[],host,port); 
%     catch
%         hdr=[];
%         fprintf('Couldnt open the buffer to get a header');
%     end;
%     pause(1);
%     if ( ~ishandle(fgr) )
%         warning('Stopped cap fitting before we connected to the buffer!');
%         return; 
%     end;
% end;
% % 
% % di = addPosInfo(hdr.channel_names,opts.capFile,opts.overridechnms); % get 3d-coords
% % ch_pos=cat(2,di.extra.pos2d); ch_names=di.vals; % extract pos and channels names
% % iseeg=find([di.extra.iseeg]);  
% 
% if (isempty(iseeg)) % cope with unrecog electrode positions
%     iseeg=true(1,size(ch_pos,2)); for ei=1:numel(ch_names); if (isempty(ch_names{ei}))iseeg(ei)=false;end;end
%     iseeg=find(iseeg);
%     % put the electrodes on a rectangular grid
%     set(gca,'xlim',[-1 1],'ylim',[-1 1]);
%     w=ceil(sqrt(numel(iseeg)));h=ceil(numel(iseeg)/w);
%     ws=linspace(-.9,.9,w); hs=linspace(-.9,.9,h);
%     for i=1:numel(iseeg);
%       ch_pos(1,iseeg(i))=ws(floor((i-1)/w)+1);
%       ch_pos(2,iseeg(i))=hs(mod(i-1,w)+1);
%     end
%     hold on;
% else
%     % draw the head
%     topohead(); 
%     hold on;
% end
% set(gca,'visible','off');
% text(mean(get(gca,'xlim')),max(get(gca,'ylim')),'Sluit het scherm om door te gaan','FontUnits','normalized','fontsize',.1,'HorizontalAlignment','center');
% 
% % draw the channel names and electrodes
% for i=1:numel(iseeg);
%    ei=iseeg(i);
%    % draw the electrodes
%    elect_hdls(i) = rectangle('position',[ch_pos(1,ei)-.1 ch_pos(2,ei)-.1 .2 .2],'curvature',[1 1],'edgeColor',[1 0 0],'lineWidth',8);
%    nm_hdls(i)    = text(ch_pos(1,ei),ch_pos(2,ei),ch_names{ei},'HorizontalAlignment','center','fontsize',.1,'FontUnits','normalized','Interpreter','none');
% end

% get bin locations
fftp=fftBins([],1,hdr.fsample,1);
% get locations we use to compute the power
[ans,bstart] = min(abs(fftp-opts.noiseband(1))); [ans,bend]=min(abs(fftp-opts.noiseband(2)));
noisebands = bstart:bend;
colors=trafficlight(64); %colors=colors(end:-1:1,:); % red at top, green at bottom

 
key=[]; dat=[]; avepow=[]; nsamples=hdr.nsamples;
while ( ishandle(fgr) ) % close figure to stop

   % wait for some new data
   endsamp = round(nsamples+opts.updateInterval*hdr.fsample);
   status=buffer('wait_dat',[endsamp -1 opts.timeOut_ms],host,port);
   if ( isempty(status) ) error('No data recieved'); return; 
   elseif ( status.nsamples < endsamp ) drawnow; continue; % not enough data yet
   end;
   dat   =buffer('get_dat',[nsamples endsamp],host,port);
   dat   =single(dat.buf);
   nsamples=status.nsamples;
   
   % fourier transform to get 50Hz power
   mu  = mean(dat,2);
   dat = dat-repmat(mu,1,size(dat,2)); % 0-mean first
   pow = abs(fft(dat,[],2))/size(dat,2);
   if ( isempty(avepow) ) 
      avepow=pow;
   else
      avepow = opts.mafactor*avepow + (1-opts.mafactor)*pow;
   end
   % get the noise power
   noisepow = mean(avepow(:,noisebands),2);
   if ( opts.verb>1 ) 
     if ( opts.verb<3 ) fprintf('avePow=%g\r',mean(noisepow(iseeg)));
     else
       fprintf('%g   %s\r',median(mu(iseeg)),sprintf('%g(%g)\t',[mu(iseeg)-median(mu(iseeg)),noisepow(iseeg)]'));
     end
   end;
   
   % update the plot
   electpow = noisepow(iseeg); 
   % exactly 0-noise power, means disconnected channel so make have infinite power
   electpow(electpow<opts.badChThreshold)=inf;
   % map the power into the color range we're using
   electpow = min(max(electpow,opts.noiseThresholds(1)),opts.noiseThresholds(2)); % limit to color range
   col = colors(floor((electpow-opts.noiseThresholds(1))/diff(opts.noiseThresholds)*(size(colors,1)-1))+1,:);
   offset   = abs(mu(iseeg)-median(mu(iseeg)));
   offset   = min(max(offset,opts.offsetThresholds(1)),opts.offsetThresholds(2));
   ocol= colors(floor((offset-opts.offsetThresholds(1))/diff(opts.offsetThresholds)*(size(colors,1)-1))+1,:);
   % set the color
   if ( ishandle(fgr) )
     for i=1:numel(elect_hdls); set(elect_hdls(i),'EdgeColor',col(i,:),'FaceColor',ocol(i,:)); end;
     drawnow;
   end
   % pause for some time to allow for <ctrl-c> without the buffer crashing
   pause(opts.timeOut_ms/2/1000);
end
return;
function rgb = trafficlight(n);
% trafficlight order colormap, i.e. green yellow red
if nargin == 0, n = size(get(gcf,'colormap'),1); end
m = fix(n/2);
step = 1/m;
ltop = ones(m+1,1);
stop = ones(m,1);
lbot = zeros(m+1,1);
sbot = zeros(m,1);
lup = (0:step:1)';
sup = (step/2:step:1)';
ldown = (1:-step:0)';
sdown = (1-step/2:-step:0)';
if n-2*m == 1
   rgb = ([lup ltop lbot;stop sdown sbot]);
else
   rgb = ([sup stop sbot;stop sdown sbot]);
end
%-----------------------
function testCase();
