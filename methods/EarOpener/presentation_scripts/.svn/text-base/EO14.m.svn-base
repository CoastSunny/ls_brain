JPsv.train_classifiers('bigC',[12 20]);
JPsv.train_classifiers('medC',[12 21]);
JPsv.train_classifiers('smallC',[12 22]);
temp=properties(JPsv);
for i=1:length(temp)

    JPsv.(temp{i}).bigC.classifier.result.maxC=max(JPsv.(temp{i}).bigC.classifier.result.tstbin);
    JPsv.(temp{i}).medC.classifier.result.maxC=max(JPsv.(temp{i}).medC.classifier.result.tstbin);
    JPsv.(temp{i}).smallC.classifier.result.maxC=max(JPsv.(temp{i}).smallC.classifier.result.tstbin);
    
end

NLsv.train_classifiers('bigC',[12 20]);
NLsv.train_classifiers('medC',[12 21]);
NLsv.train_classifiers('smallC',[12 22]);
temp=properties(NLsv);
for i=1:length(temp)

    NLsv.(temp{i}).bigC.classifier.result.maxC=max(NLsv.(temp{i}).bigC.classifier.result.tstbin);
    NLsv.(temp{i}).medC.classifier.result.maxC=max(NLsv.(temp{i}).medC.classifier.result.tstbin);
    NLsv.(temp{i}).smallC.classifier.result.maxC=max(NLsv.(temp{i}).smallC.classifier.result.tstbin);
    
end

JPv.train_classifiers('bigC',[50 51 52 53;15 25 35 45]);
JPv.train_classifiers('medC',[50 51 52 53;16 26 36 46]);
JPv.train_classifiers('smallC',[50 51 52 53;17 27 37 47]);
temp=properties(JPv);
for i=1:length(temp)

    JPv.(temp{i}).bigC.classifier.result.maxC=max(JPv.(temp{i}).bigC.classifier.result.tstbin);
    JPv.(temp{i}).medC.classifier.result.maxC=max(JPv.(temp{i}).medC.classifier.result.tstbin);
    JPv.(temp{i}).smallC.classifier.result.maxC=max(JPv.(temp{i}).smallC.classifier.result.tstbin);
    
end


NLv.train_classifiers('bigC',[50 51 52 53;15 25 35 45]);
NLv.train_classifiers('medC',[50 51 52 53;16 26 36 46]);
NLv.train_classifiers('smallC',[50 51 52 53;17 27 37 47]);

temp=properties(NLv);
for i=1:length(temp)

    NLv.(temp{i}).bigC.classifier.result.maxC=max(NLv.(temp{i}).bigC.classifier.result.tstbin);
    NLv.(temp{i}).medC.classifier.result.maxC=max(NLv.(temp{i}).medC.classifier.result.tstbin);
    NLv.(temp{i}).smallC.classifier.result.maxC=max(NLv.(temp{i}).smallC.classifier.result.tstbin);
    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

temp=properties(JPsv);
for i=1:length(temp)
    bJPsv(i)=JPsv.(temp{i}).bigC.classifier.result.maxC;
    mJPsv(i)=JPsv.(temp{i}).medC.classifier.result.maxC;
    sJPsv(i)=JPsv.(temp{i}).smallC.classifier.result.maxC;
end
temp=properties(JPv);
for i=1:length(temp)
    bJPv(i)=JPv.(temp{i}).bigC.classifier.result.maxC;
    mJPv(i)=JPv.(temp{i}).medC.classifier.result.maxC;
    sJPv(i)=JPv.(temp{i}).smallC.classifier.result.maxC;
end
temp=properties(NLsv);
for i=1:length(temp)
    bNLsv(i)=NLsv.(temp{i}).bigC.classifier.result.maxC;
    mNLsv(i)=NLsv.(temp{i}).medC.classifier.result.maxC;
    sNLsv(i)=NLsv.(temp{i}).smallC.classifier.result.maxC;
end
temp=properties(NLv);
for i=1:length(temp)
    bNLv(i)=NLv.(temp{i}).bigC.classifier.result.maxC;
    mNLv(i)=NLv.(temp{i}).medC.classifier.result.maxC;
    sNLv(i)=NLv.(temp{i}).smallC.classifier.result.maxC;
end
