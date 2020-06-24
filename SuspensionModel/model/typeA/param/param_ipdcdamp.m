
%% ABOUT THIS FILE
% ----------------------------------------------------------------------
% Parameters setup for control model
% Coded by K. Miyo on 2019/08/27 
% This parameter file is based on the file coded by K. Okutomi on 2018/05/17 for Dummy Payload
% ----------------------------------------------------------------------

%% CONSTANTS
pp=2*pi;
%
gainGndL = 0; % Disconnect 
gainGndT = 0; % Disconnect 
gainGndV = 0; % Disconnect 
gainGndY = 0; % Disconnect 
%% HARDWARE SETTINGS
% ----------------------------------------------------------------------
%% ACTUATOR NORMALIZATION
% Normalize the actuators using local sensors at 0 Hz
% F0
gain_actIPL = 1./0.0049;
gain_actIPT = 1./0.0049;
gain_actIPY = 1./0.009;

% GAS
gain_actGASF0 = 1./4.9922e-4;
gain_actGASF1 = 1./6.1190e-4;
gain_actGASF2 = 1./7.6050e-4;
gain_actGASF3 = 1./9.9399e-4;
gain_actGASBF = 1./0.0014;

% BF
gain_actBFL = 1./0.0073;
gain_actBFT = 1./0.0073;
gain_actBFV = 1./0.0029;
gain_actBFR = 1./0.0155;
gain_actBFP = 1./0.0155;
gain_actBFY = 1./3.8733;

% MN
gain_actMNL = 1./8.0767e-4;
gain_actMNT = 1./8.0767e-4;
gain_actMNV = 1./2.8364e-5;
gain_actMNR = 1./0.1286;
gain_actMNP = 1./0.1286;
gain_actMNY = 1./0.3862;

% IM
gain_actIML = 1./0.0020;
gain_actIMT = 1./0.0020;
gain_actIMV = 1./3.1558e-5;
gain_actIMR = 1./0.1288;
gain_actIMP = 1./0.1290;
gain_actIMY = 1./0.4258;

% TM
gain_actTML = 1./0.0042;
gain_actTMP = 1./0.1385;
gain_actTMY = 1./0.5427;

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
% ----------------------------------------------------------------------
blendGEO_IPL = 0;
blendGEO_IPT = 0;
blendGEO_IPY = 0;
blendLVDT_IPL = 1;
blendLVDT_IPT = 1;
blendLVDT_IPY = 1;

%% CONTROL SERVO:IP 
% ----------------------------------------------------------------------

% IP SERVO     
% Implimented Filter
ipservo_L_dcdamp  = myzpk([0.006465599280118018+1i*2.039989753903271; 0.006465599280118018-1i*2.039989753903271; 0.07000000000001788; 0.07000000000001788],...
 [0.2044602016318382+i*2.029728066995419; 0.2044602016318382-i*2.029728066995419; 3.3333-1i*2.211080000000662; 3.3333+1i*2.211080000000662; 3.571430000000035+1i*3.499269999999913; 3.571430000000035-1i*3.499269999999913; 0.000999999999952244],...
 17281.44*203.92);
ipservo_L_dcdamp    = myzpk([0.04;0.04;0.04;0.04;],...
			    [0.001;0.09;0.09;0.09;],...
                            1e0);
ipservo_L_dc        = myzpk([0.005;0.005;],...
                                         [0.0001;10;10;],...
                            1.15e4*power(10,-0.25));
%servoIPL = ipservo_L_dcdamp;
%servoIPL = ipservo_L_dc;
servoIPL = myzpk([0.01000000000005441;0.01000000000005441],...
    [9.238795325112847+i*3.826834323650134;9.238795325112847-i*3.826834323650134;
    3.82683432365084+i*9.238795325112751;3.82683432365084-i*9.238795325112751;
    1.000000188357968e-05;9.999999999998048;9.999999999999945],4896314956564.51*0.1*0.5)
servoIPT = 0;
servoIPY = 0;

gainIPL = -1;
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
% ----------------------------------------------------------------------
servoGASF0 = 0;
servoGASF1 = 0;
servoGASF2 = 0;
servoGASF3 = 0;
servoGASBF = 0;

gainGASF0 = 0;
gainGASF1 = 0;
gainGASF2 = 0;
gainGASF3 = 0;
gainGASBF = 0;

%% CONTROL SERVO BF
% ----------------------------------------------------------------------
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

%% CONTROL SERVO MN
% ----------------------------------------------------------------------
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
% ----------------------------------------------------------------------
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
% ----------------------------------------------------------------------
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
