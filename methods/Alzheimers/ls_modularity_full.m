function [m mm m1 m2] = ls_modularity_full(W, modules)

l=sum(sum(W));
k=sum(W);
D=modules;
m=0;m1=0;m2=0;
for i=1:size(W,1)
    
    for j=1:size(W,2)
        
        m1=m1+W(i,j)*D(i,j);
        m2=m2+k(i)*k(j)/l*D(i,j);
        m=m+(W(i,j)-k(i)*k(j)/l)*D(i,j);
        
    end
    
end

m=m/l;
mm=(m1-m2)/l;
m1=m1/l;
m2=m2/l;

end