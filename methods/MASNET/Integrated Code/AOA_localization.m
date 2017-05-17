function [pos]=AOA_localization(aoa,aa,sensor)  
AA= zeros(aa,2);
BB=zeros(aa,1);
% localization using the DOA (least square problem)
    AA(:,1)=ones;
    aoa(find(aoa == -90)) = -89.9999999;
    AA(:,2)=-tand(aoa);
    BB(:,1)= sensor(:,2)-(tand(aoa).*sensor(:,1)').'; 
    pos= pinv(AA)*BB;
   