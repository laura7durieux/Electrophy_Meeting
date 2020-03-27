function []=animals_names()

%then create the variable we needs inside 
 Phantom = categorical({'dog'});
 Peche = categorical({'cat'});
 Nagini = categorical({'snake'});
 
 % then do the processing 

UserAnswer = categorical({input('What is Phantom ?','s')})
if UserAnswer==Phantom
    disp("You're rigth")
else
    disp("You are wrong, try again")
end 

UserAnswer = categorical({input('What is Peche ?','s')})
if UserAnswer==Peche
    disp("You're rigth")
else
    disp("You are wrong, try again")
end 

UserAnswer = categorical({input('What is Nagini ?','s')})
if UserAnswer==Nagini
    disp("You're rigth")
else
    disp("You are wrong, try again")
end 

end