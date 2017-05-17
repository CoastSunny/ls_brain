%tdoa-rle algorithm from 'Time-difference-of-arrival regularised location
%estimator for multilateration systems', Mantilla etal,. 2013
%calum Blair 2015
%inputs: sensor_locs: N x d matrix of receiver locations, one of which
%should be at [0,0,0].
%dhat: Nx1 noisy distance measurements from receivers to target
%X: 1xd  guess of target location
%is2d: boolean, if true d=2 else d=3.
%W: choice of smoothing parameter for lambda var in Tikhonov
%regularisation.  if W>0 use this value, if W==-1 use adaptive.
%default=0.3.
%returns theta_hat,  a dx1 estimated position vector
function theta_hat = localization_mantilla(sensor_locs,dhat,X,is2d,W)
% if ~exist('c','var') ||isempty(c)
%   c = 3e8;
% end

%dimensionality
if ~exist('is2d','var') ||isempty(is2d)
  is2d = false;
end
if is2d
    D=2; 
else
    D=3; 
    assert(size(X,1) == 3); assert(size(sensor_locs,2)==3); 
end

%choice of W parameter
if ~exist('W','var') ||isempty(W)
  W=0.3;%few stations, near targets
  %w=0.03; %many stations, far targets
end

mhat =  dhat; %notation for measurement vector; dont multiply by (1/c)
theta_0 = X(1:D); %keep notation consistent with paper

%tolerance and number of iterations
tol = 1e-4;
Kmax = 1e5;

%find euclidean between estimate and all sensors, no multiplication by (1/c)
m_theta_0 = calc_m_theta(theta_0, sensor_locs,D);

%% iterative method using svd
done=false;
theta_hat = theta_0;
k=0;
use1 = true;
while ~done
  theta_hat_prev = theta_hat;
  
  %find G,the jacobian matrix. equation 11 in paper
  %the paper notation is confusing: remember this is for a measurement theta_hat
  %not a delta, (theta_hat-theta_0).
  %reminder: f(x) = f(a) + df(a)(x-a)
  G = calc_jacobian_G(sensor_locs, theta_hat_prev',D);
  cG = cond(G,2); %condition number
  [U, S, V] = svd(G);
  s = diag(S);
  
  %choose w first
  if W==-1
    %%for well conditioned targets nearby
    if k>2
      if s(2) >=s2_prev
        w = 0.8*w_prev;
      else
        w = w_prev;
      end
    end
  else
    w = W;
  end
  
  %find lambda
  if is2d
    lambda = s(2) + w * (s(1)-s(2));
  else
    lambda = s(3) + w * (s(2)-s(3));
  end
  %find f
  f = s.^2./(s.^2+lambda^2);
  
  %find mhat_Delta
  mhat_Delta_1 = mhat(2:end)' - calc_m_theta(theta_hat_prev, sensor_locs,D);
  
  %weird taylor series expansion
  %m = m_theta_0 + G*(theta-theta_0) (Not used)
  %theta_hat = (...) + theta_hat_prev;
  %option 1
  theta_hat_1 = (f(1)*(U(:,1)')*mhat_Delta_1/s(1))*V(:,1) + (f(2)*(U(:,2)')*mhat_Delta_1/s(2)) *V(:,2);
  if ~is2d
    theta_hat_1 = theta_hat_1 +  (f(3)*(U(:,3)')*mhat_Delta_1/(s(3)+0.001)) *V(:,3);
  end
  
  %option 2: no Tikhonov, usually blows up
  %theta_hat_2 = G'*G\(G'*mhat_Delta);
  
  theta_hat = theta_hat_prev + theta_hat_1;
  
  %fprintf('%f\t%f\t\t%f\n',theta_hat(1),theta_hat(2),cG);
  %loop exit conditions
  if all(abs(theta_hat-theta_hat_prev) < tol) || k==Kmax || any(isnan(theta_hat));
    done=true;
  end
  s2_prev = s(2);
  w_prev = w;
  k=k+1;
end
fprintf('%f\t%f\t\t%f\n',theta_hat(1),theta_hat(2),cG);
if any(isnan(theta_hat))
  fprintf('blew up, returning initial value\n');
  theta_hat = X(1:D);
elseif k>Kmax
  fprintf('did not converge, k=%d\n',k);
else
  fprintf('converged at k=%d\n',k);
end

theta_hat = theta_hat'; theta_hat(end+1) = X(end); %format output
theta_hat = theta_hat(1:D);
end

function m_theta = calc_m_theta(theta, sensor_locs, D)
%straightforward euclidean distance in 2 or 3 dimensions
rr = bsxfun(@minus,sensor_locs(:,1), theta(1)).^2 + ...
  bsxfun(@minus,sensor_locs(:,2), theta(2)).^2;
if D== 3 %3d fix
  rr = rr + bsxfun(@minus,sensor_locs(:,3), theta(3)).^2;
end
r = sqrt(rr);
m_theta = (r(2:end)-r(1));
end

function G = calc_jacobian_G(sensor_locs, theta, d)
%x1_term = [(x0-x1)/r1 (y0-y1)/r1]
%xn term = [(x0-xn)/rn (y0-yn)/rn]
%G = xn - x1
x1_term = (theta - sensor_locs(1,1:d))/...
  (sqrt(sum( (theta - sensor_locs(1,1:d)).^2 )) +eps);
xn_term = bsxfun(@rdivide, bsxfun(@minus, theta, sensor_locs(2:end,1:d)), ...
  (sqrt(sum( (bsxfun(@minus, theta, sensor_locs(2:end,1:d))).^2 ,2))+eps) );
G = bsxfun(@minus, xn_term, x1_term);
end
