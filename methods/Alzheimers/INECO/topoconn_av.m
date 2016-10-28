function Cx = topoconn_av(Fp,out,subj,nsource,freq)
temp=freq{1};
cfg.layout='/home/lspyrou/Documents/ls_brain/global/biosemi128.lay';
% cfg.layout='C:\Users\Loukianos\Documents\ls_brain\global\biosemi128.lay';
cfg.parameter='powspctrm';
cfg.comment='no';
figure
Cx=0;
tmp=unique(sort(out(:)));
out(out<tmp(end-nsource+1))=0;
for i=1:size(out,1)
    for j=1:size(out,2)   
        if (i~=j)
        
            Xi=Fp{subj}{2}(:,i);
            Xj=Fp{subj}{2}(:,j);
                       
            Cx=Cx+abs(out(i,j)*Xi*Xj');          
            
            
        end            
    end
end

Cx(eye(size(Cx))==1)=0;
imagesc(abs(Cx))