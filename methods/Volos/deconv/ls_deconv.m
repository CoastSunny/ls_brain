function [ERP Z DA DB l]=ls_deconv(q,AV)
l=length(AV);
parfor i=1:length(q)
    
    fprintf(num2str(i));
    Da(i).a = diag( ones( 1 , l - q( i ) ) , q( i ) );
    Db(i).a = diag( ones( 1 , l - q( i ) ) , -q( i ) );

end
DA=zeros(l);
DB=zeros(l);
fprintf('\n hello \n');

parfor i=1:length(q)
    
    fprintf(num2str(i));
    DA=DA+Da(i).a;
    DB=DB+Db(i).a;
    
end
N=length(q)+1;
ERP=AV/(N*eye(l)+DA+DB);
fprintf('\n hello \n');
Z=ERP*(N*eye(l)+DA+DB);
figure,plot(AV/norm(AV)),hold on,plot(ERP/norm(ERP),'r'),plot(Z/norm(Z),'g')
end