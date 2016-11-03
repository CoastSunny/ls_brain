function [load Rpenalty]=pfls_reg(ZtZ,ZtX,G,alpha,dimX,cons,OldLoad,DoWeight,W);

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

Rpenalty=[];
if ~DoWeight
    
    if cons==0 % No constr
        %load=((Z'*Z)\Z'*Xinuse)';
        load=(pinv(ZtZ)*ZtX).';
        
    elseif cons==1 % Orthogonal loadings acc. to Harshman & Lundy 94
        load=ZtX'*(ZtX*ZtX')^(-.5);
        
    elseif cons==2 % Nonnegativity constraint
        load=zeros(size(OldLoad));
        for i=1:dimX
%             load(i,:)=fastnnls(ZtZ,ZtX(:,i))';
             load(i,:)=fastnnls(real(ZtZ),real(ZtX(:,i))).';
%             load(i,:)=real(fastnnls(ZtZ,ZtX(:,i))).';

            %       if min(load(i,:))<-eps*1000
            %          load(i,:)=OldLoad(i,:);
            %       end
        end
        
    elseif cons==3 % Unimodality & NNLS
        load=OldLoad;
        F=size(OldLoad,2);
        if F>1
            for i=1:F
                ztz=real(ZtZ(i,i));
                ztX=real(ZtX(i,:)-ZtZ(i,[1:i-1 i+1:F])*load(:,[1:i-1 i+1:F]).');
                beta=(pinv(ztz)*ztX).';
                load(:,i)=ulsr(beta,1);
            end
        else
            beta=(pinv(ZtZ)*ZtX).';
            load=ulsr(beta,1);
        end
        
    elseif cons==7
        
        %         dim_con=16;
        %         L1=zeros(dim_con);
        ncomps=size(ZtX,1);
        dim_con=size(ZtX,2);
        a=alpha;
        A=kron(ZtZ,eye(dim_con));
        B=0;
        for i=1:5
            S=zeros(ncomps);
            S(i,i)=1;
            
            Dg=diag( ls_network_metric(G{i},'deg'));
            %             Lap=eye(128)-Dg^(-1/2)*G{i}*Dg^(-1/2);
            Lap=Dg-G{i};
            B=B+kron(S,a*Lap);
        end
        C=vec(ZtX.');
%         load=reshape(inv(A+B)*C,dim_con,ncomps);
        load=reshape((A+B)\C,dim_con,ncomps);

        for i=1:ncomps
%             load(:,i)=load(:,i)/norm(load(:,i));
        end
        for i=1:5
            S=zeros(ncomps);
            S(i,i)=1;
            %             Lap=eye(128)-Dg^(-1/2)*G{i}*Dg^(-1/2);
            Lap=Dg-G{i};
            Rpenalty(i)=trace(S*load'*Lap*load*S);
        end
    elseif cons==8
        
        ncomps=size(ZtX,1);
        load=OldLoad;
        F=size(OldLoad,2);
        dim_con=size(ZtX,2);
        a=alpha;
        
        for i=1:F
            if (i<6)
                ztz=ZtZ(i,i);
                ztX=ZtX(i,:)-ZtZ(i,[1:i-1 i+1:F])*load(:,[1:i-1 i+1:F]).';
                A=kron(ztz,eye(dim_con));
                %                 Lap=diag(ls_network_metric(G{i},'deg') )-G{i};
                Dg=diag( ls_network_metric(G{i},'deg'));
                Lap=Dg-G{i};
%                 Lap=eye(128)-Dg^(-1/2)*G{i}*Dg^(-1/2);
                B=kron(1,a*Lap);
                C=vec(ztX.');
                load(:,i)=(inv(A+B)*C);
                %                 load(:,i)=load(:,i)/norm(load(:,i));
                Rpenalty(i)=trace(load(:,i)'*Lap*load(:,i));
            else
                ztz=ZtZ(i,i);
                ztX=ZtX(i,:)-ZtZ(i,[1:i-1 i+1:F])*load(:,[1:i-1 i+1:F]).';
                load(:,i)=(pinv(ztz)*ztX).';
            end
        end
        for i=1:ncomps
%             load(:,i)=load(:,i)/norm(load(:,i));
        end
    elseif cons==9
        load=real(pinv(ZtZ)*ZtX)';
    elseif cons==10
        
        ncomps=size(ZtX,1);
        dim_con=size(ZtX,2);
        a=100;
        A=kron(ZtZ,eye(dim_con));
        Lap=diag( ls_network_metric(G,'deg') )-G;
        B=kron(eye(ncomps),a*Lap);
        C=vec(ZtX');
        load=reshape(inv(A+B)*C,dim_con,ncomps);
        
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