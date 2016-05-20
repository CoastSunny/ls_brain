clear m* , clear v*
mfs=[];vfs=[];mfp=[];vfp=[];vfp=[];mts=[];vts=[];mtp=[];vtp=[];

for j=[1 4 6]
for i=1:10
    
    fpr_sav_all(i,:,j)=cs{i}.fpr.sav(j,:);
    fpr_pro_all(i,:,j)=cs{i}.fpr.pro(j,:);
    tpr_sav_all(i,:,j)=cs{i}.tpr.sav(j,:);
    tpr_pro_all(i,:,j)=cs{i}.tpr.pro(j,:);
       
end
    mfs(end+1,:)=mean(fpr_sav_all(:,:,j));
    vfs(end+1,:)=std(fpr_sav_all(:,:,j));    
    mfp(end+1,:)=mean(fpr_pro_all(:,:,j));
    vfp(end+1,:)=std(fpr_pro_all(:,:,j));    
    mts(end+1,:)=mean(tpr_sav_all(:,:,j));
    vts(end+1,:)=std(tpr_sav_all(:,:,j));    
    mtp(end+1,:)=mean(tpr_pro_all(:,:,j));
    vtp(end+1,:)=std(tpr_pro_all(:,:,j));    
    
    h=figure, bar(mfs(end,:)),hold on,errorb(mfs(end,:),vfs(end,:)),xlabel('bias shift'),set(gca,'XTickLabel',{'0','1','2','5'}),title(['fpr-sav' num2str(j)]),saveas(h,['fpr-sav' num2str(j)],'jpg')
    h=figure, bar(mts(end,:)),hold on,errorb(mts(end,:),vts(end,:)),xlabel('bias shift'),set(gca,'XTickLabel',{'0','1','2','5'}),title(['tpr-sav' num2str(j)]),saveas(h,['tpr-sav' num2str(j)],'jpg')
    h=figure, bar(mfp(end,:)),hold on,errorb(mfp(end,:),vfp(end,:)),xlabel('bias shift'),set(gca,'XTickLabel',{'0','1','2','5'}),title(['fpr-nrow' num2str(j)]),saveas(h,['fpr-nrow' num2str(j)],'jpg')
    h=figure, bar(mtp(end,:)),hold on,errorb(mtp(end,:),vtp(end,:)),xlabel('bias shift'),set(gca,'XTickLabel',{'0','1','2','5'}),title(['tpr-nrow' num2str(j)]),saveas(h,['tpr-nrow' num2str(j)],'jpg')

end



