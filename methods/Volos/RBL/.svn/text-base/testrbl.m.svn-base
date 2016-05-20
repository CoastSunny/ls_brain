
ERP=0;
for i=1:105
    ERP=ERP+Q.trial{i}(1:2:64,:);
end
ERP=ERP/200;

w=ref*ERP'*inv(ERP*ERP');
