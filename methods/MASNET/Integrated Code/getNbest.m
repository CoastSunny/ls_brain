function out_snr = getNbest(snr,N)

sz=size(snr);

for i=1:sz(1)
    for j=1:sz(2)
        for k=1:sz(3)
            
            tmp=snr(i,j,k,:);
            [s si]=sort(tmp,'descend');
            out_snr(i,j,k,:)=tmp(si(1:3));
        end
    end
end



    
       

end