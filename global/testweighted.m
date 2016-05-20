
f=@(x,m,s) 1/2*(1+erf((x-m)/sqrt(2*s^2)));
m1=-0.5;
m2=1;
s1=1;
s2=2;

fprintf('\n normal \n')

f(0,m1,s1)
1-f(0,m2,s2)

fprintf('\n /2 \n')
k=2;
m=2*1/k*m1;
s=2*1/k^2*s1;
f(0,m,s)
m=2*1/k*m2;
s=2*1/k^2*s2;
1-f(0,m,s)

fprintf('\n /3 \n')
k=3;
m=2*1/k*m1;
s=2*1/k^2*s1;
f(0,m,s)
m=2*1/k*m2;
s=2*1/k^2*s2;
1-f(0,m,s)

fprintf('\n /4 \n')
k=4;
m=2*1/k*m1;
s=2*1/k^2*s1;
f(0,m,s)
m=2*1/k*m2;
s=2*1/k^2*s2;
1-f(0,m,s)

fprintf('\n /5 \n')
k=5;
m=2*1/k*m1;
s=2*1/k^2*s1;
f(0,m,s)
m=2*1/k*m2;
s=2*1/k^2*s2;
1-f(0,m,s)