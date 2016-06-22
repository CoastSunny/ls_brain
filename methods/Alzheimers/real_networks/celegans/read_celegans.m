fileName = '~/Downloads/celegans/celegans_n306.txt';
inputfile = fopen(fileName);
W=[];

l=1;
k=1;
W=zeros(306);

while l<2346

      % Get a line from the input file
      tline = fgetl(inputfile);

      % Quit if end of file
    if l>0 

      nums = regexp(tline,'\d+','match');
      if length(nums)
            W(str2num(nums{1}),str2num(nums{2}))=str2num(nums{3});
      end
     
    end
    
 l=l+1;

end

W=W+W.';
W=weight_conversion(W,'normalize');