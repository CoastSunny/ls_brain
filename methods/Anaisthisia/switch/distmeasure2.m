
% wtD=0;
% wtS=0;
% whD=0;
% whS=0;
%
% for si=1:10
%     for sj=1:10
%
%         wtD=wtD+norm(wtYYY(:,:,1,si)-wtYYY(:,:,1,sj));
%         wtS=wtS+norm(wtYYY(:,:,2,si)-wtYYY(:,:,2,sj));
%         whD=whD+norm(whYYY(:,:,1,si)-whYYY(:,:,1,sj));
%         whS=whS+norm(whYYY(:,:,2,si)-whYYY(:,:,2,sj));
%
%     end
% end
%
% vtD=0;
% vtS=0;
% vhD=0;
% vhS=0;
%
% for si=1:10
%     for sj=1:10
%
%         vtD=vtD+norm(vtYYY(:,:,1,si)-vtYYY(:,:,1,sj));
%         vtS=vtS+norm(vtYYY(:,:,2,si)-vtYYY(:,:,2,sj));
%         vhD=vhD+norm(vhYYY(:,:,1,si)-vhYYY(:,:,1,sj));
%         vhS=vhS+norm(vhYYY(:,:,2,si)-vhYYY(:,:,2,sj));
%
%     end
% end

% wtD=0;
% wtS=0;
% whD=0;
% whS=0;
% 
% vtD=0;
% vtS=0;
% vhD=0;
% vhS=0;
% 
% for si=1:10
%     for sj=1:10
%         
%         wtD=wtD+norm(wtYYY(:,:,1,si)-wtYYY(:,:,1,sj));
%         wtS=wtS+norm(wtYYY(:,:,2,si)-wtYYY(:,:,2,sj));
%         whD=whD+norm(whYYY(:,:,1,si)-whYYY(:,:,1,sj));
%         whS=whS+norm(whYYY(:,:,2,si)-whYYY(:,:,2,sj));
%         
%         wtD=wtD+norm(wtZZZ(:,:,1,si)-wtZZZ(:,:,1,sj));
%         wtS=wtS+norm(wtZZZ(:,:,2,si)-wtZZZ(:,:,2,sj));
%         whD=whD+norm(whZZZ(:,:,1,si)-whZZZ(:,:,1,sj));
%         whS=whS+norm(whZZZ(:,:,2,si)-whZZZ(:,:,2,sj));
%         
%         vtD=vtD+norm(vtYYY(:,:,1,si)-vtYYY(:,:,1,sj));
%         vtS=vtS+norm(vtYYY(:,:,2,si)-vtYYY(:,:,2,sj));
%         vhD=vhD+norm(vhYYY(:,:,1,si)-vhYYY(:,:,1,sj));
%         vhS=vhS+norm(vhYYY(:,:,2,si)-vhYYY(:,:,2,sj));
%         
%         vtD=vtD+norm(vtZZZ(:,:,1,si)-vtZZZ(:,:,1,sj));
%         vtS=vtS+norm(vtZZZ(:,:,2,si)-vtZZZ(:,:,2,sj));
%         vhD=vhD+norm(vhZZZ(:,:,1,si)-vhZZZ(:,:,1,sj));
%         vhS=vhS+norm(vhZZZ(:,:,2,si)-vhZZZ(:,:,2,sj));
%         
%         
%     end
% end
% 
% 
% [wtD vtD;wtS vtS;whD vhD;whS vhS]



for si=1:10
    
        
       wtWithinN(si) = norm( vec(wtYYY(:,:,:,si))-vec(mean(wtYYY(:,:,:,:),4)) ) ^2;
       wtWithinM(si) = norm( vec(wtZZZ(:,:,:,si))-vec(mean(wtZZZ(:,:,:,:),4)) ) ^2;
       vtWithinN(si) = norm( vec(vtYYY(:,:,:,si))-vec(mean(vtYYY(:,:,:,:),4)) ) ^2;
       vtWithinM(si) = norm( vec(vtZZZ(:,:,:,si))-vec(mean(vtZZZ(:,:,:,:),4)) ) ^2;
       ntWithinN(si) = norm( vec(ntYYY(:,:,:,si))-vec(mean(ntYYY(:,:,:,:),4)) ) ^2;
       ntWithinM(si) = norm( vec(ntZZZ(:,:,:,si))-vec(mean(ntZZZ(:,:,:,:),4)) ) ^2;
   
end

wtWithin=sum(wtWithinM)+sum(wtWithinN);
vtWithin=sum(vtWithinM)+sum(vtWithinN);
ntWithin=sum(ntWithinM)+sum(ntWithinN);

wtBetween=norm( vec(mean(wtYYY,4))-vec(mean(wtZZZ,4)) )^2;
ntBetween=norm( vec(mean(ntYYY,4))-vec(mean(ntZZZ,4)) )^2;
vtBetween=norm( vec(mean(vtYYY,4))-vec(mean(vtZZZ,4)) )^2;


for si=1:10
    
        
       whWithinN(si) = norm( vec(whYYY(:,:,:,si))-vec(mean(whYYY(:,:,:,:),4)) ) ^2;
       whWithinM(si) = norm( vec(whZZZ(:,:,:,si))-vec(mean(whZZZ(:,:,:,:),4)) ) ^2;
       vhWithinN(si) = norm( vec(vhYYY(:,:,:,si))-vec(mean(vhYYY(:,:,:,:),4)) ) ^2;
       vhWithinM(si) = norm( vec(vhZZZ(:,:,:,si))-vec(mean(vhZZZ(:,:,:,:),4)) ) ^2;
       nhWithinN(si) = norm( vec(nhYYY(:,:,:,si))-vec(mean(nhYYY(:,:,:,:),4)) ) ^2;
       nhWithinM(si) = norm( vec(nhZZZ(:,:,:,si))-vec(mean(nhZZZ(:,:,:,:),4)) ) ^2;
   
end

whWithin=sum(whWithinM)+sum(whWithinN);
vhWithin=sum(vhWithinM)+sum(vhWithinN);
nhWithin=sum(nhWithinM)+sum(nhWithinN);

whBetween=norm( vec(mean(whYYY,4))-vec(mean(whZZZ,4)) )^2;
nhBetween=norm( vec(mean(nhYYY,4))-vec(mean(nhZZZ,4)) )^2;
vhBetween=norm( vec(mean(vhYYY,4))-vec(mean(vhZZZ,4)) )^2;

wtBetween/wtWithin
ntBetween/ntWithin
vtBetween/vtWithin

whBetween/whWithin
nhBetween/nhWithin
vhBetween/vhWithin
