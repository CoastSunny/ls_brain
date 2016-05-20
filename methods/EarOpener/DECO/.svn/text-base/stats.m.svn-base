time=1:307;
fs=512;
% clear hT pT hE pE
% 
% %%% ASxU between language groups
% for j=1:11 %%loop throuh as60u as90u ..
%     
%     JP{j}=[D{1}{j} D{2}{j} D{3}{j} D{4}{j} D{5}{j} D{6}{j}  D{7}{j}  D{8}{j}];
%     EN{j}=[D{9}{j} D{10}{j} D{11}{j} D{12}{j} D{13}{j} D{14}{j} D{15}{j} D{16}{j}];
%     
% %     for i=time
% %         [hT{j}(i) pT{j}(i)]=ttest2(JP{j}(i,:),EN{j}(i,:));
% %     end
%     
% end
% clear JP EN
% %%% ASxU between language groups estimated
% for j=4:6
%     k=j-3;
%     JP{k}=[E{1}{j} E{2}{j} E{3}{j} E{4}{j} E{5}{j}];
%     EN{k}=[E{6}{j} E{7}{j} E{8}{j} E{9}{j} E{10}{j} E{11}{j}];
%     
%     for i=time
%         [hE{k}(i) pE{k}(i)]=ttest2(JP{k}(i,:),EN{k}(i,:));
%     end
%     
% end

%%% a,s_x,u between language groups

%% STATS on individual averages composite sounds %%
A=round([80 100 180]/1000*fs);
S=round([143 163 243]/1000*fs);
U=round([203:30:383 383 383 383 383 ; 223:30:403 403 403 403 403 ; 303:30:483 483 483 483 483]/1000*fs);
samp=3;
for j=1:16
    for i=1:11
        if (i==10)
            S=round([173 193 273]/1000*fs);
            U(:,i)=round([413 433 513]/1000*fs);
        end
%         peak_AP1=max(D{j}{i}(A(1)-samp:A(1)+samp));
%         peak_AN1=min(D{j}{i}(A(2)-samp:A(2)+samp));
%         peak_AP2=max(D{j}{i}(A(3)-samp:A(3)+samp));
%         peak_SP1=max(D{j}{i}(S(1)-samp:S(1)+samp));
%         peak_SN1=min(D{j}{i}(S(2)-samp:S(2)+samp));
%         peak_SP2=max(D{j}{i}(S(3)-samp:S(3)+samp));
%         peak_UP1=max(D{j}{i}(U(1,i)-samp:U(1,i)+samp));
%         peak_UN1=min(D{j}{i}(U(2,i)-samp:U(2,i)+samp));
%         peak_UP2=max(D{j}{i}(U(3,i)-samp:U(3,i)+samp));
%         
        peak_AP1=mean(D{j}{i}(A(1)-samp:A(1)+samp));
        peak_AN1=mean(D{j}{i}(A(2)-samp:A(2)+samp));
        peak_AP2=mean(D{j}{i}(A(3)-samp:A(3)+samp));
        peak_SP1=mean(D{j}{i}(S(1)-samp:S(1)+samp));
        peak_SN1=mean(D{j}{i}(S(2)-samp:S(2)+samp));
        peak_SP2=mean(D{j}{i}(S(3)-samp:S(3)+samp));
        peak_UP1=mean(D{j}{i}(U(1,i)-samp:U(1,i)+samp));
        peak_UN1=mean(D{j}{i}(U(2,i)-samp:U(2,i)+samp));
        peak_UP2=mean(D{j}{i}(U(3,i)-samp:U(3,i)+samp));
        
        Peaks(:,i,j)=[peak_AP1 peak_AN1 peak_AP2 peak_SP1 peak_SN1 peak_SP2 peak_UP1 peak_UN1 peak_UP2];
        
    end
end

amps_column=reshape(Peaks,1,numel(Peaks))';
%pred_column=repmat([11 12 13 21 22 23 31 32 33],1,77)';
pred_column=repmat([11 12 13 21 22 23 31 32 33],1,numel(subjects)*11)';
subj_column=repmat(1:numel(subjects),11*9,1);
subj_column=subj_column(:);
which_column=repmat([60 90 120 150 180 210 240 241 242 243 250],9,1);
which_column=which_column(:);
which_column=repmat(which_column,numel(subjects),1);
TABLEampav=[amps_column which_column pred_column subj_column];

%% STATS on individual averages individual sounds %%

% ACC=round([80 100 180]/1000*128);
% 
% for j=1:11
%     for i=1:5
%         
%         peak_P1=sources{j}{i}.avg(ACC(1));
%         peak_N1=sources{j}{i}.avg(ACC(2));
%         peak_P2=sources{j}{i}.avg(ACC(3));        
%         
%         Peaks_indi(:,i,j)=[peak_P1 peak_N1 peak_P2];
%         
%     end
% end
% amps_column=reshape(Peaks_indi,1,numel(Peaks_indi))';
% pred_column=repmat([1 2 3],1,55)';
% subj_column=repmat([1 2 3 4 5 6 7 8 9 10 11],15,1);
% subj_column=subj_column(:);
% which_column=repmat([1 2 3 4 5],3,1);
% which_column=which_column(:);
% which_column=repmat(which_column,11,1);
% TABLEampav_indi=[amps_column which_column pred_column subj_column];

