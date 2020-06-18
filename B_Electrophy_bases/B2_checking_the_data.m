%%%% checking the data (plot and choose the channels to use) %%%%%%%%%%

% like on the last script
% First we need to load the data (I put oen example of the data into the
% data folder for thoses without data to test 
load('C:\Users\laura\Documents\DataElectTemp\rat13_hab1.mat') % example 


% Delete the variable you don't need 
clearvars -except CLFP_001 CLFP_001_BitResolution CLFP_001_Gain CLFP_001_KHz CLFP_002 CLFP_003 CLFP_004 CLFP_005 CLFP_006 CLFP_007 CLFP_008 CLFP_009 CLFP_010 CLFP_011 CLFP_012 CLFP_013 CLFP_014 CLFP_015 CLFP_016

% I attribute "clearer name" but obviously you can put the name you want 
srate = CLFP_001_KHz*1000; %% mets la frequence d'échantillonage dans une autre variable 
ch_bitResolution = CLFP_001_BitResolution; %% put the bitResolution from the software raw data into a new variable
ch_gain = CLFP_001_Gain; %% put the gain from the software raw data into a new variable


% this time LFP will be a matrix of channels x times
LFP = [CLFP_001; CLFP_002; CLFP_003; CLFP_004; CLFP_005; CLFP_006; CLFP_007; CLFP_008; CLFP_009; CLFP_010; CLFP_011; CLFP_012; CLFP_013; CLFP_014; CLFP_015; CLFP_016];

% we trasnform our raw signal into mV vs second 
% Conversion in mv (depending of your recording system)
LFP=double(LFP)*ch_bitResolution/ch_gain/1000; % Convert bit into mV!

% Time 
% How many time is between points
dt = 1/srate;
% Calculation of the total time of the data  
tottime = length(LFP(1,:))/srate;
% Calculation of the vecteur reoresenting the time in sec (it have to be in
% the same length than LFP)
Time = 0:dt:tottime-dt; % (we do minus dt because we beggin the vecteur by 0 so we have a point more than it should be).

% In the case of my data The first three channels are the lateral habenula (LHb),
% the 5 to 7 are in the Hippocampus and the 8 to 10 are the BLA, 11 to 13
% are ACC, the 14 to 16 are the PRL and the 4 is the EMG. 

% So first lets plot all the channels for the LHb.
figure 
subplot(3,1,1) % Allowing to put several plot on one figure separatly
plot(Time,LFP(1,:),'b') % 'b' is the color of the ligne. See the documentation. 
title('Ch n°1') % Put a title on your graph
ylim([-0.5 0.5]) % changing Y scale (first number is the begging of the x axis, the second is the end)
subplot(3,1,2)
plot(Time,LFP(2,:),'b')
title('Ch n°2')
ylim([-0.5 0.5]) % changing Y scale
subplot(3,1,3)
plot(Time,LFP(3,:),'b')
title('Ch n°3')
ylim([-0.5 0.5]) 

% What do you see ? The second channel is very bad ! It's for that we
% absolutly need to check the channels viability before doing any analysis
% ...

% If we do the local referancing between 1 and 2 (what's come in mind first
%, you will have something horrible in the results)

% Let's try to do a local referencing, one good and one bad, for seeing the
% differences

local_good = LFP(1,:)-LFP(3,:);
local_bad = LFP(1,:)-LFP(2,:);

figure
plot(Time,local_bad,'k','DisplayName','With artefact channel'); hold on;
plot(Time,local_good,'b','DisplayName','Without artefact channel'); hold on;
legend

% you see that we obtain something wrong in the black plot ! Because the
% difference between a good signal and a very noisy one is mostly the noise
% ! In fact, will we extract the power (I will not decribe here how we use the 
% power, because the next script will be on that) from both local ref :

% we gonna use chronux toolbox for calculating quickly the spectrogram 
% we just need to apply the filtering and the downsampling first.


local_good_filt = ck_filt(local_good,srate,[0.1 500],'band'); % This is a filter wrote by Nelson Totah 
F = 5; % downsampling factor
new_srate = 1375/F; % in hz
local_good_down = decimate(local_good_filt(1,:),F);

local_bad_filt = ck_filt(local_bad,srate,[0.1 500],'band'); % This is a filter wrote by Nelson Totah 
local_bad_down = decimate(local_bad(1,:),F);


% setting chronux paramiters (just don't care of this part for now)
params.fpass = [1 100]; % in Hz (0.5 to 10) - 0.5 is minimum if we want to use a 4 sec window and see one cycle
params.Fs = new_srate;
k = 9; % num tapers (lower for less frequency leakage, higher for more leakage but smoother spectrum) % and it is a tradeoff with how many time points you have. spectrum is less smooth with many time points.
nw = (k+1)/2;
params.tapers=[nw k];

% Calulate the spectrogram
[S_good,f_good]=mtspectrumc(local_good_down,params); %must be samples by channels
S_smooth_good = fastsmooth(S_good,1000,3,1); % another type of soothing is decimate 

[S_bad,f_bad]=mtspectrumc(local_bad_down,params); %must be samples by channels
S_smooth_bad = fastsmooth(S_bad,1000,3,1); % another type of soothing is decimate 

% Ploting the spectrogram
figure
yyaxis left
plot(f_good,S_smooth_good,'DisplayName','Without artefacts'); hold on;
yyaxis right
plot(f_bad, S_smooth_bad,'DisplayName','With artefacts')
legend
legend boxoff % not putting a square around the legend


% You see there are no more oscillations the the bad local ref (no bump of
% theta for example)
% I hope I convinced you to really check the data even if it's kind of long
% when we have a lot of them.

