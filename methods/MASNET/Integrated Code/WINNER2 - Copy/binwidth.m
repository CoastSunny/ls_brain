function [varargout] = binwidth(varargin)
% Calculates an appropriate bin width, for obtaining histograms of a
% data-set, according to Sturges's rule. 
%
% [bin_width] = binwidth(data_samples)
%
% The number of bins may also be returned as an output
%
% [bin_width, Nbins] = binwidth(data_samples)


%% Input
data_samples   =       varargin{1};                  % Input data samples.


%% Apply Sturges's rule

% Calulate bin width

bin_width = (max(data_samples) - min(data_samples))/(1 + log2(length(data_samples)));

% Calulate number of bins

Nbins = ceil((max(data_samples) - min(data_samples))/bin_width);



%% Outputs

switch nargout
    
    case 1
        varargout{1} = bin_width;
        
        
    case 2
        varargout{1} = bin_width;
        varargout{2} = Nbins;
end
         


end

