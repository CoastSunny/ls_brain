function MASNET_metrics()


[file,path]=uigetfile; % you can define here a default folder to start looking at
fl=[path file];
metrics_OFDM(fl)
metrics_LTE(fl)
metrics_NOCP(fl)

end
