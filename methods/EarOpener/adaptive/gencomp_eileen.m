
%clear Ww ww bb 
clear Gen_weighted Gen_mean R

classes={{14};{20}};
channels=1:64;
time=1:64;
Ct=[];
ts_st=1:300;
ts_dev=301:600;

nosubjects=15;%how many subjects we are combining
nosubjects_test=3;%by setting that to 8 it makes it comparable to what you have done so far
                  % for later you should set it to 15 together with
                  % nosubjects=15

% train classifiers
for i=1:nosubjects
    
    G.(varnamesEproper{i}).default.train_classifier('Cs',Ct,'nfolds',10,...
        'classes',classes,'blocks_in','all','time',time,'channels',channels,...
        'freqband',[0.5 13],'objFn','klr_cg');
    Ww(:,:,i)=G.(varnamesEproper{i}).default.test.W;
    bb(i)=G.(varnamesEproper{i}).default.test.b;
    
end
%
for loopindex=1:12
start = tic;
Comb_Matrix=nchoosek(1:nosubjects,nosubjects_test);
loopindex
for ci=1:size(Comb_Matrix,1)%ci stands for a set of subjects
         
    for si=Comb_Matrix(ci,:)%si is the subject index for some ci
        
        itest=si;
        itrain=setdiff(Comb_Matrix(ci,:),itest);
        
        Stest=G.(varnamesEproper{i});
        W1=mean(Ww(:,:,itrain),3);
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
        W2=mean(Www,3);
        bias=mean(bb(itrain));
        %bias=0;
        
        gen_weighted=Stest.default.apply_classifier(Stest.default,...
            'trials',[ts_st ts_dev],'classes',classes,'blocks_in',1:4,...
            'freqband',[0.5 13],'time',time,'channels',channels,'W',W2,'bias',bias);
        gen_mean=Stest.default.apply_classifier(Stest.default,...
            'trials',[ts_st ts_dev],'classes',classes,'blocks_in',1:4,...
            'freqband',[0.5 13],'time',time,'channels',channels,'W',W1,'bias',bias);
        
        %Gen_weighted(ci,si)=gen_weighted.rate(3);%nevermind that for now
        %Gen_mean(ci,si)=gen_mean.rate(3);%this is what you want :)
        R(loopindex).Gen_weighted(ci,si)=gen_weighted.rate(3);%nevermind that for now
        R(loopindex).Gen_mean(ci,si)=gen_mean.rate(3);%this is what you want :)
        %R7.Gen_weighted(ci,si)=gen_weighted.rate(3);%nevermind that for now
        %R7.Gen_mean(ci,si)=gen_mean.rate(3);%this is what you want :)
       
    end
    %Result(loopindex)=mean(mean(Gen_mean(loopindex,:,:)));
%end
 
end
nosubjects_test = nosubjects_test + 1;
save('R','R');
duration = toc(start)
end
