 %%%%%%%%%%%% CONDITIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Let's talk about condition 
 % the ideo is pretty simple ! Either what you say is rigth (True) and
 % matlab will do want you ask, either it's wrong (False) and matlab will
 % not do it !
 % for exemple : 
%  if statement is true
%      then do THAT
%  else is wrong 
%      then do THAT
%  end
%  

%Let's try a real example !
 % We can't compare character, we need to put it as categorical 
 Phantom = categorical({'dog'});
 Peche = categorical({'cat'});
 Nagini = categorical({'snake'});

 % yes I running out of example here !
 
 if Phantom == 'dog'
     disp('Phantom is a dog')
 end
 
 % but you can be wrong 
 if Peche == 'snake'
     disp('Peche is a snake')
 else 
     disp("Peche isn't a snake even she can be sneaky")
 end
 
 % not you that I put " instead of ' because inside my sentence there was a
 % "can't" and matlab wil not understood where are the limits of texte !
 
 % We can complicate the statement 
 if Phantom == 'dog' & Peche == 'snake'
     disp('Something is not true')
 elseif Phantom == 'dog' & Peche == 'cat' & Nagini == 'snake'
     disp('you know correctly their name')
 else % if both statetement are false then display THAT
     disp('nothing to say')
 end
 
 % the & symbole represant AND, == means ARE EQUAL, ...
 % for the comparaison symbole just check here
 % https://fr.mathworks.com/help/matlab/logical-operations.html
 % and
 % https://fr.mathworks.com/help/matlab/matlab_prog/array-comparison-with-relational-operators.html
 
 % we can do that, obsiously with number !
 NbSnakes =  2;
 NbDogs = 1;
 
 
 if NbSnakes < 1
     disp("you don't have snakes")
 elseif NbDogs >= 1
     disp('you have a dog')
 elseif NbSnakes >= 1
     disp('you have at least one snake')
 end
 
% if you run if code you will see that only the second statement if
% validate even if the third is also true ! Why ? Because the order matters
% ! Matlab will take the 1 one true and go after directly to the end !

%%%%%%% EXERCICE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now let's try with something more usefull than the name or number of my
% pets ;-)
% let's recreate our fake data !
srate = 1000; % sampling rate of 1 kHz
time  = 0:1/srate:60; 
freq  = 10; % in Hz
amp   = 2; % amplitude, or height of the sine wave
freq1  = 20; % in Hz
amp1   = 1; % amplitude, or height of the sine wave
freq2  = 5; % in Hz
amp2   = 3; % amplitude, or height of the sine wav

sine_wave = amp.*sin(2*pi*freq.*time);
sine_wave1 = amp1.*sin(2*pi*freq1.*time); 
sine_wave2 = amp2.*sin(2*pi*freq2.*time); 

LFP = sine_wave + sine_wave1 + sine_wave2; 
plot(LFP)

% if you zoom in you can see that is the same that before but longueur. 

% 1- create a vector of the same size of LFP with zeros 


% My turn : I create a fake sleepTrack
number = [1 2 3 2 1 3 4 3 1 2 3 4];
SleepTrack =[];
for i=1:length(number)
    Muti = floor(rand()*20000);
    Nbrep = repelem(number(i),Muti);
    SleepTrack = [SleepTrack Nbrep];
end
SleepTrack = SleepTrack(1,1:length(LFP));

% The idea is that now you have a vector called SleepTrack with the same 
% length that LFP whitch is as if you coded the sleep.
% 1 is the active wake, 2 the calm wake, 3 the SWS and 4 the REM
% Each point in time have one of the number here, representing if the rat
% stages at this point of time. Check how it looks like ;-)

% 2- Separate put in the matrix LFP signal each time the sleeptrack is equal 
% to one. Do the same for 2 in another matrice. You will need the use the FOR
% we saw in the previous script
% plot SleepTrack, LFPAW (=1), and LFPCW (=2) on the same plot













%%%%%%%%% CORECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1-
LFP3 = zeros(1,length(LFP));

% 2- 
LFPAW=LFP3;
LFPCW=LFP3;
for i = 1:length(SleepTrack)
    if SleepTrack(i) == 1
        LFPAW(i)= LFP(i);
    elseif SleepTrack(i) == 2
        LFPCW(i)= LFP(i);
    else 
    end
end

figure
plot(SleepTrack,'b','DisplayName','SleepTrack')
hold on
plot(LFPAW,'k','DisplayName','LFP active wake')
plot(LFPCW,'g','DisplayName','LFP calme wake')
legend
hold off



 