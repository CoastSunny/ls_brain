S=100;
N=25;
p=1/N;
% C=zeros(1,N);
% for s=1:S
%
%     idx=randi(N);
%     C(idx)=C(idx)+1;
%
% end
M=10;
h=[];
for m=1:M
    C=zeros(1,N);
    for s=1:S
        
        idx(s)=randi(N);
        C(idx(s))=C(idx(s))+1;
        
    end
    sum(C)
    while (any(C<4 & C>0))
        
        idx_c=find(C==1);
       
        for j=1:numel(idx_c)
            idx_s=find(idx==idx_c(j));
            for i=1:numel(idx_s)
                C(idx(idx_s(i)))=C(idx(idx_s(i)))-1;
                idx(idx_s(i))=randi(N);
                C(idx(idx_s(i)))=C(idx(idx_s(i)))+1;
            end
        end
        idx_c=find(C==2);
       
        for j=1:numel(idx_c)
            idx_s=find(idx==idx_c(j));
            for i=1:numel(idx_s)
                C(idx(idx_s(i)))=C(idx(idx_s(i)))-1;
                idx(idx_s(i))=randi(N);
                C(idx(idx_s(i)))=C(idx(idx_s(i)))+1;
            end
        end
        idx_c=find(C==3);
       
        for j=1:numel(idx_c)
            idx_s=find(idx==idx_c(j));
            for i=1:numel(idx_s)
                C(idx(idx_s(i)))=C(idx(idx_s(i)))-1;
                idx(idx_s(i))=randi(N);
                C(idx(idx_s(i)))=C(idx(idx_s(i)))+1;
            end
        end
        
    end
    sum(C)
    h(m,:)=hist(C);
end