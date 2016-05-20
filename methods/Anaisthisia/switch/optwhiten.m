timeperiod={{[0 250 2750 3000]} {[3000 3250 5750 6000]}};
%timeperiod={{[0 250 3750 4000]} {[4000 4250 5750 6000]}};

labels={'3sec'};
nomove='NO3';
immove='IM3';
ammove='AM3';
n_con_ex=4;
clear dm Res_in Res_out
%tr=6;
mt2=9;
mn2=1;
m2=4;
t2='all';
%1->louk single trial,2->jason single trial,3->jason+boris with forget on
%the data though,4->j+b with forget on cov matrices
method=4;
L=0;
trdim=3;
time_window=1:897;
T=22;
lc=0:1:10;
hc=1:1:30;
wRes=[];

for ilc=1:numel(lc);
    for ihc=1:numel(hc);
        if(hc(ihc)>lc(ilc))
            freqband=[lc(ilc) hc(ihc)];
            timeperiod={{[0 250 2750 3000]} {[3000 3250 5750 6000]}};
            %timeperiod={{[0 250 3750 4000]} {[4000 4250 5750 6000]}};
            labels={'3sec'};
            nomove='NO3';
            immove='IM3';
            ammove='AM3';
            n_con_ex=4;
            code_louk_2_gen
            code_louk_justdata2
            wRes(:,:,end+1)=[r1(:,3) r2(:,3)];
        end
    end
end

