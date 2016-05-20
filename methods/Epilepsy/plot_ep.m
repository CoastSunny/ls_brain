function out = plot_ep(X,M,n_seg,do_mean)
figure
if (size(X,1)==20)
ch={'Fp1' 'F3' 'F7' 'C3' 'T3' 'T5' 'P3' 'O1' 'Fp2' 'F4' 'F8' 'C4' 'T4' 'T6' 'P4' 'O2' 'Fz' 'Cz' 'A1' 'A2'};
else
ch={'R1' 'R2' 'R3' 'R4' 'R5' 'R6' 'L1' 'L2' 'L3' 'L4' 'L5' 'L6'}
end

hold on
set(gca,'Ytick',1:size(X,1))
set(gca,'YtickLabel',ch)
if nargin<2; M=[]; end;
if nargin<3; n_seg=1:size(X,3); end;
if nargin<4; do_mean=1;end

if do_mean==1;x=mean(X(:,:,n_seg),3);end;
for i=1:size(X,1)
    mx(i)=max(abs(x(i,(floor(size(X,2)/2)-4):(floor(size(X,2)/2)+4))));
end
if isempty(M);M=max(mx);end;
for i=1:size(X,1)
    plot((1:size(X,2))/200*1000,x(i,:,:)/M+(i-0)*1,'Linewidth',1.5)       
    %set(gca,'XTick',[0 81 162.5 244 325])
end
xlim([0 size(X,2)/200*1000])
ylim([0 size(X,1)+2])
xlabel('time (milliseconds)')
%ylabel('electrode')
M
end

