

duration=150;

ochannels=[11 13];
hchannels=[10 12];
start_time=81;

G=Group;
clear N E M O Nf Ef SIEf SITEf DN
for i=1:numel(subjects)
    
    G.addprop(subjects{i});
    try G.(subjects{i})=controls.(subjects{i}).copy;
    catch err
        G.(subjects{i})=patients.(subjects{i}).copy;
    end
    
end
delete(findprop(G,'all'));
members=sort_nat(properties(G));

for j=1:numel(members)
    
    q=G.(members{j}).default;
    if (strcmp(members{j},'C8'))
        extra={'trials',[1:19 22:24]};
    else
        extra=[];
    end
    for k=1:numel(duration)
        
        q.train_classifier([{'cleverstuff','nirs','detrenddat','no','filterdat','no','name','co25','classes',{{2};{5}},'blocks_in',1,'channels',ochannels,'time',start_time:start_time+duration(k)-1}]);
        q.train_classifier([extra {'cleverstuff','nirs','detrenddat','no','filterdat','no','name','co23','classes',{{2};{3}},'blocks_in',1,'channels',ochannels,'time',start_time:start_time+duration(k)-1}]);
        q.train_classifier([ {'cleverstuff','nirs','detrenddat','no','filterdat','no','name','ch25','classes',{{2};{5}},'blocks_in',1,'channels',hchannels,'time',start_time:start_time+duration(k)-1}]);
        q.train_classifier([extra {'cleverstuff','nirs','detrenddat','no','filterdat','no','name','ch23','classes',{{2};{3}},'blocks_in',1,'channels',hchannels,'time',start_time:start_time+duration(k)-1}]);
        q.train_classifier([ {'cleverstuff','nirs','detrenddat','no','filterdat','no','name','ct25','classes',{{2};{5}},'blocks_in',1,'channels',10:13,'time',start_time:start_time+duration(k)-1}]);
        q.train_classifier([extra {'cleverstuff','nirs','detrenddat','no','filterdat','no','name','ct23','classes',{{2};{3}},'blocks_in',1,'channels',10:13,'time',start_time:start_time+duration(k)-1}]);
        
        N(k,1,j) = max(q.co25.res.tstbin);
        N(k,2,j) = max(q.co23.res.tstbin);
        N(k,3,j) = max(q.ch25.res.tstbin);
        N(k,4,j) = max(q.ch23.res.tstbin);
        N(k,5,j) = max(q.ct25.res.tstbin);
        N(k,6,j) = max(q.ct23.res.tstbin);
        
        E(k,1,j) = max(q.eeg.perf(2));
        E(k,2,j) = max(q.eeg.perf(1));
        
        
        Nf{k,1,j} = reshape(q.co25.f,5,size(q.co25.f,1)/5)';
        Nf{k,2,j} = reshape(q.co23.f,5,size(q.co23.f,1)/5)';
        Nf{k,3,j} = reshape(q.ch25.f,5,size(q.ch25.f,1)/5)';
        Nf{k,4,j} = reshape(q.ch23.f,5,size(q.ch23.f,1)/5)';
        Nf{k,5,j} = reshape(q.ct25.f,5,size(q.ct25.f,1)/5)';
        Nf{k,6,j} = reshape(q.ct23.f,5,size(q.ct23.f,1)/5)';              
%         temp1=reshape(q.co25.f,5,size(q.co25.f,1)/5)';
%         temp2=reshape(q.co23.f,5,size(q.co23.f,1)/5)';
%         Nf{k,1,j} = [zeros(size(temp1,1),1) Nf{k,1,j}(:,1:4)];
%         Nf{k,2,j} = [zeros(size(temp2,1),1) Nf{k,2,j}(:,1:4)];
%         Nf{k,3,j} = [zeros(size(temp1,1),1) Nf{k,3,j}(:,1:4)];
%         Nf{k,4,j} = [zeros(size(temp2,1),1) Nf{k,4,j}(:,1:4)];
%         Nf{k,5,j} = [zeros(size(temp1,1),1) Nf{k,5,j}(:,1:4)];
%         Nf{k,6,j} = [zeros(size(temp2,1),1) Nf{k,6,j}(:,1:4)];
        
        Ef{k,1,j} = q.eeg.fim;
        Ef{k,2,j} = q.eeg.fam;
        
        %         DN(k,1,:,j) = (q.co25.distmean);
        %         DN(k,2,:,j) = (q.co23.distmean);
        %         DN(k,3,:,j) = (q.ch25.distmean);
        %         DN(k,4,:,j) = (q.ch23.distmean);
        %         DN(k,5,:,j) = (q.ct25.distmean);
        %         DN(k,6,:,j) = (q.ct23.distmean);
        
    end
    
    
end
Cindiscores3
Tindiscores3

