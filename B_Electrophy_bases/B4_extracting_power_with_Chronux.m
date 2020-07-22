%%%%%%%%% B4_ Extracting power with Chronux %%%%%%%%%%%%%%%%%%

%% Preprocessing
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
dt = 1/new_srate; 
tottime = length(dHCPC(1,:))/new_srate;
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

dHPC_local = dHCPC(1,:)-dHCPC(2,:); % I choose the 1 and 2 channels but you could do it with every pair. 

figure 
plot(Time,dHPC_local,'b') % 'b' is the color of the ligne. See the documentation. 
title('Local referenced signal for the dHPC') % Put a title on your graph
ylim([-0.2 0.2]) % changing Y scale (first number is the begging of the x axis, the second is the end)


%% The spectrogram power x frenquency
% first we gonna do a spectrogram for checking where are the pic of
% frenquencies using Chronux (you can find on internet chronux manual if
% you want to see how the toolbox could be usefull)
% Warning, you need the toolbox chronux in your paths matlab. I put the
% toolbox chronux I use in the librairy folder, so if you put it your path,
% it should be working. 

% setting chronux paramiters (need to be precise matlab structure as follow) 
% set the frenquency band you want to use :
params.fpass = [1 100]; % in Hz (0.5 to 10) - 0.5 is minimum if we want to use a 4 sec window and see one cycle
% set the srate 
params.Fs = new_srate;
% set the tapers 
k = 9; % num tapers (lower for less frequency leakage, higher for more leakage but smoother spectrum) 
% and it is a tradeoff with how many time points you have. spectrum is less smooth with many time points.
nw = (k+1)/2;
params.tapers=[nw k];

% Calulate the spectrogram with chronux function
[S,f]=mtspectrumc(dHPC_local,params);
% It give you 2 outputs :
% S represent the power (by frenquencies)
% f represent the frenquencies extracted 
% This function don't extract the power in time. It just give you the power
% by frenquencies 

% Ploting the spectrogram
figure
plot(f,S);

% you can see a pick in Theta band and a little one at gamma band.
% but as you can see, is not that clean ... So let's try to smooth it a bit. 
S_smooth = fastsmooth(S,1000,3,1); % another type of soothing like decimate (see Nelson function for more)

% Ploting the spectrogram
figure
plot(f,S,'k','DisplayName','Raw');hold on;
plot(f,S_smooth,'r','DisplayName','Smoothed','LineWidth',2);
legend

% The red line is better, isn't it ?
% Now, most of poeple normalyze the power. So we gonna do the same.
% The normalisation should help to comparate individus because all of them
% have not the same power at a baseline level. Than totaly normal. 
% A numerous way to normalize exist ... The first one is to normalize on a baseline as the differencies of the power
% between the baseline and the target part on the same rat. But for that
% you have to choose a perfect baseline. Another way to normalyze is to
% change the power into decibel (dB) using logarythm function. The last one I know of, is the Z-transform. Is one will
% normalize the signal using the standart deviation of the one considered. 

% Let's try to normalyze into decibel first
S_dB = 10*log10(S_smooth);

% Ploting the spectrogram
figure
yyaxis right
plot(f,S,'k','DisplayName','Raw');hold on;
plot(f,S_smooth,'r','DisplayName','Smoothed','LineWidth',2);
yyaxis left
plot(f,S_dB,'b','DisplayName','dB normalization','LineWidth',2);
legend

% because we had choose to extract the frenquencies from 1 to 100, it give
% some error drops at this to freqs... So we gonna cut this part 

figure
xlim([1.1 99])
yyaxis right
plot(f,S,'k','DisplayName','Raw');hold on;
plot(f,S_smooth,'r','DisplayName','Smoothed','LineWidth',2);
yyaxis left
plot(f,S_dB,'b','DisplayName','dB normalization','LineWidth',2);
legend
datacursormode on % Allow you to clik on the line and see the values
hold off;

% awesome ! Now we can check where are our picks exactly ...
% the first pick is at 7.3 (theta band) and the second is at 55.3 (middle
% of gamma band).
% We also see in the spectrogram that we don't have any 50 HZ, so no
% electrical noise.

% Let's try to use the Z transform as normalization
S_Z = bsxfun(@rdivide,bsxfun(@minus,S_smooth',mean(S_smooth',2)),std(S_smooth',0,2)); % z-scored within each frequency bin by taking mean and std of entire recording at that particular freq bin 

% This line is kind of complicated ... But you can divide it like that :
% temp = S_smooth - mean(S_smooth),2); S minus its mean
% Z_tranform_applyed  = rdivide(temp, std(S_smooth,0,2)); % The result
% just above divided by the standart deviation

figure
xlim([1.1 99])
yyaxis right
hold on;
plot(f,S_Z,'r','DisplayName','Z transformed','LineWidth',2);
yyaxis left
plot(f,S_dB,'b','DisplayName','dB normalization','LineWidth',2);
legend
datacursormode on % Allow you to clik on the line and see the values
hold off;

% as you can see the Z transform gave you something even more clear, but it
% crush a little bit the gamma we seen before. 
% Each normalization will give you something slitly different... But if you
% use alway the same normalisation across your data, you should have the
% same "differencies" between your recording or your rats. 

% Now let's try to higthlight the pic you have in the spectrogram
S_Richer_Z =S_Z.*f; % enhance power from Richer and all 2017

figure
xlim([1.1 99])
yyaxis right
hold on;
plot(f,S_Z,'r','DisplayName','Z transformed','LineWidth',2);
yyaxis left
plot(f,S_Richer_Z,'r--','DisplayName','Richer from Ztransform','LineWidth',2);
plot(f,S_dB,'b','DisplayName','dB normalization','LineWidth',2);
legend
datacursormode on % Allow you to clik on the line and see the values
hold off;

% So what do you think ? I think that is pretty clear at least for me. 
% But you can also let the spectrogram with the raw data (but with the smoothing) if you don't want
% to comparate between rats. 


%% Spectrogram over time

% We gonna add the time in the "equation". 
% for that we gonna use another function from chronux

% we gonna use the same chronux paramiters than before as :
% set the frenquency band you want to use :
params.fpass = [1 100]; % in Hz (0.5 to 10) - 0.5 is minimum if we want to use a 4 sec window and see one cycle
% set the srate 
params.Fs = new_srate;
% set the tapers 
k = 9; % num tapers (lower for less frequency leakage, higher for more leakage but smoother spectrum) 
% and it is a tradeoff with how many time points you have. spectrum is less smooth with many time points.
nw = (k+1)/2;
params.tapers=[nw k];

% And we gonna add these paramiters which will define how to analyse over
% time
moving_win=2; % size of the windows to analyse 
win_shift=0.1; % size of the "pad of the movinf window"
% Chonux will do the fast fourier transform on the window of the 2 first
% second, then will moved of 0.1 s and annalyse the 2 seconds form, and
% continue until all the signal over time is done. 

% define the error
params.err =[1 0.01];

[S_time,t,f_time,Serr]=mtspecgramc(dHPC_local,[moving_win win_shift],params);

figure
plotsig(S_time,0,t,f_time); axis xy; colorbar;colormap jet;title('Sectogram over time for dHPC (0-100)')

% That is pretty clear ! You can see a theta band :-)
% But we can't see realy well the gamma band... That is normal because the
% higher are the frenquencies, the lower are the power (because the power
% the square of the amplitude and the gamma wave are smaller than theta
% wave). 

% Let's try to nomalyse that using the Z-transform we now.
% Try by yourself before looking at the solution bellow. It will be a good
% exercice to see if you understand the format of the data and what you can
% do with it. And try to do plots comparing the results you have (raw
% signal vs Z-transformed signal)








%%%%%%%% SPOILERS NORMALIZATION %%%%%%%%%
%%%
%




% go for applying the Z tranform (freq axis)

 S_time_Z = bsxfun(@rdivide,bsxfun(@minus,S_time,mean(S_time,2)),std(S_time,0,2));

figure
yyaxis left
plot(f_time,mean(S_time_Z), 'b', 'DisplayName', 'Z transform'); hold on
yyaxis right
plot(f_time,mean(S_time), 'r', 'DisplayName', 'Raw');

figure
subplot(211)
plotsig(S_time,0,t,f_time); axis xy; colorbar; colormap jet; title('Sectogram over time for dHPC (0-100)')
subplot(212)
plotsig(S_time_Z,0,t,f_time); axis xy; colorbar; colormap jet; title('Sectogram over time -Z tranform - for dHPC (0-100)')




