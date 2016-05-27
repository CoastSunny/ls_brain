function W = strongestW(W,perc)

    w=G2v(W);
    [m i]=sort(w);
    if perc <1
    thresh=m(end)*(1-perc);
    idx=(w>thresh);
    w(~idx)=0;
    W=v2G(w);
    else
    w(i(1:(end-perc)))=0;
    W=v2G(w);
    end

end