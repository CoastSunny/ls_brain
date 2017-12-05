fileName = 'C:\Users\Loukianos\Downloads\ENZYMES\ENZYMES_g292.edges';
inputfile = fopen(fileName);
W=[];

l=1;
k=1;
W=zeros(60);

while l<200

      % Get a line from the input file
      tline = fgetl(inputfile);

      % Quit if end of file
    if l>0 

      nums=strsplit(tline);
      if length(nums)
            W(str2num(nums{1}),str2num(nums{2}))=W(str2num(nums{1}),str2num(nums{2}))+1;
      end
     
    end
    
 l=l+1;

end

W=W+W.';
%W=weight_conversion(W,'normalize');
