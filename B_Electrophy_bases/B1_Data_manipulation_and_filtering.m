%%% B1 - B1_Data_manipulation (filtering & downsampling & local referencing)

% First we need to load the data (I put oen example of the data into the
% data folder for thoses without data to test 
load('D:\Documents\My_GitHub\Electrophy_Meeting\Data\rat13_hab1.mat') % example 


% Delete the variable you don't need 
clearvars -except CLFP_001 CLFP_001_BitResolution CLFP_001_Gain CLFP_001_KHz CLFP_002 CLFP_003 CLFP_004 CLFP_005 CLFP_006 CLFP_007 CLFP_008 CLFP_009 CLFP_010 CLFP_011 CLFP_012 CLFP_013 CLFP_014 CLFP_015 CLFP_016

% I attribute "clearer name" but obviously you can put the name you want 
srate = CLFP_001_KHz*1000; %% mets la frequence d'échantillonage dans une autre variable 
ch_bitResolution = CLFP_001_BitResolution; %% put the bitResolution from the software raw data into a new variable
ch_gain = CLFP_001_Gain; %% put the gain from the software raw data into a new variable

% For the example we will only take the 2 first channels recording both
% into the LHb
LFP = [CLFP_001 ; CLFP_003]; % Now you may know that it put both line into a matrix egal 2x length of the electrophy signal
% the raw represente the channels

% Plot example 
figure;
subplot(211)
plot(LFP(1,:))
title('Ch 1')
ylabel('in bit')
xlabel('in point')
subplot(212)
plot(LFP(2,:))
title('Ch 3')
ylabel('in bit')
xlabel('in point')

%Now we will plot with time en coverte to mV

% Conversion in mv (depending of your recording system)
LFP=double(LFP)*ch_bitResolution/ch_gain/1000; % Convert bit into mV!

% Time 
% How many time is between points
dt = 1/srate;
% Calculation of the total time of the data  
tottime = length(LFP)/srate;
% Calculation of the vecteur reoresenting the time in sec (it have to be in
% the same length than LFP)
Time = 0:dt:tottime-dt; % (we do minus dt because we beggin the vecteur by 0 so we have a point more than it should be).

% Plot with the conversion into mV and with the time in sec 
figure;
subplot(211)
plot(Time,LFP(1,:))
title('Ch 1')
ylabel('in mV')
xlabel('in second')
subplot(212)
plot(Time,LFP(2,:))
title('Ch 3')
ylabel('in mV')
xlabel('in second')

% Application du filtre de Nelson
LFP_filtered = ck_filt(LFP,srate,[0.1 500],'band'); % This is a filter wrotte by Nelson Totah 
% this filter take away the frequencies out of the range 0.1-500
% Be carefull you need to have the folder librairies added to you path for
% calling Nelson's function


% We can plot with and without filter 
figure 
plot(Time,LFP(1,:),'b')
hold on
plot(Time,LFP_filtered(1,:),'r')
legend('With filter','Without filter')
title('Comparing with and without filter')
ylabel('in mV')
xlabel('in second')

% the process takes some time so we can downsampled your data for seepind
% the process 
% in my data I have 1375 points per second as sampling rate
% but for our analysis juste 200 should be enougth (allow to analyse
% frenquencies from 0 to 100Hz)
% So we can divide uor number of point by 5
% lower sampling rate to 2x the highest frequnecy that you want to look at
% for LFP1
F = 5; % downsampling factor
new_srate = 1375/F; % in hz
LFP_downsampled = decimate(LFP_filtered(1,:),F);
LFP_downsampled2 = decimate(LFP_filtered(2,:),F);
% then put them back together 
LFP_downsampled = [LFP_downsampled;LFP_downsampled2];

% We can plot the results and the comparaison but we need to modifie the
% time vector because we changed the sample rate
dt = 1/new_srate;
tottime = length(LFP_downsampled(1,:))/new_srate;
Time_downsampled = 0:dt:tottime-dt; % (we do minus dt because we beggin the vecteur by 0 so we have a point more than it should be).

% and plot
figure 
plot(Time,LFP_filtered(1,:),'b')
hold on
plot(Time_downsampled,LFP_downsampled(1,:),'r')
legend('Without downsampling','With downsampling')
title('Comparing with and without dowsampling')
ylabel('in mV')
xlabel('in second')



% Next local reference (limit the volume conduction)
LFPnet = [LFP_downsampled(2,:)] - [LFP_downsampled(1,:)];
% We can also writte it like that :
LFP1 = LFP_downsampled(2,:);
LFP2 = LFP_downsampled(1,:);
LFPnet = LFP2 - LFP1;
% LFPnet is the same length than LFP 

%We can comparaire the effect of our calculation 
figure 
plot(Time_downsampled,LFP1,'b')
hold on
plot(Time_downsampled,LFPnet,'r')
legend('before local referencing','after local referencing')
title('first derivation comparaison')
ylabel('in mV')
xlabel('in second')


% your turn, you can try to use your own data or using others channels into
% this recording 
% channels 1-3 are LHb
% channels 5-7 are dHPC
% channels 8-10 are BLA
% channems 11-13 are ACC
% channels 14-16 are PRL 
% enjoy and be carefull some of the channels are full of artefacts (I will
% no say witch on because the next script I will wrotte will be on
% artefacts ^^) but you can try by ourself to manage them ;-)


