bs=[0 1 2 5];
%digits(3);
for si=1:10
    for j=1:4
        FPRtable{si,j}=round([cs{si}.out.fpr.sav(:,j)';cs{si}.out.fpr.pro(:,j)']*100)/100;
        a=num2cell(FPRtable{si,j});b=cell(2,1);c=[b a];c{1}='sav';c{2}='nrow';
        for i = 1:numel(c);c{i}=num2str(c{i});end;
        d={'#trials','1','2','3','4','5','6','7','8','9'};e=[d' c']';
        s=sym(e,'d');latex_table1{si,j}=latex(s);
        latex_table1{si,j}=['fpr/bs-' num2str(bs(j)) ':' '$' latex_table1{si,j} '$'];
        
        TPRtable{si,j}=round([cs{si}.out.tpr.sav(:,j)';cs{si}.out.tpr.pro(:,j)']*100)/100;
        a=num2cell(TPRtable{si,j});b=cell(2,1);c=[b a];c{1}='sav';c{2}='nrow';
        d={'#trials','1','2','3','4','5','6','7','8','9'};e=[d' c']';
        for i = 1:numel(e);e{i}=num2str(e{i});end;
        s=sym(e,'d');latex_table2{si,j}=latex(s);
        latex_table2{si,j}=['tpr/bs-' num2str(bs(j)) ':' '$' latex_table2{si,j} '$'];
    end
    subject_fpr{si}=[latex_table1{si,1} ' \\ ' latex_table1{si,2} ' \\ ' latex_table1{si,3} ' \\ ' latex_table1{si,4}  ];
    subject_tpr{si}=[latex_table2{si,1} ' \\ ' latex_table2{si,2} ' \\ ' latex_table2{si,3} ' \\ ' latex_table2{si,4}  ];
    %subject_full{si}=[subject_fpr{si} ' \newline ' subject_tpr{si} ' \newline ' ];
    subject_full{si}=[latex_table1{si,1} '\\' latex_table2{si,1} '\\'...
        latex_table1{si,2} '\\' latex_table2{si,2} '\\'...
        latex_table1{si,3} '\\' latex_table2{si,3} '\\'...
        latex_table1{si,4} '\\' latex_table2{si,4} '\\'];
end

A=zeros(2,9,4);
for i=1:10
    for j=1:4
        
        A(:,:,j)=A(:,:,j)+FPRtable{i,j};
        
    end
end
A=A/10;

B=zeros(2,9,4);
for i=1:10
    for j=1:4
        
        B(:,:,j)=B(:,:,j)+TPRtable{i,j};
        
    end
end
B=B/10;

for j=1:4
a=num2cell(A(:,:,j));b=cell(2,1);c=[b a];c{1}='sav';c{2}='nrow';
for i = 1:numel(c);c{i}=num2str(c{i});end;
d={'#trials','1','2','3','4','5','6','7','8','9'};e=[d' c']';
s=sym(e,'d');fave{j}=['fpr/bs-' num2str(bs(j)) ':' '$' latex(s) '$'];
end
for j=1:4
a=num2cell(B(:,:,j));b=cell(2,1);c=[b a];c{1}='sav';c{2}='nrow';
for i = 1:numel(c);c{i}=num2str(c{i});end;
d={'#trials','1','2','3','4','5','6','7','8','9'};e=[d' c']';
s=sym(e,'d');tave{j}=['tpr/bs-' num2str(bs(j)) ':' '$' latex(s) '$'];

end