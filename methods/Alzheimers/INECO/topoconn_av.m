function Cx = topoconn_av(Fp,out,subj,nsource,freq,band,only,vis)
N=numel(out);
dn=numel(diag(out));
if nargin<8
    vis=1;
end
if isempty(band)
    band=1:size(Fp{subj}{1},1);
end
if isempty(nsource)    
    nsource=(N-dn)/2;    
end
if nsource>(N-dn)/2
    error('more sources than there are')
end
temp=freq{1};
cfg.layout='/home/lspyrou/Documents/ls_brain/global/biosemi128.lay';
% cfg.layout='C:\Users\Loukianos\Documents\ls_brain\global\biosemi128.lay';
cfg.parameter='powspctrm';
cfg.comment='no';

Cx=0;
outu=triu(out);
[tmp itmp]=sort(outu(:));
tmp=flipud(itmp);

for i=1:nsource    
    [tmpr tmpc]=ind2sub(size(out),tmp(i));
    r(i)=tmpr;
    c(i)=tmpc;    
end

for i=1:numel(r)                  
        Xi=Fp{subj}{2}(:,r(i));
        Xj=Fp{subj}{2}(:,c(i));
        Xij=abs(Xi*Xj');%Xij=Xij/max(max(Xij));
        Xji=abs(Xj*Xi');%Xji=Xji/max(max(Xji));
        fXi=1;norm(Fp{subj}{1}(band,r(i)));
        fXj=1;norm(Fp{subj}{1}(band,c(i)));
        %             Cx=Cx+abs(out(i,j)*Xi*Xj');
    if only==0 
        cx=Xij*fXi*fXj+Xji*fXi*fXj;
        cx=cx/max(max(cx));
        Cx=Cx+out(r(i),c(i))*cx;
    elseif only==1 && nsource==i
        cx=Xij*fXi*fXj+Xji*fXi*fXj;
        cx=cx/max(max(cx));
        Cx=Cx+out(r(i),c(i))*cx;
    end
    
end
% Cx=Cx/numel(r);
Cx(eye(size(Cx))==1)=0;
if vis==1
    figure,imagesc(abs(Cx)),title('tensor pli')
end
