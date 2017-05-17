function [varargout] = ComplexGaussPhase(varargin)
%
% Calculates the probability density function (PDF) of phase of a complex Gaussian random variable, x + jy, 
% where: x~(alpha, s1^2) and y~(beta, s2^2) over the support [-pi:step:pi].
%
% P = ComplexGaussPhase(alpha, s1, s2, step)
%
% returns a vector of probability denities, P.

%% Input arguments. 

alpha           = varargin{1};
s1              = varargin{2};
s2              = varargin{3};
step            = varargin{4};


%% Comupute PDF of phase according to P.Beckmann, "Rayleigh distribition and its generalisations", 1964.

theta_range = [-pi:step:pi];
P = zeros(1,length(theta_range));
B = alpha/(sqrt(s1 + s2));
K = sqrt(s2/s1);

Gp2 = 1 + K^2;
Pp1 = K*exp((-0.5*(B^2))*(1 + (K^2))); 

for tt = 1:length(theta_range)    
    Gp1 = B*K*cos(theta_range(tt));    
    Gp3 = 2*((K^2)*(cos(theta_range(tt))^2) + (sin(theta_range(tt))^2));
    Gp4 = sqrt(Gp2/Gp3);
    G = Gp1*Gp4;
    
    Pp2 = pi*Gp3;
    Pp4 = Pp1/Pp2;
    Pp5 = 1 + erf(G);
    Pp6 = G*sqrt(pi)*exp(G^2);
    Pp7 = 1 + Pp6*Pp5;
    
    P(tt) = Pp4*Pp7;
end
   
    
%% Output arguments.

varargout{1} = P;

end
    
    
    
    
    
    

