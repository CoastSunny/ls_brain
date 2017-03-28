function pli=ls_pli(X,band,vis)
if nargin<3
    vis=1;
end
if isempty(band)
    band=1:size(X,1);
end
tr=size(X,3);
fr=size(X,1);
ch=size(X,2);

for i=1:tr
    count=1;
    for j=band

        x=X(count,:,i);
        csd(count,:,:,i)=x'*x;
        count=count+1; 
    end

end
count=1;
for i=band

    pli(count,:,:)=abs(mean(sign(imag((csd(count,:,:,:)))),4));  
    count=count+1;
    
end
pli=mean(pli,1);
if vis==1
    figure,imagesc(squeeze(pli)),title('pli')
    set(gca,'Xtick',[16 48 80 112])
    set(gca,'Xticklabels',{'back' 'right' 'front' 'left'})
    set(gca,'Ytick',[16 48 80 112])
    set(gca,'Yticklabels',{'back' 'right' 'front' 'left'})  
end
