
ch=[1 3;11 12;9 10;1 8; 9 15];
ch=[1 1 1 1]'*[1 2];
tt=32;
freqband=[11 80];
fs=200;
p=2;
pp=1;
filt=mkFilter(freqband,floor(len/2),fs/len);

for si=1:4
    
    eval(['a=' subj{si} '_iEEG(:,:,:);']);
    eval(['b=' subj{si} '_riEEG(:,:,:);']);
    len=size(a,2);
%     a=fftfilter(a,filt,[0 len],2,1);
%     b=fftfilter(b,filt,[0 len],2,1);

    figure
    scatter(a(ch(si,1),tt,:),a(ch(si,2),tt,:)), hold on
    %figure
    scatter(b(ch(si,1),tt,:),b(ch(si,2),tt,:),'r*')
    figure
    scatter3(a(ch(si,1),tt,:).^p,a(ch(si,2),tt,:).^p,a(ch(si,1),tt,:).^pp.*a(ch(si,2),tt,:).^pp), hold on
    %figure
    scatter3(b(ch(si,1),tt,:).^p,b(ch(si,2),tt,:).^p,b(ch(si,1),tt,:).^pp.*b(ch(si,2),tt,:).^pp,'r*')
    
end