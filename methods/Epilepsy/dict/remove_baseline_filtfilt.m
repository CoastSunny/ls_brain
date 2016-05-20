%zero-shift filtering 
function denoised_signal=remove_baseline_filtfilt(x,f,mode,order)
    samplerate=200;
    [b,a]=butter(order,f/samplerate,mode);
    fdata=filtfilt(b,a,x);
    fdata(1:size(x,2)/2);
    denoised_signal=fdata';
end