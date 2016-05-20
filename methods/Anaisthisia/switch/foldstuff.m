function out = foldstuff(z,trblocks,exblocks,outblocks,nfolds,nexamples)

if nargin<4
    nfolds=10;
end
if nargin<5
    nexamples=[];
end

foldIdxs=zeros(size(z.Y,1),nfolds);

if (numel(trblocks)==1)

    trnInd= floor([z.di(n2d(z,'epoch')).extra.src])==trblocks;
    
elseif (numel(trblocks)==2)
    
    trnInd= floor([z.di(n2d(z,'epoch')).extra.src])==trblocks(1) | ...
            floor([z.di(n2d(z,'epoch')).extra.src])==trblocks(2);

elseif (numel(trblocks)==3)    
    
trnInd= floor([z.di(n2d(z,'epoch')).extra.src])==trblocks(1) |...
        floor([z.di(n2d(z,'epoch')).extra.src])==trblocks(2) |...
        floor([z.di(n2d(z,'epoch')).extra.src])==trblocks(3);
    
end


if ~isempty(exblocks)
if (numel(exblocks)==1)

    exInd= floor([z.di(n2d(z,'epoch')).extra.src])==exblocks;
    
elseif (numel(exblocks)==2)
    
    exInd= floor([z.di(n2d(z,'epoch')).extra.src])==exblocks(1) | ...
            floor([z.di(n2d(z,'epoch')).extra.src])==exblocks(2);

elseif (numel(exblocks)==3)    
    
exInd= floor([z.di(n2d(z,'epoch')).extra.src])==exblocks(1) |...
        floor([z.di(n2d(z,'epoch')).extra.src])==exblocks(2) |...
        floor([z.di(n2d(z,'epoch')).extra.src])==exblocks(3);
    
elseif (numel(exblocks)==4)    
    
exInd= floor([z.di(n2d(z,'epoch')).extra.src])==exblocks(1) |...
        floor([z.di(n2d(z,'epoch')).extra.src])==exblocks(2) |...
        floor([z.di(n2d(z,'epoch')).extra.src])==exblocks(3) |...
        floor([z.di(n2d(z,'epoch')).extra.src])==exblocks(4);
        
end
end

if ~isempty(outblocks)
if (numel(outblocks)==1)

    outInd= floor([z.di(n2d(z,'epoch')).extra.src])==outblocks;
    
elseif (numel(outblocks)==2)
    
    outInd= floor([z.di(n2d(z,'epoch')).extra.src])==outblocks(1) | ...
            floor([z.di(n2d(z,'epoch')).extra.src])==outblocks(2);

elseif (numel(outblocks)==3)    
    
outInd= floor([z.di(n2d(z,'epoch')).extra.src])==outblocks(1) |...
        floor([z.di(n2d(z,'epoch')).extra.src])==outblocks(2) |...
        floor([z.di(n2d(z,'epoch')).extra.src])==outblocks(3);
    
elseif (numel(outblocks)==4)    
    
outInd= floor([z.di(n2d(z,'epoch')).extra.src])==outblocks(1) |...
        floor([z.di(n2d(z,'epoch')).extra.src])==outblocks(2) |...
        floor([z.di(n2d(z,'epoch')).extra.src])==outblocks(3) |...
        floor([z.di(n2d(z,'epoch')).extra.src])==outblocks(4);
        
end
end


if (~isempty(nexamples))
    nim=find(z.Y(:,1)==1 & trnInd'==1);
    im=find(z.Y(:,1)==-1 & trnInd'==1);
    mov=find(z.Y(:,2)==-1 & trnInd'==1);
    nom=find(z.Y(:,2)==1 & trnInd'==1);
    
    trnInd( setdiff( ( 1:numel( trnInd ) ), ...
        union ( union( im(1:nexamples),mov(1:nexamples) ) , union( nim(1:nexamples) , nom(1:nexamples) ) ) ) )...
        =false;       
    
end

outfIdxs=zeros(size(z.Y,1),1); 
outfIdxs(outInd)=1;
outfIdxs(trnInd)=-1; 

% outfIdxs(~trnInd)=1; 
% if ~isempty(exblocks)
% outfIdxs(exInd)=0;
% end

foldIdxs(trnInd,1:nfolds)=gennFold(z.Y(trnInd,:),nfolds);    
out.mov_idx=z.Y(:,2)==-1 & trnInd'==1;
out.im_idx=z.Y(:,1)==-1 & trnInd'==1;
out.nom_idx=z.Y(:,2)==1 & trnInd'==1;
out.foldIdxs=foldIdxs;
out.outfIdxs=outfIdxs;



% if (~isempty(nexamples))
%     im=find(z.Y(:,1)==-1 & trnInd'==1);
%     mov=find(z.Y(:,2)==-1 & trnInd'==1);
%     nom=find(z.Y(:,2)==1 & trnInd'==1);
%     
%     trnInd( setdiff( ( 1:numel( trnInd ) ), ...
%         union ( union( im(1:nexamples),mov(1:nexamples) ) , nom(1:nexamples) ) ) )...
%         =false;       
%     
% end

