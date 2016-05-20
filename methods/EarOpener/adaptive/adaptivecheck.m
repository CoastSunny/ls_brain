S=APLO3.copy;
classes={{14};{20}};
channels=1:64;
S.d1.default.train_classifier('Cs',[],'nfolds',10,'name','normal','classes',classes,'blocks_in',[1:4],'time',1:64,'channels',channels,'objFn','train_cg_con','freqband',[0.5 13]);
S.d2.default.train_classifier('Cs',[],'nfolds',10,'name','normal','classes',classes,'blocks_in',[1:4],'time',1:64,'channels',channels,'objFn','train_cg_con','freqband',[0.5 13]);
W1=S.d1.default.normal.W;
W2=S.d2.default.normal.W;
%W1=randn(64,64);
clear A B C
n_trials=80;
Cs=[10:0.5:0.5];
%Cs=[400:-10:1 ]*5000;
for i=1:50
    
    a=randperm(300);b=randperm(300)+300;
    tr_st=a(1:n_trials);tr_dev=b(1:n_trials);
    ts_st=a(n_trials+1:end);ts_dev=b(n_trials+1:end);
    %% add full training
    %% rfe as same session preproc
    S.d2.default.train_classifier('classes',classes,'blocks_in',[1:4],...
        'time',1:64,'channels',channels,'objFn','train_cg_con',...
        'w_template',W1,'name','transfer','trials',[tr_st tr_dev],'Cs',Cs,'nfolds',4,'Cscale',1);
    
    S.d3.default.train_classifier('classes',classes,'blocks_in',[1:4],...
        'time',1:64,'channels',channels,'objFn','train_cg_con',...
        'w_template',W2,'name','transfer','trials',[tr_st tr_dev],'Cs',Cs,'nfolds',4,'Cscale',1);
    
%     S.d2.default.train_classifier('classes',classes,'blocks_in',[1:4],...
%         'time',1:64,'channels',channels,'objFn','train_cg_con',...
%         'w_template',[],'name','small','trials',[tr_st tr_dev],'Cs',[],'nfolds',5);
%     
%     S.d3.default.train_classifier('classes',classes,'blocks_in',[1:4],...
%         'time',1:64,'channels',channels,'objFn','train_cg_con',...
%         'w_template',[],'name','small','trials',[tr_st tr_dev],'Cs',[],'nfolds',5);
    
    out12n=S.d1.default.apply_classifier(S.d2.default,...
        'trials',[ts_st ts_dev],'name','normal','classes',classes,'blocks_in',1:4,'time',1:64,'channels',channels);
    out13n=S.d1.default.apply_classifier(S.d3.default,...
        'trials',[ts_st ts_dev],'name','normal','classes',classes,'blocks_in',1:4,'time',1:64,'channels',channels);
    out23n=S.d2.default.apply_classifier(S.d3.default,...
        'trials',[ts_st ts_dev],'name','normal','classes',classes,'blocks_in',1:4,'time',1:64,'channels',channels);
    
    out22t=S.d2.default.apply_classifier(S.d2.default,...
        'trials',[ts_st ts_dev],'name','transfer','classes',classes,'blocks_in',1:4,'time',1:64,'channels',channels);
    out23t=S.d2.default.apply_classifier(S.d3.default,...
        'trials',[ts_st ts_dev],'name','transfer','classes',classes,'blocks_in',1:4,'time',1:64,'channels',channels);    
    out33t=S.d3.default.apply_classifier(S.d3.default,...
        'trials',[ts_st ts_dev],'name','transfer','classes',classes,'blocks_in',1:4,'time',1:64,'channels',channels);
    
%     out22s=S.d2.default.apply_classifier(S.d2.default,...
%         'trials',[ts_st ts_dev],'name','small','classes',classes,'blocks_in',1:4,'time',1:64,'channels',channels);
%     out23s=S.d2.default.apply_classifier(S.d3.default,...
%         'trials',[ts_st ts_dev],'name','small','classes',classes,'blocks_in',1:4,'time',1:64,'channels',channels);    
%     out33s=S.d3.default.apply_classifier(S.d3.default,...
%         'trials',[ts_st ts_dev],'name','small','classes',classes,'blocks_in',1:4,'time',1:64,'channels',channels);
%    
    
    A(i,:)=[out12n.rate(3) out13n.rate(3) out23n.rate(3)];%; n.rate];
    B(i,:)=[out22t.rate(3) out23t.rate(3) out33t.rate(3)];% t.rate];
  %  C(i,:)=[out22s.rate(3) out23s.rate(3) out33s.rate(3)];% t.rate];
    
end