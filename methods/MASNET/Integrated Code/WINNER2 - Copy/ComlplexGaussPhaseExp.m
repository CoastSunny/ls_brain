% ComlplexGaussPhase
% To calculate the distribution of phase of a complex Gaussian random variable, x + jy, 
% where: x~(alpha, s1^2) and y~(beta, s2^2) over the support [-pi:step:pi]

clear

%% Hard code some parameters
M = 10670;

mean_imag = 0;
var_imag = 1/(2*M);

rho = 0; % the mean of real part of x
var_real = ((1-rho^2)^2)/(2*M);
step = 0.01;

theta_range = [-pi:step:pi];

P = zeros(1,length(theta_range));

%% Harmonise with notation in: P.Beckmann, "Statistical distribution of the amplitude and phase of a multiple scattered field"

alpha = rho;
s1 = var_real;
s2 = var_imag;

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
   
    
    
    
    
    
    
    
    

