
%clear Ww ww bb
clear Gen_weighted Gen_mean 

classes={{14};{20}};
channels=1:64;
time=1:64;
Ct=[];
ts_st=1:300;
ts_dev=301:600;
F=[];
Y=[];
nosubjects=15;%how many subjects we are combining
nosubjects_test=15;%by setting that to 8 it makes it comparable to what you have done so far
% for later you should set it to 15
% %% train classifiers
for i=1:nosubjects_test
    
    G.(varnamesEproper{i}).default.train_classifier('Cs',Ct,'nfolds',10,...
        'classes',classes,'blocks_in','all','time',time,'channels',channels,...
        'freqband',[0.5 13],'objFn','lr_cg');
    Ww(:,:,i)=G.(varnamesEproper{i}).default.test.W;
    bb(i)=G.(varnamesEproper{i}).default.test.b;
    
end
%%

Comb_Matrix=nchoosek(1:nosubjects_test,nosubjects);
%%
for ci=1:size(Comb_Matrix,2)%ci stands for a set of subjects
    
    for si=Comb_Matrix(ci)%si is the subject index for some ci
        
        itest=si;
        itrain=setdiff(Comb_Matrix,itest);
        
        Stest=G.(varnamesEproper{si});
        W1=mean(Ww(:,:,itrain),3);
        count=0;
        for i=itrain
            count=count+1;
            ww(:,count)=vec(Ww(:,:,i));
        end
        Sigma=std(ww,0,2);
        Sigma=Sigma/max(Sigma);
        Sigma=1./Sigma;
        Sw=reshape(Sigma,numel(channels),64);
        Www=repop(Ww(:,:,itrain),'*',Sw,3);
        W2=mean(Www,3);
        bias=mean(bb(itrain));
        %bias=0;
        %%
        gen_weighted=Stest.default.apply_classifier(Stest.default,...
            'trials',[ts_st ts_dev],'classes',classes,'blocks_in',1:4,...
            'freqband',[0.5 13],'time',time,'channels',channels,'W',W2,'bias',bias);
        gen_mean=Stest.default.apply_classifier(Stest.default,...
            'trials',[ts_st ts_dev],'classes',classes,'blocks_in',1:4,...
            'freqband',[0.5 13],'time',time,'channels',channels,'W',W1,'bias',bias);
        
        cada=[];      
        for cidx=1:nosubjects
            if ~isempty(intersect(itrain,cidx))
            cada{cidx}=Stest.default.apply_classifier(Stest.default,...
                'trials',[ts_st ts_dev],'classes',classes,'blocks_in',1:4,...
                'time',1:64,'channels',channels,'W',Ww(:,:,cidx),'bias',bb(cidx),'freqband',[0.5 13]);
            F(:,cidx,ci)=cada{cidx}.f';
            Y(:,cidx,ci)=cada{cidx}.labels;
            else
                F(:,cidx,ci)=out1{cidx}.f;
                Y(:,cidx,ci)=out1{cidx}.labels;
            end
            
        end
        
        Gen_weighted(ci,si)=gen_weighted.rate(3);%nevermind that for now
        Gen_mean(ci,si)=gen_mean.rate(3);%this is what you want :)
        
    end
    
end




