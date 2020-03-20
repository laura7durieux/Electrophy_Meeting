%% Main script for preprocessing 
% lauch matlab timer 
tic
% Where are the data
[file,path] = uigetfile('*.mat',...
    'Select All files that you want to concanenate', ...
    'MultiSelect', 'on');
if isequal(file,0)
    disp('User selected Cancel');
else
    disp(['User selected ', fullfile(path,file)]);
end

for i=1:length(file)
    eval(['file' num2str(i) ' = file(1,i);']);
end


%% Localisation of saving data

[fileSav,pathSav] = uiputfile('Select where to save the data');


%% Info from the user 
GenParams.Rat=input('Which is the rat number ?');
GenParams.Session=categorical(cellstr(input('What session do you analyse ? (HAB1,HAB2,HAB3,StressBL,Stress1,Stress2)','s')));
if GenParams.Session == 'Stress1' | GenParams.Session == 'Stress2'
    GenParams.SubSession = categorical(cellstr(input('What part of the stress protocol do you analyse ? (BL,S1,S2,PS1,PS2)','s')));
else 
    GenParams.SubSession = categorical(cellstr('empty'));
    disp('Habituation will be analyse continuously')
end
GenParams.HeadStage=input('What is the number of the headstage for this extraction ? (1 or 2)');
dHPCExample = input('Enter a dHPC channel okay as example for plot (5 6 7)');

% Retrieved data from Excel file on the viability of the channels 
[ChParams] = retriveElect3Info(GenParams.Rat,GenParams.Session);

%% Load the data and put them together 
[LFP,ElectParams] = Concatenate_data(path,file,GenParams.HeadStage);

% Clear variables except the one cited
clearvars -except LFP struct_data GenParams ChParams ElectParams dHPCExample pathSav

%% Set electrophy settings
ElectParams.SR = ElectParams.ch_KHz*1000;
LFP_Raw = LFP; % For keeping the raw Data

%% Do the conversion en mV and time calculation
LFP_converted=double(LFP)*ElectParams.ch_bitResolution/ElectParams.ch_gain/1000; % Convert bit into mV!

dt = 1/ElectParams.SR;
tottime = length(LFP_converted)/ElectParams.SR;
ElectParams.time = 0:dt:tottime-dt;

%% Filtering
[ElectParams.Nchans, ElectParams.Nsamples] = size(LFP);
LFP_filtered=zeros(ElectParams.Nchans,ElectParams.Nsamples);
% Turn on parallele pool processing 
parpool;
% Filtering the Data - Nelson Filter
parfor k=1:ElectParams.Nchans
    LFP_filtered(k,:) = ck_filt(LFP_converted(k,:),1375,[0.1 500],'band');
end
delete(gcp('nocreate'));

% comparison plot of filter application (dHPC)
filtfig = figure;
figure(filtfig)
plot(ElectParams.time,LFP_converted(dHPCExample,:),'b')
hold on
plot(ElectParams.time,LFP_filtered(dHPCExample,:),'r')
legend('Without filter','With filter')
title('Comparison plot of filter application (LF=500, HF=0.1, dHPC)')
ylabel('en mV')
xlabel('en second')

%% Downsampling 
ElectParams.F = 5; % downsampling factor


ElectParams.New_SR = ElectParams.SR/ElectParams.F; % in hz
ElectParams.New_NR = ElectParams.New_SR/2; % in hz
LFP_downsampled = zeros(ElectParams.Nchans,ceil(ElectParams.Nsamples/ElectParams.F));
parpool;
parfor k=1:ElectParams.Nchans
    LFP_downsampled(k,:) = decimate(LFP_filtered(k,:),ElectParams.F); % Fonction for downsampling 
end
delete(gcp('nocreate'));

% calulation of the new time vector
dt = 1/ElectParams.New_SR;
tottime = length(LFP_downsampled)/ElectParams.New_SR;
ElectParams.New_time = 0:dt:tottime-dt;

% comparison plot of filter application (dHPC)
DSfig = figure;
figure(DSfig)
plot(ElectParams.time,LFP_filtered(dHPCExample,:),'b')
hold on
plot(ElectParams.New_time,LFP_downsampled(dHPCExample,:),'r')
legend('Without downsampling','With downsampling')
title('Comparison plot of Downsampling "decimate" application (F=5, dHPC)')
ylabel('en mV')
xlabel('en second')

%% Error plot between before and after filtering and downsampling sur dHPC example
diffig = figure;
figure(diffig)
plot(ElectParams.time,LFP_converted(dHPCExample,:),'b')
hold on
plot(ElectParams.New_time,LFP_downsampled(dHPCExample,:),'r')
legend('Before processing','After Processing')
title('Comparison plot after and before preprocessing (dHPC)')
ylabel('en mV')
xlabel('en second')

%% Automatic local referencing 

[LFP_local]=localRef(ChParams.RatData,ChParams.Structures,LFP_downsampled);

Localfig = figure;
figure(Localfig)
plot(ElectParams.New_time,LFP_downsampled(dHPCExample,:),'b')
hold on
plot(ElectParams.New_time,LFP_local(3,:),'r')
legend('Before local referencing','After local referencing')
title('Comparison plot after and before the local referencing (dHPC)')
ylabel('en mV')
xlabel('en second')

%% Cutting the signal

if GenParams.SubSession == 'S1' || GenParams.SubSession == 'S2'
    Size = length(LFP_local(1,:))/ElectParams.New_SR/60; % en minute
    message = ['The signal is ',num2str(Size),' minutes long, no need to cut it by hours'];
    disp(message)
else
    CuttingTimes = 3600; % in s
    [DatabyHours] = slicingSignal(LFP_local,ElectParams.New_SR,CuttingTimes);
end

%% Saving data and plot

nameFolder = [num2str(GenParams.Rat),char(GenParams.Session),char(GenParams.SubSession)];
mkdir(pathSav,nameFolder) % folder creation

namePlotA = ['FilteringPlot',num2str(GenParams.Rat),char(GenParams.Session),char(GenParams.SubSession),'.fig'];
namePlotB = ['DownsamplingPlot',num2str(GenParams.Rat),char(GenParams.Session),char(GenParams.SubSession),'.fig'];
namePlotC = ['ErrorProcessPlot',num2str(GenParams.Rat),char(GenParams.Session),char(GenParams.SubSession),'.fig'];
namePlotD = ['LocalRefPlot',num2str(GenParams.Rat),char(GenParams.Session),char(GenParams.SubSession),'.fig'];


saveas(filtfig,fullfile(pathSav,nameFolder,namePlotA));
saveas(DSfig,fullfile(pathSav,nameFolder,namePlotB));
saveas(diffig,fullfile(pathSav,nameFolder,namePlotC));
saveas(Localfig,fullfile(pathSav,nameFolder,namePlotD));

clearvars -except ChParams DatabyHours ElectParams GenParams LFP_converted LFP_local pathSav nameFolder

nameData = ['Data',num2str(GenParams.Rat),char(GenParams.Session),char(GenParams.SubSession),'.mat'];
save(fullfile(pathSav,nameFolder,nameData))

% end of the matlab timer
toc
