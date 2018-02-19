function [p_lcmv,w_lcmv] = ls_lcmv(C,H)
warning on
for i=1:size(H,2)
    h=H(:,i);    
    w_lcmv(i,:)=inv(h.'*inv(C)*h)*h.'*inv(C);
    p_lcmv(i)=inv(h.'*inv(C)*h);
end
warning off
end