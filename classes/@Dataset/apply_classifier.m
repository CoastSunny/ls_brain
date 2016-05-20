function out = apply_classifier( obj , target_obj , varargin )

if ( nargin > 0 )
    
    opts = struct( ...
        'name' , 'test' , ...
        'blocks_in'  , 'all' , ...
        'channels' , 'all' , ...
        'time' , 'all' , ...
        'detrenddat' , 'yes' , ...
        'filterdat', 'yes' , ...
        'freqband' , [0.5 13] , ...
        'frequency_transform' , 'none' , ...
        'times_in', [] , ...
        'freqs_in' , [] , ...
        'dataset_name' , 'default' , ...
        'classes' , [] , ...
        'target_labels', [-1 +1] , ...
        'bias' , [] , ...
        'W' , [] , ...
        'av_trials' , [] , ...
        'av_decisions' , [] , ...
        'cleverstuff' , 'stupid' , ...
        'method' , 'all', ...
        'dim' , 3, ...
        'trials','all' , ...
        'sorti' , 'yes' , ...
        'spatialfilter' , [] , ...
        'capfile' , 'cap_tmsi_mobita', ...
        'ls_fit','no', ...
        'wavebeam','no');
    
    [ opts ] = parseOpts( opts , varargin ) ;
    opts2var
    
    [time channels]=convertall2var(target_obj,time,channels);
    [blocks_in blocks_excluded]=getBlocks(target_obj,blocks_in);
    [indices classlength labels]=getIndices(target_obj,classes,blocks_excluded,trials);
    fprintf('Careful\n');
    if (strcmp(sorti,'yes'))
        [indices si]=sort(indices);
        labels=labels(si);
    end
    X=cat(3,target_obj.data.trial{indices});
    X=X(channels,time,:);
    
    if (strcmp(filterdat,'yes'))
        fs=obj.data.fsample;
        len=size(X,2);
        filt=mkFilter(freqband,floor(len/2),fs/len);
        X=fftfilter(X,filt,[0 len],2,0);
    end
    if (strcmp(detrenddat,'yes'))
        X=detrend(X,2); % detrend over time
    end
    %%
    if (~isempty(spatialfilter))
        di = addPosInfo(channels,capfile); % get 3d-coords
        ch_pos=cat(2,di.extra.pos3d); ch_names=di.vals; % extract pos and channels names
        R=[];
        if ( size(X,1)> 5 ) % only spatial filter if enough channels
            switch ( spatialfilter )
                case 'slap';
                    fprintf('3) Slap\n');
                    R=sphericalSplineInterpolate(ch_pos,ch_pos,[],[],'slap');%pre-compute the SLAP filter we'll use
                case 'car';
                    fprintf('3) CAR\n');
                    R=eye(size(X,1))-(1./size(X,1));
                case 'whiten';
                    fprintf('3) whiten\n');
                    R=whiten(X,1,1,0,0,1); % symetric whiten
                case 'none';
                otherwise;
            end
        end
        if ( ~isempty(R) ) % apply the spatial filter
            X=tprod(X,[-1 2 3],R,[1 -1]);
        end
    end
    
   global w1 w2 i1 i2
    if (strcmp(wavebeam,'yes'))
    for i=1:size(X,3)
        
        for j=1:10
            
            y=w1(j,:)*X(:,:,i);
            [C L]=wavedec(y,3,'dmey');
            C(logical(i1(j,:)))=0;
            y = waverec(C,L,'dmey');
            Y(j,:,i)=y;
        end
        for j=1:10
            
            y=w2(j,:)*X(:,:,i);
            [C L]=wavedec(y,3,'dmey');
            C(logical(i2(j,:)))=0;
            y = waverec(C,L,'dmey');
            Y(j+10,:,i)=y;
        end
    end
    X=Y;
    end
    
    %%
    if (strcmp(frequency_transform,'spectrogram'))
        [X ss f o]=spectrogram(X,2,'fs',fs,'width_ms',1000,'overlap',0);
        t=find(ss/fs>=times_in(1) & ss/fs<=times_in(2));
        fr=find(f>=freqs_in(1) & f<=freqs_in(2));
        X=X(:,fr,t,:);
    end
    %     [badtr,vars]=idOutliers(X,3,3);
    %     X=X(:,:,~badtr);
    %
    if(~isempty(bias))
        bold=obj.( name ).b;
        obj.( name ).b=bias;
    end
    if(~isempty(W))
        Wold=obj.( name ).W;
        W=W;
        obj.( name ).W=W;
    end
    
    if (~isempty(av_trials))
        p=av_trials;
        Y=zeros(numel(channels),numel(time),size(X,3)-p+1);
        for j=p:size(X,3)
            for k=1:p
                Y(:,:,j-p+1)=Y(:,:,j-p+1)+X(:,:,j-k+1);
            end
            Y(:,:,j-p+1)=1/p*Y(:,:,j-p+1);
        end
        X=Y;
        fprintf('trl');
    end
    
    if (strcmp(cleverstuff,'stupid'))
        %  X=repop(X,'/',std(X,0,1));
        [ f , fraw , p] = apply_erp_clsfr( X , obj.( name ) );
        
    elseif (strcmp(cleverstuff,'rfe'))
        
        excluded=obj.(name).rfe.excluded;
        
        for j=2:numel(excluded)
            clear Z
            for i = 1 : size( X,3 )
                Y=X(:,:,i);
                if (strcmp(method,'all'))
                    Y=Y(:);
                    Y(excluded{j})=[];
                elseif (strcmp(method,'time'))
                    Y(:,(excluded{j}(1)-1)/numel(channels)+1)=[];
                elseif (strcmp(method,'space'))
                    Y((excluded{j}(1)-1)/numel(channels)+1,:)=[];
                end
                Z(:,:,i)=Y;
            end
            X=Z;
        end
        [ f , fraw , p] = apply_erp_clsfr( X , obj.( name ).rfe.opt.clsfr );
    end
    
    if(~isempty(W))
        obj.( name ).W=Wold;
    end
    
    if(~isempty(bias))
        obj.( name ).b=bold;
    end
    
    if (~isempty(av_decisions))
        fraw = filter(1/av_decisions*ones(1,av_decisions),1,fraw);
        fraw = fraw(av_decisions:end);
        p = 1./(1+exp(-fraw));
        fprintf('dec');
    end
    
    if (numel(target_labels)==1)
        
        rate = sum( target_labels * fraw > 0 ) / numel( fraw );% sum(fraw>0)
        
        trls=numel(fraw);
        
    end
    
    if (numel(target_labels)>1)
        
        c1l=classlength(1);%numel(old_indices{1});
        c2l=classlength(2);%numel(old_indices{2});
        
        fraw1   = target_labels(1)*fraw(labels==-1);
        rate(1) = sum(fraw1>0)/numel(fraw1);
        trls(1) = numel(fraw1);
        fraw2   = target_labels(2)*fraw(labels==1);
        rate(2) = sum(fraw2>0)/numel(fraw2);
        trls(2) = numel(fraw2);
        
        frawt    = [fraw1' fraw2'];
        rate(3) = sum(frawt>0)/numel(frawt);
        trls(3) = numel(frawt);
        
        
    end
    
    out.rate=rate;
    out.trls=trls;
    out.f=f';
    out.p=p;
    out.labels=labels;
    
end

end