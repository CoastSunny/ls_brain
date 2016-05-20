function out= fperf( f, labels )

    %out.perf = sum ( f .* labels > 0 ) / numel(f) ;
    out.tpr = sum ( f(labels==1) >= 0 ) / numel(f(labels==1)) ;
    out.fpr = sum ( f(labels==-1) >= 0 ) / numel(f(labels==-1)) ;
    out.perf=.5*(out.tpr+1-out.fpr);
    out.ppidx = f>=0;
    out.npidx = f<=0;

end