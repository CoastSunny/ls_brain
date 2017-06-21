
load /home/lspyrou/Documents/masnet/em_terrano/carpark/OutPutTable_of_Earl_Mountbatten_Carpark.mat
Pow_Ray=[];MP=[];
Out_Table=table2array(Output_Table);
Rx_idxs=2;
RayPower_idx=7;
Pow_Ray=zeros(max(Out_Table(:,Rx_idxs)),max(Out_Table(:,6)));
for rx_idx=1:max(Out_Table(:,Rx_idxs))
    
    idx=find(Out_Table(:,Rx_idxs)==rx_idx);
    Pow_Ray(rx_idx,1:numel(Out_Table(idx,RayPower_idx)'))=Out_Table(idx,RayPower_idx)'-30;
    MP(rx_idx)=10*log10(sum(10.^(Pow_Ray(rx_idx,1:numel(Out_Table(idx,RayPower_idx)'))/10)));
    
end



 