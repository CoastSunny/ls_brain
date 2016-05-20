template=mean(spike,1);
%template=C(1,:);
wopt=[];
Res=[];
template=spike(1,:);
%Res=zeros(size(X,2)-l,431);

for i=1:1:size(X,2)-l
    %tic
    sY=X(sEEG_idx,i:i+l-1);
    for ii=1:18
        tmp(ii)=norm(sY(ii,:));
    end
    sY=repop(sY,'/',tmp(10)');
   % sY(end+1,:)=ones(1,size(sY,2));
    iY=X(iEEG_idx,i:i+l-1);
     for j=1:size(spikes,2)
        template=spike(j,:);
       % l=length(template);
        template=template-mean(template);
        template=template/norm(template);
        %wopt=inv(sY*sY'+300*eye(size(sY,1)))*sY*template';
        wopt=(sY*sY'+1*eye(size(sY,1)))\(sY*template');
        %Res(i,j)=norm(wopt'*sY-template);
        Res(i,j)=norm(wopt'*sY-template);
        %     sY=repop(sY,'-',mean(sY,2));
        %     iY=repop(iY,'-',mean(iY,2));
        %     [A,B,R]=canoncorr(sY',iY');
        %     C(i,:)=R;        
    end
   % toc
end