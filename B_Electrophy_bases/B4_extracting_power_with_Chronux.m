%%%%%%%%% B4_ Extracting power with Chronux %%%%%%%%%%%%%%%%%%

% before doing anything we need to apply what we learn on the previous
% scripts.

% First, concatenate and load the files
% Where are the data
[file,path] = uigetfile('*.mat',...
    'Select All files that you want to concanenate', ...
    'MultiSelect', 'on');
if isequal(file,0) % check if you selected at least one file
    disp('User selected Cancel');
else
    disp(['User selected ', fullfile(path,file)]);
end

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

% technically you can also load the file you saved before (in the previous
% script) but I think it will be usefull to have all the "preprocess" in
% one file

% we trasnform our raw signal into mV vs second 
% Conversion in mv (depending of your recording system)
LFP=double(LFP)*ch_bitResolution/ch_gain/1000; % Convert bit into mV!

% filtering and downsampling all the channels

for i = 1:length(LFP(:,1))
    LFP_filtered(i,:) = ck_filt(LFP(i,:),srate,[0.1 500],'band'); % This is a filter wrote by Nelson Totah 
end

F = 5; % downsampling factor
new_srate = 1375/F; % in hz
for i = 1:length(LFP(:,1))
    LFP_downsampled(i,:) = decimate(LFP_filtered(i,:),F);
end


% It will take some time to run the code on top (that is normal)
% here you can save the LFP and like that you will never needs to wait
% during preprocessing stages 

path_store = 'D:\Documents\ElectrophySchool';
name_file = 'LFP_20min_rat13_Hab1_preprocessed.mat' ; % the .mat shown to matlab the format of the file you want to save. 

% Now let's store your LFP with the variables we needs for the analysis
save(fullfile(path_store,name_file),'LFP','srate','ch_bitResolution','ch_gain');


% We gonna focus on the hippocampus for now 
% In the case of my data The first three channels are the lateral habenula (LHb),
% the 5 to 7 are in the Hippocampus and the 8 to 10 are the BLA, 11 to 13
% are ACC, the 14 to 16 are the PRL and the 4 is the EMG. 
dHCPC = LFP_downsampled(8:10,:);

% Time 
dt = 1/srate; 
tottime = length(dHCPC(1,:))/srate;
Time = 0:dt:tottime-dt; 

% So first lets plot all the channels for the dHPC.
figure 
subplot(3,1,1) % Allowing to put several plot on one figure separatly
plot(Time,dHCPC(1,:),'b') % 'b' is the color of the ligne. See the documentation. 
title('Ch n°1') % Put a title on your graph
ylim([-0.5 0.5]) % changing Y scale (first number is the begging of the x axis, the second is the end)
subplot(3,1,2)
plot(Time,dHCPC(2,:),'b')
title('Ch n°2')
ylim([-0.5 0.5]) % changing Y scale
subplot(3,1,3)
plot(Time,dHCPC(3,:),'b')
title('Ch n°3')
ylim([-0.5 0.5]) 

% gonna do the local ref 








