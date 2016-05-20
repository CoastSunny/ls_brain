
for tp_index=1:numel(tp_test)
    
    tp=tp_test(tp_index);    
    empirical=0;method=2;
    embc
    rtmp(1)=R(actual_fpr_idx,end);
    rtmp(3)=R(actual_tpr_idx,end);
    rtmp(4)=R(mod_tpr_idx,end);
    empirical=1;method=2;
    embc
    rtmp(2)=R(actual_fpr_idx,end);
    rtmp(5)=R(actual_tpr_idx,end);
    rtmp(6)=R(emp_tpr_idx,end);
    r(tp_index,:)=[rtmp(1) rtmp(2) rtmp(3) rtmp(4) rtmp(5) rtmp(6)];

end
R=[r tp_test'];
