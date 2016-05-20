% trblocks=1;
% exblocks=[2 3];
% code_louk_2jf;
% Res1_in=Res_in;
% Res1_out=Res_out;

figure
bar(mean(Res1_in))
hold
errorbar(mean(Res1_in),std(Res1_in),'ro')
title('1sec windows, validation set')
axis([0 3 0 1]),grid
figure
bar(mean(Res1_out))
hold
errorbar(mean(Res1_out),std(Res1_out),'ro')
title('1sec windows, outer fold')
axis([0 3 0 1]),grid
% trblocks=2;
% exblocks=[1 3];
% code_louk_2jf;
% Res2_in=Res_in;
% Res2_out=Res_out;

figure
bar(mean(Res2_in))
hold
errorbar(mean(Res2_in),std(Res2_in),'ro')
title('3sec 1sec windows, validation set')
axis([0 3 0 1]),grid
figure
bar(mean(Res2_out))
hold
errorbar(mean(Res2_out),std(Res2_out),'ro')
title('3sec 1sec windows, outer fold')
axis([0 3 0 1]),grid
% trblocks=3;
% exblocks=[1 2 ];
% code_louk_2jf;
% Res3_in=Res_in;
% Res3_out=Res_out;

figure
bar(mean(Res3_in))
hold
errorbar(mean(Res3_in),std(Res3_in),'ro')
title('9sec 1sec windows, validation set')
axis([0 3 0 1]),grid
figure
bar(mean(Res3_out))
hold
errorbar(mean(Res3_out),std(Res3_out),'ro')
title('9sec 1sec windows, outer fold')
axis([0 3 0 1]),grid
