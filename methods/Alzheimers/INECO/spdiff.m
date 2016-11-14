function out = spdiff(Cx,rt,ct)

cc=triu(Cx);
[tmp itmp]=sort(cc(:));
[r c]=ind2sub(size(cc),itmp(end));
out=abs(rt-r)+abs(c-ct);
end