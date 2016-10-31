function Cx = topoconn_av(Fp,out,subj,nsource,freq,band,vis)
if nargin<7
    vis=1;
end
if isempty(band)
    band=1:size(Fp{subj}{1},1);
end
temp=freq{1};
cfg.layout='/home/lspyrou/Documents/ls_brain/global/biosemi128.lay';
% cfg.layout='C:\Users\Loukianos\Documents\ls_brain\global\biosemi128.lay';
cfg.parameter='powspctrm';
cfg.comment='no';

Cx=0;
if ~isempty(nsource)
    tmp=unique(sort(out(:)));
    out(out<tmp(end-min(nsource,numel(tmp)-1)+1))=0;
end
for i=1:size(out,1)
    for j=1:size(out,2)
        if (i~=j)
            
            Xi=Fp{subj}{2}(:,i);
            Xj=Fp{subj}{2}(:,j);
            fXi=1;mean(abs(Fp{subj}{1}(band,i)));
            fXj=1;mean(abs(Fp{subj}{1}(band,j)));
            if (i==3 && j==4)
               a=1;
            elseif (i==7 && j==9)
                a=1;
            end
            Cx=Cx+abs(out(i,j)*Xi*Xj'/(max(max(Xi*Xj'))))*fXi*fXj;
            
            
        end
    end
end

Cx(eye(size(Cx))==1)=0;
if vis==1
    figure,imagesc(abs(Cx)),title('tensor pli')
end
