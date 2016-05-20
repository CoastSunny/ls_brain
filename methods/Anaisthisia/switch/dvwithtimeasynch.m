

for si=1:10
    figure,
    subplot(1,2,1),plot(A1csERD{si}(2).out.dv.pos),title(num2str(ADR1o(si,2)))
    subplot(1,2,2),plot(A1csERD{si}(2).out.dv.neg),title(num2str(ADR1o(si,2)))
   % figure,plot(A1csERD{si}(2).out.dv.neg)
    
end