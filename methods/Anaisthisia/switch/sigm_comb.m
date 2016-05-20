function y = sigm_comb( x , no_elements , s_max, s_thresh , s_skew)
%%%warning the function name is wrong, will deal with it later
if (nargin<3)
    s_max=4;
    s_thresh=0.5;
    s_skew=3;
end
    for i = 1 : numel( x ) - no_elements + 1    
        
        temp = s_max*sum( 1 ./ ( 1 + exp( - x( i : i + no_elements -1 ) ) .^ s_skew ) );
        if (temp >s_thresh)
            y(i)=1;
        else
            y(i)=-1;
        end
    
    end

end