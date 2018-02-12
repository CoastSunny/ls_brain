function rois =  elec2roi(X)
% X electrode positions 3D (not MNI), electrodes in rows
nelec=size(X,1);

template=[0 -18.7 12.8];
%these values are the desired result from a (>) test of the electrode
%position to the template
RAI=[1 1 0];
RAS=[1 1 1];
RPI=[1 0 0];
RPS=[1 0 1];
LAI=[0 1 0];
LAS=[0 1 1];
LPI=[0 0 0];
LPS=[0 0 1];
ROI=[RAI;RAS;RPI;RPS;LAI;LAS;LPI;LPS];

for i=1:nelec

    rois(i)=find(ismember(ROI,X(i,:)>template,'rows')==1);

end


end