
n=0.99;
gamma=1;
w=ones(3,116,100);
y(1)=0;
for p=1:100
    delay=dfilt.delay(p-1);
    y(1) = y(1) + w(:,1,p)' * filter(delay,x(:,1));
end


for k=1:116
    
    for p=1:100                
        
        
        phi = gamma * y(k) - y(k) * abs( y(k) ) ^2 ;
        
        w(:,k+1,p) = w(:,k,p) + n * phi * filter(delay,x(:,k)) ;
        
    end
    
end

