
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



wtD=0;
wtS=0;
whD=0;
whS=0;

vtD=0;
vtS=0;
vhD=0;
vhS=0;

for si=1:10
    for sj=1:10
        
        wtD=wtD+norm(wtYYY(:,:,1,si)/norm(wtYYY(:,:,1,si))-wtYYY(:,:,1,sj)/norm(wtYYY(:,:,1,sj)));
        wtS=wtS+norm(wtYYY(:,:,2,si)/norm(wtYYY(:,:,2,si))-wtYYY(:,:,2,sj)/norm(wtYYY(:,:,2,sj)));
        whD=whD+norm(whYYY(:,:,1,si)/norm(whYYY(:,:,1,si))-whYYY(:,:,1,sj)/norm(whYYY(:,:,1,sj)));
        whS=whS+norm(whYYY(:,:,2,si)/norm(whYYY(:,:,2,si))-whYYY(:,:,2,sj)/norm(whYYY(:,:,2,sj)));
        
        wtD=wtD+norm(wtZZZ(:,:,1,si)/norm(wtZZZ(:,:,1,si))-wtZZZ(:,:,1,sj)/norm(wtZZZ(:,:,1,sj)));
        wtS=wtS+norm(wtZZZ(:,:,2,si)/norm(wtZZZ(:,:,2,si))-wtZZZ(:,:,2,sj)/norm(wtZZZ(:,:,2,sj)));
        whD=whD+norm(whZZZ(:,:,1,si)/norm(whZZZ(:,:,1,si))-whZZZ(:,:,1,sj)/norm(whZZZ(:,:,1,sj)));
        whS=whS+norm(whZZZ(:,:,2,si)/norm(whZZZ(:,:,2,si))-whZZZ(:,:,2,sj)/norm(whZZZ(:,:,2,sj)));
        
        vtD=vtD+norm(vtYYY(:,:,1,si)/norm(vtYYY(:,:,1,si))-vtYYY(:,:,1,sj)/norm(vtYYY(:,:,1,sj)));
        vtS=vtS+norm(vtYYY(:,:,2,si)/norm(vtYYY(:,:,2,si))-vtYYY(:,:,2,sj)/norm(vtYYY(:,:,2,sj)));
        vhD=vhD+norm(vhYYY(:,:,1,si)/norm(vhYYY(:,:,1,si))-vhYYY(:,:,1,sj)/norm(vhYYY(:,:,1,sj)));
        vhS=vhS+norm(vhYYY(:,:,2,si)/norm(vhYYY(:,:,2,si))-vhYYY(:,:,2,sj)/norm(vhYYY(:,:,2,sj)));
        
        vtD=vtD+norm(vtZZZ(:,:,1,si)/norm(vtZZZ(:,:,1,si))-vtZZZ(:,:,1,sj)/norm(vtZZZ(:,:,1,sj)));
        vtS=vtS+norm(vtZZZ(:,:,2,si)/norm(vtZZZ(:,:,2,si))-vtZZZ(:,:,2,sj)/norm(vtZZZ(:,:,2,sj)));
        vhD=vhD+norm(vhZZZ(:,:,1,si)/norm(vhZZZ(:,:,1,si))-vhZZZ(:,:,1,sj)/norm(vhZZZ(:,:,1,sj)));
        vhS=vhS+norm(vhZZZ(:,:,2,si)/norm(vhZZZ(:,:,2,si))-vhZZZ(:,:,2,sj)/norm(vhZZZ(:,:,2,sj)));
        
        
    end
end


[wtD vtD;wtS vtS;whD vhD;whS vhS]

