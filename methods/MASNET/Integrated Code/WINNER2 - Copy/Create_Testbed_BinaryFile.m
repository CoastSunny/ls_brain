%% Binary file creator

clear

%% Paths


%% Make file

fp1 = fopen('Sound_tx1iii.bin', 'wb');
fwrite(fp1,Tx_soundIQ_int,'int16');
fclose(fp1);