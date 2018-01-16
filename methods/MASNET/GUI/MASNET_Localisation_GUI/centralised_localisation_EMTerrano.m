function [est_target,est_ls] = centralised_localisation_EMTerrano(dists,Sensors,p)
% %%% TDOA maesurements converted into distance differences measurements 
dhat =dists-dists(1);
% %%% choose the first sensor to be the reference node (fusion center)
new_origin = Sensors(1,:);
%%% compute the sensor offsets which is the sensor locations according to
% %%% the reference node (fusion center)
sensor_offsets = bsxfun(@minus,Sensors,new_origin);
%%% constrained squared-range-difference-based least squares estimate from
% %%%'Exact and Approximate Solutions of Source Localization Problems', beck et
% %%%al, 2008 section iii
guess = localize_srdls(sensor_offsets,dhat);
%%% after computing the y vector as defined in 'Exact and Approximate Solutions 
%%% of Source Localization Problems', beck et al, 2008 section iii, the
%%% estimated target position is computed by adding the first p (3)
%%% components of vector y to the location of reference node (fusion center)
est_target = guess(1:p,1)+new_origin.';
d1 = dists(1);
b = least_square_update(Sensors,dhat,d1);
est_ls = lscov(sensor_offsets,b/2);
end