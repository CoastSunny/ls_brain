%calculate CRLB (Cramer Rao Lower Bound) in MATLAB using derivation given
%in Least Squares Algorithms for Time-of-Arrival Based Mobile Location,
%Cheung et al, IEEE TSP 2004
%calum blair 2/12/14
%input: target location (x,y) 1x2 , locations of M sensors (Mx2), sigma
%(scalar)
%outputs: C: lower bound matrix in x and y
%         sigma_out: sqrt(trace(C)), single measure of accuracy
function [C, sigma_out ]= crlb(target,sensors,sigma, sigma_rss)

M = size(sensors,1); %number of observations
X = sensors(:,1);
Y = sensors(:,2);
if numel(target) ==3
	Z = sensors(:,3);
end
s2 = sigma.^2;


if ~exist('sigma_rss','var') ||isempty(sigma_rss)
    use_RSS = false;
else
    use_RSS = true;
end

%extract target locs and expand to size(sensors)
T = repmat(target,M,1);
x = T(:,1);
y = T(:,2);
if numel(target) ==3
	z = T(:,3);
end
denom = (s2 * ((x - X).^2 + (y-Y).^2 ));
yterm = sum(  (y-Y).^2 ./ denom);
xterm = sum(  (x-X).^2 ./ denom );
diffterm = sum(  (x-X).*(y-Y) ./ denom ); % 27/7/15 added -ve here
fim = [xterm diffterm;diffterm yterm];

if use_RSS %include RSS information and shrink bound
    r = sqrt( (x-X).^2 + (y-Y).^2);
    dx = x-X; 
    dy = y-Y; 
    bb = (10/ (sigma_rss * log(10)))^2; %b is ((10*np)/(sigma_dB * log(10))^2 but sigma_rss is set as sigma_dB/np
    xterm_rss = sum((dx./r).^2./(r.^2));
    yterm_rss = sum( (dy./r).^2./(r.^2));
    diffterm_rss =  sum( ((dx./r) .* (dy./r)) ./ (r.^2));
    fim_rss = bb * [xterm_rss diffterm_rss;  diffterm_rss yterm_rss];
    fim = fim + fim_rss;
end


C = inv(fim);
%find standard deviation as single measure,
%sqrt(var(x) + var(y))
sigma_out = sqrt(trace(C));

end
