%constrained squared-range-difference-based least squares estimate from
%'Exact and Approximate Solutions of Source Localization Problems', Beck et
%al, 2008 section iii
%sensor_locs can be 2 or 3-dimensional. each row repesents a new sensor
%dhat should be distance not squared distance, n rows x 1 column
%returns X, where the (1:n-1) dimensions of X are target coordinates

function [X] = localize_srdls(sensor_locs, dhat)
a = sensor_locs;
if isrow(dhat), dhat = dhat'; end

%form A and b matrices
B = [-2*a -2*dhat];
g = (dhat.^2 - sum(a.^2,2) );

%minimise ||By-g||^2 subject to constraint y'Cy =0,y(end)>=0
C = eye(size(a,2)+1); C(end)=-1;
%ytilde = (B'*B+lambda*C)\B'*g

ytilde = @(lambda)(((B'*B+lambda*C)\(B'*g))' *C* ((B'*B+lambda*C)\(B'*g)));
lambda = 0;

%turn off warnings about ugly matrices: we are already
warning('off','MATLAB:nearlySingularMatrix');
%procedure prototype: find a lambda
try
    lambda  = fzero(ytilde,0);
catch
    lambda  = fzero(ytilde,1);
end
%substitute back into ytilde to solve
z = (B'*B+lambda*C)\(B'*g);

%procedure srd-ls:
if z(end) >=0  %fine
    X = z;
else
%     counter = counter+1;
    lambda_ = lambda;
    %look for other roots
    lambda  = fzero(ytilde,1);
    if abs(lambda-lambda_)<1e-6
        lambda_new = fzero(ytilde,2);
        if abs(lambda_new-lambda)<1e-6
        warning('pick another search point');
        z = zeros(4,1);
    else
        z = (B'*B+lambda*C)\(B'*g);
        end
    end
    X=z;
end
warning('on','MATLAB:nearlySingularMatrix');
end
