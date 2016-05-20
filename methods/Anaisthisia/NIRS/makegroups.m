controls=NIRS.copy;
delete(findprop(controls,'T2')),delete(findprop(controls,'T3')),delete(findprop(controls,'T4')),delete(findprop(controls,'T5')),delete(findprop(controls,'T6')),delete(findprop(controls,'T9')),delete(findprop(controls,'T10'))
controls.combine_subjects

patients=NIRS.copy;
delete(findprop(patients,'C4')),delete(findprop(patients,'C6')),delete(findprop(patients,'C7')),delete(findprop(patients,'C8')),delete(findprop(patients,'C9')),delete(findprop(patients,'C10')),delete(findprop(patients,'C11'))
patients.combine_subjects

