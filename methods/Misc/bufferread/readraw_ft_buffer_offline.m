function [x,di,fs,summary,opts,info]=readraw_fieldtrip(filename,varargin);
% convert fieldtrip struct to a jf_bciobj one
%
% [X,di,fs,summary,opts,info]=readraw_fieldtrip(filename[,options])
%
% Inputs:
%  filename -- the fieldtrip file to read
%              OR
%              [struct] a fieldtrip data structure
% Options:
%  Y              -- [Nx1] set of labels for the trials
%  single         -- [bool] flag store data in single format          (1)
% Outputs
%  X              -- [numel(chanIdx)+1 x nSamp x nEpoch] data matrix
%  di             -- [ndims(X)+1 x 1] dimInfo struct describing the layout of X
%  fs             -- [float] sampling rate of this data
%  summary        -- [str] string describing what we loaded
%  opts           -- the parsed options structure
%  info           -- [struct] containing additional useful info about the loaded data
opts = struct('prune_equal',0,'epochFn','eventEpochFn',...
              'single',1,'verb',1,'chanIdx',[],'subsample',struct('fs',256),...
              'markerCh','Status');
[opts,varargin]=parseOpts(opts,varargin);

x = [];
y = [];
fs = [];
di = [];
summary = '';
info=struct('filename',filename); % record file name

% get the associated header and events filenames
[fdir,fname,fext]=fileparts(filename);
hdrfname=fullfile(fdir,'header');
eventfname=fullfile(fdir,'events');
datafname =fullfile(fdir,'samples');

hdr=read_buffer_offline_header(hdrfname);
info.hdr=hdr;
events=read_buffer_offline_events(eventfname,hdr);
info.events=events;

if ( isfield(hdr,'SampleRate') )
  fs=hdr.SampleRate;
elseif ( isfield(hdr,'Fs') )
  fs=hdr.Fs;
else
  error('Cant find sample rate');
end
if any(fs~=fs(1))
   error('channels with different sampling rate not supported');
end
samp2ms = 1000/fs; 
ms2samp = fs/1000;


subSampRatio=1;
if ( ~isempty(opts.subsample) && opts.subsample.fs < fs ) 
   subSampRatio = fs/opts.subsample.fs;
end

nchannels = hdr.nChans;
nsamp     = hdr.nSamples;

% Now we can extract the bits we want
[epType,bgns,ends,offset_samp,opts.epOpts]=feval(opts.epochFn,events,varargin{:},'fs',fs);

if ( isempty(bgns) || isempty(ends) ) 
   warning('File: %s didnt contain any valid epochs',filename);
   return;
end

trlens=ends-bgns+1;
% BODGE: check for badly finished file with over-long last trial
longTr=find(trlens>10*median(trlens));
if ( ~isempty(longTr) )
   warning(sprintf('%d **Very** long trial(s) found, may be CORRUPT. Deleted',numel(longTr)));
   epType(longTr)=[];bgns(longTr)=[];ends(longTr)=[];
end
maxtrlen=max(trlens(:));
if ( opts.prune_equal )
   maxtrlen=min(trlens(:));
   ends  =bgns+maxtrlen-1;           % set end to min length
end

%---------------------------------------------------------------------------
% Finally: Extract the bits we want
%---------------------------------------------------------------------------
ntrials = numel(bgns);
fprintf('Identified %d epochs to read.\n',ntrials);
chanIdx = opts.chanIdx; if ( isempty(chanIdx) ) chanIdx=1:nchannels; end;
if ( islogical(chanIdx) ) chanIdx=find(chanIdx); end;
if ( isfield(hdr,'Chan_Select') )
   hdr.Chan_Select(:)=0; hdr.Chan_Select(chanIdx)=1;
end
nchannels=numel(chanIdx);
y = epType;%double(epType);%types(:);

% downsampling?
omaxtrlen=maxtrlen; ooffset_samp=offset_samp;
if ( subSampRatio>1 )
   info.ofs=fs; 
   fs=opts.subsample.fs; info.fs=fs;
   fprintf('Downsampling: from %d to %d.\n',info.ofs,info.fs);
   maxtrlen   = floor(maxtrlen./subSampRatio);
   offset_samp= floor(offset_samp./subSampRatio);
end
if ( opts.single ) x = zeros(nchannels, maxtrlen, ntrials, 'single');
else               x = zeros(nchannels, maxtrlen, ntrials);
end
for tr=1:ntrials;
   bgntr= bgns(tr);
   endtr= min(max(bgns(tr)+omaxtrlen,ends(tr)),nsamp); % use all data available, i.e. don't 0-pad
   xtr  = read_buffer_offline_data(datafname,hdr,[bgntr endtr-1]);
   if ( subSampRatio>1 ) % sub-sample
      [xtr,idx] = subsample(xtr,size(xtr,2)./subSampRatio,2);
   end
   if( ~opts.single ) xtr=single(xtr); end;
   if( ~isempty(chanIdx) ) 
     x(:,1:size(xtr,2),tr) = xtr;
   else
     x(:,1:size(xtr,2),tr) = xtr(chanIdx,:);
   end
   if ( opts.verb > 0 ) % progress reporting
      si=round(tr/(ntrials/100)); % nearest step
      if ( tr==round(si*ntrials/100) ) 
         fprintf(repmat('.',max(1,si-round((tr-1)./(ntrials/100))),1)); 
      end
   end
end

% Now setup the dim info array
if ( isfield(hdr,'label') ) chvals=hdr.label;
elseif ( isfield(hdr,'Label') ) chvals=hdr.Label; 
end
if ( ~isempty(chvals) ) % use names for the channels if available 
   % clean up the labels to remove extra 0 characters...
   for i=1:numel(chvals); 
      e=find(chvals{i}==0,1); if ( ~isempty(e) ) chvals{i}=chvals{i}(1:min(end,e-1)); end; 
   end
   if ( ~isempty(chanIdx) ) chvals=chvals(chanIdx); end;
else
   chvals=opts.chanIdx;
end
di = mkDimInfo(size(x),'ch','',chvals,...
               'time','ms',([1:maxtrlen]+offset_samp(1))*samp2ms*subSampRatio,...
               'epoch','',[],'','uV');
% restrict the states to the start of the trials too & record as trialinfo
for tr=1:ntrials;
   di(3).extra(tr).sampleIdx = [bgns(tr) ends(tr) -offset_samp(min(end,tr),:)];
   if ( iscell(y) ) 
     di(3).extra(tr).marker    = y{tr};
   else
     di(3).extra(tr).marker    = y(tr);
   end
   % events which happened during this time
   if ( isfield(events,'sample') )
      ei = [events.sample]>bgns(tr) & [events.sample]+[events.duration] < ends(tr); 
      di(3).extra(tr).events    = ...
          struct('typ',{{events(ei).type}},'value',{{events(ei).value}},'pos',[events(ei).sample],'dur',[events(ei).duration]);
   end
end
return;