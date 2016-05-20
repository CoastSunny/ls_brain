function y = vec_elements_product( x , no_elements )
%%%warning the function name is wrong, will deal with it later
    for i = 1 : numel( x ) - no_elements + 1    
        
        temp = sum( sign( x( i : i + no_elements -1 ) ) );
        if (temp ==1*no_elements)
            y(i)=1;
        else
            y(i)=-1;
        end
    
    end

end