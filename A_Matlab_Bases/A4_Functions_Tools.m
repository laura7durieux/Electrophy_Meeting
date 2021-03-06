%%%%%%%%%%%%%% USING FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% okay so what about function !
% It will be, for sur, what you need to most in matlab 

% What is a function
% A function is a group of statements that together perform a task. 
%In MATLAB, functions are defined in separate files. 
%The name of the file and of the function should be the same 

% You should know that in function you have one or more input, and one or
% more outputs. 

% let's start simple : for example in Matlab you have implemented function
% who comes with the software as : mean() function 

% Let's say we want di the mean of a 
a= [1 2 3 4 5 6];

% function will be mostly as OUTPUT = FunctionName(INPUT)
% SO
b = mean(a);
% mean is just a particular script wrote in matlab. But we can't access
% them because it's a build in function wrote with another another language (mostly C)

% but you can simply check what are it ouptups and inputs
help mean
% or entrer mean in the search bar at the rigth top of matlab

% You can also add script function for outside, as in electrophy we use
% often chronux. For the example, I wrote a function : use_a_function
input = 5; % in case of my function the input need to be a number 
% if not the case, a error will pop.
[output]=use_a_function(input); 
% this function will multiply by 10 number given in the input and put it as
% output.
disp(output)
% for the function works, you need to add the folder librairies into the
% path of Matlab (see the video I send on matlab setting). 


% let try to make an error :
input = 'Laura'; % selfcentered ^^
[output]=use_a_function(input); 

% Ok, so now we have the error and you want to see the script of the
% function, trying to solve the error then you can access the
% function(because is a external one) by clicking on the name of the
% function in the error :-)

% the function that we will use the most (not exaustive list)
c=length(a);
d=size(a);
e=zeros(3); % already use this one 
f=disp(input);
g=save(filename);
h=load(filename);
j =mean(a);
k=find(a == 2);
figure
plot()
% ...
% If you want to know how use these function, I let you do it because I
% can't do a list of all matlab function. 

% tips: il you want to do something in matlab, there are probably a
% function who does it. So, at this point google is your close friend :-p

%%%%%%%%% exercice %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In the folder librairies you can see a folder called chronux, it is a set
% of functions design for oscillation analysis. Let's try to call one !

% create a fake oscillation 
srate = 1000; % sampling rate of 1 kHz
time  = -1:1/srate:1; 
freq  = 10; % in Hz
amp   = 2; % amplitude, or height of the sine wave
freq1  = 20; % in Hz
amp1   = 1; % amplitude, or height of the sine wave
freq2  = 5; % in Hz
amp2   = 3; % amplitude, or height of the sine wav

sine_wave = amp.*sin(2*pi*freq.*time);
sine_wave1 = amp1.*sin(2*pi*freq1.*time); 
sine_wave2 = amp2.*sin(2*pi*freq2.*time); 

LFP = sine_wave + sine_wave1 + sine_wave2; % you should obtain the same results that 
% on the DO_THE_MATHS script. 

% 1-Plot the signal on time
% 2-label both axis : x = time and y = mV - you have to look for the
% function for that

% 3- Now let call the mtspectrumc from chronus ! This is not simple, there are
% 2 outputs and a lot input ! I give you the parameters : run the ligne
% below
params.fpass = [1 30]; % in Hz (0.5 to 10) - 0.5 is minimum if we want to use a 4 sec window and see one cycle
params.Fs = srate;
k = 3; % num tapers (lower for less frequency leakage, higher for more leakage but smoother spectrum) % and it is a tradeoff with how many time points you have. spectrum is less smooth with many time points.
nw = (k+1)/2;
params.tapers=[nw k];

% the goal of this function if to extract the power of your oscilation 
% You should check what are the input and output in chronux manual on
% internet.

% 4- now that you have the power and the frenquencies, try to plot the
% spectrogram (x = frenquencies and y = power)

% 5- That was you first spectrogram ! Proud ? Did you expecte the plot to
% look like that ? Do you know why the peaks are so large ?



%%%%%%%%%%%%%%%%%%Correction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1- 

figure
plot(time,LFP)

% 2-
xlabel('fake time')
ylabel('fake mV')


% 3-
[S,f]=mtspectrumc(LFP,params); 

% 4- 
figure; 
plot(f,S,'DisplayName','Fake Spectrogram');
xlabel('fake frequencies')
ylabel('fake power')


