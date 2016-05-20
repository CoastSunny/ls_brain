
time=1:44;

S.default.train_classifier('name','T1T4','classes',{{22};{20}},'time',time,'channels',1:64,'blocks_in',[2 3]);
S.default.train_classifier('name','T4T1','classes',{{22};{20}},'time',time,'channels',1:64,'blocks_in',[5 6]);
nBlocks=length(S.default.paths);


f14=[];
f41=[];

T1T4blocks=cellfun(@(y) ~isempty(y),(cellfun(@(x) strfind(x,'T1T4'),S.default.block_names,'UniformOutput',0)));
T4T1blocks=cellfun(@(y) ~isempty(y),(cellfun(@(x) strfind(x,'T4T1'),S.default.block_names,'UniformOutput',0)));

for i=1:nBlocks
    
    out{i}=S.default.apply_classifier(S.default,...
        'name','T1T4','classes',{{22};{20}},'time',time,'channels',1:64,'blocks_in',i,'target_labels',[-1 +1],'sorti','yes');
    f14=[f14 out{i}.f];
        
end

for i=1:nBlocks
    
    out{i}=S.default.apply_classifier(S.default,...
        'name','T4T1','classes',{{22};{20}},'time',time,'channels',1:64,'blocks_in',i,'target_labels',[-1 +1],'sorti','yes');
    f41=[f41 out{i}.f];
        
end

for i=1:sum(T1T4blocks)

    idx_T1T4=[S.default.block_idx{T1T4blocks}];
    idx_devT1T4=idx_T1T4(2:2:end);

end

for i=1:sum(T4T1blocks)

    idx_T4T1=[S.default.block_idx{T4T1blocks}];
    idx_devT4T1=idx_T4T1(2:2:end);

end

dst=get_stim_info(S.default);

dst=dst(:,2);
dst(:,1)=(dst(:,1));

f_devT1T4=f14(idx_devT1T4);
dst_devT1T4=dst(idx_devT1T4/2,:); %/2 i am so clever

f_devT4T1=f41(idx_devT4T1);
dst_devT4T1=dst(idx_devT4T1/2,:); %/2 i am so clever


b=f_devT1T4';
X0=ones(size(dst_devT1T4,1),1);
X1=[dst_devT1T4 ones(size(dst_devT1T4,1),1)];
X2=abs(X1);

theta0=inv(X0'*X0)*X0'*b;res0=norm(X0*theta0-b);
theta1=inv(X1'*X1)*X1'*b;res1=norm(X1*theta1-b);
theta2=inv(X2'*X2)*X2'*b;res2=norm(X2*theta2-b);
RT1T4=[res0 res1 res2];

% f_devT4T1=f(idx_devT4T1);
% dst_devT4T1=dst(idx_devT4T1/2,:); %/2 i am so clever
% 
% f_devT4T1=f(idx_devT4T1);
% dst_devT4T1=dst(idx_devT4T1/2,:); %/2 i am so clever


b=f_devT4T1';
X0=ones(size(dst_devT4T1,1),1);
X1=[dst_devT4T1 ones(size(dst_devT4T1,1),1)];
X2=abs(X1);


theta0=inv(X0'*X0)*X0'*b;res0=norm(X0*theta0-b);
theta1=inv(X1'*X1)*X1'*b;res1=norm(X1*theta1-b);
theta2=inv(X2'*X2)*X2'*b;res2=norm(X2*theta2-b);
RT4T1=[res0 res1 res2];


b=[f_devT4T1';f_devT1T4'];
X0=ones(size(dst_devT4T1,1)+size(dst_devT1T4,1),1);
X1=[dst_devT4T1 ones(size(dst_devT4T1,1),1);dst_devT1T4 ones(size(dst_devT1T4,1),1)];
X2=abs(X1);
X3=[dst_devT4T1.^2 dst_devT4T1 ones(size(dst_devT4T1,1),1);...
    dst_devT1T4.^2 dst_devT1T4 ones(size(dst_devT1T4,1),1)];
X4=[dst_devT4T1.^3 dst_devT4T1.^2 dst_devT4T1 ones(size(dst_devT4T1,1),1);...
    dst_devT1T4.^3 dst_devT1T4.^2 dst_devT1T4 ones(size(dst_devT1T4,1),1)];
X5=abs(X3);
X6=abs(X4);
theta0=inv(X0'*X0)*X0'*b;res0=norm(X0*theta0-b);
theta1=inv(X1'*X1)*X1'*b;res1=norm(X1*theta1-b);
theta2=inv(X2'*X2)*X2'*b;res2=norm(X2*theta2-b);
theta3=inv(X3'*X3)*X3'*b;res3=norm(X3*theta3-b);
theta4=inv(X4'*X4)*X4'*b;res4=norm(X4*theta4-b);
theta5=inv(X5'*X5)*X5'*b;res5=norm(X5*theta5-b);
theta6=inv(X6'*X6)*X6'*b;res6=norm(X6*theta6-b);
Rfull=[res0 res1 res2 res3 res4 res5 res6];
Rfull-min(Rfull)



