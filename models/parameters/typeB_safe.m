
%% ABOUT THIS FILE
% ----------------------------------------------------------------------
% INITIAL Parmeter setting for NO CONTROL MODE
% Type-B for KAGRA
% Coded by Shoda on 2018/03/13
% ----------------------------------------------------------------------

%% CONSTANTS
pp=2*pi;

%% ACTUATOR NORMALIZATION
% Normalize the actuators using local sensors at 0 Hz

% F0 (Normalized with LVDT signals)
gain_act_LIP = 214.7;
gain_act_TIP = 214.7;
gain_act_YIP = 158.9;

% IM (Normalized with OSEM signals)
gain_act_LIM = 183.6;
gain_act_TIM = 183.6;
gain_act_VIM = 384.5;
gain_act_RIM = 1.766;
gain_act_PIM = 1.746;
gain_act_YIM = 0.387;

% TM (Normalized with OSEM signals)
gain_act_LTM = 0.0126;
gain_act_PTM = 1.133;
gain_act_YTM = 1.773;

% GAS (Normalzed with LVDT signals)
gain_act_GASF0 = 1193.;
gain_act_GASF1 = 940.7;
gain_act_GASBF = 383.3;


%% BLENDING FILTERS
blend_LVDT = 1;
blend_GEO  = 0;


%% SERVO FILTER
% SERVO FILTER F0
servo_LIP = 0;
servo_TIP = 0;
servo_YIP = 0;

% SERVO FILTER IM
servo_LIM = 0;
servo_TIM = 0;
servo_VIM = 0;
servo_RIM = 0;
servo_PIM = 0;
servo_YIM = 0;

% SERVO FILTER TM
servo_LTM = 0;
servo_PTM = 0;
servo_YTM = 0;

% SERVO FILTER GAS
servo_GASF0 = 0;
servo_GASF1 = 0;
servo_GASBF = 0;

% SERVO FILTER OpLev
servo_oplev_PIM = 0;
servo_oplev_YIM = 0;

% SERVO FILTER IFO
servo_global_LIP = 0;
servo_global_LIM = 0;
servo_global_LTM = 0;

%% GAIN
gain_LIP = 0; gain_TIP = 0; gain_YIP = 0;
gain_LIM = 0; gain_TIM = 0; gain_VIM = 0;
gain_RIM = 0; gain_PIM = 0; gain_YIM = 0;
gain_LTM = 0; gain_PTM = 0; gain_YTM = 0;
gain_GASF0 = 0; gain_GASF1 = 0; gain_GASBF = 0;
gain_oplev_PIM = 0; gain_oplev_YIM = 0;
gain_global_LIP = 0; gain_global_LIM = 0; gain_global_LTM = 0;


