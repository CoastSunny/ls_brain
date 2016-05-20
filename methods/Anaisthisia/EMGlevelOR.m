function [dat,key,state]=EMGlevelOR(varargin);
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
opts=struct('updateInterval',.5,'capFile','1010','overridechnms',0,'verb',1,'mafactor',.1,...
    'noiseband',[55 200],'noiseThresholds',[2 10],'offsetThresholds',[5 15],'badChThreshold',1e-8,'fig',[],...
    'host','localhost','port',1972,'timeOut_ms',5000,'showOffset',true);
opts=parseOpts(opts,varargin);
host=opts.host; port=opts.port;

fgr=figure;
hdr=[];
while ( isempty(hdr) || ~isstruct(hdr) || (hdr.nchans==0) ) % wait for the buffer to contain valid data
    try 
        hdr=buffer('get_hdr',[],host,port); 
    catch
        hdr=[];
    end;
    pause(1);    
end;

% get bin locations
fftp=fftBins([],1,hdr.fsample,1);
% get locations we use to compute the power
[ans,bstart] = min(abs(fftp-opts.noiseband(1))); [ans,bend]=min(abs(fftp-opts.noiseband(2)));
noisebands = bstart:bend;


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
   emg_chan=[22 26]; %channels numbers for EMG
   dat=dat(emg_chan,:);
   
   % fourier transform to get EMG power  
   mu  = mean(dat,2);
   dat = dat-repmat(mu,1,size(dat,2)); % 0-mean first
   pow = abs(fft(dat,[],2))/size(dat,2);
   if ( isempty(avepow) ) 
      avepow=pow;
   else
      avepow = opts.mafactor*avepow + (1-opts.mafactor)*pow;
   end
   % get the noise power
   emgpow = mean(avepow(1,noisebands)-avepow(2,noisebands),2);  
   
   figure(fgr),bar(emgpow);
   
end   

end
