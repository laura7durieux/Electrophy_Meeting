function [HR, HRS, HlR, HlRS, HiR, HiRS, ChiR, HshR, HshRS] = gaussian_method_v7_1_0(R, pars)
%GAUSSIAN_METHOD_V7_1_0 Estimate entropy values using the Gaussian Method.
%
% ---------
% ARGUMENTS
% ---------
% R    - response matrix
% pars - parameters structure

%   Copyright (C) 2009 Cesare Magri
%   Version 7.1.0

% -------
% LICENSE
% -------
% This software is distributed free under the condition that:
%
% 1. it shall not be incorporated in software that is subsequently sold;
%
% 2. the authorship of the software shall be acknowledged and the following
%    article shall be properly cited in any publication that uses results
%    generated by the software:
%
%      Magri C, Whittingstall K, Singh V, Logothetis NK, Panzeri S: A
%      toolbox for the fast information analysis of multiple-site LFP, EEG
%      and spike train recordings. BMC Neuroscience 2009 10(1):81;
%
% 3.  this notice shall remain in place in each source file.

BIASFUNC = @gaussian_bias;

% HiR, HiRS and ChiR are not computed for the gaussian case, null values
% are returned instead:
HiR  = NaN;
HiRS = NaN;
ChiR = NaN;

% We have to recompute Nc, Nt, maxNt (in the case this routine is called by
% quadratic extrapolation)
Nt    = pars.Nt;
Nc    = size(R,1);
maxNt = size(R,2);
totNt = sum(Nt);
Ns    = pars.Ns;

logOf2times2 = 2*log(2);
logOf2piTimesExp1 = log(2*pi*exp(1));

lind = findtrial(Nt, maxNt, Ns);
mask = false(size(R,2), size(R,3));
mask(lind) = true;

% H(R) and H_lin(R) -------------------------------------------------------
if pars.doHR || pars.doHlR

    % Removing mean:
    meanRvec = mean(R(:,mask),2);
    Rvec = R(:,mask) - meanRvec(:,ones(totNt,1));

    covPr = (Rvec * Rvec') ./ (totNt-1);
end

% H(R)
if pars.doHR
    HR = (Nc * logOf2piTimesExp1 + log(det(covPr))) / logOf2times2;

    % Bias correction:
    if pars.biasCorrNum==3
        HRbias = BIASFUNC(totNt, Nc);
        HR = HR - HRbias;
    end
else
    HR = 0;
end

% H_lin(R)
if pars.doHlR
    HlR = (Nc * logOf2piTimesExp1 + sum(log(diag(covPr)), 1)) / logOf2times2;

    % Bias correction:
    if pars.biasCorrNum==3
        HlRbias = Nc * BIASFUNC(totNt, 1);
        HlR = HlR - HlRbias;
    end
else
    HlR = 0;
end


% H(R|S) and H_lin(R|S) ---------------------------------------------------
if pars.doHRS || pars.doHlRS
    
    % Removing mean
    meanR = sum(R.*permute(mask(:,:,ones(Nc,1)), [3 1 2]), 2) ./ permute(Nt(:, ones(Nc,1)), [2 3 1]);
    Rzeromean = R - meanR(:, ones(maxNt,1), :);
    
    if Nc==1 
        % HlRS is never computed for Nc==1, if we got here it's cause we
        % need to compute H(R|S):
        covPrsMat = covPrsForSingletonNc(Rzeromean, Nt, mask, maxNt, Ns);

        HRS  = (Nc * logOf2piTimesExp1 + log(covPrsMat(:))) / logOf2times2;

        HlRS = 0;

        % Bias correction:
        if pars.biasCorrNum==3
            HRSbias = BIASFUNC(Nt, 1);
            HRS = HRS - HRSbias;
        end
    else    
        HRS  = zeros(Ns,1);
        HlRS = zeros(Ns,1);
        
        for s=1:Ns
            covPrs = Rzeromean(:, 1:Nt(s), s) * Rzeromean(:, 1:Nt(s), s).' ./ (Nt(s)-1);

            if pars.doHRS
                detCovPrs = det(covPrs);

                HRS(s) = (Nc * logOf2piTimesExp1 + log(detCovPrs)) / logOf2times2;

                % Bias correction:
                if pars.biasCorrNum==3
                    HRSbias = BIASFUNC(Nt(s), Nc);
                    HRS(s) = HRS(s) - HRSbias;
                end
            end;

            if pars.doHlRS
                diagCovPrs = diag(covPrs);

                HlRS(s) = (length(diagCovPrs) * logOf2piTimesExp1 + sum(log(diagCovPrs))) / logOf2times2;

                % Bias correction:
                if pars.biasCorrNum==3
                    HlRSbias = Nc * BIASFUNC(Nt(s), 1);
                    HlRS(s) = HlRS(s) - HlRSbias;
                end
            end
        end
    end

    if ~pars.doHRS
        HRS = 0;
    end

    if ~pars.doHlRS
        HlRS = 0;
    end

else
    HRS  = 0;
    HlRS = 0;
end

% H_sh(R) and H_sh(R|S) ---------------------------------------------------
if pars.doHshR || pars.doHshRS

    Rsh = shuffle_R_across_cells(R, Nt);

    if pars.doHshR
        % Removing mean:
        meanRshvec = mean(Rsh(:,mask),2);
        Rshvec = Rsh(:,mask) - meanRshvec(:,ones(totNt,1));
        
        covPshr = (Rshvec * Rshvec') ./ (totNt-1);
    
        HshR = (Nc * logOf2piTimesExp1 + log(det(covPshr))) / logOf2times2;
        
        % Bias correction:
        if pars.biasCorrNum==3
            HshRbias = BIASFUNC(totNt, Nc);
            HshR = HshR - HshRbias;
        end
    else
        HshR = 0;
    end

    % Remark: HshRS not computed for Nc==1
    if pars.doHshRS
        % Removing mean
        meanRsh = sum(Rsh.*permute(mask(:,:,ones(Nc,1)), [3 1 2]), 2) ./ permute(Nt(:, ones(Nc,1)), [2 3 1]);
        Rsh = Rsh - meanRsh(:,ones(maxNt,1),:);
    
        HshRS = zeros(Ns,1);
        for s=1:Ns
            covPshrs = Rsh(:, 1:Nt(s), s) * Rsh(:, 1:Nt(s), s).' ./ (Nt(s)-1);
            detCovPshrs = det(covPshrs);
            
            HshRS(s) = (Nc * logOf2piTimesExp1 + log(detCovPshrs)) / logOf2times2;
        end
        
        % Bias correction:
        if pars.biasCorrNum==3
            HshRSbias = BIASFUNC(Nt(:), Nc);
            HshRS = HshRS - HshRSbias;
        end
    else
        HshRS = 0;
    end

else
    HshR  = 0;
    HshRS = 0;
end


function covPrs = covPrsForSingletonNc(R, Nt, mask, maxNt, Ns)
    
% Removing first singleton dimension:
R2D = zeros(maxNt, Ns);
R2D(mask) = R(1,mask);

% Computing the variance (R.*R faster than R.^2):
covPrs = (sum(R2D.*R2D,1)) ./ (Nt.' - 1);