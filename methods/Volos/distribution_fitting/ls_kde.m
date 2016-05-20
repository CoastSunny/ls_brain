function f = ls_kde( x , X , h )

    n=size(X,3);
    f=0;
    for i=1:n
    
        f=f + gkernel( x , X(:,:,i) , h);
        
    end
   
    f=f/n/h;


end

function z = gkernel( x , y , h )

z = 1 / sqrt( 2 * pi ) * exp( -1/2 * norm( ( x - y ) / h )^2 );

end