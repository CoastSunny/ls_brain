

G=APLO3;
txt='A3_';

%%%%%%%%%%%%%%%%%%%% TRAINING CLASSIFIER VARIOUS DAYS ANALYSIS
%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

members={'d1' 'd2' 'd3'};
initial_no_members=numel(members);

blocks_in=[1:4 9:12 17:20];
time=1:64;
channels=1:64;
target_labels=[-1 +1];

for i=1:initial_no_members
    G.(members{i}).default.train_classifier('name','c1622','classes',{{16};{22}},'blocks_in',blocks_in,'channels',channels,'time',time);
    G.(members{i}).default.train_classifier('name','c1420','classes',{{14};{20}},'blocks_in',blocks_in,'channels',channels,'time',time);
end
try
G.combine_subjects( 'name' , 'd1d2'   , 'exclusion' , {'d3' 'd4' 'd5'}   );
G.combine_subjects( 'name' , 'd1d2d3' , 'exclusion' , {'d4' 'd5' 'd1d2'} );
catch err
G.combine_subjects( 'name' , 'd1d2'   , 'exclusion' , {'d3' 'd4' }   );
G.combine_subjects( 'name' , 'd1d2d3' , 'exclusion' , {'d4' 'd1d2'} );
end
G.d1d2.default.train_classifier('name','c1622','classes',{{16};{22}},'blocks_in',blocks_in,'channels',channels,'time',time);
G.d1d2.default.train_classifier('name','c1420','classes',{{14};{20}},'blocks_in',blocks_in,'channels',channels,'time',time);
G.d1d2d3.default.train_classifier('name','c1622','classes',{{16};{22}},'blocks_in',blocks_in,'channels',channels,'time',time);
G.d1d2d3.default.train_classifier('name','c1420','classes',{{14};{20}},'blocks_in',blocks_in,'channels',channels,'time',time);

Gd12d1=G.d1.default.c1420.res.tstbin(G.d1.default.c1420.res.opt.Ci)+G.d1.default.c1622.res.tstbin(G.d1.default.c1622.res.opt.Ci);
Gd12d1=Gd12d1/2;

members={'d1' 'd2' 'd3' 'd1d2' 'd1d2d3'};
no_members=numel(members);
for i=1:no_members;
    res(i,i).p=0.5*( G.(members{i}).default.c1420.res.tstbin( G.(members{i}).default.c1420.res.opt.Ci) + G.(members{i}).default.c1622.res.tstbin( G.(members{i}).default.c1622.res.opt.Ci) );
end

for i=1:no_members
    for j=1:no_members
        if (i~=j)
            
            tmp1=G.(members{i}).default.apply_classifier( G.(members{j}).default,'name','c1420','classes',{{14};{20}},'target_labels',[-1 +1],'blocks_in',blocks_in,'channels',channels,'time',time);
            tmp2=G.(members{i}).default.apply_classifier( G.(members{j}).default,'name','c1622','classes',{{16};{22}},'target_labels',[-1 +1],'blocks_in',blocks_in,'channels',channels,'time',time);
            tmp3=0.5*(tmp1.rate(3)+tmp2.rate(3));
            res(i,j).p=tmp3;
            
        end
    end
end
% %%%%%%%%%%%%%check balance%%%%%%%%%%%%%%%%
i=1;j=2;
b=-4:0.1:4;
classes1={{14};{20}};
classes2={{16};{22}};
out(i,j).s=check_balance(G.(members{i}),G.(members{j}),'c1420',classes1,target_labels,blocks_in,channels,time);
out(i,j).d=check_balance(G.(members{i}),G.(members{j}),'c1622',classes2,target_labels,blocks_in,channels,time);
i=1;j=3;
classes1={{14};{20}};
classes2={{16};{22}};
out(i,j).s=check_balance(G.(members{i}),G.(members{j}),'c1420',classes1,target_labels,blocks_in,channels,time);
out(i,j).d=check_balance(G.(members{i}),G.(members{j}),'c1622',classes2,target_labels,blocks_in,channels,time);

figure, hold, plot(b,out(1,2).s.c1_rate,'r'),plot(b,out(1,2).s.c2_rate,'g'),plot(b,out(1,3).s.c1_rate,'r--'),plot(b,out(1,3).s.c2_rate,'g--'),plot(G.d1.default.c1420.b,res(1,1).p ,'bo')
legend({'standard class d2' 'deviant class d2' 'standard class d3' 'deviant class d3' 'initial std clsfr'},'Location','SouthEast')
title('what happens when we apply the standards trained classifier on other days')
xlabel('classifier bias');ylabel('class specific rate')
%saveaspdf(gcf,[txt 'baldaystd'],'closef')
figure, hold, plot(b,out(1,2).d.c1_rate,'r'),plot(b,out(1,2).d.c2_rate,'g'),plot(b,out(1,3).d.c1_rate,'r--'),plot(b,out(1,3).d.c2_rate,'g--'),plot(G.d1.default.c1622.b,res(1,1).p ,'bo')
legend({'standard class d2' 'deviant class d2' 'standard class d3' 'deviant class d3' 'initial dev clsfr'},'Location','SouthEast')
title('what happens when we apply the deviants trained classifier on other days')
xlabel('classifier bias');ylabel('class specific rate')
%saveaspdf(gcf,[txt 'baldaydev'],'closef')
%%%%%%%%%%%%%%%%%%%% TRAINING CLASSIFIER VARIOUS DAYS ANALYSIS
%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PRINCIPAL COMPONENTS CLASSIFIER VOLOS%%%%%%%%%%%%%%%%%%%%%%%%
ti=(1:64);
tinterest=13:21;
for i=1:no_members

    [U S Vd]=svd(G.(members{i}).default.c1622.W);
    if ( abs(max(Vd(tinterest,1)))>abs(min(Vd(tinterest,1))) && max(Vd(tinterest,1))>0 );Vd(:,1)=-Vd(:,1);end;
    V(i).Vd=Vd(ti,1);
    [U S Vs]=svd(G.(members{i}).default.c1420.W);
    if ( abs(max(Vs(tinterest,1)))>abs(min(Vs(tinterest,1))) && max(Vs(tinterest,1))>0 );Vs(:,1)=-Vs(:,1);end;
    V(i).Vs=Vs(ti,1);

end
t=ti/128;
figure,hold on,plot(t,V(1).Vs,'r'),plot(t,V(2).Vs,'g'),plot(t,V(3).Vs,'b'),plot(t,V(4).Vs,'m'),plot(t,V(5).Vs,'y')
title('standards classifier principal components');xlabel('time');ylabel('weights');legend({'day1' 'day2' 'day3' 'day12' 'day123'},'Location','SouthEast')
%saveaspdf(gcf,[txt 'pcdaystd'],'closef')
figure,hold on,plot(t,V(1).Vd,'r'),plot(t,V(2).Vd,'g'),plot(t,V(3).Vd,'b'),plot(t,V(4).Vd,'m'),plot(t,V(5).Vd,'y')
title('deviants classifier principal components');xlabel('time');ylabel('weights');legend({'day1' 'day2' 'day3' 'day12' 'day123'},'Location','SouthEast')
%saveaspdf(gcf,[txt 'pcdaydev'],'closef')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        CHECK BALANCE FOR DEVIANTS -> STANDARD CLASSIFIER%%%%%%%%%%%%%%%%%%%%%%%%
i=1;j=2;
classes={{14};{20}};
target_labels=[-1 +1];
blocks_in=[1:4 9:12 17:20];
out2(i,j).s=check_balance(G.(members{i}),G.(members{j}),'c1622',classes,target_labels,blocks_in,channels,time);
figure, hold, plot(b,out2(i,j).s.c1_rate,'r'),plot(b,out2(i,j).s.c2_rate,'g'),plot(G.d1.default.c1622.b,res(1,1).p ,'bo')
legend({'standard class d2' 'deviant class d2' 'initial dev clsfr'},'Location','SouthEast'),title('what happens when we apply the deviant trained classifier on the standard')
xlabel('classifier bias');ylabel('class specific rate')
%saveaspdf(gcf,[txt 'balcrossd2'],'closef')
i=1;j=3;
classes={{14};{20}};
target_labels=[-1 +1];
blocks_in=[1:4 9:12 17:20];
out2(i,j).s=check_balance(G.(members{i}),G.(members{j}),'c1622',classes,target_labels,blocks_in,channels,time);
figure, hold, plot(b,out2(i,j).s.c1_rate,'r'),plot(b,out2(i,j).s.c2_rate,'g'),plot(G.d1.default.c1622.b,res(1,1).p ,'bo')
legend({'standard class d3' 'deviant class d3' 'initial dev clsfr'},'Location','SouthEast'),title('what happens when we apply the deviant trained classifier on the standard')
xlabel('classifier bias');ylabel('class specific rate')
%saveaspdf(gcf,[txt 'balcrossd3'],'closef')

%%%%%%%%%%%% day 4 and 5 %%%%%%%%%%%
members={'d1d2d3' 'd4'};
i=1;j=2;
tmp1= G.(members{i}).default.apply_classifier( G.(members{j}).default,'name','c1420','classes',{{14}},'target_labels',[-1],'blocks_in',blocks_in,'channels',channels,'time',time);
try
    tmp2= G.(members{i}).default.apply_classifier( G.(members{j}).default,'name','c1622','classes',{{22}},'target_labels',[+1],'blocks_in',blocks_in,'channels',channels,'time',time);
    tmp3= 0.5*(tmp1.rate + tmp2.rate );
    res2(i,j).pb=tmp3;
catch err
end
tmp4= G.(members{i}).default.apply_classifier( G.(members{j}).default,'name','c1622','classes',{{21}},'target_labels',[+1],'blocks_in',blocks_in,'channels',channels,'time',time);

tmp5= 0.5*(tmp1.rate + tmp4.rate );
res2(i,j).ps=tmp5;

i=1;j=3;
tmp1= G.(members{i}).default.apply_classifier( G.(members{j}).default,'name','c1420','classes',{{14}},'target_labels',[-1],'blocks_in',blocks_in,'channels',channels,'time',time);
tmp2= G.(members{i}).default.apply_classifier( G.(members{j}).default,'name','c1622','classes',{{22}},'target_labels',[+1],'blocks_in',blocks_in,'channels',channels,'time',time);
tmp3= 0.5*(tmp1.rate + tmp2.rate );
res2(i,j).pb=tmp3;
tmp4= G.(members{i}).default.apply_classifier( G.(members{j}).default,'name','c1622','classes',{{21}},'target_labels',[+1],'blocks_in',blocks_in,'channels',channels,'time',time);
tmp5= 0.5*(tmp1.rate + tmp4.rate );
res2(i,j).ps=tmp5;
