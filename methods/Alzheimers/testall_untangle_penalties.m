clear SIMCOOL
PEN=[1:5:100];
for pp=1:numel(PEN)
pen=PEN(pp);    
l=1;
nodes=16;
untangle_paper
pSIM16{pp}=SIMCOOL;
end
% 
% pen=100;
% l=1;
% nodes=32;
% untangle_paper
% E32=E;
% RE32=RE;
% E232=E2;
% RE232=RE2;
% SIM32=SIMCOOL;
% 
% 
% pen=500;
% l=1;
% nodes=64;
% untangle_paper
% E64=E;
% RE64=RE;
% E264=E2;
% RE264=RE2;
% SIM64=SIMCOOL;