%FASTCOV Computes covariance matrices for gaussian method.
%
% USAGE
%
%   [COVPRS, COVPR, DIAGCOVPRS, DIAGCOVPR] = FASTCOV(R, NT, NC, MAXNT, NS, TOTNT, BTSPFLAG);
%
% INPUTS
%   R        - response matrix
%   NT       - number of trial per stimulus array
%   NC       - number of cells (must be equal to size(NT,1))
%   MAXNT    - maximum number of trials (must be equal to max(NT) and to size(NT,2))
%   NS       - number of stimuli (must be equal to size(NS,3))
%   TOTNT    - totanl number of trial (must be equal to sum(NT))
%   BTSPFLAG - flag specifying whether the trial/stimulus pairing of the
%              input matrix should be used (flag set to 0) or whether
%              trials should be paired randomly to stimuli (flag different
%              from 0) for bootstapped entropy computation.
%
% OUTPUTS
%   COVPRS     - Covariance matrices of stimulus conditional probabilities.
%                These are stored in a L-by-L-by-NS matrix.
%   COVPR      - Covariance matrix of stimulus unconditional probability of
%                of size L-by-L.
%   DIAGCOVPRS - diagonal of COVPRS
%   DIAGCOVPR  - diagonal of COVPR
%
% REMARKS
%   - The covariance matrices returned by FASTCOV are NOT normalized!
%
%   - FASTCOV computes covariance by subtracting the product of the mean
%     values from the cross-correlation estimate. This procedure is faster
%     compared to the standard covariance estimation method which consists
%     in first subtracting the sample mean and then computing the
%     cross-correlation value. However, it is also more prone to numerical
%     errors arising from the finite precision with which numbers are
%     represented in a computer. For the sake of the estimation of entropy,
%     the speed advantage overcomes the precision loss since, in general,
%     cases for which the numerical errors become significant correspond to
%     cases for which the entropy values are not significant anyways.

% Copyright (C) 2010 Cesare Magri
% Version 1.1.0

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

% ----------
% DISCLAIMER
% ----------
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.