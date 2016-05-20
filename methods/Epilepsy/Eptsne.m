 
for si=1:numel(subj)
%     
%     d=TPfX{si};
%     dr=TPfRX{si};
    eval(['d=' subj{si} '_iEEG;']);
    eval(['dr=' subj{si} '_riEEG;']);
    d=reshape(d,[],size(d,3));
    dr=reshape(dr,[],size(dr,3));
    df=cat(2,dr,d);
    [mdf mf]=compute_mapping(df','tSNE',2);
    MDF{si}=mdf;
    figure,hold on
    scatter3(mdf(1:size(dr,2),1),mdf(1:size(dr,2),2),mdf(1:size(dr,2),3))
    scatter3(mdf(size(dr,2)+1:end,1),mdf(size(dr,2)+1:end,2),mdf(size(dr,2)+1:end,3),'r')
    
end

% for si=1:numel(subj)
%     
%  
%     dat=MDF{si};
%     clusters=3;
%     [idx c]=kmeans(MDF{si},clusters,'Distance','sqEuclidean','Replicates',3);
% 
% %     scatter3(mdf(1:size(dr,2),1),mdf(1:size(dr,2),2),mdf(1:size(dr,2),3))
% %     scatter3(mdf(size(dr,2)+1:end,1),mdf(size(dr,2)+1:end,2),mdf(size(dr,2)+1:end,3),'r')
%     
% end