function [varargout] = distfit(varargin)

% Takes in a vector of data samples and creates a probability density function (PDF) or
% a cumulative density function (CDF).
% It then tries to fit the data statistically using curve fitting techniques
% based on Matlab's maximum likelihood estimator algorithm.
%
% Inputs are a vector of data samples, a variable specifying the amount of
% bins to use to create the PDF or CDF, a string specfiying PDF of CDF and a string denoting the distribution
% with which to attempt to fit the data. If no distribution string is specifed
% then the algorithm simply returns a PDF or a CDF plot.
%
% Outputs are the centre values of the bins for the input samples bins, the centre points for the curve 
% fitted PDF or CDF, PDF or CDF values and a curve fitted PDF or CDF and optionally the K-factor (in dB) for
% the case of the Rician distribution:
%
% [bin_samples, bins_fit, pdf_values, fitted_pdf] = distfit(data_samples, Nbins, dist_func, dist)
%
% where dist is a string and can be specified as:
%
%         'beta'                             Beta
%         'bernoulli'                        Bernoulli
%         'binomial'                         Binomial
%         'discrete uniform' or 'unid'       Discrete uniform
%         'exponential'                      Exponential
%         'extreme value' or 'ev'            Extreme value
%         'gamma'                            Gamma
%         'generalized extreme value' 'gev'  Generalized extreme value
%         'generalized pareto' or 'gp'       Generalized Pareto
%         'geometric'                        Geometric
%         'lognormal'                        Lognormal
%         'negative binomial' or 'nbin'      Negative binomial
%         'normal'                           Normal
%         'poisson'                          Poisson
%         'rayleigh'                         Rayleigh
%         'uniform'                          Uniform
%         'weibull' or 'wbl'                 Weibull
%         'rician'                           Rician
%
% and dist_func is a string, 'CDF', 'cdf', 'PDF' or 'pdf', that specifies whether
% probability or cumulative density functions are desired at the output.
%
% For the case of the Rician distribution:
%
% [bin_samples, bins_fit, pdf_values, fitted_pdf, K] = distfit(data_samples, Nbins,dist_func,'rician')
%
% The meaning of K for other distributions needs to be verified by the
% user.
%
% Finally for the case where the distribution is not specified:
%
% [bin_samples, bins_fit, pdf_values] = distfit(data_samples, Nbins, dist_func).



%% Inputs
switch nargin
    
    case 3
        
        data_samples   =       varargin{1};                  % Input data samples.
        Nbins          =       varargin{2};                  % Number of bins for PDF.
        dist_func      =       varargin{3};                  % Specify function, 'PDF' or 'CDF'
        
    case 4
        
        data_samples   =       varargin{1};                  % Input data samples.
        Nbins          =       varargin{2};                  % Number of bins for PDF.
        dist_func      =       varargin{3};                  % Specify function, 'PDF' or 'CDF'
        dist           =       varargin{4};                  % Distribution to attempt to fit.
        
end


%% Compute PDF of data.

% Histogram

[val bin_samples] = hist(data_samples, Nbins);

% PDF
% Matlab Website: Probability density function estimate. The height of each bar is, (number of observations in the bin) / (total number of observations * width of bin). 
% The area of each bar is the relative number of observations. The sum of the bar areas is 1.
% http://uk.mathworks.com/help/matlab/ref/histogram.html

pdf_values = val/sum(val*(abs(bin_samples(2)-bin_samples(1))));


%% Curve fitting for the PDF.
switch nargin
    
    case 4
        % Call histogram again to set bin width lower for PDF curve.
        
        [~, bin_fit] = hist(data_samples, 50);
        
        % MLE algorithm to perform curve fitting.
        
        
        
        est_param = mle(data_samples,'distribution',dist);
        
        if      numel(est_param) == 1
            fitted_pdf = pdf(dist, bin_fit, est_param(1));
        elseif  numel(est_param) == 2
            fitted_pdf = pdf(dist, bin_fit, est_param(1), est_param(2));
        elseif  numel(est_param) == 3
            fitted_pdf = pdf(dist, bin_fit, est_param(1), est_param(2), est_param(3));
        end
        
        % Calculate K factor if Rician distribution has been chosen.
        
        if strcmpi(dist,'rician') || strcmpi(dist,'Rician')
            
            
            K_dB = 10*log10(est_param(1)^2/(2*(est_param(2)^2)));
            
        end
        
end

if strcmp(dist_func, 'CDF') || strcmp(dist_func, 'cdf') 
    % CDF
    % Matlab web-site: Cumulative density function estimate. The height of each bar is equal to the cumulative relative number of observations in the bin and all previous bins. 
    % The height of the last bar is 1. For categorical data, the height of each bar is equal to the cumulative relative number of observations in each category and all previous categories. 
    % The height of the last bar is 1
    cdf = cumsum(val);
    pdf_values = cdf/(cdf(end));
    
    fitted_pdf = cumsum(fitted_pdf);
    fitted_pdf = fitted_pdf/(fitted_pdf(end));
    
elseif strcmp(dist_func, 'PDF') || strcmp(dist_func, 'pdf')
end


%% Outputs


switch nargout
    
    case 2
        varargout{1} = bin_samples;
        varargout{2} = pdf_values;
        
    case 3
        
        varargout{1} = bin_samples;
        varargout{2} = pdf_values;
        varargout{3} = est_param;
        
        
    case 4
        varargout{1} = bin_samples;
        varargout{2} = bin_fit;
        varargout{3} = pdf_values;
        varargout{4} = fitted_pdf;
        
    case 5
        varargout{1} = bin_samples;
        varargout{2} = bin_fit;
        varargout{3} = pdf_values;
        varargout{4} = fitted_pdf;
        varargout{5} = est_param;
        
        
    case 6
        varargout{1} = bin_samples;
        varargout{2} = bin_fit;
        varargout{3} = pdf_values;
        varargout{4} = fitted_pdf;
        varargout{5} = K_dB;
        varargout{6} = est_param;
        
end

end
