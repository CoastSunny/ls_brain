i=10;j=3;
figure,subplot(2,3,1),plot(RESconv{i,j}{9}{1},'Linewidth',2),title('degree')
subplot(2,3,2),plot(RESconv{i,j}{8}{1},'Linewidth',2),title('clustering')
subplot(2,3,3),plot(RESconv{i,j}{11}{1},'Linewidth',2),title('transitivity')
subplot(2,3,4),plot(RESconv{i,j}{10}{1},'Linewidth',2),title('neighb degree')
subplot(2,3,5),plot(RESconv{i,j}{12}{1},'Linewidth',2),title('all')


% figure,subplot(2,3,1),plot(mean(RESconv{i,j}{19}{1}{1})),title('degree')
% subplot(2,3,2),plot(RESconv{i,j}{18}{1}),title('clustering')
% subplot(2,3,3),plot(RESconv{i,j}{21}{1}),title('transitivity')
% subplot(2,3,4),plot(RESconv{i,j}{20}{1}),title('neighb degree')
% subplot(2,3,5),plot(RESconv{i,j}{22}{1}),title('all')
