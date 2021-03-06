%%%%%%%%%%%%% LOOPS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% or how to make Matlab repeate the same thing !
 
% we have 2 solution for that : FOR and WHILE 
% I'm more used to FOR statement but sometime WHILE is usefull to use.

% sythase is :
% for THAT NUMBER OF TIME
%     DO THAT
% end
% 
% while THAT IS FALSE 
%     DO THAT
% end

% NOte : Be carful using loops for two things : 1) you need to make sur
% that your loop have a end, without that matlab will continue to do the
% same thing over and over. 2) loops are slow to run, so somethime
% you can simply use matrix manipulation for doing the same thing !

%% For FOR 
% let go to example !
a = rand(1,60)*10;
for i = 1:length(a) % for i which will take the value of the length of a 
    disp(i) % display i value
end
% we have 60 repeats because the length of a is 60

for i = 1:length(a) % for i which will take the value of the length of a 
    disp(a(i)) % display a value on i position
end
% You understand the idea 

% now if we do that 
for i = 1:length(a)+1 % for i which will take the value of the length of a 
    disp(a(i)) % display a value on i position
end
% You will see this error : Index exceeds array bounds.
% Current error when you use loop, it's means that you ask for a number
% that doesn't existe. In our example, we ask for : display the value position i of a, 
% but when i = 61, a doesn't have this value because it stop at 60. 

for i = 1:0.5:5
    j = i+0.5;
    disp(j)
end
% I let you understand this one ^^

%% Now for WHILE
i=1;
while i ~= 10
    disp(i)
    i = i +1;
end
% see it stoped at 9 because at 10 i was not different of 10
% That allow you do adapt the number of repetition ...

inputUser = input('Entrer "c" if you want to continue or "q" if you want to quite','s');
k = 1;
while inputUser ~= 'q'
    x=["You want to continu the process ", num2str(k)];
    disp(x)
    k = k+1;
    inputUser = input('Entrer "c" if you want to continue or "q" if you want to quite','s');
end

% That is quite simple, isn't it ? 

%% Your turn !
%%%%%%%% EXERCICE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Exercice 1
Let try something simple for now and we will complicate thing after !

% 1- Make a vector (c) of 20 going from 1 to 20 by increment of 1.

% 2- Calculate the mean between the two first points, and after between the 2  and 3
% and after the 3 and 4 until the end of c. Store it in a new vector.

%%% Exercice 2
% Know, we will create a fake signal way more complicated than our first.

% let set the time and the sampling rat which will not change
srate = 1000; % sampling rate of 1 kHz
time  = 0:1/srate:60; 

% 1- create a frequency vector containing 50 random number between 0 and 
% 100. <make the frequencies being integer number (without
% digit after the decimal point) and even we can do it without loop, try do to it with it ^^

% 2- Do the same with the amplitude 50 of length and from 0.1 to 10

% 3- create a sin wave with amp(1) and freq(1), then with amp(2) and freq(2) 
%  etc ... At the end you should have in the same matrice (raw = sine wave and col = time)
%      it should be a matrix of 50 on 60001


%  4- Now let's try to sum all our sine waves (you don't have to use FOR for that ^^)
%      and plot it 


% 5- Zoom in, What do you thing ? it's a little bit better isn't it ? But 
% it's far from a good model we need to make it more random in time. We will see that 
% later 


% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CORRECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Exercice 1
%1-
c = 1:20;

%2- 
m = zeros(1,length(c)-1);
for i = 1:length(c)-1
    m(i) = mean([c(i),c(i+1)]);
end

%%% Exercice 2
% 1- 
freq = zeros(1,50);
for i = 1:length(freq)
    freq(i) = floor(rand()*100);
end

%2-
amp = zeros(1,50);
for i = 1:length(amp)
    amp(i) = round(rand()*10,1);
end

%-3
 sine_wave = zeros(length(amp),length(time));
 for i = 1:length(amp)
     sine_wave(i,:) = amp(1,i).*sin(2*pi*freq(1,i).*time);
 end

%-4
better_sine_wave = sum(sine_wave);

figure
plot(time,better_sine_wave)
