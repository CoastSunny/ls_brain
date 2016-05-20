function denoised_signal=remove_baseline(x,f,mode,order)
    samplerate=200;
    [b,a]=butter(order,f/samplerate,mode);
    fdata=filter(b,a,x);
    fdata(1:size(x,2)/2);
    denoised_signal=fdata';
end