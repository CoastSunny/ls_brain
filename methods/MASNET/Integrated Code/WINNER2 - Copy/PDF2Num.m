% Arbitray generation of complex numbers.

clear

% Parameters
N = 2500;

% Initialisations
new_rand_num = zeros(1,N);

%% Uniform distribution LUT
% create vector of uniform random numbers
uni_vec = rand(1,N);

% Sort them and find the minimum difference
%uni_vec = sort(uni_vec);
%Prob_step1 = min(diff(uni_vec));

%% Arbitrary PDF
% probability density function is based on this data
probabilities = [0, 1, 10, 2, 0, 0, 4, 5, 3, 1, 0];
Prob_step2 = (2*pi)/length(probabilities);
x = -pi:Prob_step2:pi-Prob_step2;

% do spline interpolation for smoothing
xq = -pi:0.05:pi;
pdf = interp1(x, probabilities, xq, 'spline');

% remove negative elements due to the spline interpolation
pdf(pdf < 0) = 0;

% normalize the function to have an area of 1.0 under it
pdf = pdf / sum(pdf);

% the integral of PDF is the cumulative distribution function
cdf = cumsum(pdf);

%% Create LUT

LUT = [cdf;xq];

for xx = 1:N
    r = randi([1,length(uni_vec)],1,1);
    uni_num = uni_vec(r);
    [~,b] = min(abs(cdf-uni_num));
    new_rand_num(xx) = xq(b);
end
    

%% Plots

figure(1)
hist(new_rand_num,50)
figure(2)
plot(xq,pdf)














