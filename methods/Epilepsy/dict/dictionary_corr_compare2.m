function [D2,noatoms,location,location1,max_corr]=dictionary_corr_compare2(D,D2,patchsz)
    %change! minimum correlation should be considered instead of maximum
    %here ?! no! because here it says if the are similar replace with
    %initial value so maximum is correct! 
    t=.6;
    location=zeros(size(D2,2),1);
    max_corr=zeros(size(D2,2),size(D,2));
    count=0;

    for i=1:size(D2,2)
        for j=1:size(D,2)
%             [C C_l]=max(xcorr(D2(:,i),D(:,j)));
            C=mean(xcorr(D2(:,i),D(:,j)));
            max_corr(i,j)=C;
            if abs(C)>t
                D2(:,i)=cos([0:1:patchsz-1]*i*pi/(patchsz+1));
%                 D2(:,i)=randn(71,1);
                %the final value of count shows the number of atoms that
                %are not replaced
                count=count+1;
                %in location vector, the values which are (-1) are not
                %replaced, and the ones which are 0 are replaced
                location(i)=-1;
                break;
            end
        end
    end
    %number of atoms that aren't replaced with noise
    noatoms=size(D2,2)-count;
    %shows the locations of D2 elements which aren't replaced with noise
    location1=find(location==0);
end