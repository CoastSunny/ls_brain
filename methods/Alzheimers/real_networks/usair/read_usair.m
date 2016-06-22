fileName = '~/Downloads/usair/USAir97.net';
inputfile = fopen(fileName);
W=[];

l=1;
k=1;
W=zeros(332); % number of nodes

while l<2462 % insert last line noninclusive

      % Get a line from the input file
      tline = fgetl(inputfile);

      % Quit if end of file
    if l>335 %line before edges start

      nums = strsplit(tline);
      if length(nums)
            W(str2num(nums{2}),str2num(nums{3}))=str2num(nums{4});
      end
     
    end
    
 l=l+1;

end

W=W+W.';
W=weight_conversion(W,'normalize');