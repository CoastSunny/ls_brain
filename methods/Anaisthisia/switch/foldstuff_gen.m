function out = foldstuff_gen(z,si,siexcl,trblocks,exblocks,outblocks,nfolds)

foldIdxs=zeros(size(z.Y,1),nfolds);
strnInd=ones(1,size(z.Y,1));

for i=1:numel(siexcl)
strnInd=strnInd & floor([z.di(n2d(z,'epoch')).extra.src])~=siexcl(i);
end

idxs=([z.di(n2d(z,'epoch')).extra.src]);

if (numel(trblocks)==1)
    
    trnInd= floor((idxs-floor(idxs))*10)==trblocks;
    
elseif (numel(trblocks)==2)
    
    trnInd= floor((idxs-floor(idxs))*10)==trblocks(1) | ...
        floor((idxs-floor(idxs))*10)==trblocks(2);
    
elseif (numel(trblocks)==3)
    
    trnInd= floor((idxs-floor(idxs))*10)==trblocks(1) |...
        floor((idxs-floor(idxs))*10)==trblocks(2) |...
        floor((idxs-floor(idxs))*10)==trblocks(3);
    
end
if ~isempty(exblocks)
    if (numel(exblocks)==1)
        
        exInd= floor((idxs-floor(idxs))*10)==exblocks;
        
    elseif (numel(exblocks)==2)
        
        exInd= floor((idxs-floor(idxs))*10)==exblocks(1) | ...
            floor((idxs-floor(idxs))*10)==exblocks(2);
        
    elseif (numel(exblocks)==3)
        
        exInd= floor((idxs-floor(idxs))*10)==exblocks(1) |...
            floor((idxs-floor(idxs))*10)==exblocks(2) |...
            floor((idxs-floor(idxs))*10)==exblocks(3);
        
    end
end
if ~isempty(outblocks)
    if (numel(outblocks)==1)
        
        outInd= floor((idxs-floor(idxs))*10)==outblocks;
        
    elseif (numel(outblocks)==2)
        
        outInd= floor((idxs-floor(idxs))*10)==outblocks(1) | ...
            floor((idxs-floor(idxs))*10)==outblocks(2);
        
    elseif (numel(outblocks)==3)
        
        outInd= floor((idxs-floor(idxs))*10)==outblocks(1) |...
            floor((idxs-floor(idxs))*10)==outblocks(2) |...
            floor((idxs-floor(idxs))*10)==outblocks(3);
        
    end
end

foldIdxs(trnInd & strnInd,1:nfolds)=gennFold(z.Y(trnInd & strnInd,:),nfolds); 

outfIdxs=zeros(size(z.Y,1),1);
siidxs=floor([z.di(n2d(z,'epoch')).extra.src])==si;
outfIdxs(outInd & siidxs)=1;
if (isempty(exblocks))
    exInd=logical(zeros(1,size(z.Y,1)));
end
outfIdxs(exInd)=0;
outfIdxs(strnInd &trnInd)=-1;


out.foldIdxs=foldIdxs;
out.outfIdxs=outfIdxs;