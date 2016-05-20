f=@(w1,w2,theta,m1,s1,m2,s2,r)...
    (1-normcdf(theta,w1*m1+w2*m2,sqrt(w1^2*s1^2+w2^2*s2^2+2*r*w1*w2*s1*s2)));


weight=@(r,m1,s1,m2,s2)((r*s1*s2-m1*m2)/(m2^2-s2^2));