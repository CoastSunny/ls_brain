function Y = sortMatrixElements(A,varargin)
%
% Sort values of the matrix elements and provide their original positions
% 
% SORTMATRIXELEMENTS(A) returns a matrix that is composed of 3 columns:
% first column is the array of the sorted (ascending) values of the
% original matrix second column is the array of corresponding row positions
% and third column is that of column positions.
% 
% SORTMATRIXELEMENTS(A,dir) returns sorted values with a descending order
% if dir is equal to -1, or with an ascending order, otherwise.
%
% A  : the matrix to be sorted
% dir: direction of the sort, -1 for descending, 1 for ascending (default)
%
% I want to sort the matrix elements and at the same time
% to know the position of each. I will create an array of arrays which
% consists of elements that each has its value, row position and column
% position. An example:
% A = [8 2 6 11; 4 7 9 12; 5 1 3 10];
% Array of arrays (X)
% X is [8 1 1;
%       2 1 2;
%       6 1 3;
%      11 1 4; 
%       4 2 1;
%       7 2 2;
%       9 2 3;
%      12 2 4;
%       5 3 1;
%       1 3 2;
%       3 3 3;
%      10 3 4]
% And result of the sort (y)
% Y is [1 3 2;
%       2 1 2;
%       3 3 3;
%       4 2 1;
%       5 3 1;
%       6 1 3;
%       7 2 2;
%       8 1 1;
%       9 2 3;
%      10 3 4; 
%      11 1 4;
%      12 2 4 ]


if nargin > 2
    error('Error: More than 2 arguments!');
elseif nargin == 1
    dir = 1;
elseif nargin < 1
    error('Error: No argument!');
elseif isnumeric(varargin{1})
    dir = varargin{1};
    if not(dir==-1)
        dir = 1;
    end
else
    error('Error: Second argument must be an integer (-1 or 1)');
end

[As,Y] = sort(A(:)); 
[Y,c]  = ind2sub(size(A),Y); 
Y      = [As,Y,c];


% % First step: Create X
% nrow = size(A,1);
% ncol = size(A,2);
% X = zeros(nrow*ncol,3);
% for r=1:nrow
%     for c=1:ncol
%         X((r-1)*ncol+c,:)=[A(r,c) r c];
%         % A row of X, for example [12 3 5], means
%         % the first element, 12, is the value
%         % of the original element in A with 
%         % a position (row 3,column 5).
%     end
% end
% % Second step: Sort rows 
% % (i.e. to sort using first column of X, that column consists of the values
% % of the elements of original matrix A)
% Y = sortrows(X, dir);
        