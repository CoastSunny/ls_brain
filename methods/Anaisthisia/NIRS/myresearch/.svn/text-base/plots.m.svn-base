clear S O orig smoothed freq recon;
freqs=1:100;
for i=1:15

    sub=FO1{i};
    for j=1:6
        trial=sub{j};
        orig(j,freqs)=trial(9,freqs);%/norm(trial(9,freqs));
        smoothed(j,freqs)=trial(1,freqs)/norm(trial(1,freqs));
        recon(j,freqs)=trial(13,freqs);
        freq(j,freqs)=trial(10,freqs);
%    figure,hold on,plot(freq(1,:),orig(j,freqs),'k.-','Linewidth',2)
%    plot(freq(1,:),recon(j,freqs),'k','Linewidth',2)
   %plot(freq(1,:),smoothed(j,freqs),'r')
    end
%figure,hold on,plot(freq(1,:),mean(orig),'k-.','Linewidth',4)
%plot(freq(1,:),mean(recon),'k','Linewidth',4)
%plot(freq(1,:),mean(smoothed),'r')
Recon(i,:)=mean(recon);
Orig(i,:)=mean(orig);

end

R=mean(Recon);
O=mean(Orig);