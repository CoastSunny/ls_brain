%%
% clear all;
% close all;
% clc;


sigma_val = [0.05:0.001:0.09];


load ('new_D2.mat')

load ('O_T.mat')

load ('A')

data=zeros(2,200);

data(1,:)=O_T(28,73.5*200+1:74.5*200);

data(1,:)=data(1,:)-mean(data(1,:));
data(1,:)=data(1,:)/norm(data(1,:));

data(2,:)=A;
data(2,:)=data(2,:)/norm(data(2,:));
data(2,:)=data(2,:)-mean(data(2,:));

figure
    for i=1:2
        subplot(2,1,i)
        plot(data(i,:))
        title('original sources')
    end

denoised_signal=remove_baseline_filtfilt(data(1,:),70,'low');
denoised_signal=remove_baseline_filtfilt(denoised_signal,10,'high');
data(1,:)=denoised_signal;

%plot original sources
    figure
    for i=1:2
        subplot(2,1,i)
        plot(data(i,:))
        title('baseline removed original sources')
    end

% data2=data(:,65:135);

% data2(1,:)=data2(1,:)-mean(data2(1,:));
% data2(1,:)=data2(1,:)/norm(data2(1,:));

%[data3]=smooth_data(9,data2);

    %plot original sources 70 samples
%     figure
%     for i=1:2
%         subplot(2,1,i)
%         plot(data2(i,:))
%         title('70 sample original sources')
%     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mixtures=O_T(1:18,73.5*200+1:74.5*200);

%smoohing each channel one by one by averaging
[mixtures]=smooth_data(9,mixtures);

%plot scalp mixtures
    figure
    for i=1:18
        subplot(9,2,i)
        plot(mixtures(i,:))
        title(strcat('scalp mixtures',int2str(i)))
    end
    
Y1=mixtures;

    figure
    for i=1:size(Y1,1)
        subplot(size(Y1,1)/2,2,i)
        plot(Y1(i,:))
        title(strcat('Chosen IC',int2str(i)))
    end

% [IC,A1,W1]=fastica(Y1,'approach','symm','numOfIC',size(Y1,1),'epsilon',0.0001);
%     figure 
%     for i=1:size(IC,1)
%         subplot(size(IC,1)/2,2,i)
%         plot(IC(i,:))
%         title(strcat('IC',int2str(i)));
%     
%     end


D=new_D2';
% NbSources=1;
NbSources=2;
% NbSources=4;

    
    [y1,y2]=size(Y1);
    [d1,d2]=size(D);
   
    patchsz=d1;
    y_v=reshape(Y1,[1 y1*y2]);
    
    %Calculating Number of Patches
    %no patches
%     NbPatches=NbSources;
    %considering patches 50% overlap
    NbPatches=floor(2*NbSources*y2/patchsz-1);
    %considering patches max overlap
%     NbPatches=NbSources*y2-patchsz-1
    
    Patches=zeros(patchsz,NbSources*y2,NbPatches);
    const=sqrt(1.15);
    sparsel=2;
      
    %adding dictionary members (patchsz+10)=81 members
    %cosine initialization
    for k=0:1:patchsz+10
        V=cos([0:1:patchsz-1]*k*pi/(patchsz+10));
        if k>0, V=V-mean(V); end;
        D2(:,k+1)=V/norm(V);
    end


      for i=1:NbPatches
        for j=1:patchsz
            %no patches
%             Patches(j,(i-1)*patchsz+j,i)=1;
            %considering patches
            Patches(j,(i-1)*floor(patchsz/2)+j,i)=1;
        end
      end
    
       
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    M=200;
    
    [d3,d4]=size(D2);
    miu=sqrt((d4-d3)/(d3*(d4-1)))+1;
    n_itr=20;

    sigmavalues=-ones(1,length(sigma_val));
    summation1=0;
    summation2=0;
    
    A2 = colnorm(y1,NbSources);
    X=A2'*Y1;
    x_v=reshape(X,[1 prod(size(X))]);
    
%     conv=zeros(length(sigma_val),M);
%     conv1=zeros(length(sigma_val),M);
%     conv2=zeros(length(sigma_val),M);
%     conv3=zeros(length(sigma_val),M);
    

ii_array_zerocheck=zeros(1,length(sigma_val));
ii_array_infcheck=zeros(1,length(sigma_val));

for c = 1:length(sigma_val)
    
    
    A2 = colnorm(y1,NbSources);
    X=A2'*Y1;

  
    sigma_v=sigma_val(c);
    sigma=3*sigma_v;
    delta_sigma=(sigma-sigma_v)/M;    
       
    for ii=1:M
        
        ii_array(c)=ii
        
        lambda=30;
        
        for j = 1:size(D,2)
            D(:,j) = D(:,j)/norm(D(:,j));
        end
    
        for j = 1:size(D2,2)
            D2(:,j) = D2(:,j)/norm(D2(:,j));
        end

        S=update_S(D, (sigma*const*patchsz), Patches, X)
        
       

        S2=update_S(D2, (sigma*const*patchsz), Patches, X)
        
        
        
        [D2,S2]=update_D(Patches,X,S2,D2);
        
        S1=[S S2];

        D2=decorrelation_rotation(Patches,X,D2,S2,miu,n_itr,NbSources,y2);
        
        %using corrcoef
%         [D2,noatoms,location1]=dictionary_corr_compare(D,D2,patchsz);

        %using xcorr
        [D2,noatoms,location,location1,max_corr]=dictionary_corr_compare2(D,D2,patchsz);
       
        
        D1=[D D2];
        
        
        
%%     
        X=update_X(A2,D1,NbSources,y2,y_v,Patches,S1,lambda);

        A2=update_A(Y1,X);    
        
%%

        sigma=sigma-delta_sigma;

        
        if sum(S2)== 0
           'zerocheck'
            if(ii>7)
%             sigmavalues=[sigmavalues sigma_val(c)];
%             sigmavalues=[sigmavalues c];
            sigmavalues(c)=c;
            ii_array_zerocheck(c)=ii;
            end
            break;    
        
        elseif length(find(S2~=0))>30
            'infcheck'
%             sigmavalues=[sigmavalues sigma_val(c)];
%             sigmavalues=[sigmavalues c];
            sigmavalues(c)=c;
            ii_array_infcheck(c)=ii;         
            
            break;
        end
        


        %convergence check
        %% 
        %norm 0
%         for a=1:size(Patches,3)
%             summation1=summation1+calculate_normzero(S(a,:));
%         end
        %norm 1
        
        %%%%%%%%%%%%%%%%%%%%%%%%x_v added here%%%%%%%%%%%%%%%%%%%%%%%%%
%         x_v=reshape(X,[1 prod(size(X))]);
%         
%         for a=1:size(Patches,3)
%             summation1=summation1+norm(S1(a,:),1);
%         end
%         for b=1:size(Patches,3)
%             summation2=summation2+(norm(D1*S1(b,:)'-Patches(:,:,b)*x_v'))^2;
%         end
%         conv1(c,i)=lambda*(norm((y_v'-kron(eye(y2),A2)*x_v'),2))^2;
%         conv2(c,i)=summation1;
%         conv3(c,i)=summation2;
%         
%         conv(c,i)=lambda*(norm((y_v'-kron(eye(y2),A2)*x_v'),2))^2+summation1+summation2;
      
%         conv=lambda*(norm((y_v'-kron(eye(y2),A)*x_v'),2))^2+summation1+summation2;
        
        %define stopping criterion...error less than 0.01
%         if i>7
%             if abs(conv(c,i)-conv(c,i-1))/abs(conv(c,i-1))<0.02
% %             if conv(c,i)>conv(c,i-1)
%                 i_break(c)=i;
%                 sigmavalues(c)=c;
%                 break;
%             end 
%         end
        
    end
    
    S_t{c}=S;
    D_t{c}=D;
    
    S2_t{c}=S2;
    D2_t{c}=D2;
    
    source{c}=X;
    fprintf('iteration - %d\n',c)
    
end
% conv_f=zeros(length(sigma_val),M);
% conv_f(:,2:end)=conv(:,1:M-1);
% conv_f=abs(conv-conv_f)./(abs(conv_f));
% conv_f1=zeros(length(sigma_val),M);
% conv_f1(:,2:end)=conv1(:,1:M-1);
% conv_f1=abs(conv-conv_f1)./(abs(conv_f1));
% conv_f2=zeros(length(sigma_val),M);
% conv_f2(:,2:end)=conv2(:,1:M-1);
% conv_f2=abs(conv-conv_f2)./(abs(conv_f2));
% conv_f3=zeros(length(sigma_val),M);
% conv_f3(:,2:end)=conv3(:,1:M-1);
% conv_f3=abs(conv-conv_f3)./(abs(conv_f3));
sigmavalues_correct=find(sigmavalues==-1);

%% plot sources
%     for k=1:length(sigma_val)
%         figure
%         for i=1:NbSources
%         subplot(NbSources,1,i)
%         plot(source{1, k}(i,:))
%         title(strcat('source',int2str(k),'-',int2str(i)));
%         end
%     end
    
%% find and plot low aplitude sources
    for j=1:length(sigma_val) 
        if (max(max(abs(source{1,j})))<20)
            j1(j)=j;
        end
    end
    
    low_amplitude_sources=find(j1~=0);
    for t=1:length(low_amplitude_sources)
        sources_correct{1,t}=source{1,low_amplitude_sources(t)};
        ind_sources_correct(t)=low_amplitude_sources(t);
    end
    
%     %plot low aplitude sources
    
%     for h=1:length(low_amplitude_sources)
%         figure
%         for i=1:NbSources
%         subplot(NbSources,1,i)
%         plot(source{1, low_amplitude_sources(h)}(i,:))
%         title(strcat('source',int2str(low_amplitude_sources(h)),'-',int2str(i)));
%         end
%     end

