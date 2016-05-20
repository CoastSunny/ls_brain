
declims=[0 1];

out1=calperf(A1csERD,'out','dec');
out2=calperf(A2csERD,'out','dec');
out3=calperf(A3csERD,'out','dec');

figure,
subplot(1,3,1),imagesc(out1.tpr{2}),colorbar,caxis(declims)
xlabel('number of combined trials'),ylabel('FPR')
subplot(1,3,2),imagesc(out2.tpr{2}),colorbar,caxis(declims)
xlabel('number of combined trials'),ylabel('FPR')
subplot(1,3,3),imagesc(out3.tpr{2}),colorbar,caxis(declims)
xlabel('number of combined trials'),ylabel('FPR')

out1=calperf(A1csERD,'out','dec2');
out2=calperf(A2csERD,'out','dec2');
out3=calperf(A3csERD,'out','dec2');

figure,
subplot(1,3,1),imagesc(out1.tpr{2})
xlabel('number of combined trials'),ylabel('FPR')
subplot(1,3,2),imagesc(out2.tpr{2}),colorbar,caxis(declims)
xlabel('number of combined trials'),ylabel('FPR')
subplot(1,3,3),imagesc(out3.tpr{2}),colorbar,caxis(declims)
xlabel('number of combined trials'),ylabel('FPR')

for si=1:10
   
    figure,imagesc(out1.indi_tpr{si}{2}),colorbar,caxis(declims),title(num2str(ADR1i(si,2)))
    
end