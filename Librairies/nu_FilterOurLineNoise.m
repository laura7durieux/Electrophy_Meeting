% This is a script for filtering out line noise in fieldtrip


%% Housekeeping
clear; clc; warning off; tic; 

addpath(fullfile('C:', 'MATLAB', 'fieldtrip'));
% addpath(fullfile('C:', 'MATLAB', 'fieldtrip', 'Neuralynx'));


%% Load your data and turn them into fieldtrip format
load('wf.mat');
data = struct;
data.fsample = 12000;
data.trial{1} = wf;
data.time{1} = 1/data.fsample : 1/data.fsample :  (length(data.trial{1})/data.fsample);
data.label = {'N'};


%% Segment data (to facilitate PSD analysis)
cfg = [];
cfg.length    = 1;
data = ft_redefinetrial(cfg, data);


%% Filter data

data_unfiltered = data; %keep a copy before filtering



% SOS: comment out either configuration 1 or configuration 2
    cfg = [];

    % configuration 1
    cfg.dftfilter     = 'yes';
    cfg.dftfreq       = 50;

    % configuration 2
%     cfg.bsfilter = 'yes';
%     cfg.bsfreq = [49 51];
%     cfg.bsfiltord = 3;
%     cfg.bsinstabilityfix = 'reduce';

data_filtered = ft_preprocessing(cfg, data);



%% PSD analysis
cfg = [];
cfg.method     = 'mtmfft';
cfg.foi        = [1:1:100];
cfg.taper      = 'hanning';
freq_filtered = ft_freqanalysis(cfg, data_filtered);
freq_unfiltered = ft_freqanalysis(cfg, data_unfiltered);


%% Plot
figure;
cfg = [];
cfg.linewidth = 1;
cfg.xlim = [0 100];
cfg.ylim = 'maxmin';
h{1} = subplot(3,1,1); ft_singleplotER(cfg, freq_unfiltered, freq_filtered); title('both');
h{2} = subplot(3,1,2); ft_singleplotER(cfg, freq_unfiltered); title('unfiltered');
h{3} = subplot(3,1,3); ft_singleplotER(cfg, freq_filtered); title('filtered');
linkaxes([h{1} h{2} h{3}], 'xy')

toc;