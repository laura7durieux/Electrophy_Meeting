function [Stats]=game_animals(Nbround)

if isstring(Nbround)|ischar(Nbround)
    error('you need to enter the number of time you want to play')
end

animals ={'Phantom','dog';'Peche', 'cat';'Nagini','snake';'Rumpel','snake';'Alduin','lezard'};


RandNum = ceil((rand(Nbround,1)*10)/2);
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