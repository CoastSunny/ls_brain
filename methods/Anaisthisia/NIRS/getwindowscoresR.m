function out = getwindowscoresR(T,Y,tmp1,tmp2,wind1,wind2,sel1,sel2)

for i=1:size(T,3)
    
    if (~isempty(Y))
        %%%%simple averaging
        if(strcmp(tmp1,'-'))
            tmp3=-1;
        else
            tmp3=1;
        end;
        if(strcmp(tmp2,'-'))
            tmp4=-1;
        else
            tmp4=1;
        end;
        if (nargin==6)
            a=repop(eye(size(T{i},2)),'*',wind1);a(all(a==0,2),:)=[];
            b=repop(eye(size(T{i},2)),'*',wind2);b(all(b==0,2),:)=[];
            R=tmp3*T{i}(:,wind1>0)*a+...
            tmp4*Y{i}(:,wind2>0)*b;
        else
            R=tmp3*T{i}+...
            tmp4*Y{i};
        end
        %%%%weighted averaging
        
    else
        if(strcmp(tmp1,'-'))
            tmp3=-1;
        else
            tmp3=1;
        end;
        R=tmp3*T{i};
    end
    if (exist('wind1')~=1)
        subj_dv=R;
    else
        subj_dv=R(:,logical(wind1));
    end
    rest=subj_dv(1:12,:);
    movement=subj_dv(13:end,:);
    
    
    score = sum(sign(rest)<0)+sum(sign(movement)>=0);
    rate(i,:)=score/(size(rest,1)+size(movement,1));
    comb_rest = cumsum(rest')';
    comb_move = cumsum(movement')';
    comb_score = sum(sign(comb_rest)<0)+sum(sign(comb_move)>=0);
    comb_rate(i,:)=comb_score/(size(movement,1)+size(rest,1));
    
end

out.rate=rate;
out.comb_rate=comb_rate;

end