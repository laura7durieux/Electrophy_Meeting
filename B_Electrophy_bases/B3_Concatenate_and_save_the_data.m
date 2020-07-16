% B3 - concatenate the data + save the progress you made 

% The goal of this script is to resolve this issue :
% If you have several electrophys files save continuously during time (as
% the system I use does. Meaning, it save the electrophy track in file
% of ten minutes, so if I record 20 min I will have two file. 

% I'm sure that you can solve this issue alone but seems most of you will
% work on the same system than me, so it will be usefull if we do it
% together. 

% Okay, so the goal is to load one file, put the variables of interest into
% a new variable and loading a new file, ect... One can ask why we don't
% load all the file at the same time ? You can try, and I quess you will
% see why ;-)

% first we gonna load the first file 
load('D:\Documents\ElectrophySchool\rat13_hab1_part1.mat') % example, you need to replace with your file location

% And we do the same thing than before.
% Delete the variable you don't need 
clearvars -except CLFP_001 CLFP_001_BitResolution CLFP_001_Gain CLFP_001_KHz CLFP_002 CLFP_003 CLFP_004 CLFP_005 CLFP_006 CLFP_007 CLFP_008 CLFP_009 CLFP_010 CLFP_011 CLFP_012 CLFP_013 CLFP_014 CLFP_015 CLFP_016


% this time LFP will be a matrix of channels x times
LFP = [CLFP_001; CLFP_002; CLFP_003; CLFP_004; CLFP_005; CLFP_006; CLFP_007; CLFP_008; CLFP_009; CLFP_010; CLFP_011; CLFP_012; CLFP_013; CLFP_014; CLFP_015; CLFP_016];

% Now, we have stored our first 10 min but we want to add the the second 10
% min. 
% So, we gonna load the second file 
load('D:\Documents\ElectrophySchool\rat13_hab1_part2.mat') % example, you need to replace with your file location
% Be carefull, it will erase the files with the same name in your
% workspace.
% We don't need to attritube once again the variable "srate,
% "ch_bitResolution", ... (it's the same for all files ^^)
clearvars -except LFP CLFP_001 CLFP_001_BitResolution CLFP_001_Gain CLFP_001_KHz CLFP_002 CLFP_003 CLFP_004 CLFP_005 CLFP_006 CLFP_007 CLFP_008 CLFP_009 CLFP_010 CLFP_011 CLFP_012 CLFP_013 CLFP_014 CLFP_015 CLFP_016

% So we need to add it to our LFP matrix at the end, so on the width of the
% matrix because it's channels by times (in other word x axis (or number of colums) is the time)
LFP2_temporaire = [CLFP_001; CLFP_002; CLFP_003; CLFP_004; CLFP_005; CLFP_006; CLFP_007; CLFP_008; CLFP_009; CLFP_010; CLFP_011; CLFP_012; CLFP_013; CLFP_014; CLFP_015; CLFP_016];
LFP =[LFP, LFP2_temporaire];


% I attribute "clearer name" but obviously you can put the name you want 
srate = CLFP_001_KHz*1000; %% Change and store the sampling rate (pass in Hz)
ch_bitResolution = CLFP_001_BitResolution; %% put the bitResolution from the software raw data into a new variable
ch_gain = CLFP_001_Gain; %% put the gain from the software raw data into a new variable

% and delete what we don't need 
clearvars -except LFP srate ch_bitResolution ch_gain

% Now, if you check the number of colums it has doubled. 
% You can go on and on like that BUT ...
% What happen if you have 100 files to import ??? Coding is kind of a lazy
% job so instead of writing the same code over and over we gonna do a loop
% and matlab will take care of the rest. 

% clear everything
clc; % will clear you command windows
clear all; %  will clear your workspace
close all; % will close all the figure oppenned (here we don't have any figure but like that you know the commande)

% For doing a loop we need to know when the loop end, how many iteration do
% we need, and for that we need to have the number of file and also the
% name of the files (for loading them). 

% For doing that we gonna use a new function called uigetfile which gonna
% open a exploratory windows allowing you to select all the file you want
% to open afterwards

% Where are the data
[file,path] = uigetfile('*.mat',...
    'Select All files that you want to concanenate', ...
    'MultiSelect', 'on');
if isequal(file,0) % check if you selected at least one file
    disp('User selected Cancel');
else
    disp(['User selected ', fullfile(path,file)]);
end

% As you can see it will give you the all the names of the files selected
% and the path where you took the files. That is amazing because you will
% have the number of files (so the number of iteration you need to do in
% your loop) and also their names and the pathway to acess it (allowing to
% load the file automatically). 


% Now I think that you should try alone to do the rest of the code for
% concatenate you data.  Neverthe less I will put the solution below, don't
% look if you want to give it a try by yourself. 


%%%%%%%%%%%%%%%%%%%%%%%%% Saving the data %%%%%%%%%%%%%%%%%%%%%%
% for saving the data, you will just need one function : "save(path and name of the file, variables)"

% For instance, if we need to save our LFP variable we just created
path_store = 'D:\Documents\ElectrophySchool';
name_file = 'LFP_20min_rat13_Hab1.mat' ; % the .mat shown to matlab the format of the file you want to save. Be carefull,
% if you don't put it at the end, the saving will not work.

% we also gonna use the 'fullfile' function. We already used it several
% times but I think that I never explain what it does. It puts all the
% inputs you gave to it into a complet pathway. Try it :
fullfile(path_store,name_file)

% Now let's store your LFP with the variables we needs for the analysis
save(fullfile(path_store,name_file),'LFP','srate','ch_bitResolution','ch_gain');

% Your data are saved in the folder 'path' you put in save. You can check
% in the file explorer



%%%%%%%%%%%%%%%%%%% SPOILERS : concatenation solution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%
%%%%
%

% Okay so know we have everything we need to write down the loop alowing to
% cocatenate the data automatically. 

%initializing the variable need to store the lfp
LFP = [];

% the loop for storing the LFP of each file on the continuity of previous
% files 
for i = 1:length(file) % For the numer of file stored in "file" cell array
    load(fullfile(path,file{i})); % load the file of the current iteration
    LFP_temp = [CLFP_001; CLFP_002; CLFP_003; CLFP_004; CLFP_005; CLFP_006; CLFP_007; CLFP_008; CLFP_009; CLFP_010; CLFP_011; CLFP_012; CLFP_013; CLFP_014; CLFP_015; CLFP_016];
    LFP =[LFP, LFP_temp];
end

% now lets take the other variable you gonna need 
% I attribute "clearer name" but obviously you can put the name you want 
srate = CLFP_001_KHz*1000; %% Change and store the sampling rate (pass in Hz)
ch_bitResolution = CLFP_001_BitResolution; %% put the bitResolution from the software raw data into a new variable
ch_gain = CLFP_001_Gain; %% put the gain from the software raw data into a new variable

% and delete what we don't need 
clearvars -except LFP srate ch_bitResolution ch_gain

% tada !! It's done :-)
% So now, you should be able to do it by yourself on your own files :-)

