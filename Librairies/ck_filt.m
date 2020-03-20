function out = ck_filt(data,rate,band,type,order)

% out =  ck_filt(data,rate,band,type)

% returns the DATA sampled at RATE filtered as specified
% by TYPE and BAND:

% TYPE: ('high'/'low'/'band'/'stop')

% BAND: (cuttof/[low high]) In Hz and rate in sec

% ORDER: order of the Butterworth filter (default 3)

% if matrix is given, operates along second dimension

if nargin < 5

   order = 3;

end

if min(size(data))==1

   data = data(:)';

end

%% original filters

switch type

   case 'low'

      [filtb,filta]=butter(order,(band*2)/rate,'low');

      for s=1:size(data,1)

         out(s,:) = filtfilt(filtb,filta,data(s,:));

      end

     

   case 'band'

      [filtb,filta]=butter(order,(band(2)*2)/rate,'low');

      for s=1:size(data,1)

         out(s,:) = filtfilt(filtb,filta,data(s,:));

      end

     

      [filtb,filta]=butter(order,(band(1)*2)/rate,'high');

      for s=1:size(data,1)

         out(s,:) = filtfilt(filtb,filta,out(s,:));

      end

   case 'high'

      [filtb,filta]=butter(order,(band*2)/rate,'high');

      for s=1:size(data,1)

         out(s,:) = filtfilt(filtb,filta,data(s,:));

      end

     

end


end