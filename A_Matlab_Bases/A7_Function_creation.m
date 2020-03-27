%%%%%%%%%%%% CREATE FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% I will be verry quick on this one because it could be usefull not only 
% if you alreday manage matlab well 
%     
% Creating can seems not really usefull at the begging but in fact it same a lot of time 
% because you will create the function once and use it a lot.
% Moreover, it will make your script way more ordered and clean.
% Without it you will finish with 100000 raw in your script and don't really 
% remember what is the variable you use for what.
% In function, all the varaible create inside the function will not come to 
% your workspace except for the output of this function. 
% 
% When you create a function, you need to create a new file / script. The name 
% of the file seems to be the name of the function. 
% 
% Open the file in the librairie called use_a_function
% 
% you can see the synthase of creating the function 

function [ouputs] = name_of_the_function(inputs)
HERE you can writte what you need to do with the function 
end


% Example: 
% Let's create our first function 
% 
% We want : the function will process the knowledge on the name of my pets 
% sorry I don't have realy simple example in mind 

% Open a new script 
% Inside write

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function []=animals_names()

%then create the variable we needs inside 
 Phantom = categorical({'dog'});
 Peche = categorical({'cat'});
 Nagini = categorical({'snake'});
 
 % then do the processing 

UserAnswer = categorical({input('What is Phantom ?','s')});
if UserAnswer==Phantom
    disp("You're rigth")
else
    disp("You are wrong, try again")
end 

UserAnswer = categorical({input('What is Peche ?','s')});
if UserAnswer==Peche
    disp("You're rigth")
else
    disp("You are wrong, try again")
end 

UserAnswer = categorical({input('What is Nagini ?','s')});
if UserAnswer==Nagini
    disp("You're rigth")
else
    disp("You are wrong, try again")
end 

end % end of the function not the loop

%% Now let's try to call it 
animals_names()
% That is clearly working

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% let's go for something more complicated ! And like that we will manage
% some categorical, cell array and make a funier game

function [Stats]=game_animals(Nbround)
% when you write function you have to be more organize then in script
% because it will be use to anythings

% first let's check if input is a string or char
if isstring(Nbround)|ischar(Nbround)
    error('you need to enter the number of time you want to play')
end

animals ={'Phantom','dog';'Peche', 'cat';'Nagini','snake';'Rumpel','snake';'Alduin','lezard'};


RandNum = ceil((rand(Nbround,1)*10)/2)
Stats = zeros(Nbround,2);
for i=1:Nbround
    X= sprintf('What is %s ?',(animals{RandNum(i,1),1}));
    UserAnswer = input(X,'s');
    
    UserAnswer = categorical({UserAnswer});
    Answer = categorical(animals(RandNum(i,1),2));
    
    if UserAnswer == Answer
        disp('you are right')
        Stats(i,:) = [i 1];
    else
        disp('you are wrong')
        Stats(i,:) = [i 0];
    end
end
end

% run it 
Nbround=5;
[Stats]=game_animals(Nbround)
disp(Stats)

% the question quite repeating themself but the idea is what matters :-)


%%
%%%%%%%%%%%%%%%% EXERCICE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The exercice will  be simple. You remember the script you wrote on the 
% Exercice n° 2 in the script on Condition. 
% Do the same exercice but this time make a function of it : input (the number of repeat)
% and the output the "SW_way_better" or in other word the fake LFP and the time. 

% 
% 
% 
% 
% 
% 
% 
% 

%%%%%% CORECTION %%%%%%%%%%%%%%%%%%%%%%%
%

%You will find the function in the librairies folder !

% input
reap = 100;

% functon
[SW_way_better,time]=fake_not_so_good_LFP(reap);

% plot
figure
plot(time,SW_way_better)
xlim([40 41])



