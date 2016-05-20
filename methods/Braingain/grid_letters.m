GRID_LETTERS{1}={'b' 'c' 'd' 'e' 'f' 'a'};
GRID_LETTERS{2}={'h' 'i' 'j' 'k' 'l' 'g'};
GRID_LETTERS{3}={'n' 'o' 'p' 'q' 'r' 'm'};
GRID_LETTERS{4}={'s' 't' 'u' 'v' 'w' 'x'};
GRID_LETTERS{5}={'z' '.' ',' '_' 'y' 'we have an issue here'};

z=[repmat([0 0 0 0 1],1,15)  repmat([0 0 0 0 1],1,15)    ];
o=[repmat([0 0 1 0 0],1,15)  repmat([1 0 0 0 0 0],1,15)  ];
e=[repmat([1 0 0 0 0],1,15)  repmat([0 0 1 0 0 0],1,15)  ];
k=[repmat([0 1 0 0 0],1,15)  repmat([0 0 1 0 0 0],1,15)  ];
n=[repmat([0 0 1 0 0],1,15)  repmat([0 0 0 0 0 1],1,15)  ];
ZOEKEN=[z o e k e n];

label1{1,1}=repmat([-1 -1 -1 -1 1],1,15);

label1{2,2}=repmat([1 -1 -1 -1 -1 -1],1,15);
label1{2,1}=repmat([1 -1 -1 -1 -1],1,15);

label1{3,1}=repmat([-1 -1 1 -1 -1],1,15);

label1{4,2}=repmat([-1 1 -1 -1 -1 -1],1,15);
label1{4,1}=repmat([-1 1 -1 -1 -1 ],1,15);

label1{5,1}=repmat([1 -1 -1 -1 -1],1,15);

label1{6,2}=repmat([-1 -1 -1 1 -1 -1],1,15);
label1{6,1}=repmat([-1 -1 -1 1 -1 ],1,15);

label1{7,1}=repmat([-1 1 -1 -1 -1],1,15);

label1{8,2}=repmat([-1 -1 -1 1 -1 -1],1,15);
label1{8,1}=repmat([-1 -1 -1 1 -1],1,15);

label1{9,1}=repmat([1 -1 -1 -1 -1],1,15);

label1{10,2}=repmat([-1 -1 -1 1 -1 -1],1,15);
label1{10,1}=repmat([-1 -1 -1 1 -1 ],1,15);

label1{11,1}=repmat([-1 -1 1 -1 -1],1,15);

label1{12,2}=repmat([1 -1 -1 -1 -1 -1],1,15);
label1{12,1}=repmat([1 -1 -1 -1 -1 ],1,15);

target1=[lettertopred('z',GRID_LETTERS) lettertopred('o',GRID_LETTERS) lettertopred('e',GRID_LETTERS) lettertopred('k',GRID_LETTERS) lettertopred('e',GRID_LETTERS) lettertopred('n',GRID_LETTERS)];

label2{1,1}=repmat([-1 1 -1 -1 -1],1,15);

label2{2,2}=repmat([-1 -1 1 -1 -1 -1],1,15);
label2{2,1}=repmat([-1 -1 1 -1 -1],1,15);

label2{3,1}=repmat([1 -1 -1 -1 -1],1,15);

label2{4,2}=repmat([-1 -1 -1 -1 -1 1],1,15);
label2{4,1}=repmat([-1 -1 -1 -1 1],1,15);

label2{5,1}=repmat([-1 1 -1 -1 -1],1,15);

label2{6,2}=repmat([-1 -1 1 -1 -1 -1],1,15);
label2{6,1}=repmat([-1 -1 1 -1 -1],1,15);

label2{7,1}=repmat([-1 -1 -1 1 -1],1,15);

label2{8,2}=repmat([-1 -1 1 -1 -1 -1],1,15);
label2{8,1}=repmat([-1 -1 1 -1 -1],1,15);

label2{9,1}=repmat([1 -1 -1 -1 -1],1,15);

label2{10,2}=repmat([-1 -1 -1 -1 -1 1],1,15);
label2{10,1}=repmat([-1 -1 -1 -1 1],1,15);

label2{11,1}=repmat([-1 -1 1 -1 -1],1,15);

label2{12,2}=repmat([-1 -1 -1 -1 1 -1],1,15);
label2{12,1}=repmat([-1 -1 -1 -1 1 ],1,15);

target2=[lettertopred('j',GRID_LETTERS) lettertopred('a',GRID_LETTERS) lettertopred('g',GRID_LETTERS) lettertopred('u',GRID_LETTERS) lettertopred('a',GRID_LETTERS) lettertopred('r',GRID_LETTERS)];
