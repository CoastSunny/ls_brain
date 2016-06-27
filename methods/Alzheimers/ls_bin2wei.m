function [W, We] = ls_bin2wei(B,noise_std,keep_structure)

n=size(B,1);
W=triu(rand(n));
W=W+W';
rng('shuffle')

E=triu(randn(n))*(noise_std);

if (keep_structure)
    E=(E+E').*B;
else
    E=E+E';
end

W = B .* W;
We=W+E;
W(W<0)=0;W=W/max(max(W));
We(We<0)=0;We=We/max(max(We));

end