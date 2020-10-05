% Script for reconstructing the Type-A situation
%%
%%%%%%%%%%%%%Initial SS model construction%%%%%%%%%%%%%%%
%% Add path
clear all;                     % Clear workspace
close all;                     % Close plot windows
addpath('../../utils');  % Add path to utilities
addpath('./param');  % Add path to utilities
%%
%addpath('../utility');      % Add path to utilities
%addpath('SUS');
%addpath(genpath('/kagra/kagranoisebudget/Common/Utils'));
%addpath(genpath('/kagra/kagranoisebudget/Dev/Utils'));
%%
g = 9.81;                      % Gravity constant
freq=logspace(-2,2.5,1001);
optic = 'ETMX';

%% Load parameters
load(['./param/',optic,'mdl_realparams.mat']);

%% Make free swinging model
%mdlfile = 'TypeA_siso180515';
mdlfile
st = linmod(mdlfile);
invl   =strrep(st.InputName, [mdlfile,'/'],'');
outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
sysc0  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);


%% Adjust actuator efficiency to klog 14512
% ind105 = find(freq>10.5,1);
% 
% [magTM,~] = bodesus(sysc0,'injTML','dispTML',freq);
% gain_actTML = 1.6e-7/magTM(ind105)*gain_actTML;
% 
% [magIM,~] = bodesus(sysc0,'injIML','dispTML',freq);
% gain_actIML = 8.2e-9/magIM(ind105)*gain_actIML;
% 
% [magMN,~] = bodesus(sysc0,'injMNL','dispTML',freq);
% gain_actMNL = 6.1e-8/magMN(ind105)*gain_actMNL;
% 
% %% reconstruct sysc0
% st = linmod(mdlfile);
% invl   =strrep(st.InputName, [mdlfile,'/'],'');
% outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
% sysc0  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);

%% Adjust actuator efficiency to JGW-T2011661
inddc = 1;

[magTM,~] = bodesus(sysc0,'injTML','dispTML',freq);
gain_actTML = 1.7e-7*1.e+6*20/(2^16)/magTM(inddc)*gain_actTML;

[magIM,~] = bodesus(sysc0,'injIML','dispTML',freq);
gain_actIML = 2.1e-7*1.e+6*20/(2^16)/magIM(inddc)*gain_actIML;

[magMN,~] = bodesus(sysc0,'injMNL','dispTML',freq);
gain_actMNL = 5.1e-6*1.e+6*20/(2^16)/magMN(inddc)*gain_actMNL;

%% reconstruct sysc0
mdlfile
st = linmod(mdlfile);
invl   =strrep(st.InputName, [mdlfile,'/'],'');
outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
sysc0  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);

%% Load damping filters
[~,GPStime]=system('tconvert_hoge June 24 2020 19:00 UTC');
GPStime=str2num(GPStime);
mdlfile = 'typeAsimctrl_NB';
[Filt,SW,MTRX] = getCurrentLiveFilt_TypeA(optic,freq,GPStime);

%% set gain
setgain_TypeA_damped;

gainSCL=1;gainSCT=1;

%% Make damped model
st = linmod(mdlfile);
invl   =strrep(st.InputName, [mdlfile,'/'],'');
outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
sysc  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Export ABCD

ConvertSS2dat('dampedETMXsc','A',sysc,'./O3TypeAreconst');
