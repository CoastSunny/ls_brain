 function out = train_classifier( obj , varargin )

opts = struct( ...
    'name'    , 'test' , ...
    'classes' , [] , ...
    'classes_outer', [] , ...
    'target_labels', [-1 +1] , ...
    'blocks_in'  , 'all' , ...
    'blocks_outer', 'none' , ...
    'channels' , 'all' , ...
    'time' , 'all' , ...
    'detrenddat' , 'yes' , ...
    'filterdat', 'yes' , ...
    'freqband' , [1 20] , ...
    'frequency_transform' , 'none' , ...
    'times_in', [] , ...
    'freqs_in' , [] , ...
    'nfolds' , 10 , ...
    'fIdxs' , [] , ...
    'Cs', [] , ...
    'Cscale', [] , ...
    'vis' , 'off' , ...
    'cleverstuff' , 'normal' , ...
    'method' , 'all', ...
    'dim' , 3 , ...
    'trials' , 'all' , ...
    'calibrate', 'cr' , ...
    'balYs' , 1 , ...
    'sorti', 'yes' , ...
    'spatialfilter' , [] , ...
    'capfile' , [] , ...
    'ls_fit','no', ...
    'wavebeam','no',...
    'objFn','klr_cg',...
    'w_template',[]) ;
[ opts ] = parseOpts( opts , varargin ) ;
if (nargin==1)
    
    opts
    fprintf('\n Required inputs: classes\n');
    
elseif ( nargin > 1 )
    
    opts2var
    try obj.addprop(name);
    catch err
        % delete(obj.(name));
    end
    
    [time channels]=convertall2var(obj,time,channels);
    [blocks_in blocks_excluded]=getBlocks(obj,blocks_in);
    [indices classlength labels]=getIndices(obj,classes,blocks_excluded,trials);
    fprintf('Careful\n');
    if (strcmp(sorti,'yes'))
        [indices si]=sort(indices);
        labels=labels(si);
    end
    fprintf('\nClass 1\t markers:\t%s \n\t examples:\t%d \n\t labels:\t -1 \nClass 2\t markers:\t%s \n\t examples:\t%d \n\t labels:\t +1 \n\n ', num2str(cell2mat(classes{1})),classlength(1),num2str(cell2mat(classes{2})),classlength(2))
    if (classlength(1)/classlength(2)<0.8 | classlength(2)/classlength(1)<0.8)
        fprintf('\n Have you used a classifier that balances the classes? \n');
    end
    
    %check validity by randomizing indices
    %indices=indices(randperm(numel(indices)));
    X=cat(3,obj.data.trial{indices});
    X=X(channels,time,:);
    
    fprintf('classification starting...\n');
    X=ls_whiten(X,4,2,3,1,1:64);
    if (strcmp(filterdat,'yes'))
        fs=obj.data.fsample;
        len=size(X,2);
        filt=mkFilter(freqband,floor(len/2),fs/len);
        X=fftfilter(X,filt,[0 len],2,1);
    end
    if (strcmp(detrenddat,'yes'))
        X=detrend(X,2); % detrend over time
    end
    %% 3) Surface Laplacian
    if (~isempty(spatialfilter))
        %
        R=[];
        if ( size(X,1)> 5 ) % only spatial filter if enough channels
            switch ( spatialfilter )
                case 'slap';
                    fprintf('3) Slap\n');
                    di = addPosInfo(channels,capfile); % get 3d-coords
                    ch_pos=cat(2,di.extra.pos3d); ch_names=di.vals; % extract pos and channels names
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
    size(X)
   
    %%
%         [isbad]=idOutliers(X,1,3);
%         X=X(~isbad,:,:);
% 
%         [badtr,vars]=idOutliers(X,3,3);
%         X=X(:,:,~badtr);
%         labels=labels(:,~badtr);
%         out.nobadtr=sum(badtr>0);
    
    if (strcmp(frequency_transform,'spectrogram'))
        [X ss f o]=spectrogram(X,2,'fs',fs,'width_ms',250,'overlap',0.5);             
        
    end
    
    dim=ndims(X);
    if (strcmp(cleverstuff,'normal')) 
        
        [clsfr, res]=cvtrainLinearClassifier(X,labels,Cs,nfolds,'Cscale',Cscale,'dim',dim,'zeroLab',1,'balYs',balYs,'objFn',objFn,'fIdxs',fIdxs,'calibrate',calibrate);%,'w_template',w_template);
        
    elseif (strcmp(cleverstuff,'rfe'))
        size(X)
        out=rfe(X,labels,method,channels,nfolds);
        clsfr=out.opt.clsfr;
        res=out.opt.res;
        
    elseif (strcmp(cleverstuff,'nirs'))
        
        count=1;
        for i=1:size(X,3)
            
            for j=1:5
                y(:,:,count) = mean(X(:,1+30*(j-1):30*(j-1)+30,i),2);%3 sec windows
                %y(:,:,count) = (X(:,1+30*(j-1):30*(j-1)+30,i));%3 sec windows
                count = count+1;
            end
            
        end
        
        X=y;
        size(X)
        temp=size(y,3);
        labels(1:temp/2)=-1; labels((temp/2)+1:temp)=1;
        test=cell2mat(classes{2});
        
        fIdxs=obj.eeg.fI;
        if test==5
            if (size(fIdxs,1)==180)
                fIdxs(61:120,:)=[];
            elseif (strcmp(obj.full_name(1:2),'C8'))
                fIdxs(61:110,:)=[];
            end
            
        else
            if (size(fIdxs,1)==180)
                fIdxs(121:180,:)=[];
            elseif (strcmp(obj.full_name(1:2),'C8'))
                fIdxs(111:170,:)=[];
            end
        end
        
        tmp=reshape(y,size(X,1),5,size(fIdxs,1)/5);
        tmpr=tmp(:,:,1:12);
        tmpm=tmp(:,:,13:end);
        % for i=1:12
        %     rest=fIdxs(1:60,i);
        %     mov=fIdxs(61:120,i);
        %     fIdxs(:,i)=[rest(randperm(60)); mov(randperm(60))];
        % end
        [clsfr, res]=cvtrainLinearClassifier(X,labels,Cs,nfolds,'fIdxs',fIdxs,'dim',dim,'zeroLab',1,'balYs',balYs,'objFn','klr_cg','calibrate',calibrate);
%         if(size(y,1)==2)
%             figure,hold on
%             for i=1:120
%                 if i<61
%                     plot(y(1,:,i),y(2,:,i),'go')
%                 else
%                     plot(y(1,:,i),y(2,:,i),'r+')
%                 end
%             end
%             x=-3:0.1:3;
%             f=-(clsfr.W(1).*x+clsfr.b)/clsfr.W(2);
%             
%             plot(x,f,'LineWidth',2);
%             if (strcmp(name,'co25'))
%                 tempname='Oxy IM';
%             elseif (strcmp(name,'co23'))
%                 tempname='Oxy AM';
%             elseif (strcmp(name,'ch25'))
%                 tempname='Deoxy IM';
%             elseif (strcmp(name,'ch23'))
%                 tempname='Deoxy AM';
%             end
%             title([obj.full_name(1:3) ' perf: ' num2str(max(res.tstbin)) ' type: ' tempname]);legend({'rest','movement'})
%             axis([min(y(1,:,:)) max(y(1,:,:)) min(y(2,:,:)) max(y(2,:,:))]);
%         end        
%         
%         for i=1:12
%              figure,hold on
%               x=-3:0.1:3;
%             f=-(clsfr.W(1).*x+clsfr.b)/clsfr.W(2);
%               plot(x,f,'LineWidth',2);
%             trx=y;
%             tmp=zeros(1,120);
%             tmp([ (i-1)*5+1:(i-1)*5+5 (i-1)*5+61:(i-1)*5+65])=1;
%             trx(:,:, logical(tmp))=[];
%             tstx=y;
%             tstx(:,:,~logical(tmp))=[];
%             for i=1:110
%                 if i<56
%                     plot(trx(1,:,i),trx(2,:,i),'go')
%                 else
%                     plot(trx(1,:,i),trx(2,:,i),'r+')
%                 end
%             end
%             for i=1:10
%                 if i<6
%                     plot(tstx(1,:,i),tstx(2,:,i),'gd','LineWidth',4)
%                 else
%                     plot(tstx(1,:,i),tstx(2,:,i),'rd','LineWidth',4)
%                 end
%             end
%             axis([min(y(1,:,:)) max(y(1,:,:)) min(y(2,:,:)) max(y(2,:,:))]);
% %             text(0,0,num2str(clsfr.W(1)))
% %             text(0,0,num2str(clsfr.W(2)))
%         end
%         
     end
    
    obj.(name)=clsfr;
    try
        obj.(name).distmean=mean(abs(mean(tmpm,3)-mean(tmpr,3)));
    catch err
    end
    obj.(name).res=res;
    obj.(name).f=res.tstf(:,:,res.opt.Ci);
    %     obj.(name).isbad=isbad;
    %     obj.(name).badtr=badtr;
    obj.(name).labels=labels;
    obj.(name).perf=max(obj.(name).res.tstbin);
    obj.(name).options=varargin;
    
    if (exist('out','var'))
        obj.(name).rfe=out;
    end
    
    %%%Results%%%%
    fprintf('\nTraining set performance: %0.3f\n',max(obj.(name).res.trnbin));
    fprintf('Validation set performance: %0.3f\n',max(obj.(name).res.tstbin));
    out.rate=max(obj.(name).res.tstbin);
    out.rateauc=max(obj.(name).res.tstauc);
    f=obj.(name).res.tstf(:,:,obj.(name).res.opt.Ci);
    fp=f(labels==+1);rp=sum(fp>0)/numel(fp);fn=f(labels==-1);rn=sum(fn<0)/numel(fn);
    ft=[-1*fn' fp'];rt=sum(ft>0)/numel(ft);
    fprintf('Negative class rate: %0.3f \nPositive class rate: %0.3f \n',rn,rp);
    out.f=f;
    out.p=1./(1+exp(-f));
    out.labels=labels;
    out.rn=rn;
    out.rp=rp;
    out.Ci=obj.(name).res.opt.Ci;
    if ( ~strcmp(blocks_outer,'none') )
        
        if (~isempty(classes_outer))
            tmp=strmatch('classes',varargin(1:2:end),'exact');
            varargin{tmp*2}=classes_outer;
        end
        tmp=strmatch('blocks_in',varargin(1:2:end));
        varargin{tmp*2}=blocks_outer;
        
        out = obj.apply_classifier( obj , varargin);
        if (numel(target_labels)==1)
            fprintf('Outer fold class rate: %0.3f \n',out.rate);
        else
            fprintf('Outer fold performance: \n class1: %0.3f \n class2: %0.3f \n performance: %0.3f\n ', ...
                out.rate(1),out.rate(2),out.rate(3));
        end
        
    end
    %%%Results%%%%
    
    if (strcmp(vis,'on2'))
        
        W=clsfr.W;
        [U S V]=svd(W);
        s=diag(S);
        s=s.^2;
        t=time/fs;
        figure,hold on,plot(t,V(:,1),'r'),plot(t,V(:,2),'g'),plot(t,V(:,3),'b')
        legend({num2str(s(1)/sum(s)) num2str(s(2)/sum(s)) num2str(s(3)/sum(s))})
        title('First 3 principal components'),xlabel('time')
        dw=obj.diff_wave('classes',classes,'blocks_in',blocks_in,'time',time,'vis','off');
        figure,hold on, plot(t,V(:,1),'r'),plot(t,dw/norm(dw),'g')
        title('PC1 and difference wave,normalised'),xlabel('time')
        figure,hold on, plot(t,V(:,1),'r'),plot(t,-dw/norm(dw),'g')
        title('PC1 and difference wave,normalised'),xlabel('time')
        dw=obj.diff_wave('classes',classes,'blocks_in',blocks_in,'vis','off',...
            'difftype','spacewave','channels',channels);
        figure,hold on, plot(U(:,1),'r'),plot(dw/norm(dw),'g')
        title('space PC1 and space difference wave,normalised'),xlabel('electrode number')
        [fpr,tpr,bias,AUC,OPTROCPTSUBY,SUBYNAMES] = perfcurve(labels,f,1);
        figure,plot(fpr,tpr,'.');xlabel('FPR'),ylabel('TPR');title('ROC curve by varying classifier bias, validation set');
        figure,hold on,plot(bias+obj.(name).b,1-fpr,'r'),plot(bias+obj.(name).b,tpr,'g'),plot(obj.(name).b,rt,'o')
        title('class rates with varying bias')
        xlabel('absolute bias');ylabel('class rate');
        
    end
end

end
%   X=mean(X,2);
%size(X)
% for i=1:size(X,3);
%     z=X(:,:,i);
%     z=z(:);
%     for j=2:14
%
%         z(excluded{j})=[];
%
%     end
%     Z(:,1,i)=z;
% end
% clear X
% X=Z;
%X=cumsum(X);
%    for i=1:size(X,3)/2
%        a(i)=X(1,1,i);
%        b(i)=X(1,2,i);
%        c(i)=X(1,3,i);
%    end
%    figure
%    scatter3(a,b,c);
%    %scatter3(b,c,b.*c);
%    hold on
%    for i=1:size(X,3)/2
%        a(i)=X(1,1,i+size(X,3)/2);
%        b(i)=X(1,2,i+size(X,3)/2);
%        c(i)=X(1,3,i+size(X,3)/2);
%    end
%    scatter3(a,b,c,'+')
%    %scatter3(b,c,b.*c,'+')
%
%  x=mean(X(:,1:1250,:),2);
%         y=mean(X(:,1251:2500,:),2);
%         z=mean(X(:,2501:3750,:),2);
%         w=mean(X(:,3751:5000,:),2);
%         for i=1:size(X,3)
%             e1(:,:,i)=var(X(:,1:1250,i)')';
%             e2(:,:,i)=var(X(:,1251:2500,i)')';
%             e3(:,:,i)=var(X(:,2501:3750,i)')';
%             e4(:,:,i)=var(X(:,3751:5000,i)')';
%         end
%
%         X=[x y z w];