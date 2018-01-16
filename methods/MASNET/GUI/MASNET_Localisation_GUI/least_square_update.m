%%% This function is to compute the constant distance matrix b for TDOA
%%% Its inputs is the sensors' positions(anchor), distance differences
%%% vector(d) and the reference  distance value (d1), the ouput is the
%%% constant matrix b
function [b]=least_square_update(anchor,d,d1)

x = anchor(:,1);
y = anchor(:,2);
z = anchor(:,3);
k = x.^2+y.^2+z.^2;
b = (k-k(1))-(2*d1.*d).'-(d.^2).';



    