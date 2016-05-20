function out = pchange(a,b,c)

out=(mean(cell2mat(a))-mean(cell2mat(b)))/mean(cell2mat(c));

end