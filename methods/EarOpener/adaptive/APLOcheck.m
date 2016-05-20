classes={{16};{22}};
channels=1:64;
Ct=[];
clear Gen Ada Ind R Ada2 IndVal GenVal
% for i=1:15
% 
% G.(varnamesEproper{i}).default.train_classifier('Cs',Ct,'nfolds',10,'name','normal',...
%     'classes',classes,'blocks_in','all','time',1:64,'channels',channels,...
%     'freqband',[0.5 13],'objFn','klr_cg');
% Ww(:,:,i)=G.(varnamesEproper{i}).default.normal.W;
% bb(i)=G.(varnamesEproper{i}).default.normal.b;
% end
idx=1:15;
for si=idx
itest=si;
itrain=setdiff(idx,itest);
itrain
Stest=G.(varnamesEproper{itest});
W=mean(Ww(:,:,itrain),3);
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
bias=mean(bb(itrain));

ntrials=50;
count=0;
Css=[0.05];
nfolds=10;
for ntrials=20:5:150
for i=1:1
    
    %a=randperm(300);b=randperm(300)+300;
%     tr_st=a(1:n_trials);tr_dev=b(1:n_trials);
%     ts_st=a(n_trials+1:end);ts_dev=b(n_trials+1:end);
%     tr_st=1:50;tr_dev=301:350;
%     ts_st=51:300;ts_sev=351:600;
%     
count=count+1;
Cs=Css*ntrials/20;
        tr_st=1:ntrials;tr_dev=(1:ntrials)+300;
        %ts_st=ntrials+1:300;ts_dev=(ntrials+1)+300:600;
        ts_st=151:300;ts_dev=451:600;
%     Stest.default.train_classifier('classes',classes,'blocks_in',[1:4],...
%         'trials',[tr_st tr_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
%         'time',1:64,'channels',channels,'Cs',Cs,...
%         'objFn','train_cg_con','w_template',W,'Cscale',1,'nfolds',nfolds);
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
        'time',1:64,'channels',channels,'W',(W*(1-Cs)+Cs*Wtransf.*Sw),'bias',bias*(1-Cs)+Cs*btransf);
    
    ada2=Stest.default.apply_classifier(Stest.default,...
        'trials',[ts_st ts_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
        'time',1:64,'channels',channels,'W',(W*14/15+Wtransf.*Sw/15),'bias',bias*(1-Cs)+Cs*btransf);
    
    ind=Stest.default.apply_classifier(Stest.default,...
        'trials',[ts_st ts_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
        'time',1:64,'channels',channels);
     indt=Stest.default.apply_classifier(Stest.default,...
        'trials',[tr_st tr_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
        'time',1:64,'channels',channels);
    
    genval=Stest.default.apply_classifier(Stest.default,...
        'trials',[tr_st tr_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
        'time',1:64,'channels',channels,'W',W,'bias',bias);
   
    
    Gen(i)=gen.rate(3);
    Ada(i)=ada.rate(3);
    Ada2(i)=ada2.rate(3);
    Ind(i)=ind.rate(3);
    IndVal(i)=Stest.default.transfer.perf;
    GenVal(i)=genval.rate(3);
    b1f=(ada.f+gen.f).*gen.labels;
    b2f=(0.5*ind.f+0.5*gen.f).*gen.labels;
    Bayes1(i)=sum(b1f>0)/numel(b1f);
    Bayes2(i)=sum(b2f>0)/numel(b2f);
    
    Stest.default.train_classifier('classes',classes,...
        'trials',[tr_st tr_dev],'name','advisor','classes',classes,'blocks_in',1:4,...
        'time',1:64,'channels',channels,'Cs',0,...
        'objFn','klr_cg','Cscale',[],'nfolds',1,'advisor',genval.f);
    
    ada3=Stest.default.apply_classifier(Stest.default,...
        'trials',[ts_st ts_dev],'name','advisor','classes',classes,'blocks_in',1:4,...
        'time',1:64,'channels',channels,'advisor',gen.f);
    
    Ada3(i)=ada3.rate(3);
    F=[];
    for ic=itrain
    
         temp=Stest.default.apply_classifier(Stest.default,...
        'trials',[tr_st tr_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
        'time',1:64,'channels',channels,'W',Ww(:,:,ic),'bias',bb(ic));
        F(end+1,:)=temp.f;
    end
    F(end+1,:)=indt.f;
    F(end+1,:)=ones(1,size(F,2));
    weights=inv(F*F'+100*eye(size(F,1)))*F*temp.labels';
    weights(weights(1:end-1)<0)=0;
   % weights=lsqnonneg(F',temp.labels');
    Ada4val=sum( ( ( weights'*F ).*temp.labels ) > 0 ) / numel( temp.labels );
    Fo=[];
    for ic=itrain
        
         temp=Stest.default.apply_classifier(Stest.default,...
        'trials',[ts_st ts_dev],'name','transfer','classes',classes,'blocks_in',1:4,...
        'time',1:64,'channels',channels,'W',Ww(:,:,ic),'bias',bb(ic));
        Fo(end+1,:)=temp.f;
    end
    Fo(end+1,:)=ind.f;
    Fo(end+1,:)=ones(1,size(Fo,2));
    Ada4(i)= sum( ( ( weights'*Fo ).*temp.labels ) > 0 ) / numel( temp.labels );
    
end

R(si,:,count)=[mean(Gen)    mean(Ada)    mean(Ada2)  mean(Ada3)   mean(Ada4) mean(Ada4val) ...
               mean(GenVal) mean(IndVal) mean(Ind)   mean(Bayes1) mean(Bayes2)];
           
end
end