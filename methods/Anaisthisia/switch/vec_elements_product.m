function y = vec_elements_product( x , no_elements )
%fprintf('warning there is a bug to where I place the trailing elements');
%%%warning the function name is wrong, will deal with it later
x=reshape(x,1,numel(x));
for i = 1 : numel( x ) - no_elements + 1
    
    temp = sum( sign( x( i : i + no_elements -1 ) ) );
    if (temp ==1*no_elements)
        y(i)=1;
    else
        y(i)=-1;
    end
    
end

if no_elements>1
    y=[sign(x(1:no_elements-1)) y];
end
end