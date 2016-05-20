k=1;
members=sort(properties(GRID));
timein=1:150;
t=timein./250;
tf=(0:75)/150*250;
txlim=[0 0.6];
fxlim=[0 125];
tmp=35;
train_sl=repmat(tmp,1,12);%12 train targets
channels=1:10;
%for j=1:100
spf=[];
cal='cr';
for j=1:numel(members)
    
    S=GRID.(members{j}).copy;
    tmp1=S.default.train_classifier('spatialfilter',spf,'name','train','classes',{{0};{1}},'channels',channels,'freqband',[0.1 10],'vis','off','balYs',0,'calibrate',cal,'sorti','yes');
    tmp2=S.default.train_classifier('spatialfilter',spf,'name','test1','classes',{{10};{11}},'channels',channels,'freqband',[0.1 10],'vis','off','balYs',0,'calibrate',cal,'sorti','yes');
    tmp3=S.default.train_classifier('spatialfilter',spf,'name','test2','classes',{{20};{21}},'channels',channels,'freqband',[0.1 10],'vis','off','balYs',0,'calibrate',cal,'sorti','yes');
    Wtr=S.default.train.W;Wtst1=S.default.test1.W;Wtst2=S.default.test2.W;
    [U Str Vtr]=svd(Wtr);[U Stst1 Vtst1]=svd(Wtst1);[U Stst2 Vtst2]=svd(Wtst2);  
    str=diag(Str);str=str.^2;stst1=diag(Stst1);stst1=stst1.^2;stst2=diag(Stst2);stst2=stst2.^2;
    cost1 = dot(Wtr(:),Wtst1(:))/(norm(Wtr(:))*norm(Wtst1(:)));
    cost2 = dot(Wtr(:),Wtst2(:))/(norm(Wtr(:))*norm(Wtst2(:)));
    degt1 = acos(cost1)*180/pi;
    degt2 = acos(cost2)*180/pi;
    D(j,:)=[degt1 degt2];
   % D(j,:)=[subspace(Wtr',Wtst1')*180/pi subspace(Wtr',Wtst2')*180/pi];
  %  figure,hold on,plot(Vtr(:,1),'r'),plot(Vtst1(:,1),'g'),plot(Vtst2(:,1),'b'),title(members{j})
  %  legend({ num2str(str(1)/sum(str)) num2str(stst1(1)/sum(stst1)) num2str(stst2(1)/sum(stst2)) })
    out1=S.default.apply_classifier(S.default,'spatialfilter',spf,'name','train','classes',{{10};{11}},'sorti','yes','channels',channels,'freqband',[0.1 10]);
    out2=S.default.apply_classifier(S.default,'spatialfilter',spf,'name','train','classes',{{20};{21}},'sorti','yes','channels',channels,'freqband',[0.1 10]);  
    
    Lrate(j,1)=tmp1.rate;
    Lrate(j,2)=tmp2.rate;
    Lrate(j,3)=tmp3.rate;
    Lrate(j,4)=(out1.rate(1)+out1.rate(2))/2;
    Lrate(j,5)=(out2.rate(1)+out2.rate(2))/2;
    Lauc(j,1)=tmp1.rateauc;
    Lauc(j,2)=tmp2.rateauc;
    Lauc(j,3)=tmp3.rateauc;
    try
        Lbad(j,1)=tmp1.nobadtr;
        Lbad(j,2)=tmp2.nobadtr;
        Lbad(j,3)=tmp3.nobadtr;
    catch err
    end
    
    train_targets=S.default.markers(S.default.markers>50 & S.default.markers<60)-50;
    tmp4=dv2pred(tmp1.f,train_sl,GRID_LETTERS);
    correct_train_targets=sum(tmp4.ip'==train_targets);
    [s1 s2]=getvarspred(S);
    train2=dv2pred(tmp2.f,s1,GRID_LETTERS);
    train3=dv2pred(tmp3.f,s2,GRID_LETTERS);
    test1=dv2pred(out1.fraw,s1,GRID_LETTERS);
    test2=dv2pred(out2.fraw,s2,GRID_LETTERS);
           
    tr1=predtorate(train2.ip,'zoeken',GRID_LETTERS);   
    tr2=predtorate(train3.ip,'jaguar',GRID_LETTERS);
    r1=predtorate(test1.ip,'zoeken',GRID_LETTERS);   
    r2=predtorate(test2.ip,'jaguar',GRID_LETTERS);
    
    Lctt(j,:)=[correct_train_targets tr1 tr2 r1 r2];
    Lcttr(j,:)=Lctt(j,:)/12;
        
    
end

for j=1:numel(members)
    
    fprintf('\n Subject %s :\t Train( %0.2f/%0.2f/%d )   \t Test1( %0.2f/%0.2f/%0.2f -- %d/%d )   \t Test2( %0.2f/%0.2f/%0.2f -- %d/%d )'...
        ,members{j},...
        Lrate(j,1),Lauc(j,1),Lctt(j,1),...
        Lrate(j,2),Lauc(j,2),Lrate(j,4),Lctt(j,2),Lctt(j,4),...
        Lrate(j,3),Lauc(j,3),Lrate(j,5),Lctt(j,3),Lctt(j,5)     );
    
end
fprintf('\n');