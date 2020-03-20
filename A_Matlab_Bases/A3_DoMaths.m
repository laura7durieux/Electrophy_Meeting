%%%%%%%%%% Do Maths with MATlab %%%%%%%%%%%%%%%%%%%%%%%%%

%The Goal of Matlab is to do maths and it's why it is perfectly desing for
%that in compare to other language (as python for example). 

%% Part 1 : basic calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% As you will see it's pretty simple 
a = 1 + 2; % addition
b = 6-3; % substraction
c = 20/3.25; % division 
d = 15*2; % Multiplication
%Remainder after division (modulo operation)(what's left)
e = mod(25,5);
f = mod(21,5);

% round the number at the interger closest (without float number)
f1 = 21/5;
f2 = round(21/5);

% absolute number
g = 2-20; % substraction leading to a negative number
g=abs(g); % Absolute value calculation and erase the old g variable

% Powers and square root
h = 2^3; % Other word 2*2*2
i = sqrt(25); % be cause 25 is equale 5^2 = 5*5

% we can also use more complexe function as:
j1 = exp(10); % exponentials
j2 = log(10); % natural logarithms
j3 = sin(10); % works also with cos() and tan()
j4 = prod(1:10); % factorial of 10
% You can see this ling for more : https://fr.mathworks.com/help/matlab/arithmetic-operators.html?s_tid=CRUX_lftnav
% or
% https://fr.wikibooks.org/wiki/D%C3%A9couvrir_Matlab/Calculs_%C3%A9l%C3%A9mentaires
% (French)

%% Part2 : Vector and matrix Maths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Warning : the matrice calculation is differente of what we know ... Keep
% that in mind because it could do something very wrong to your data... I will shown you after !

% What's happen when we want to use directly what is inside your variable !
% let's say 
a = [1 2 3];
b = [4 5 6];
b2 = [7;8;9]; 
% the basic calculation are the same for the vector !
c = a + b;
% Look at the results : that will do the addition of the 1st terme of the 1st variable with
% the 1st of the 2nd variable

% you can also addition what is inside one vector
d=sum(a);
d1 = diff(a);

% the multiplication and division 
e = a*b;
%%% ERROR %%%%
% That's is not working because you ask for a matrice multiplication (can
% explain what is it exctly because I don't understand it, but the idéa is
% : We don't want to do that, because it's another complicated maths
% calculation)
% For doing the multiplication we should add a dot before '*' as '.*'
e = a.*b;
%Working ! And that's the same for the division
f=a./b;

% let try now to multiplied a raw vector with a column vector term by term
g = a.*b2;
% you see happen is happing ! So be careful of the direction of your data !

% for the example of something you need to AVOID
Avoiding = a*b2;
% Did you understand ? I can't so it's exctly for that I m avoiding matrice
% calculation !! Lack of mathematic knowledge !

% You can do the same with matrices but you need the same size of your to
% matrice 
a = rand(2,4); % random numbers included between 0 and 1
b = rand(2,4);
c = rand(5,5);

a =round(a*10);
b = ceil(b*10); % I m letting you discover what does this function by asking at Matlab in the search bar (top rigth)
% when you multiply the matrice by 1 terme you don't to put the dot because
% it is imposible to make matrice calculation on it (needs to matrices !)

d = a .* b;
e = a + b;
f = b - a;
g = b./a;

% Know let try that :
h = b + c;
% ERROR %
% Mathlab say that you need to have the same size of matrice for doign the
% calcul. 

%%%%%%%%%%% Exercice 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SO now you know what I know : let's try
% I will put the code at the end 
% lets do something fun : electrophy-ich ! 
srate = 1000; % sampling rate of 1 kHz
time  = -1:1/srate:1; 
freq  = 10; % in Hz
amp   = 2; % amplitude, or height of the sine wave

% Lets create our first oscilation
sine_wave = amp.*sin(2*pi*freq.*time); % Note that you need the .* for point-wise vector multiplication.

% lets plot
figure % for opening the figure 
plot(sine_wave)

% Exercice 1 : Create 2 other oscilations with :
% - freq = 20 and amp = 1
% - freq = 5 and amp = 3
% plot them togheter : use the following code
figure
plot(sine_wave,'b')% 'b' is for blue
hold on            % putting them on the same plot
plot(sine_wave1,'g') %'g' is for green
plot(sine_wave2,'r') %'r' is for red
hold off


% Exercice 2 : Let's adding together the 3 wave we created , calling the
% variable LFP1.
% and plot them ! It seems almost as brain oscilation (too much organised
% but almost). We will make it as a real one futher in the process don't
% worry

%Exercice 3 : Now let's create a copy of the later oscillation (call it LFP2) and make it
%more complex adding a new ocillation to it (freq = 8 and amp = 2.5) and
%plot them on the same figure

%Exercice 4 : Now let try to do the local reference between them. not : the local 
% ref is simply one LFP ch minus another. Plot them. Do you understand why
% we have this result ?

% Exercice 5 : make the absolute value of the LFP local you created. What will happen ? 
% Plot the LFP_local and the LFP_abs on the same plot




%%%%%%%%%%% CODE CORRECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercice 1 : correction
freq1  = 20; % in Hz
amp1   = 1; % amplitude, or height of the sine wave
freq2  = 5; % in Hz
amp2   = 3; % amplitude, or height of the sine wave

sine_wave1 = amp1.*sin(2*pi*freq1.*time); 
sine_wave2 = amp2.*sin(2*pi*freq2.*time); 

figure
plot(sine_wave,'b')% 'b' is for blue
hold on            % putting them on the same plot
plot(sine_wave1,'g') %'g' is for green
plot(sine_wave2,'r') %'r' is for red
hold off


% Exercice 2 : correction
LFP1 = sine_wave + sine_wave1 + sine_wave2;

figure 
plot(LFP1,'b') % 'b' is for blue


% Exercice 3 : correction
freq3  = 8; % in Hz
amp3   = 2.5; % amplitude, or height of the sine wave

sine_wave3 = amp3.*sin(2*pi*freq3.*time); 
 
LFP2 = LFP1 + sine_wave3;

figure
plot(LFP1,'b')% 'b' is for blue
hold on            % putting them on the same plot
plot(LFP2,'g') %'g' is for green
hold off

% Exercice 4 : correction
 
LFP_local = LFP1 - LFP2;

figure
plot(LFP1,'b')% 'b' is for blue
hold on            % putting them on the same plot
plot(LFP2,'g') %'g' is for green
plot(LFP_local,'r')
hold off


% Exercice 5 : correction
LFP_abs = abs(LFP_local);

figure
plot(LFP_abs)
hold on         % putting them on the same plot
plot(LFP_local,'g') %'g' is for green
hold off