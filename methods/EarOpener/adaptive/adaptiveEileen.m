classes={{14};{20}};
channels=1:64;
Ct=[];
clear Gen Ada Ind R Ada2 IndVal GenVal
for i=1:15
    
    G.(varnamesEproper{i}).default.train_classifier('Cs',Ct,'nfolds',10,'name','normal',...
        'classes',classes,'blocks_in','all','time',1:64,'channels',channels,...
        'freqband',[0.5 13],'objFn','klr_cg');
    Ww(:,:,i)=G.(varnamesEproper{i}).default.normal.W;
    bb(i)=G.(varnamesEproper{i}).default.normal.b;
    
end
idx=1:15;

for si=idx
    itest=si;
    itrain=setdiff(idx,itest);
    itrain
    
    Stest=G.(varnamesEproper{itest});
    W=mean(Ww(:,:,itrain),3);
    
    %% weighted average
    count=0;
    for i=itrain
        count=count+1;
        ww(:,count)=vec(Ww(:,:,i));
    end
    Sigma=std(ww,0,2);
    Sigma=Sigma/max(Sigma);
    Sigma=1./Sigma;
    Sw=reshape(Sigma,64,64);
    Www=repop(Ww(:,:,itrain),'*',Sw,3);
    W=mean(Www,3);
    %%
    bias=mean(bb(itrain));    
    
    count=0;    
    
    for ntrials=20:5:150    
            
            count=count+1;
            Cs=Css*ntrials/20;
            tr_st=1:ntrials;tr_dev=(1:ntrials)+300;
            ts_st=151:300;ts_dev=451:600;%
            
            Stest.default.train_classifier('classes',classes,'blocks_in',[1:4],...
                'trials',[tr_st tr_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
                'time',1:64,'channels',channels,'Cs',[],...
                'objFn','klr_cg','Cscale',[],'nfolds',nfolds);
            
            Wtransf=Stest.default.transfer.W;
            btransf=Stest.default.transfer.b;
            
            gen=Stest.default.apply_classifier(Stest.default,...
                'trials',[ts_st ts_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
                'time',1:64,'channels',channels,'W',W,'bias',bias);            
            
            ada=Stest.default.apply_classifier(Stest.default,...
                'trials',[ts_st ts_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
                'time',1:64,'channels',channels,'W',(W*14/15+Wtransf.*Sw/15),'bias',bias*(1-Cs)+Cs*btransf);
            
            ind=Stest.default.apply_classifier(Stest.default,...
                'trials',[ts_st ts_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
                'time',1:64,'channels',channels);
                                    
                        
            Gen=gen.rate(3);
            Ada=ada.rate(3);            
            Ind=ind.rate(3);                                                           
                                                  
        
        R(si,:,count)=[Gen Ada Ind];
        
    end
end
save('R','R')
