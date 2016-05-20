
clear buttons
clear sequence
clear files1
clear files2
clear correct
files1 = rdir('**/buttonpress.mat');
files2 = rdir('**/sequence.mat');


files1.name
%files2.name

for i = 1 : numel( files1 )
    
try
    buttons=load([pwd '/' files1(i).name]);
   
    sequence=load([pwd '/' files2(i).name]);
    d=strmatch('dev',sequence.v.type(sort(sequence.v.question_trials)));
    s=strmatch('std',sequence.v.type(sort(sequence.v.question_trials)));
    try
    correct(i)=sum(buttons.v(d)==1)+sum(buttons.v(s)==2);
    catch err
        correct(i)=999;
    end
    
catch err
    buttons=load([pwd '/' files1(i).name]);
    sequence=load([pwd '/' files2(i).name]);
    d=strmatch('dev',sequence.v.type(sort(sequence.v.questiontrials)));
    s=strmatch('std',sequence.v.type(sort(sequence.v.questiontrials)));
    try
    correct(i)=sum(buttons.v(d)==1)+sum(buttons.v(s)==2);
    catch err
        correct(i)=999;
    end
end
    
end
correct