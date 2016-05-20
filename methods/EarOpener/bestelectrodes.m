
APLO1.d1.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64,'cleverstuff','rfe','method','space')
APLO1.d2.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64,'cleverstuff','rfe','method','space')
APLO1.d3.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64,'cleverstuff','rfe','method','space')

APLO2.d1.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64,'cleverstuff','rfe','method','space')
APLO2.d2.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64,'cleverstuff','rfe','method','space')
APLO2.d3.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64,'cleverstuff','rfe','method','space')

APLO3.d1.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64,'cleverstuff','rfe','method','space')
APLO3.d2.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64,'cleverstuff','rfe','method','space')
APLO3.d3.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64,'cleverstuff','rfe','method','space')

a=APLO1.d1.default.test.rfe.all_channels{end};
b=APLO1.d2.default.test.rfe.all_channels{end};
c=APLO1.d3.default.test.rfe.all_channels{end};

d=APLO2.d1.default.test.rfe.all_channels{end};
e=APLO2.d2.default.test.rfe.all_channels{end};
f=APLO2.d3.default.test.rfe.all_channels{end};

g=APLO3.d1.default.test.rfe.all_channels{end};
h=APLO3.d2.default.test.rfe.all_channels{end};
i=APLO3.d3.default.test.rfe.all_channels{end};