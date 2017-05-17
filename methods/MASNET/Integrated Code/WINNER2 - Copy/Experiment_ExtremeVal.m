%% Numerical experiments with extreme value distribution

clear

% Generate appropriate data.
Nbins = 50;
rng default;  % For reproducibility
data = randn(1000,500);
xMinima = min(data, [], 2);
xMaxima = max(data, [], 2);

% PDFs.
[bins_min,bins_min_fit, pdf_min,pdf_fit_min] = distfit(xMinima,Nbins,'pdf','extreme value');
[bins_max,~, pdf_max,~] = distfit(xMaxima,Nbins,'pdf','extreme value');
[~,bins_max_fit, ~,pdf_fit_max,est_ex] = distfit(-1*xMaxima,Nbins,'pdf','extreme value');
[bins_max_n,bins_max_fit_n, pdf_max_n,pdf_fit_max_n,est_n] = distfit(xMaxima,Nbins,'pdf','normal');
pdf_fit_max = pdf_fit_max(end:-1:1);
bins_max_fit = -1*bins_max_fit(end:-1:1);









% Plots
figure(1)
plot(bins_min,pdf_min,'-bs')
hold on; grid on;
plot(bins_min_fit,pdf_fit_min,'-b')

figure(2)
plot(bins_max,pdf_max,'-rs')
hold on; grid on;
plot(bins_max_fit,pdf_fit_max,'-r')
plot(bins_max_fit_n,pdf_fit_max_n,'-g')