function out = detdiffnorm(A,B)

    da=detrend(A);
    db=detrend(B);
    out=detrend(A)*(da*db')/(da*da')-detrend(B);

end