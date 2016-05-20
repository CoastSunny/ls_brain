function out = dv2pred(f,sl,GRID_LETTERS)
%% shows correct number of predictions and
f=reshape(f,1,numel(f));
%%copy spelling 1
for i=1:12 %i: selection number
    
        tmp=sum(sl(1:i-1))+1:sum(sl(1:i));
        fp{i}=f(tmp);
        
        if (numel(fp{i})==75)
            
            codeBook=repmat(eye(5),1,15);
        
        elseif (numel(fp{i})==90)           
                        
            codeBook=repmat(eye(6),1,15);
            
        elseif (numel(fp{i})==35)
            
            codeBook=repmat(eye(5),1,7);
            
        end
    
        pred{i}=codeBook*fp{i}';
        
end

[ m ip ] = cellfun(@max,pred);
tl=[];tlt=[];
for i=1:2:12
tl{end+1}=GRID_LETTERS{ip(i)}{ip(i+1)};
end

out.tl=tl;
out.ip=ip;



