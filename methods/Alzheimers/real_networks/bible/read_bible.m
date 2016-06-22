fileName = '~/Downloads/bible/out.moreno_names_names';
inputfile = fopen(fileName);
W=[];

l=1;
k=1;
W=zeros(1773);

while l<9134

      % Get a line from the input file
      tline = fgetl(inputfile);

      % Quit if end of file
    if l>2 

      nums = regexp(tline,'\d+','match');
      if length(nums)
            W(str2num(nums{1}),str2num(nums{2}))=str2num(nums{3});
      end
     
    end
    
 l=l+1;

end

W=W+W.';
W=weight_conversion(W,'normalize');