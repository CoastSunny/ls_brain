% Stefan Haufe, 2014-16
% stefan.haufe@tu-berlin.de
%
% Arne Ewald, 2015, 2016, mail@aewald.net
%
% If you use this code for a publication, please ask Stefan Haufe for the
% correct reference to cite.

% License
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see http://www.gnu.org/licenses/.

%% Initialization

clear all
clc

set_path

%% to generate your own data set and evaluate the performance

% you can generate your own data with the according ground truth to test 
% your specific analysis pipleline. Here, an example using LVMC beamforming,
% the imaginary part of coherency and the Phase-Slope-Index (PSI) is
% demonstrated
ndatasets = 30;

% give your benchmark a name
dataset_string = 'new_benchmark';  

generate_datasets_ar(ndatasets, dataset_string);

% insert your data analysis code 
% HERE

% or try
EEG_estimate_lcmv_imcoh_psi(ndatasets, dataset_string);
% or
% MEG_estimate_lcmv_imcoh_psi(ndatasets, dataset_string);


%% to evaluate the existing data

ndatasets = 100;

dataset_string = 'benchmark'; 

% to apply the example data analysis pipeline on the given challenge data
% you can run

% EEG_estimate_lcmv_imcoh_psi(ndatasets, dataset_string);
% MEG_estimate_lcmv_imcoh_psi(ndatasets, dataset_string);
