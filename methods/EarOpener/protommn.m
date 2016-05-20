function out = protommn(S,T,classes,classes_outer,time,channels,blocks_in,blocks_outer,trials,trials_outer,bias,C)

    [dw fulldwt cov fullaw] = S.diff_wave('classes',classes,'blocks_in',blocks_in,'vis','off','difftype','timewave','trials',trials);
    %[dw2 fulldwt2 cov2 fullaw2] = T.diff_wave('classes',classes_outer,'blocks_in',blocks_in,'vis','off','difftype','timewave','trials',trials_outer);  
  
    W = inv( cov( channels , channels ) + C * eye( numel( channels ) ) ) * ( -fulldwt( channels , time ) );
    %W = ( -fulldwt( channels , time ) );   
    if (isempty(bias)) 
     bias =  sum(diag(W * fullaw(channels,time)))/2 ; 
    end
    bias
    %figure,plot(W)
    tmp = S.apply_classifier(T,'classes',classes_outer,...
        'blocks_in',blocks_outer,'channels',channels,'time',time,'W',W,'bias',bias,'trials',trials_outer);
    
    %out.out=check_balance(S,Y,'test',{{14};{20}},[-1 1],3:4,1:64,1:64,W);
    
    out=tmp;
    out.W=W;   
        
end