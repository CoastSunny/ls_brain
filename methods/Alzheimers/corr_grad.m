function grad = corr_grad(x,y)
    
    mx=mean(x);
    my=mean(y);
    x=x-mx;
    y=y-my;
    grad = ( (y) - (x)*(y).'/norm(x)^2 * (x)) / (norm(x)*norm(y));


end