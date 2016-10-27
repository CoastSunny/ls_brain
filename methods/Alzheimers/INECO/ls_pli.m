function pli=ls_pli(X)

tr=size(X,3);
fr=size(X,1);
ch=size(X,2);

for i=1:tr
    for j=1:fr

        x=X(fr,:,i);
        csd(:,:,i)=x'*x;
    
    end

end

pli=abs(mean(sign(imag(conj(csd))),3));