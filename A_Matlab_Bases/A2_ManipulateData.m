%%%%%%%%%%%%%% Manipulate data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Part 1 : Create matrix/ vector

a = [1 2 3; 4 5 6;7 8 9];

b = rand(3); % create random number of uniform distribution from 0 to 1

c = zeros(3); %create a matrix of 3 by 3 of zero number

v = [1:10]; % create a vector with the number from 1 to 10
v1 = [1:0.5:10]; % create a vector from 1 to 10 but with a pad of 0.5

%% Part 2 : Display variables

% we  have several choice :
% just write the name in the command center 
a
% or using fonction as
disp('I created my first matrix')
disp(a)

% or just don't the ";" at the end of the command

%% Part 3 Indexing
% Indexing it's juste the name of the process of "how are stored the data"
%In matrix it's with the ligne and colunm numbers 

% For example, let change by 5 the number of c at the raw 2 and col 2 and
% store it in a new variable

d = c; % create the new variable
d(2,2) = 5; %put 5 instead of 0 at the raw 2 abd col 2

% Change the 1 raw and 3 col by 3
d(1,3) = 3;

% Change the 1 raw and the col 1&2 by 1
d(1,1:2)=1;

% Change a full col (col2)
d(:,2)=0.5;

% Change a full raw (raw3)
d(3,:)=0.7;

%% Part 4 Take just part of a variable
% Keeping just the first col
e = d(:,1);
% Keeping just the first ligne
e = d(1,:);
%%% Warning, the variable erase themself if you use the same name
% Keeping the last 2 col
e= d(:,2:3);
% but you can also writte
e1= d(:,2:end);

%% Part 5 :Concatenate data
% Warning : for concatenate data you need to have the same size of the
% matrix or vector !
% ok let put b after a into f
f = [a b];

% or put b below a into f
f = [a ; b];
% it's working as before with number 

% now, why not put e after f into g ?
g = [f e];
%%% ERROR %%%%%
% Let's check the size of the matrix
size(f)
size(e)
% In that case we have 6 raws for f and just 3 for e, so matlab say that it
% can concatenate them. 
% That is a current mistake, for matrix you need ABSOLUTLY to have the same
% size on the concatenated dimension 

% but you can cheat a little ! : In matlab NaN means "not a number" but it
% is process as number - it's not strings
h=[NaN NaN NaN;NaN NaN NaN;NaN NaN NaN];
% Look they are double (as number)


%%%%%%%%%% Exercice 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SO now you know everythink : let's try

% 1- Create a vector v of 10 col with random number ?
% 2 - Create a matrix a of 5 raw and 5 col of zeros ?
% 3 - Changing the last raw of a by 1 ?
% 4 - Concatenate the data wihout changing/ adding number ? PS : perhaps
% you van find a function that's help?

%%%%%%%%%%%% Exercie 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find why this code doesn't work (don't add a all command, just find the
% litle mistake)

a = [1 2 3, 4 5 6, 7 8 9];
b = rand(3);
b(1,:)=1;
f = [a b];
