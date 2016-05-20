CAM=[Ciaverage_nirsAMo Ciaverage_nirsAMd Ciaverage_nirsAMf Ciaverage_eegAM Ciaverage_combAMo Ciaverage_combAMd Ciaverage_combAMf];
CAM(end+1,:)=mean(CAM);
C=round(CAM*100)/100;
d=num2cell(C);
for i=1:numel(d);d{i}=num2str(d{i});end;
e={'C4' ,'C6' ,'C7' ,'C8', 'C9' ,'C10' ,'C11','C12','mean'}
f=[e' d];
s=sym(f,'d');
lCAM=latex(s);

CIM=[Ciaverage_nirsIMo Ciaverage_nirsIMd Ciaverage_nirsIMf Ciaverage_eegIM Ciaverage_combIMo Ciaverage_combIMd Ciaverage_combIMf];
CIM(end+1,:)=mean(CIM);
C=round(CIM*100)/100;
d=num2cell(C);
for i=1:numel(d);d{i}=num2str(d{i});end;
e={'C4' ,'C6' ,'C7' ,'C8', 'C9' ,'C10' ,'C11','C12','mean'}
f=[e' d];
s=sym(f,'d');
lCIM=latex(s);

TAM=[Tiaverage_nirsAMo Tiaverage_nirsAMd Tiaverage_nirsAMf Tiaverage_eegAM Tiaverage_combAMo Tiaverage_combAMd Tiaverage_combAMf];
TAM(end+1,:)=mean(TAM);
C=round(TAM*100)/100;
d=num2cell(C);
for i=1:numel(d);d{i}=num2str(d{i});end;
e={'T2' ,'T3' ,'T5', 'T6' , 'T7' ,'T9' ,'T10','mean'}
f=[e' d];
s=sym(f,'d');
lTAM=latex(s);


TIM=[Tiaverage_nirsIMo Tiaverage_nirsIMd Tiaverage_nirsIMf Tiaverage_eegIM Tiaverage_combIMo Tiaverage_combIMd Tiaverage_combIMf];
TIM(end+1,:)=mean(TIM);
C=round(TIM*100)/100;
d=num2cell(C);
for i=1:numel(d);d{i}=num2str(d{i});end;
e={'T2' ,'T3' ,'T5', 'T6' , 'T7' ,'T9' ,'T10','mean'}
f=[e' d];
s=sym(f,'d');
lTIM=latex(s);

