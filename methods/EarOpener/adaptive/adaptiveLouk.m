classes={{16};{22}};
channels=1:64;
Ct=[];
clear Gen Ada Ind R Ada2 IndVal GenVal
freqband=[.5 13];
for i=1:15
    
    G.(varnamesEproper{i}).default.train_classifier('Cs',Ct,'nfolds',10,'name','normal',...
        'classes',classes,'blocks_in','all','time',1:64,'channels',channels,...
        'freqband',freqband,'objFn','klr_cg');
    Ww(:,:,i)=G.(varnamesEproper{i}).default.normal.W;
    bb(i)=G.(varnamesEproper{i}).default.normal.b;
    
end
idx=1:15;
nfolds=10;
for si=idx
    itest=si;
    itrain=setdiff(idx,itest);
    itrain
    
    Stest=G.(varnamesEproper{itest});
    W=mean(Ww(:,:,itrain),3);
    
    %% weighted average
%     count=0;
%     for i=itrain
%         count=count+1;
%         ww(:,count)=vec(Ww(:,:,i));
%     end
%     Sigma=std(ww,0,2);
%     Sigma=Sigma/max(Sigma);
%     Sigma=1./Sigma;
%     Sw=reshape(Sigma,64,64);
%     Www=repop(Ww(:,:,itrain),'*',Sw,3);
%     W=mean(Www,3);
    %%
    bias=mean(bb(itrain));    
    
    count=0;    
    
    for ntrials=20:5:150    
            
            count=count+1;
           
            tr_st=1:ntrials;tr_dev=(1:ntrials)+300;
            ts_st=151:300;ts_dev=451:600;%
            
            Stest.default.train_classifier('classes',classes,'blocks_in',[1:4],...
                'trials',[tr_st tr_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
                'time',1:64,'channels',channels,'Cs',[],...
                'objFn','klr_cg','Cscale',[],'nfolds',nfolds,'freqband',freqband);
            
%             Wtransf=Stest.default.transfer.W;
%             btransf=Stest.default.transfer.b;
            
            gen=Stest.default.apply_classifier(Stest.default,...
                'trials',[ts_st ts_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
                'time',1:64,'channels',channels,'W',W,'bias',bias,'freqband',freqband);            
                        
            
            ind=Stest.default.apply_classifier(Stest.default,...
                'trials',[ts_st ts_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
                'time',1:64,'channels',channels,'freqband',freqband);
                                    
                        
            Gen=gen.rate(3);
            Ind=ind.rate(3);
            
            labtst=ind.labels';
            fGen=gen.f;
            fInd=ind.f;
            fAda=fGen+fInd;
            Ada=sum(fAda.*labtst'>0)/numel(labtst);     
            
            cada=[];
            A=[];
            for cidx=1:numel(itrain)
                cada{end+1}=Stest.default.apply_classifier(Stest.default,...
                'trials',[tr_st tr_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
                'time',1:64,'channels',channels,'W',Ww(:,:,itrain(cidx)),'bias',bb(itrain(cidx)),'freqband',freqband); 
                A(:,end+1)=cada{end}.f';
            end
            labtrn=cada{end}.labels';
            theta=inv(A'*A)*A'*labtrn;
            theta2=inv(A'*A+eye(size(A'*A)))*A'*labtrn;
            theta3=lsqnonneg(A,labtrn);
            theta4=inv(A'*A+100*eye(size(A'*A)))*A'*labtrn;
            cada=[];
            A=[];
            for cidx=1:numel(itrain)
                cada{end+1}=Stest.default.apply_classifier(Stest.default,...
                'trials',[ts_st ts_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
                'time',1:64,'channels',channels,'W',Ww(:,:,itrain(cidx)),'bias',bb(itrain(cidx)),'freqband',freqband); 
                A(:,end+1)=cada{end}.f';
            end
            
            fAda2=A*theta;
            Ada2=sum(fAda2.*labtst>0)/numel(labtst);
            fAda3=A*theta2;
            Ada3=sum(fAda3.*labtst>0)/numel(labtst);
            fAda4=fAda2+fInd';
            Ada4=sum(fAda4.*labtst>0)/numel(labtst);
            fAda5=fAda3+fInd';
            Ada5=sum(fAda5.*labtst>0)/numel(labtst);
            fAda6=A*theta3;
            Ada6=sum(fAda6.*labtst>0)/numel(labtst);
            fAda7=fAda6+fInd';
            Ada7=sum(fAda7.*labtst>0)/numel(labtst);
            fAda8=A*theta4;
            Ada8=sum(fAda8.*labtst>0)/numel(labtst);
            fAda9=fAda8+fInd';
            Ada9=sum(fAda9.*labtst>0)/numel(labtst);
            
        R(si,:,count)=[Gen Ada Ada2 Ada3 Ada4 Ada5 Ada6 Ada7 Ada8 Ada9 Ind];
        
    end
end
save('R','R')






