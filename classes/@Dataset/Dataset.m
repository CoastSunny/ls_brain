classdef Dataset < dynamicprops
    %DATASET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        full_name
        dataset_name
        markers
        markers_list
        block_idx
        block_names
        paths
        data
        cfg
        
    end
    
    methods
        
        function obj = Dataset( varargin )
            
            fclose( 'all' );
            command = '' ;
            if ( nargin > 0 )
                
                opts = struct ( 'paths' , [] , 'marker' , [] , 'cfg' , [] ) ;
                [ opts  ] = parseOpts( opts , varargin );
                opts2var
                clear('functions')
                old_cfg=cfg;
                counter=1;
                
                cfg.trialdef.eventvalue=marker;
                cfg.trialdef.eventtype='trial';
                for i=1:length(paths)
                    
                    flag='good';
                    
                    cfg.dataset=paths{i};
                    
                    try trial_cfg=ft_definetrial(cfg);
                    catch err
                        flag='bad';
                    end
                    
                    if (exist('trial_cfg','var') && size(trial_cfg.trl,1)<cfg.mintrials)
                        flag='bad';
                    end
                    if (~strcmp(flag,'bad'))
                        
                        data{counter}=ft_preprocessing(trial_cfg);
                        
                        if (isfield( cfg,'artifacts') & strcmp(cfg.artifacts.threshold.flag,'yes'))
                            trial_cfg.artfctdef.threshold.min = cfg.artifacts.threshold.min;
                            trial_cfg.artfctdef.threshold.max = cfg.artifacts.threshold.max;
                            trial_cfg.artfctdef.threshold.bpfilter = cfg.artifacts.threshold.bpfilter;
                            
                            [trial_cfg, artifact] = ft_artifact_threshold(trial_cfg,data{counter});
                            trial_cfg.artfctdef.threshold.artifact=artifact;
                            data{counter}=ft_rejectartifact(trial_cfg,data{counter});
                        end
                        
                        if (isfield(cfg,'resampleFs') && ~isempty(cfg.resampleFs))
                            trial_cfg.resamplefs=cfg.resampleFs;
                            data{counter}=ft_resampledata(trial_cfg,data{counter});
                        end
                        command=strcat(command,',','data{',num2str(counter),'}');
                        
                        temp2 = paths{i};
                        temp3 = regexp( temp2 , '/' ) ;
                        temp2( 1 : temp3( end ) ) = [] ;
                        obj.block_names{ counter } = temp2;
                        obj.paths{counter}=paths{i};
                        counter = counter+1 ;
                        
                        %data=ft_preprocessing(cfg);
                        %measurement(counter).data=data;
                        %measurement(counter).markers=data.trialinfo;
                        %counter=counter+0;
                        
                    end
                    
                end
                
                if (length(data)>1)
                    
                    eval ( [ 'alldata = ft_appenddata( []' , command , ');' ] );
                    obj.data = alldata;
                    obj.markers = obj.data.trialinfo;
                    obj.markers_list = unique( obj.markers );
                    
                    temp = 0 ;
                    if (isfield( cfg,'artifacts') & strcmp(cfg.artifacts.threshold.flag,'yes'))
                        for i = 1 : numel( obj.data.cfg.previous )
                            if ( i==1 )
                                try
                                    temp=size(obj.data.cfg.previous{1}.artfctdef.threshold.trl(:,4),1)-size(obj.data.cfg.previous{1}.artfctdef.threshold.artifact(:,2),1);
                                catch err
                                    temp=size(obj.data.cfg.previous{1}.artfctdef.threshold.trl(:,4),1);
                                end
                                obj.block_idx{ i } = 1 : temp ;
                                
                            else
                                %   try
                                %  temp = size(obj.data.cfg.previous{i-1}.artfctdef.threshold.trl(:,4),1)-size(obj.data.cfg.previous{i-1}.artfctdef.threshold.artifact(:,2),1);
                                temp2 = size(obj.data.cfg.previous{i}.artfctdef.threshold.trl(:,4),1)-size(obj.data.cfg.previous{i}.artfctdef.threshold.artifact(:,2),1);
                                %                                 catch err
                                %                                     temp = temp + size(obj.data.cfg.previous{i-1}.artfctdef.threshold.trl(:,4),1);
                                %                                     temp2 = size(obj.data.cfg.previous{i}.artfctdef.threshold.trl(:,4),1);
                                %                                 end
                                obj.block_idx{ i } = obj.block_idx{i-1}(end) +1 : obj.block_idx{i-1}(end) + temp2;
                            end
                            
                        end
                    else
                        for i=1:numel(obj.data.cfg.previous)
                            if (i==1)
                                obj.block_idx{ i } = 1 : numel(obj.data.cfg.previous{i}.trl(:,4));
                            else
                                temp = temp + numel(obj.data.cfg.previous{i-1}.trl(:,4));
                                obj.block_idx{ i } = temp + 1 : temp + numel(obj.data.cfg.previous{i}.trl(:,4));
                            end
                        end
                    end
                    obj.cfg=old_cfg;
                    
                else
                    
                    obj.data = data{1};
                    obj.markers = data{1}.trialinfo;
                    obj.markers_list = unique(obj.markers);
                    obj.cfg=old_cfg;
                    if (isfield( cfg,'artifacts') & strcmp(cfg.artifacts.threshold.flag,'yes'))
                        obj.block_idx{ 1 } = 1 : size(obj.data.cfg.previous{1}.artfctdef.threshold.trl(:,4),1)-size(obj.data.cfg.previous{1}.artfctdef.threshold.artifact(:,2),1);
                    elseif isfield(cfg,'trialfun') && strcmp(cfg.trialfun,'ft_trialfun_brainamp')
                        obj.block_idx{ 1 } = 1 : numel(obj.data.cfg.trl(:,4));
                    else
                        obj.block_idx{ 1 } = 1 : numel(obj.data.cfg.previous.trl(:,4));
                    end
                    
                end
                
            end
            
        end
        
        function [dw dwtr fulldw cov fullaw]=diff_wave(obj,varargin)
            opts = struct( ...
                'classes' , [] , ...
                'trials', 'all' , ...
                'blocks_in'  , 'all' , ...
                'channels' , 'all' , ...
                'time' , 'all' , ...
                'difftype' , 'timewave' , ...
                'vis', 'on') ;
            
            if (nargin==1)
                [ opts ] = parseOpts( opts , varargin ) ;
                opts
                fprintf('\n Required inputs: classes\n');
                
            elseif (nargin >1)
                
                [ opts ] = parseOpts( opts , varargin ) ;
                opts2var
                
                [time channels]=convertall2var(obj,time,channels);
                [blocks_in blocks_excluded]=getBlocks(obj,blocks_in);
                [indices classlength labels]=getIndices(obj,classes,blocks_excluded,trials);
                
                sprintf('Class 1 length: %d \nClass 2 length: %d ',classlength(1),classlength(2))
                
                
                cfg.channel=channels;
                for i=1:size(classes,1);
                    cfg.trials = indices(1:classlength(i));
                    
                    indices(1:classlength(i))=[];
                    cfg.preproc.lpfilter='yes';
                    cfg.preproc.lpfreq=13;
                    cfg.preproc.hpfilter='yes';
                    cfg.preproc.hpfreq=.5;
                    
                    cfg.preproc.demean='yes';
                    cfg.preproc.detrend='yes';
                    %                     cfg.preproc.baselinewindow=[0 0.6];
                    cfg.keeptrials='yes';
                    cfg.covariance='yes';
                    wave{i}=ft_timelockanalysis(cfg,obj.data);
                end
                if (strcmp(difftype,'timewave'))
                    if (numel(cfg.channel)>1)
                        fulldw=wave{1}.avg-wave{2}.avg;
                        dw=mean(wave{1}.avg)-mean(wave{2}.avg);
                        fullaw=wave{1}.avg+wave{2}.avg;
                        var=(wave{1}.var+wave{1}.var)/2;
                        dwtr=(wave{1}.trial-wave{2}.trial);
                    else
                        dw=wave{1}.avg-wave{2}.avg;
                        var=(wave{1}.var+wave{2}.var)/2;
                        dwtr=(wave{1}.trial-wave{2}.trial);
                    end
                elseif (strcmp(difftype,'spacewave'))
                    if (numel(cfg.channel)>1)
                        fulldw=wave{1}.avg'-wave{2}.avg';
                        dw=mean(wave{1}.avg')-mean(wave{2}.avg');
                        cov=wave{1}.cov+wave{1}.cov;
                    else fprintf('not enough channels,exiting');
                        return;
                    end
                end
                
                if (strcmp(difftype,'timewave'))
                    dw=dw(time);
                    dwtr=dwtr(:,:,time);
                elseif (strcmp(difftype,'spacewave'))
                    dw=dw(channels);
                    
                end
                
                if (strcmp(vis,'on'))
                    if (strcmp(difftype,'timewave'))
                        figure,plot(time/obj.data.fsample,dw)
                    elseif (strcmp(difftype,'spacewave'))
                        figure,plot(dw)
                    end
                elseif (strcmp(vis,'error'))
                    figure,shadedErrorBar(wave{1}.time,dw,var.^.5,'r',1)
                end
                
            end
        end
        
        
        function out=plot(obj,varargin)
            
            opts = struct( ...
                'classes' , [] , ...
                'method' , 'avg' , ...
                'save2disk' , 'no' , ...
                'filename' , 'undefined' , ...
                'blocks_in'  , [] , ...
                'channels' , 'all' , ...
                'time' , 'all' , ...
                'trials' , 'all' , ...
                'fig' , [] , ...
                'vis' , 'on' , ...
                'badrem' , 'yes' , ...
                'norm_avg' , 'no' ,...
                'nF',[]) ;
            
            [ opts ] = parseOpts( opts , varargin ) ;
            opts2var
            
            blocks=1:numel(obj.block_idx);
            if ~isempty(blocks_in)
            blocks_out=setdiff(blocks,blocks_in);
            else
                blocks_out=[];
            end
            cfg.channel=channels;
            [time channels]=convertall2var(obj,time,channels);
            [indices classlength labels]=getIndices(obj,classes,blocks_out,trials);
            if (strcmp(badrem,'yes'))
                X=cat(3,obj.data.trial{indices});
                X=X(channels,time,:);
                [badtr,vars]=idOutliers(X,3,2.5);
                indices=indices(~badtr);
                labels=labels(:,~badtr);
            end
            %indices=randi(468,1,numel(indices));
            if (isempty(indices))
                fprintf('No trials found!!!');
                return;
            end;
            
            cfg.trials=indices;
            if (strcmp(method,'avg'))
% %                 
                cfg.preproc.lpfilter='yes';
                cfg.preproc.lpfreq=30;
                cfg.preproc.hpfilter='yes';
                cfg.preproc.hpfreq=1;
                % %
                cfg.preproc.demean='yes';
                cfg.preproc.detrend='yes';
                cfg.preproc.baselinewindow=[-0.2 0];
% %                  
%                  cfg.covariance='yes';
                 cfg.keeptrials='yes';
                var = ft_timelockanalysis( cfg , obj.data ) ;
                
                cfg.channel='all';
                if ( strcmp( vis , 'on' ) )
                    figure, ft_singleplotER( cfg , var ) ;
                end
                if ( strcmp ( norm_avg , 'no'))
                    out.avg=var.avg(:,time);
                elseif ( strcmp ( norm_avg, 'yes'))
                    out.avg=var.avg(:,time)/norm(var.avg(:,time));
                end
                out.var=var.var(:,time);
                if (size(var.avg,1)>1)
                    out.avg=mean(var.avg(:,time));
                    out.var=mean(var.var(:,time));
                end
                for timepoint=1:size(var.trial,3)
                                        
                   kurt(timepoint)=kurtosis((var.trial(:,end,timepoint)))-3;
                  %  negen(timepoint)
                    
                end
                out.full=var;
                out.full.avg=out.full.avg(:,time);
                out.full.var=out.full.var(:,time);
                out.full.kurt=kurt;
                if (strcmp(save2disk,'yes'))
                    
                    saveaspdf(gcf,[filename num2str(marker)],'closef')
                    
                end;
                
            elseif (strcmp(method,'wavelet'))
                
                cfg.method=method;
                cfg.toi=0:0.01:0.6;
                %cfg.foilim=[4:4:24];
                %cfg.foi=6:1:24;
                var=ft_freqanalysis(cfg,obj.data);
                cfg.layout='EEG1010.lay';
                cfg.channel='all';
                figure,ft_singleplotTFR(cfg,var);
            elseif (strcmp(method,'spectro'))
                
                %                 cfg.lpfilter='yes';
                %                 cfg.lpfreq=30;
                %                 cfg.hpfilter='yes';
                %                 cfg.hpfreq=1;
                %                 cfg.covariance='yes';
                %                 cfg.demean='yes';
                %                 cfg.detrend='yes';
                
                %                 cfg.baselinewindow=[0 0.6];
                cfg.keeptrials='yes';
                var = ft_timelockanalysis( cfg , obj.data ) ;
                
                for i=1:numel(indices)
                    [ftemp(:,:,i),start_samp,freqs]=spectrogram(var.trial(i,:,time),3,'fs',250,'nwindows',1,'overlap',0);
                end
                out.power=mean(ftemp,3);
                out.freqs=freqs;
                
            elseif (strcmp(method,'fft'))   
                
                cfg.keeptrials='yes';
                var = ft_timelockanalysis( cfg , obj.data ) ;
                L=numel(time);
                NFFT = 2^nextpow2(L); 
                %NFFT = 512;
                Fs=obj.data.cfg.resamplefs;
                f = Fs/2*linspace(0,1,NFFT/2+1);

                % Plot single-sided amplitude spectrum.
              
                for i=1:numel(indices)
                    temp=fft(var.trial(i,:,time),NFFT,3)/L;
                    temp=squeeze(temp);
                    [ftemp(:,:,i)]=2*abs(temp(:,1:NFFT/2+1));
                end
                out.power=mean(ftemp,3);
                out.freqs=f;
                
                elseif (strcmp(method,'fft2'))   
                
                cfg.keeptrials='yes';
                var = ft_timelockanalysis( cfg , obj.data ) ;
                L=numel(time)/nF;
                K=numel(time);
                NFFT = 2^nextpow2(L); 
                %NFFT = 2048;1024;512;
                Fs=obj.cfg.resampleFs;
                f = Fs/2*linspace(0,1,NFFT/2+1);

                % Plot single-sided amplitude spectrum.
                
                for i=1:numel(indices)
%                     fi=F(i,:);
%                     fi=repmat(fi,1,nF/numel(fi));
                    count=1;
                    for j=1:K/nF:K
                        temp=fft(var.trial(i,:,j:j+(K/nF)-1),NFFT,3)/L;
                        temp=squeeze(temp);
                        [ftemp(:,:,i,count)]=2*abs(temp(:,1:NFFT/2+1));
                        count=count+1;
                    end
                end
                
                out.power=mean(mean(ftemp,4),3);
                out.freqs=f;
                
            elseif (strcmp(method,'tfr'))
                
                cfg.method=method;
                cfg.toi=-1:0.01:1.5;
                cfg.foilim=[0 125];
                var=ft_freqanalysis(cfg,obj.data);
                cfg.layout='EEG1010.lay';
                cfg.channel='all';
                figure,ft_singleplotTFR(cfg,var);
                
            elseif (strcmp(method,'multi'))
                
                cfg.layout='EEG1010.lay';
                var=ft_timelockanalysis([],obj.data);
                figure,ft_multiplotER(cfg,var);
                
            elseif (strcmp(method,'diff'))
                
                figure,plot(obj.data.diff.waves);
                
            elseif (strcmp(method,'errorbar'))
                
                %cfg.covariance='yes';
                var = ft_timelockanalysis( cfg , obj.data ) ;
                figure,shadedErrorBar(var.time,var.avg,var.var.^.5,'r',1)
                
            end
            
            
        end
        
        function out = multiplot( obj , varargin)
            
            
            opts = struct( ...
                'ax', [] , ...
                'matrix', [] , ...
                'classes' , [] , ...
                'save2disk' , 'no' , ...
                'filename' , 'undefined' , ...
                'blocks_in'  , [] , ...
                'channels' , 'all' , ...
                'time' , 'all' , ...
                'trials' , 'all' , ...
                'fig' , [] , ...
                'vis' , 'on' ) ;
            
            [ opts ] = parseOpts( opts , varargin ) ;
            opts2var
            
            blocks=1:numel(obj.block_idx);
            blocks_out=setdiff(blocks,blocks_in);
            cfg.channel=channels;
            
            figure
            
            for i=1:numel(classes)
                
                [indices classlength labels]=getIndices(obj,(classes{i}),blocks_out,trials);
                cfg.trials=indices;
                subplot(matrix(1),matrix(2),i);
                cfg.covariance='yes';
                cfg.demean='yes';
                %cfg.detrend='yes';
                cfg.baselinewindow=[-0.1 0];
                %cfg.lpfilter='yes';
                %cfg.lpfreq=15;
                var = ft_timelockanalysis( cfg , obj.data ) ;
                
                cfg.channel='all';
                if ( strcmp( vis , 'on' ) )
                    ft_singleplotER( cfg , var ) ;
                    ylabel(obj.full_name);
                    title(classes{i})
                    if (~isempty(ax))
                        axis(ax);
                    end
                    
                end
                
                out.avg=(var.avg);
                out.var=var.var;
                if (strcmp(save2disk,'yes'))
                    
                    saveaspdf(gcf,[filename num2str(marker)],'closef')
                    
                end;
                
                
            end
            
        end
        
        function new = copy(obj)
            
            new = feval(class(obj));
            
            members = properties(obj);
            for i = 1:length(members)
                try new.addprop(members{i})
                catch err
                end
                new.(members{i}) = obj.(members{i});
            end
        end
        
        function [out]=cool(obj,varargin)
            opts = struct( ...
                'classes' , [] , ...
                'trials', 'all' , ...
                'blocks_in'  , 'all' , ...
                'channels' , 'all' , ...
                'time' , 'all' , ...
                'vis', 'off') ;
            
            if (nargin==1)
                [ opts ] = parseOpts( opts , varargin ) ;
                opts
                fprintf('\n Required inputs: classes\n');
                
            elseif (nargin >1)
                
                [ opts ] = parseOpts( opts , varargin ) ;
                opts2var
                
                [time channels]=convertall2var(obj,time,channels);
                [blocks_in blocks_excluded]=getBlocks(obj,blocks_in);
                [indices classlength labels]=getIndices(obj,classes,blocks_excluded,trials);
                
                sprintf('Class 1 length: %d \nClass 2 length: %d ',classlength(1),classlength(2))
                
                X=cat(3,obj.data.trial{indices});
                X=X(channels,time,:);
                a=0;b=0;
                global mmn
                figure(1),hold on
                for i=1:classlength(1)
                    x=X(:,:,i);
                    y=x'*inv(x*x')*x*mmn';
                    figure(1),plot(y)
                    w(:,i)=inv(x*x')*x*mmn';
                    a=a+y;
                    ra(i)=norm(y-mmn');
                end
                a=a/classlength(1);
                figure(2),hold on
                for i=classlength(1)+1:classlength(1)+classlength(2)
                    x=X(:,:,i);
                    y=x'*inv(x*x')*x*mmn';
                    figure(2),plot(y)
                    w(:,i)=inv(x*x')*x*mmn';
                    b=b+y;
                    ra(i)=norm(y-mmn');
                end
                b=b/classlength(2);
                figure,hold on,plot(a,'r'),plot(b,'g')
                figure,plot(filter(1/10*ones(1,10),1,ra));
            end
            out.w=w;
        end
        
    end
    
end

