sel2start=19;
sel2=144;

for jj=1:10;
    if jj==1;
        sel1=48;%48
    elseif jj==4
        sel1=56;%56
    else
        sel1=60;%60
    end    
    [hp(jj,:) pp(jj,:)]=kstest((FpL{jj}(1:sel1)-mean(FpL{jj}(1:sel1)))/std(FpL{jj}(1:sel1)));
    [hn(jj,:) pn(jj,:)]=kstest((FnL{jj}(1:sel1)-mean(FnL{jj}(1:sel1)))/std(FnL{jj}(1:sel1)));

end
for jj=11:20
    [hp(jj,:) pp(jj,:)]=kstest((Fp{jj-10}(sel2start:sel2)-mean(Fp{jj-10}(sel2start:sel2)))/std(Fp{jj-10}(sel2start:sel2)));
    [hn(jj,:) pn(jj,:)]=kstest((Fn{jj-10}(sel2start:sel2)-mean(Fn{jj-10}(sel2start:sel2)))/std(Fn{jj-10}(sel2start:sel2)));
end
