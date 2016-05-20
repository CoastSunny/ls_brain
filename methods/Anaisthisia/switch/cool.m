% clear res
% mp=1;sp=1;mn=-1;sn=1;
% N=2;
% blah=1:0.01:10;
% for i=1:numel(blah)
% 
%     out=checkmethod(mp,sp,mn,sn*blah(i),N,0.6);
%     res(i)=out.tpr_sav/out.tpr_nrow;
%     
% end
    

out=checkmethod(mp,sp,mn,sn,2,0.01)
% figure,hold on,plot(out.x,out.PSCDF,'k','Linewidth',3),plot(out.x,out.PNCDF,'r','Linewidth',3)
% plot(out.x,out.NSCDF,'k-.','Linewidth',3),plot(out.x,out.NNCDF,'r-.','Linewidth',3)
% plot(out.x,out.PCDF,'k:','Linewidth',3),plot(out.x,out.NCDF,'r:','Linewidth',3)


% clear cdiff1 cdiff2
% 
% for i=1:numel(out.NNCDF)
%     temp=find(out.NSCDF<=out.NNCDF(i));
%     if (~isempty(temp) )
%         cdiff1(i)=out.x(temp(1))-out.x(i);
%     else 
%         cdiff1(i)=NaN;
%     end
% end
% 
% for i=1:numel(out.PNCDF)
%     temp=find(out.PSCDF<=out.PNCDF(i));
%     if (~isempty(temp) )
%         cdiff2(i)=out.x(temp(1))-out.x(i);
%     else 
%         cdiff2(i)=NaN;
%     end
% end
% 
% figure,plot(out.x,cdiff1-cdiff2)
% d=cdiff1-cdiff2;
