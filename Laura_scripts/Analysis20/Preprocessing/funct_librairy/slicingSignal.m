%% Cutting the signal

function [cellCut] = slicingSignal(LFP,New_SR,CuttingTimes)

% Do the time calculation
TimeTot = length(LFP(1,:))/New_SR; % In seconds
PointsInTimes=CuttingTimes*New_SR; % number of matlab points in the cutting time

% Knowing how many hours are available in the LFP signal
HoursAvailable = fix(TimeTot/CuttingTimes); %in hours 

% How many time left after taking the 3hours
TimeLeft = TimeTot - (HoursAvailable*CuttingTimes); % in second
X = ['They are ',num2str(HoursAvailable),' hours in this recording'];
disp(X)
Y = [num2str(TimeLeft),' seconds out of the ',num2str(HoursAvailable),' hours calculated, will be deleted'];
disp(Y)

% Slicing the signal by hour
cellCut={};
for i = 1: HoursAvailable
    cellCut{1,i}=i;
    cellCut{2,i} = LFP(:,(PointsInTimes*(i-1))+1:(i*PointsInTimes));
end
% Main Output = cellCut where the 1 raw is the hour and the 2 rax is the
% data 

