function B=unimodal(X,Y,Bold)

%UNIMODAL unimodal regression
%
% Solves the problem min|Y-XB'| subject to the columns of
% B are unimodal and nonnegative. The algorithm is iterative
% If an estimate of B (Bold) is given only one iteration is given, hence
% the solution is only improving not least squares
% If Bold is not given the least squares solution is estimated
%
% I/O B=unimodal(X,Y,Bold)
%
% Reference
% Bro and Sidiropoulos, "Journal of Chemometrics", 1998, 12, 223-247.



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
% 
% fr=0:40;
% FF=@(x,fr)(x(1)*exp(-(fr-x(2)).^2/x(3)^2));
% x1=[0.5 2];x2=[3 6 10 20];x3=[0.1 2];
% options = optimoptions('lsqcurvefit');
% options.Display='off';
if nargin==3
    B=Bold;
    F=size(B,2);
    for f=1:F
        y=Y-X(:,[1:f-1 f+1:F])*B(:,[1:f-1 f+1:F])';
        beta=pinv(X(:,f))*y;
%         tmp=lsqcurvefit(FF,[1 x2(f) 2]',fr,beta,[x1(1) x2(f)-3 x2(1)],[x1(2) x2(f)+3 x2(2)],options);
%         if f<(F)
%             B(:,f)=FF(tmp,fr)';
%         else
%             B(:,f)=ulsr(beta,1);
%         end
         B(:,f)=ulsr(beta',1);
    end
else
    F=size(X,2);
    maxit=100;
    B=randn(size(Y,2),F);
    Bold=2*B;
    it=0;
    while norm(Bold-B)/norm(B)>1e-5&it<maxit
        Bold=B;
        it=it+1;
        for f=1:F
            y=Y-X(:,[1:f-1 f+1:F])*B(:,[1:f-1 f+1:F])';
            beta=pinv(X(:,f))*y;
%             tmp=lsqcurvefit(FF,[1 x2(f) 2]',fr,beta,[x1(1) x2(f)-3 x2(1)],[x1(2) x2(f)+3 x2(2)],options);
%             if f<(F)
%                 B(:,f)=FF(tmp,fr)';
%             else
%                 B(:,f)=ulsr(beta,1);
%             end
                        B(:,f)=ulsr(beta',1);
        end
    end
    if it==maxit
        disp([' UNIMODAL did not converge in ',num2str(maxit),' iterations']);
    end
end