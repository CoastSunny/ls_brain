tr=1;

H=randn(4,4)+eye(4);
h1=H(:,1)/norm(H(:,1));
h2=H(:,2)/norm(H(:,2));
s1=peak(1024,tr,2048,4,200);
s2=peak(1024,tr,2048,3,300);
s3=peak(1024,tr,2048,4,800);
s4=peak(1024,tr,2048,4,900);
%s5=peak(1024,tr,2048,2,950);

S=[s1;s2;s3;s4];

for i=1:1000
            
    N=randn(4,1024);
    X(:,:,i)=H*S+.1*N;
    
end

%% method louk
n1=randn(1,1024);
n2=randn(1,1024);
np=.1;
s1=s1+np*n1;
s2=s2+np*n2;

r1 = s1 - (s2*s1')/(s2*s2')*s2;
r2 = s2 - (s1*s2')/(s1*s1')*s1;
R=[s1;s2];

clear eLouk eLS eTLS
for i=1:10
    
    Y = X(:,:,i);
    w1 = inv(Y*Y')*Y*r1';
    w2 = inv(Y*Y')*Y*r2';
    a1 = Y*Y'*w1;a1=a1/norm(a1);
    a2 = Y*Y'*w2;a2=a2/norm(a2);
    eLouk(i) = norm(a1-h1) + norm(a2-h2);
    A=inv(R*R')*R*Y';          
    z1=A(1,:)'/norm(A(1,:));
    z2=A(2,:)'/norm(A(2,:));
    eLS(i) = norm(z1-h1) + norm(z2-h2);    
    %% TLS
    C=[R ; Y];
    [u s v]=svd(C');
    vbb=v(3:end,3:end);
    vab=v(1:2,3:end);
    x=-vab*inv(vbb);
    x1=x(1,:)'/norm(x(1,:));
    x2=x(2,:)'/norm(x(2,:));
    eTLS(i) = norm(x1-h1) + norm(x2-h2);
end

mean(eLouk),mean(eLS),mean(eTLS)


%% method LS





