%restoredefaultpath

startup
addpath([home '/Documents/ls_brain/classes/common'])
addpath([home '/Documents/ls_brain/global'])
addpath([home '/Documents/ls_brain/classes'])
addpath([home '/Documents/ls_brain/methods/Alzheimers'])
p=[home '/Documents/ls_brain/methods/Epilepsy/DiscreteTFDs-v1.0'];
path(path,p);
DTFDPath(p);
clear p

% addpath([home '/Documents/ls_brain/methods/Anaisthisia/switch/'])
addpath([home '/Documents/ls_brain/methods/Misc/KMBOX-0.9/'])
addpath([home '/Documents/ls_brain/methods/Misc/libsvm-3.20/matlab/'])
addpath(genpath([home '/Documents/ls_brain/methods/Misc/drtoolbox/']))
addpath([home '/Documents/ls_brain/methods/Misc/tensor_toolbox'])
addpath([home '/Documents/ls_brain/methods/Misc/tensor_toolbox/met'])
addpath([home '/Documents/ls_brain/methods/Misc/TENSORBOX'])
addpath([home '/Documents/ls_brain/methods/Epilepsy'])
addpath([home '/Documents/ls_brain/methods/Misc/nway330/'])
addpath([home '/Documents/ls_brain/methods/Misc/srv1_9'])
addpath([home '/Documents/ls_brain/methods/Misc/'])
addpath([home '/Documents/ls_brain/methods/Misc/code'])
addpath([home '/Documents/ls_brain/methods/Misc/matlab-bgl-master'])
addpath([home '/Documents/ls_brain/methods/Misc/2016_01_16_BCT'])
a=which('trace');
rmpath(a(1:end-7));