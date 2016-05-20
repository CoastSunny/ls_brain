function out = plot_ep_all(X,M,n_seg,do_mean)
% figure
ch={'R6' 'R5' 'R4' 'R3' 'R2' 'R1' 'L6' 'L5' 'L4' 'L3' 'L2' 'L1'...
    'Fp1' 'F3' 'F7' 'C3' 'T3' 'T5' 'P3' 'O1' 'Fp2' 'F4' 'F8' 'C4'...
    'T4' 'T6' 'P4' 'O2' 'Fz' 'Cz' 'A1' 'A2'};
hold on
set(gca,'Ytick',1:size(X,1))
set(gca,'YtickLabel',ch)
if nargin<2; M=[]; end;
if nargin<3; n_seg=1:size(X,3); end;
if nargin<4; do_mean=1;end

if do_mean==1;x=mean(X(:,:,n_seg),3);end;
for i=1:12
    mi(i)=max(abs(x(i,(floor(size(X,2)/2)-4):(floor(size(X,2)/2)+4))));
end
for i=13:size(X,1)
    mx(i-12)=max(abs(x(i,(floor(size(X,2)/2)-4):(floor(size(X,2)/2)+4))));
end
if isempty(M);M=[max(mi) max(mx)];end;
for i=1:size(X,1)
    if (i<13)
        MM=M(1);
    else
        MM=M(2);
    end
    plot((1:size(X,2))/200*1000,x(i,:,:)/MM+(i-0)*1,'Linewidth',2)       
    %set(gca,'XTick',[0 81 162.5 244 325])
end
xlim([0 size(X,2)/200*1000])
ylim([0 size(X,1)+2])
xlabel('time (milliseconds)')
%ylabel('electrode')
M
end

% [a b c d]=readCapInf('capep.txt')
% figure,ft_plot_topo3d(d',mean(TPX{1}(sEEG_idx,97:101,1),2));