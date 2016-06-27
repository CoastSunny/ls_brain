function [W,We] = wRand(n,noise_std)


W=triu(rand(n));
W=(W+W').*~eye(n);
E=triu(randn(n))*noise_std;
E=(E+E').*~eye(n);

We=W+E;
W(W<0)=0;W=W/max(max(W));
We(We<0)=0;We=We/max(max(We));

end


