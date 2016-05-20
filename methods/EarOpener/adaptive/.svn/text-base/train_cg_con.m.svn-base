function [w,f,J] = train_cg_con(x,y,lambda,varargin)
% TRAIN_CG    Train a logistic regression model by conjugate gradient.
%
% W = TRAIN_CG(X,W) returns maximum-likelihood weights given data and a
% starting guess.
% Data is columns of X, each column already scaled by the output (+1 or -1).
% W is the starting guess for the parameters (a column).

% Written by Thomas P Minka
opts=struct('w_template',[],'alphab',[],'nobias',0,'dim',[],...
    'maxIter',inf,'maxEval',[],'tol',0,'tol0',0,'lstol0',1e-2,'objTol',1e-6,'objTol0',1e-4,...
    'verb',0,'step',0,'wght',[],'X',[],'ridge',0,'maxLineSrch',50,...
    'maxStep',3,'minStep',5e-2,'marate',.95,'bPC',[],'incThresh',.75,'optBias',0,'maxTr',inf);
[opts,varargin]=parseOpts(opts,varargin{:});
opts2var
temp=0;
if (isempty(w_template))
    w_template=[zeros(size(x,1),1)];
    temp=1;
else
   w_template=reshape(w_template',size(x,1),1);
end
w=[w_template;0];
x(end+1,:)=1;
ox=x;
x=repop(x,'*',y',2);
x(:,y==0)=[];
s1 = 1./(1+exp(w'*x));
if temp==0
   lambda=0.1*norm(x*s1')/norm(w)*lambda; 
end

if nargin < 3
    lambda = 0;
end
[d,n] = size(x);
%flops(0);
old_g = zeros(size(w,1),1);

for iter = 1:2000
    old_w = w;
    % s1 = 1-sigma
    
    s1 = 1./(1+exp(w'*x));
    if (temp==1)
        g = x*s1' - lambda*w;
        
    else
      %  g = x*s1' - lambda*([w(1:end-1)-w_template/norm(w_template)*norm(w(1:end-1)); w(end)]);% -lambda*w;
         g = x*s1' - lambda*([w(1:end-1)-w_template; w(end)]);% -lambda*w;
    end
    
    
    % flops(flops + flops_mul(w',x) + n*(flops_exp+2) + flops_mul(x,s1') + 2*d);
    if iter == 1
        u = g;
    else
        u = cg_dir(u, g, old_g);
    end
    
    % line search along u
    ug = u'*g;
    ux = u'*x;
    a = s1.*(1-s1);
    uhu = (ux.^2)*a' + lambda*(u'*u);
    w = w + (ug/uhu)*u;
    old_g = g;
    % flops(flops + flops_mul(u',g) + flops_mul(u',x) + 2*n + ...
    %     n+flops_mul(1,n,1) + 2*d+1);
    %   if lambda > 0
    %     flops(flops + 1+flops_mul(u',u));
    %   end
    
    run.w(:,iter) = w;
    %run.flops(iter) = flops;
    run.e(iter) = logProb(x,w) - 0.5*lambda*w'*w;
    df(iter)=max(abs(w-old_w));
    if max(abs(w - old_w)) < 1e-6 && iter>2 
       % iter
        break
    end
    %lambda=lambda*0.99;
end
% figure(2)
% plot(run.e)
%figure,plot(df)
f=w'*ox;f = reshape(f,size(y));
J=abs(w-old_w);

if iter == 2000
    warning('not enough iters')   
end






