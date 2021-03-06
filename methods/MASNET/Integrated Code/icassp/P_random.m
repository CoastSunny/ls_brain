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
M=10000;
h=[];
x=[0:20];
for m=1:M
    
    C=zeros(1,N);
    for s=1:S
        
        idx(s)=randi(N);
        C(idx(s))=C(idx(s))+1;
        
    end
    
    while (any(C<4 & C>0))
        
        for no_sens=1:3
            while( any(C==no_sens))
                idx_c=find(C==no_sens);
                
                idx_s=find(idx==idx_c(1));
                for i=1:numel(idx_s)
                    C(idx(idx_s(i)))=C(idx(idx_s(i)))-1;
                    idx(idx_s(i))=randi(N);
                    C(idx(idx_s(i)))=C(idx(idx_s(i)))+1;
                end
            end
        end
        
    end
    
    
    h(m,:)=hist(C,x);
    sh(m)=sum(C>0);
    
end

prd=mean(h,1)/sum(mean(h,1));
msh=mean(sh);