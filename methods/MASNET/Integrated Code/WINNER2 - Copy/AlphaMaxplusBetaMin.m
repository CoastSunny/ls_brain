% Aprroimxtes to the absolut value

clear
N = 100;

alpha = (2*cos(pi/8))/(1+ cos(pi/8));
beta = (2*sin(pi/8))/(1+ cos(pi/8));

h = randn(N,1) + j*randn(N,1);

h_abs1 = abs(h);
h_abs2 = zeros(1,N);

for xx = 1:N
    h_max = max([abs(real(h(xx))), abs(imag(h(xx)))]);
    h_min = min([abs(real(h(xx))), abs(imag(h(xx)))]);
    h_abs2(xx) = alpha*h_max + beta*h_min;
end

figure(1)
plot(h_abs1,'-bx')
hold on; grid on;
plot(h_abs2,'-rs')