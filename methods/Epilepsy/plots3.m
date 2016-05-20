
ch=[1 3;11 12;9 10;1 8; 9 15];
%ch=[1 1 1 1]'*[5 6];
tt=9;
ff=1;
freqband=[11 80];
fs=200;
p=2;
pp=1;
filt=mkFilter(freqband,floor(len/2),fs/len);

for si=1:5
    
    eval(['a=' subj{si} '_fsEEG(:,:,:,:);']);
    eval(['b=' subj{si} '_frsEEG(:,:,:,:);']);
   
   

    figure
    scatter(a(ch(si,1),ff,tt,:),a(ch(si,2),ff,tt,:)), hold on
    %figure
    scatter(b(ch(si,1),ff,tt,:),b(ch(si,2),ff,tt,:),'r*')
    figure
    scatter3(a(ch(si,1),ff,tt,:).^p,a(ch(si,2),ff,tt,:).^p,a(ch(si,1),ff,tt,:).^pp.*a(ch(si,2),ff,tt,:).^pp), hold on
    %figure
    scatter3(b(ch(si,1),ff,tt,:).^p,b(ch(si,2),ff,tt,:).^p,b(ch(si,1),ff,tt,:).^pp.*b(ch(si,2),ff,tt,:).^pp,'r*')
    
end