%%% Variable types %%%%%
% Varaibles will be use to store data, or number, or character than you
% will need after. I advise you to put a comprehansive name for each of
% your variables. For exemple if you want to store your name :
myName='Lucas';
% It's pretty usefull because you can change what the variable containes
% without seaching for each time you use it in the code. 

a = 1; % a will be a variable = 1 and if you put ";" it's means that you supress the console output. 
% It will appear in "double" (the better is to work with double so if you
% see that a variable is "int" try to change it in double.
w = 'c'; 
% It's a string/ characters 1x1

% Vector
% create a ligne of 1x6 (ligne x colonne)
b = [1 1 2 2 3 3]; 
% you can also writte it like that
b = [1,1,2,2,3,3];
% create a colonne of 5x1
c = [1;2;3;4;5];
% All of that are vector because it's one line (or colonne)!
x = 'characters'; % char of 1x10

% Matrix
% Les matrix sont des "tableaux" de nombres et contiennent des dimensions (je parlerais des dimensions plus tard).
% matrix of doubles 3x3
d = [1 2 3;4 5 6;7 8 9];
% matrix of doubles 4x2
e=[1 2;2 3;3 4;4 5];

% Tables (we will not use that much ... but it could be usefull when you
% want to export in some data out of Matlab environment.
j=table(c,[8;7;4;5;6],[0;0;0;0;0],'VariableNames',{'Var1','Var2','Var3'});

% cell arrays : create a kind of matrix where each cases are whatever you
% want (it's indexed)
f = {a,b,c,d,e}; % 1 by 5
% but you can also create a "table"
g ={a b; c d; e f}; % 3x2
% as you can see you can put a cell array into a cell array ! but be
% carefull to write what you put inside because there are no label in cell
% array. 

% Structures : It's as a cell array but without indexing. It's seem like a
% dictiorany because you need a word to access what you put inside.
h = struct('Var1',a,'Var2',b,'Var3',d,'Var4',e);
% Yes you can also put a cell array into a structure but it's kind of
% complicated to manipulate after. (More you stay with simple ways to store
% you data, more it will be simple to use and more your code will be
% understandable')


%%%%%%%%%%%%% I hope it will be usefull %%%%%%%%%%%%%%%%%%%