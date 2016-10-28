function pli=ls_pli(X)

tr=size(X,3);
fr=size(X,1);
ch=size(X,2);

for i=1:tr
    for j=1:fr

        x=X(j,:,i);
        csd(j,:,:,i)=x'*x;
    
    end

end

for i=1:fr

    pli(i,:,:)=abs(mean(sign(imag(conj(csd(i,:,:,:)))),4));    
    
end

figure,imagesc(squeeze(mean(pli,1)))
