
clear ss ssr ssrs
for i=23:numel(subj)
    clear temp
    for j=1:size(tpx{i},3)
        for k=1:size(tpx{i},3)
            temp(j,k)=sum(diag(tpx{i}(:,:,j)*tpx{i}(:,:,k)'));
        end
    end
    ss{i}=temp;
    clear temp
    for j=1:size(tprx{i},3)
        for k=1:size(tprx{i},3)
            temp(j,k)=sum(diag(tprx{i}(:,:,j)*tprx{i}(:,:,k)'));
        end
    end
    ssr{i}=temp;
    clear temp
    for j=1:size(tpx{i},3)
        for k=1:size(tprx{i},3)
            temp(j,k)=sum(diag(tpx{i}(:,:,j)*tprx{i}(:,:,k)'));
        end
    end
    ssrs{i}=temp;
end