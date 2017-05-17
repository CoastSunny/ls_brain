clear all
clc
%% The model of ULA observation matrix
% parameters
DoA=50;
rad=DoA.*pi/180;
N=10;       % # of elements in ULA
M=length(DoA);        % # of source signals
K=1000;     % # of samples 
d=0.5;      % element spacing 
SNR=10; % signal SNRs
stdn=sqrt(10.^(-SNR/10));
% steering vectors
for k=1:N
    for w=1:M
        A(k,w)=exp(-1j*2*pi*0.5*(k-1)*sind(DoA(w))).';
    end
end
S=zeros(M,K);    % source signals
for w=1:M
    S(w,:)=stdn(w)*randn(1,K)+1j*stdn(w)*randn(1,K);
end
n=sqrt(0.5)*(randn(N,K)+1j*randn(N,K));  % noise 
X=A*S+n;


R = zeros(N,N);
for iK = 1:K
    R = R+X(:,iK)*X(:,iK)';
end
R = (1/K)*R;

%% MUSIC algorithm

[q,lambda]=eig(R);  % q- eigenvector of R, lambda- eigenvalue of R
[E,Idx] = sort(diag(lambda),'descend'); % order eigen values descendingly
Qs=q(:,Idx(1:M));        % signal space 
Qn=q(:,Idx(M+1:N));      % noise space
angle=[-90:0.1:90];


for i=1:length(angle)
    phi(i)=angle(i)*pi/180;
    for k=1:N
        a_mu(k,i)=exp(-1j*2*pi*d*(k-1)*sin(phi(i))).';
    end
    Pmu(i)=1./(abs(a_mu(:,i)'*(Qn*Qn')*a_mu(:,i)));
end
for i=1:length(angle)
    phi(i)=angle(i)*pi/180;
    for k=1:N
        a_bar(k,i)=exp(-1j*2*pi*d*(k-1)*sin(phi(i))).';
    end
     Pbar(i) = abs(a_bar(:,i)'*R*a_bar(:,i));

end
figure
plot(angle,10*log10(Pmu),'r'); hold on 
plot(angle,10*log10(Pbar),'b'); hold off
[v,id]=sort(10*log10(Pmu),'descend');
angle_est =  angle(id(1:length(DoA)));
[~,id_bar] = max(10*log10(Pbar));
angle_bar_est = angle(id_bar);





