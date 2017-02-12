function Cx = topoconn_av2(FT,out,subj,nsource,freq,band,only,vis)
N=numel(out);
dn=numel(diag(out));
if nargin<8
    vis=1;
end
if isempty(band)
    band=1:size(FT{1,subj}{1},1);
end
if isempty(nsource)    
    nsource=(N-dn)/2;    
end
if nsource>(N-dn)/2
    error('more sources than there are')
end
temp=freq{1};
cfg.layout='/home/lspyrou/Documents/ls_brain/global/biosemi128.lay';
cfg.layout='C:\Users\Loukianos\Documents\ls_brain\global\biosemi128.lay';
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
%         tmpr=sign(max(FT{1,subj}{1}(:,r(i))));
%         tmpc=sign(max(FT{1,subj}{1}(:,c(i))));
        
%         Xi=tmpr*FT{1,subj}{1}(:,r(i))+min(tmpr*FT{1,subj}{1}(:,r(i)));
%         Xj=tmpc*FT{1,subj}{1}(:,c(i))+min(tmpc*FT{1,subj}{1}(:,c(i)));
        Xi=FT{1,subj}{1}(:,r(i));
        Xj=FT{1,subj}{1}(:,c(i));
        Xij=abs(Xi*Xj');%Xij=Xij/max(max(Xij));
%         Sij=single(and(sign(Xi)==1,sign(Xj)==1))*single(and(sign(Xi)==1,sign(Xj)==1)');
        Xji=abs(Xj*Xi');%Xji=Xji/max(max(Xji));
%         Sji=single(and(sign(Xj)==1,sign(Xi)==1))*single(and(sign(Xj)==1,sign(Xi)==1)');
        fXi=sum(abs(FT{1,subj}{3}(band,r(i))));%/sum(abs(FT{1,subj}{3}(:,r(i)).^2));
        fXj=sum(abs(FT{1,subj}{3}(band,c(i))));%/sum(abs(FT{1,subj}{3}(:,c(i)).^2));
        %             Cx=Cx+abs(out(i,j)*Xi*Xj');
        for k=1:numel(FT{1,subj}{4})
            
            P(:,:,k)=FT{1,subj}{4}{k}*FT{1,subj}{2};
        
        end
        Pi=sum(sum(abs(P(:,r(i),band))));%/sum(sum(sum(abs(P(:,:,band)))));
        Pj=sum(sum(abs(P(:,c(i),band))));%/sum(sum(sum(abs(P(:,:,band)))));
%         Xij=Xij.*Sij;
%         Xji=Xji.*Sji;
    if only==0 
        cx=Xij+Xji;
        cx=cx/max(max(cx))*((fXi+fXj)*(Pi+Pj));
        Cx=Cx+out(r(i),c(i))*cx;
    elseif only==1 && nsource==i
        cx=Xij+Xji;
        cx=cx/max(max(cx))*(fXi*Pi*fXj*Pj);
        Cx=Cx+out(r(i),c(i))*cx;
    end
    
end
% Cx=Cx/numel(r);
Cx(eye(size(Cx))==1)=0;
if vis==1
    figure,imagesc(abs(Cx)),title('tensor pli')    
    set(gca,'Xtick',[16 48 80 112])
    set(gca,'Xticklabels',{'back' 'right' 'front' 'left'})
    set(gca,'Ytick',[16 48 80 112])
    set(gca,'Yticklabels',{'back' 'right' 'front' 'left'})  
end
