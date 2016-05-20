if isunix==0
    home='C:\Users\Loukianos';
    home_bci='D:\';
else
    home='~';
    home_bci='~';
end


addpath([home '/Documents/ls_brain/global'])
addpath([home_bci '/BCI_code/toolboxes/jf_bci'])
addpath([home_bci '/BCI_code/toolboxes/jf_bci/biosemi'])
addpath([home_bci '/BCI_code/toolboxes/jf_bci/readraw'])
addpath(genpath([home_bci '/BCI_code/toolboxes/classification']))
addpath([home_bci '/BCI_code/toolboxes/eeg_analysis'])
addpath(genpath([home_bci '/BCI_code/toolboxes/numerical_tools']))
addpath([home_bci '/BCI_code/toolboxes/signal_processing'])
addpath(genpath([home_bci '/BCI_code/toolboxes/utilities']))
addpath([home_bci '/BCI_code/toolboxes/brainstream/core'])
addpathBS
