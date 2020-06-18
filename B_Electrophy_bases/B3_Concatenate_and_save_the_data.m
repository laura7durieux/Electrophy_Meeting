% B3 - concatenate the data + save the progress you made 

% The goal of this script is to resolve this issue :
% If you have several electrophys files save continuously during time (as
% the system I use does. Meaning, it save the electrophy track in file file
% for ten minutes, so if I record 20 min I will have too file. 

% I'm sure that you can solve this issue alone but seems most of you will
% work on the same system than me, so it will be usefull if we do it
% together. 

% Okay, so the goal is to load one file, put the variables of interest into
% a new variable and loading a new file, ect... One can ask why we don't
% load all the file at the same time ? You can try, and I quess you will
% see ;-)

% first we gonna load the first file 
load('C:\Users\laura\Documents\DataElectTemp\rat13_hab1_part1.mat') % example, you need to replace with your file location

% And we do the same think than before.
% Delete the variable you don't need 
clearvars -except CLFP_001 CLFP_001_BitResolution CLFP_001_Gain CLFP_001_KHz CLFP_002 CLFP_003 CLFP_004 CLFP_005 CLFP_006 CLFP_007 CLFP_008 CLFP_009 CLFP_010 CLFP_011 CLFP_012 CLFP_013 CLFP_014 CLFP_015 CLFP_016

% I attribute "clearer name" but obviously you can put the name you want 
srate = CLFP_001_KHz*1000; %% Change and store the sampling rate (pass in Hz)
ch_bitResolution = CLFP_001_BitResolution; %% put the bitResolution from the software raw data into a new variable
ch_gain = CLFP_001_Gain; %% put the gain from the software raw data into a new variable


% this time LFP will be a matrix of channels x times
LFP = [CLFP_001; CLFP_002; CLFP_003; CLFP_004; CLFP_005; CLFP_006; CLFP_007; CLFP_008; CLFP_009; CLFP_010; CLFP_011; CLFP_012; CLFP_013; CLFP_014; CLFP_015; CLFP_016];

% Now, we have stored our first 10 min but we want to add the the second 10
% min. 
% So, we gonna load the second file 
load('C:\Users\laura\Documents\DataElectTemp\rat13_hab1_part2.mat') % example, you need to replace with your file location
% Be carefull, it will erase the files with the same name in your
% workspace.
% We don't need to attritube once again the variable "srate,
% "ch_bitResolution", ... (it's the same for all files ^^)
clearvars -except LFP CLFP_001 CLFP_001_BitResolution CLFP_001_Gain CLFP_001_KHz CLFP_002 CLFP_003 CLFP_004 CLFP_005 CLFP_006 CLFP_007 CLFP_008 CLFP_009 CLFP_010 CLFP_011 CLFP_012 CLFP_013 CLFP_014 CLFP_015 CLFP_016

% So we need to add it to our LFP matrix at the end, so on th width of the
% matrix because it's channels by times (in other word x axis is the time)
LFP2_temporaire = [CLFP_001; CLFP_002; CLFP_003; CLFP_004; CLFP_005; CLFP_006; CLFP_007; CLFP_008; CLFP_009; CLFP_010; CLFP_011; CLFP_012; CLFP_013; CLFP_014; CLFP_015; CLFP_016];
LFP =[LFP, LFP2_temporaire];

% Now, if you check the number of colums it has doubled. 
% You can go on and on like that BUT ...
% What happen if you have 100 files to import ??? Coding is kind of a lazy
% job so instead of writing the same code over and over we gonna do a loop
% and matlab will take care of the rest. 

% For doing a loop we need to know when the loop end,how many iteration do
% we need, and for that we need to have the number of file and also the
% name of the file for loading them. 