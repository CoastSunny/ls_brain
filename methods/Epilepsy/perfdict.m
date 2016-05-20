figure,hold on
temp_ours=(DN(:,2)-DN(:,1))./DN(:,2)*100;
plot(temp_ours,'r-.')
temp_ref=(DN(:,2)-DN(:,3))./DN(:,2)*100;
plot(temp_ref,':')
TEMP=[temp_ours';temp_ref'];