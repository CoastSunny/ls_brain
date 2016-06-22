clear Er16 Re16

for tr=1:numel(SIM16)
    Er16(tr)=(SIM16{tr}{2}{1}(end,1)/SIM16{tr}{1}{1}(1)+SIM16{tr}{2}{1}(end,5)/SIM16{tr}{1}{1}(2))/2;
    Re16(tr)=SIM16{tr}{3}{1}(end,1)/SIM16{tr}{5}{1}(end,1);
    Er16deg(tr)=(SIM16{tr}{7}{1}(1,1)/SIM16{tr}{6}{1}(1)+SIM16{tr}{7}{1}(1,5)/SIM16{tr}{6}{1}(2))/2;
    Re16deg(tr)=SIM16{tr}{8}{1}(1)/SIM16{tr}{10}{1}(end,1);
end

for tr=1:numel(SIM32)
    Er32(tr)=(SIM32{tr}{2}{1}(end,1)/SIM32{tr}{1}{1}(1)+SIM32{tr}{2}{1}(end,5)/SIM32{tr}{1}{1}(2))/2;
    Re32(tr)=SIM32{tr}{3}{1}(end,1)/SIM32{tr}{5}{1}(end,1);
    
end


for tr=1:numel(SIM64)
    Er64(tr)=(SIM64{tr}{2}{1}(end,1)/SIM64{tr}{1}{1}(1)+SIM64{tr}{2}{1}(end,5)/SIM64{tr}{1}{1}(2))/2;
    Re64(tr)=SIM64{tr}{3}{1}(end,1)/SIM64{tr}{5}{1}(end,1);    
end