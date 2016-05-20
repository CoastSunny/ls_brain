figure
bar(mean(bal_Res_in))
hold
errorbar(mean(bal_Res_in),std(bal_Res_in),'ro')
title('Inner fold, validation set')

figure
bar(mean(bal_Res_out))
hold
errorbar(mean(bal_Res_out),std(bal_Res_out),'ro')
title('Outer fold, balanced')

figure
bar(mean(cr_Res_out))
hold
errorbar(mean(cr_Res_out),std(cr_Res_out),'ro')
title('Outer fold, calibrated')