 function load=pfls(ZtZ,ZtX,dimX,cons,OldLoad,DoWeight,W);

%PFLS
%
% See also:
% 'unimodal' 'monreg' 'fastnnls'
%
%
% Calculate the least squares estimate of
% load in the model X=load*Z' => X' = Z*load'
% given ZtZ and ZtX
% cons defines if an unconstrained solution is estimated (0)
% or an orthogonal (1), a nonnegativity (2), or a unimodality (3)
%
%
% Used by PARAFAC.M

% $ Version 1.02 $ Date 28. July 1998 $ Not compiled $
% Apr 2002 - Fixed error in weighted ls $ rb

% Copyright (C) 1995-2006  Rasmus Bro & Claus Andersson
% Copenhagen University, DK-1958 Frederiksberg, Denmark, rb@life.ku.dk
%
% This program is free software; you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation; either version 2 of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with
% this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
% Street, Fifth Floor, Boston, MA  02110-1301, USA.


if ~DoWeight
    
    if cons==0 % No constr
        %load=((Z'*Z)\Z'*Xinuse)';
        load=(pinv(ZtZ)*ZtX)';
        
    elseif cons==1 % Orthogonal loadings acc. to Harshman & Lundy 94
        load=ZtX'*(ZtX*ZtX')^(-.5);
        
    elseif cons==2 % Nonnegativity constraint
        load=zeros(size(OldLoad));
        for i=1:dimX
            load(i,:)=fastnnls(ZtZ,ZtX(:,i))';
            %       if min(load(i,:))<-eps*1000
            %          load(i,:)=OldLoad(i,:);
            %       end
        end
        
    elseif cons==3 % Unimodality & NNLS
        load=OldLoad;
        F=size(OldLoad,2);        
        if F>1
            for i=1:F
                ztz=ZtZ(i,i);
                ztX=ZtX(i,:)-ZtZ(i,[1:i-1 i+1:F])*load(:,[1:i-1 i+1:F])';
                beta=(pinv(ztz)*ztX)';           
                load(:,i)=ulsr(beta,1);
            end
        else
            beta=(pinv(ZtZ)*ZtX)';
            load=ulsr(beta,1);
        end
    elseif cons==6
        load=OldLoad;
        dim1=size(load,1);
        temp=numel(load(:,1));
        root=roots([1 -1 -2*temp]);
        dim2=root(1);
        H=ones(1,dim2)'*ones(1,dim2)-eye(dim2);
        
        F=size(load,2);
        for i=1:F
            if i==1
                b=load(:,i);
                
                ztz=ZtZ(i,i);
                ztX=ZtX(i,:)-ZtZ(i,[1:i-1 i+1:F])*load(:,[1:i-1 i+1:F])';
                b=(pinv(ztz)*ztX)';
                b=b/max(b);
                B=v2G(b);
                lamda=100000;
                for it=1:200
                    alfa=trace(B^3);
                    bita=trace(B^2*H);
                    trans(it)=alfa/bita;
                    diff_lamda=((trans(it)-1.0));
                    grad_trans=((3*bita*B^2-alfa*(B*H+H*B))/bita^2 ).*H;
                    b=b-0.0001*(0*2*b*(ztz)-0*2*ztX'+lamda*diff_lamda*G2v(grad_trans)');
                    B=v2G(b);
                end
                load(:,i)=b;
            else
                ztz=ZtZ(i,i);
                ztX=ZtX(i,:)-ZtZ(i,[1:i-1 i+1:F])*load(:,[1:i-1 i+1:F])';
                beta=(pinv(ztz)*ztX)';     
                load(:,i)=ulsr(beta,1);
            end
        end
    end
    
    
    
elseif DoWeight
    Z=ZtZ;
    X=ZtX;
    if cons==0 % No constr
        load=OldLoad;
        one=ones(1,size(Z,2));
        for i=1:dimX
            ZW=Z.*(W(i,:).^2'*one);
            %load(i,:)=(pinv(Z'*diag(W(i,:))*Z)*(Z'*diag(W(i,:))*X(i,:)'))';
            load(i,:)=(pinv(ZW'*Z)*(ZW'*X(i,:)'))';
        end
        
    elseif cons==2 % Nonnegativity constraint
        load=OldLoad;
        one=ones(1,size(Z,2));
        for i=1:dimX
            ZW=Z.*(W(i,:).^2'*one);
            load(i,:)=fastnnls(ZW'*Z,ZW'*X(i,:)')';
        end
        
    elseif cons==1
        disp(' Weighted orthogonality not implemented yet')
        disp(' Please contact the authors for further information')
        error
        
    elseif cons==3
        disp(' Weighted unimodality not implemented yet')
        disp(' Please contact the authors for further information')
        error
        
    end
    
end


% Check that NNLS and alike do not intermediately produce columns of only zeros
if cons==2|cons==3
    if any(sum(load)==0)  % If a column becomes only zeros the algorithm gets instable, hence the estimate is weighted with the prior estimate. This should circumvent numerical problems during the iterations
        load = .9*load+.1*OldLoad;
    end
end