function [D1,noatoms,location1]=dictionary_corr_compare(D,D1,patchsz)
    
    %threshold
%     t=0.5;
%     t=0.25;

    s=0;
    m=0;
    n=10^10;
    for i=1:size(D1,2)
        for j=1:size(D,2)
            C=corrcoef(D1(:,i),D(:,j));
            s=s+abs(C(1,2));
            if abs(C(1,2))>m
                m=abs(C(1,2));
            end
            if abs(C(1,2))<n
                n=abs(C(1,2));
            end
%             if C(1,2)>t
% %                 D1(:,i)=cos([0:1:patchsz-1]*i*pi/(patchsz+1));
%                 D1(:,i)=0.001*cos([0:1:patchsz-1]*i*pi/(patchsz+1));
%                 break;
%             end
        end
    end
    m;
    n;
    s=s/(size(D1,2)*size(D,2));
   
    t=.3*s;
%     t=.3;
    location=zeros(size(D1,2),1);
    count=0;
    
%     t=(m+n)/2;
%     t=0.9*t;

    for i=1:size(D1,2)
        for j=1:size(D,2)
            C=corrcoef(D1(:,i),D(:,j));
            if C(1,2)>t
                D1(:,i)=cos([0:1:patchsz-1]*i*pi/(patchsz+1));
                count=count+1;
                location(i)=-1;
%                     D1(:,i)=0.001*cos([0:1:patchsz-1]*i*pi/(patchsz+1));
                break;
            end
        end
    end
    noatoms=size(D1,2)-count;
    location1=find(location==0);
end