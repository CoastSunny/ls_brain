

duration=5000;

ochannels=[11 13];
hchannels=[10 12];
start_time=1251;

csubjects={ 'C4' 'C6' 'C7' 'C8' 'C9' 'C10' 'C11' };
psubjects={ 'T2' 'T3' 'T4' 'T5' 'T6' 'T9' 'T10' };
subjects={'C4' 'C6' 'C7' 'C8' 'C9' 'C10' 'C11' 'T2' 'T3' 'T4' 'T5' 'T6' 'T9' 'T10'};
G=Group;
for i=1:numel(subjects)

    G.addprop(subjects{i});
    try G.(subjects{i})=controls.(subjects{i}).copy;
    catch err
        G.(subjects{i})=patients.(subjects{i}).copy;
    end
    
end
delete(findprop(G,'all'));
members=sort(properties(G));

for j=1:14%(numel(members)-2)

    q=G.(members{j}).default;
    
     for k=1:numel(duration)                
        
        q.train_classifier('cleverstuff','nirs','detrenddat','no','filterdat','no','name','co25','classes',{{2};{5}},'blocks_in',1,'channels',ochannels,'time',start_time:start_time+duration(k));
        q.train_classifier('cleverstuff','nirs','detrenddat','no','filterdat','no','name','co23','classes',{{2};{3}},'blocks_in',1,'channels',ochannels,'time',start_time:start_time+duration(k));
        q.train_classifier('cleverstuff','nirs','detrenddat','no','filterdat','no','name','ch25','classes',{{2};{5}},'blocks_in',1,'channels',hchannels,'time',start_time:start_time+duration(k));
        q.train_classifier('cleverstuff','nirs','detrenddat','no','filterdat','no','name','ch23','classes',{{2};{3}},'blocks_in',1,'channels',hchannels,'time',start_time:start_time+duration(k));
        q.train_classifier('cleverstuff','nirs','detrenddat','no','filterdat','no','name','ct25','classes',{{2};{5}},'blocks_in',1,'channels',10:13,'time',start_time:start_time+duration(k));
        q.train_classifier('cleverstuff','nirs','detrenddat','no','filterdat','no','name','ct23','classes',{{2};{3}},'blocks_in',1,'channels',10:13,'time',start_time:start_time+duration(k));
        
        N(k,1,j) = max(q.co25.res.tstbin);
        N(k,2,j) = max(q.co23.res.tstbin);
        N(k,3,j) = max(q.ch25.res.tstbin);
        N(k,4,j) = max(q.ch23.res.tstbin);
        N(k,5,j) = max(q.ct25.res.tstbin);
        N(k,6,j) = max(q.ct23.res.tstbin);
        
        E(k,1,j) = max(q.eeg.perf(2));
        E(k,2,j) = max(q.eeg.perf(1));
        
        M(k,1,j) = sum(sign(q.co25.f)==q.co25.labels')/numel(q.co25.labels);
        M(k,2,j) = sum(sign(q.co23.f)==q.co23.labels')/numel(q.co23.labels);
        M(k,3,j) = sum(sign(q.ch25.f)==q.ch25.labels')/numel(q.ch25.labels);
        M(k,4,j) = sum(sign(q.ch23.f)==q.ch23.labels')/numel(q.ch23.labels);
        M(k,5,j) = sum(sign(q.ct25.f)==q.ct25.labels')/numel(q.ct25.labels);
        M(k,6,j) = sum(sign(q.ct23.f)==q.ct23.labels')/numel(q.ct25.labels);
                        
        O(k,1,j) = sum(sign(mean(reshape(q.co25.f,5,24)))==mean(reshape(q.co25.labels,5,24)))/numel(mean(reshape(q.co25.labels,5,24)));
        O(k,2,j) = sum(sign(mean(reshape(q.co23.f,5,24)))==mean(reshape(q.co23.labels,5,24)))/numel(mean(reshape(q.co23.labels,5,24)));
        O(k,3,j) = sum(sign(mean(reshape(q.ch25.f,5,24)))==mean(reshape(q.ch25.labels,5,24)))/numel(mean(reshape(q.ch25.labels,5,24)));
        O(k,4,j) = sum(sign(mean(reshape(q.ch23.f,5,24)))==mean(reshape(q.ch23.labels,5,24)))/numel(mean(reshape(q.ch23.labels,5,24)));
        O(k,5,j) = sum(sign(mean(reshape(q.ct25.f,5,24)))==mean(reshape(q.ct25.labels,5,24)))/numel(mean(reshape(q.ct25.labels,5,24)));
        O(k,6,j) = sum(sign(mean(reshape(q.ct23.f,5,24)))==mean(reshape(q.ct23.labels,5,24)))/numel(mean(reshape(q.ct23.labels,5,24)));
        
        Nf(k,:,:,1,j) = reshape(q.co25.f,5,24)';
        Nf(k,:,:,2,j) = reshape(q.co23.f,5,24)';
        Nf(k,:,:,3,j) = reshape(q.ch25.f,5,24)';
        Nf(k,:,:,4,j) = reshape(q.ch23.f,5,24)';
        Nf(k,:,:,5,j) = reshape(q.ct25.f,5,24)';
        Nf(k,:,:,6,j) = reshape(q.ct23.f,5,24)';                
        
        Ef(k,:,:,1,j) = q.eeg.fim;
        Ef(k,:,:,2,j) = q.eeg.fam;
        SIEf(k,:,:,1,j) = q.SIeeg.fim;
        SIEf(k,:,:,2,j) = q.SIeeg.fam;
        SITEf(k,:,:,1,j) = q.SIeeg.tfim;
        SITEf(k,:,:,2,j) = q.SIeeg.tfam;
                                
    end

end

% mNC=mean(N(:,:,1:7),3);
% for i=1:numel(duration)
%     for j=1:6
%         sNC(i,j)=std(N(i,j,:));
%     end
% end
% 
% mNT=mean(N(:,:,8:14),3);
% for i=1:numel(duration)
%     for j=1:6
%         sNT(i,j)=std(N(i,j,:));
%     end
% end
% 
% mMC=mean(M(:,:,1:7),3);
% for i=1:numel(duration)
%     for j=1:6
%         sMC(i,j)=std(M(i,j,:));
%     end
% end
% 
% mMT=mean(M(:,:,8:14),3);
% for i=1:numel(duration)
%     for j=1:6
%         sMT(i,j)=std(M(i,j,:));
%     end
% end
% 
% mOC=mean(O(:,:,1:7),3);
% for i=1:numel(duration)
%     for j=1:6
%         sOC(i,j)=std(O(i,j,:));
%     end
% end
% 
% mOT=mean(O(:,:,8:14),3);
% for i=1:numel(duration)
%     for j=1:6
%         sOT(i,j)=std(O(i,j,:));
%     end
% end
% 
% for j=1:numel(members)
%         
%     ISf(j,:)=mean(squeeze(Nf(1,:,:,6,j)+Ef(1,:,:,2,j))');
%     
% end
