
%% ABOUT THIS FILE
% ----------------------------------------------------------------------
% Parameters setup for control model
% Type-A with Dummy Payload for KAGRA
% Coded by K. Okutomi on 2018/05/17
% ----------------------------------------------------------------------

%% CONSTANTS
pp=2*pi;

%% HARDWARE SETTINGS
% ----------------------------------------------------------------------
%% ACTUATOR NORMALIZATION
% Normalize the actuators using local sensors at 0 Hz
% F0
gain_actIPL = 1;
gain_actIPT = 1;
gain_actIPY = 1;

% GAS
gain_actF0GAS = 1;
gain_actF1GAS = 1;
gain_actF2GAS = 1;
gain_actF3GAS = 1;
gain_actBFGAS = 1;

% BF
gain_actBFL = 1;
gain_actBFT = 1;
gain_actBFV = 1;
gain_actBFR = 1;
gain_actBFP = 1;
gain_actBFY = 1;

% PF
gain_actPFL = 1;
gain_actPFT = 1;
gain_actPFV = 1;
gain_actPFR = 1;
gain_actPFP = 1;
gain_actPFY = 1;

% MN
gain_actMNL = 1;
gain_actMNT = 1;
gain_actMNV = 1;
gain_actMNR = 1;
gain_actMNP = 1;
gain_actMNY = 1;

% IM
gain_actIML = 1;
gain_actIMT = 1;
gain_actIMV = 1;
gain_actIMR = 1;
gain_actIMP = 1;
gain_actIMY = 1;

% TM
gain_actTML = 1;
gain_actTMP = 1;
gain_actTMY = 1;

%% COUPRING MATRIX
% Diagonal part
cMat_BF = eye(6);
cMat_MN = eye(6);
cMat_IM = eye(6);
cMat_TM = eye(3);

% Non-diagonal part

%% CONTROL SETTINGS
% ----------------------------------------------------------------------
%% SENSOR BLENDING
% This part constructs filters for blending LVDT and ACC signals.
% Blending filters are constructed from polynominal expression of a Laplace
% transformed equation (s+w0)^n, where w0 is the blending frequency and n
% is an arbitrary (odd) integer.

% BLENDING FREQUENCY: 50 mHz
% f_blend = 0.05;
% w_blend = f_blend*pp;

% COEFFICIENTS LIST OF POLYNOMINAL EXPRESSION OF (s+w0)^n
% n_blend = 7; % 7th order blending
% nbd = (n_blend+1)/2;
% cf_poly = zeros(1,n_blend+1);
% for n=0:n_blend;
%     cf_poly(n+1)=nchoosek(n_blend,n)*w_blend^(n);
% end

% BLENDING FILTERS
% blend_HP = tf([cf_poly(1:nbd),zeros(1,nbd)],cf_poly);
% blend_LP = tf(cf_poly(nbd+1:n_blend+1),cf_poly);

% BLENDING FILTERS (ZPK EXPRESSION)
% blend_LP = myzpk([0.075+1i*0.0581;0.075-1i*0.0581],[0.3;0.3;0.3;0.3;0.3],66.97);
% blend_HP = myzpk([0.75+1i*0.581;0.75-1i*0.581;0;0;0],[0.3;0.3;0.3;0.3;0.3],1);


%% F0 SENSOR BLENDING
blendGEO_IPL = 0;
blendGEO_IPT = 0;
blendGEO_IPY = 0;
blendLVDT_IPL = 0;
blendLVDT_IPT = 0;
blendLVDT_IPY = 0;

%% CONTROL SERVO:IP
servoIPL = 0;
servoIPT = 0;
servoIPY = 0;
gainIPL = 0;
gainIPT = 0;
gainIPY = 0;

vservoIPL = 0;
vservoIPT = 0;
vservoIPY = 0;
vgainIPL = 0;
vgainIPT = 0;
vgainIPY = 0;

servoHieIPL = 0;
servoHieIPY = 0;
gainHieIPL = 0;
gainHieIPY = 0;

%% CONTROL SERVO GAS 
servoF0GAS = 0;
servoF1GAS = 0;
servoF2GAS = 0;
servoF3GAS = 0;
servoBFGAS = 0;

gainF0GAS = 0;
gainF1GAS = 0;
gainF2GAS = 0;
gainF3GAS = 0;
gainBFGAS = 0;

%% CONTROL SERVO BF
servoBFL = 0;
servoBFT = 0;
servoBFV = 0;
servoBFR = 0;
servoBFP = 0;
servoBFY = 0;
gainBFL = 0;
gainBFT = 0;
gainBFV = 0;
gainBFR = 0;
gainBFP = 0;
gainBFY = 0;

servoHieBFL = 0;
servoHieBFR = 0;
servoHieBFP = 0;
servoHieBFY = 0;
gainHieBFL = 0;
gainHieBFR = 0;
gainHieBFP = 0;
gainHieBFY = 0;

%% CONTROL SERVO PF
servoPFL = 0;
servoPFT = 0;
servoPFV = 0;
servoPFR = 0;
servoPFP = 0;
servoPFY = 0;
gainPFL = 0;
gainPFT = 0;
gainPFV = 0;
gainPFR = 0;
gainPFP = 0;
gainPFY = 0;

servoOL_PFR = 0;
servoOL_PFP = 0;
servoOL_PFY = 0;
gainOL_PFR = 0;
gainOL_PFP = 0;
gainOL_PFY = 0;

servoHiePFL = 0;
servoHiePFP = 0;
servoHiePFY = 0;
gainHiePFL = 0;
gainHiePFP = 0;
gainHiePFY = 0;

%% CONTROL SERVO MN
servoMNL = 0;
servoMNT = 0;
servoMNV = 0;
servoMNR = 0;
servoMNP = 0;
servoMNY = 0;
gainMNL = 0;
gainMNT = 0;
gainMNV = 0;
gainMNR = 0;
gainMNP = 0;
gainMNY = 0;

servoOL_MNR = 0;
servoOL_MNP = 0;
servoOL_MNY = 0;
gainOL_MNR = 0;
gainOL_MNP = 0;
gainOL_MNY = 0;

servoHieMNL = 0;
servoHieMNP = 0;
servoHieMNY = 0;
gainHieMNL = 0;
gainHieMNP = 0;
gainHieMNY = 0;

%% CONTROL SERVO IM
servoIML = 0;
servoIMT = 0;
servoIMV = 0;
servoIMR = 0;
servoIMP = 0;
servoIMY = 0;
gainIML = 0;
gainIMT = 0;
gainIMV = 0;
gainIMR = 0;
gainIMP = 0;
gainIMY = 0;

servoHieIML = 0;
servoHieIMP = 0;
servoHieIMY = 0;
gainHieIML = 0;
gainHieIMP = 0;
gainHieIMY = 0;

%% CONTROL SERVO TM

servoTML = 0;
servoTMP = 0;
servoTMY = 0;
gainTML = 0;
gainTMP = 0;
gainTMY = 0;

servoOL_TML = 0;
servoOL_TMP = 0;
servoOL_TMY = 0;
gainOL_TML = 0;
gainOL_TMP = 0;
gainOL_TMY = 0;

servoISC_TML = 0;
gainISC_TML = 0;
