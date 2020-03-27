
function [SW_way_better,time]=fake_not_so_good_LFP(reap)

% inputs
srate = 1000; % sampling rate of 1 kHz
time  = 0:1/srate:100; 

% frequencies calculation
freq = zeros(1,reap);
for i = 1:length(freq)
    freq(i) = floor(rand()*100);
end

% amplitude calculation
amp = zeros(1,reap);
for i = 1:length(amp)
    amp(i) = round(rand()*10,1);
end

% calculation of diferente random sine wave
SW_inTime = zeros(reap,length(time));
for i = 1:length(amp)
    RandStart = floor(rand()*100000);
    RandEnd = floor(rand()*100000);
    
    if RandStart < RandEnd 
        temp = amp(1,i).*sin(2*pi*freq(1,i).*time);
        TimesPoints = fix(RandStart:RandEnd);
        SW_inTime(i, TimesPoints) = temp(1,TimesPoints);
    elseif RandStart > RandEnd
        temp = amp(1,i).*sin(2*pi*freq(1,i).*time);
        TimesPoints = fix(RandEnd:RandStart);
        SW_inTime(i,TimesPoints) = temp(1,TimesPoints);
    else 
        disp('Start and Stop are equal or the length of the rand is too short...')
    end
end

% sum of the random sine wave
SW_way_better = sum(SW_inTime);



