

clear all
close all
load('/Users/louk/MATLAB/classes/jV.mat')
load('/Users/louk/MATLAB/classes/nV.mat')
load('/Users/louk/MATLAB/classes/nSV.mat')
load('/Users/louk/MATLAB/classes/jSV.mat')

jSV(:,end+1)=[mean(jSV(1,:));mean(jSV(2,:));mean(jSV(3,:))];
figure(1),bar(jSV'),axis([0.2 9 0 1]),xlabel('participant');ylabel('ratio');title('JP single');
set(gca,'XTickLabel',{'1','2','3','4','5','6','7','av'}),legend('big','medium','small')
saveas(figure(1),'jSV.jpg');

nSV(:,end+1)=[mean(nSV(1,:));mean(nSV(2,:));mean(nSV(3,:))];
figure(2),bar(nSV'),axis([0.2 10 0 1]);xlabel('participant');ylabel('ratio');title('NL single');
set(gca,'XTickLabel',{'1','2','3','4','5','6','7','8','av'}),legend('big','medium','small')
saveas(figure(2),'nSV.jpg');

jV(:,end+1)=[mean(jV(1,:));mean(jV(2,:));mean(jV(3,:))];
figure(3),bar(jV'),axis([0.2 9 0 1]);xlabel('participant');ylabel('ratio');title('JP multi');
set(gca,'XTickLabel',{'1','2','3','4','5','6','7','av'}),legend('big','medium','small')
saveas(figure(3),'jV.jpg');

nV(:,end+1)=[mean(nV(1,:));mean(nV(2,:));mean(nV(3,:))];
figure(4),bar(nV'),axis([0.2 7 0 1]);xlabel('participant');ylabel('ratio');title('NL multi');
set(gca,'XTickLabel',{'1','2','3','4','5','av'}),legend('big','medium','small')
saveas(figure(4),'nV.jpg');

jSV(:,end)=[];nSV(:,end)=[];jV(:,end)=[];nV(:,end)=[];
A=[mean(jSV')' mean(nSV')' mean(jV')' mean(nV')'];
C=[std(jSV') std(nSV') std(jV') std(nV')];
figure(5),bar(A);,axis([0.2 4 0 1]),legend('JP single','NL single','JP multi','NL multi'),xlabel('contrast'),ylabel('ratio'),hold on
errorbar([1.725 1.9 2.1 2.25 2.75 2.9 3.1 3.25 3.75 3.9 4.1 4.25]-1 ,[A(1,:) A(2,:) A(3,:)],C,-C,'o')
set(gca,'XTickLabel',{'big','medium','small'})
saveas(figure(5),'con.jpg');

figure(6),bar(A');axis([0.2 5 0 1]),legend('big','medium','small'),xlabel('group'),ylabel('ratio')
hold on,B=[std(jSV')' std(nSV')' std(jV')' std(nV')'];
errorbar([0.775 1 1.225 1.775 2 2.225 2.775 3 3.225 3.775 4 4.227] ,[A(:,1)' A(:,2)' A(:,3)' A(:,4)'],B(:),-B(:),'o')
set(gca,'XTickLabel',{'JP single','NL single','JP multi','NL multi'})
saveas(figure(6),'gr.jpg');