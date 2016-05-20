
fidx_control=find(subject_identifier(used_subjects==1)==0);
fidx_patient=find(subject_identifier(used_subjects==1)==1);
% tmp=randperm(23);
% fidx_control=tmp(1:11);fidx_patient=tmp(12:end);
pcount=1;ccount=1;
Pkurt=[];Pvar=[];
Ckurt=[];Cvar=[];
F=Fp;
for i=1:23

    if sum(i==fidx_patient)>0
        Pkurt(pcount,:)=kurtosis(F{i}{3});
        Pskew(pcount,:)=skewness(F{i}{3});
        Pvar(pcount,:)=std(F{i}{3},0,1);
        pcount=pcount+1;
    elseif sum(i==fidx_control)>0
        Ckurt(ccount,:)=kurtosis(F{i}{3});
        Cskew(ccount,:)=skewness(F{i}{3});
        Cvar(ccount,:)=std(F{i}{3},0,1);
        ccount=ccount+1;
    end
    
end

figure, subplot(2,2,1), hold on, plot(mean(Pkurt)),plot(mean(Ckurt),'r'),title('kurtosis')
subplot(2,2,2), hold on, plot(mean(Pskew)),plot(mean(Cskew),'r'),title('skewness')
subplot(2,2,3), hold on, plot(mean(Pvar)),plot(mean(Cvar),'r'),title('variance')
legend({'patients','controls'})


pcount=1;ccount=1;
for i=1:23
    G=permute(Gt{i},[3 1 2]);
    G=reshape(Gt{i},[],size(Gt{i},3));
    if sum(i==fidx_patient)>0
        tPkurt(pcount,:)=kurtosis(G');
        tPskew(pcount,:)=skewness(G');
        tPvar(pcount,:)=std(G',0,1);
        pcount=pcount+1;
    elseif sum(i==fidx_control)>0
        tCkurt(ccount,:)=kurtosis(G');
        tCskew(ccount,:)=skewness(G');
        tCvar(ccount,:)=std(G',0,1);
        ccount=ccount+1;
    end
    
end

figure, subplot(2,2,1), hold on, plot(mean(tPkurt)),plot(mean(tCkurt),'r'),title('kurtosis')
subplot(2,2,2), hold on, plot(mean(tPskew)),plot(mean(tCskew),'r'),title('skewness')
subplot(2,2,3), hold on, plot(mean(tPvar)),plot(mean(tCvar),'r'),title('variance')
legend({'patients','controls'})
