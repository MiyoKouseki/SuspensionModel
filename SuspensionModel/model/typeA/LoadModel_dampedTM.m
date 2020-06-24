


%% Add path
clear all;                     % Clear workspace
close all;                     % Close plot windows
addpath('../utility');      % Add path to utilities
addpath('SUS');
addpath(genpath('/kagra/kagranoisebudget/Common/Utils'));
addpath(genpath('/kagra/kagranoisebudget/Dev/Utils'));
addpath('../../../')
g = 9.81;                      % Gravity constant
freq=logspace(-2,2.5,1001);
optic = 'ETMX';

%% Load parameters

load([optic,'mdl_realparams.mat']);

%% Make free model
st = linmod(mdlfile);
invl   =strrep(st.InputName, [mdlfile,'/'],'');
outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
sysc0  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);


%% Load damping filters
[~,GPStime]=system('tconvert Mar 15 2020 9:00 JST');
GPStime=str2num(GPStime);
mdlfile = 'typeAsimctrl_NB';
[Filt,SW] = getCurrentLiveFilt_TypeA(optic,freq,GPStime);

%% set gain
%TM
gainTML=1;  gainTMP=1;  gainTMY=1;
gainTML_LOCK=0; gainTMP_LOCK=0; gainTMY_LOCK=0;
%IM
gainIML=1;  gainIMT=1;  gainIMV=1;  gainIMR=1;  gainIMP=1;  gainIMY=1;
gainTMOL_IML=1; gainTMOL_IMP=1; gainTMOL_IMY=1;
gainLOCK_IML=1; gainLOCK_IMP=1; gainLOCK_IMY=1;
%MN
gainMNL=1;  gainMNT=1;  gainMNV=1;  gainMNR=1;  gainMNP=1;  gainMNY=1;
gainTMOL_MNL=1; gainTMOL_MNP=1; gainTMOL_MNY=1;
gainOL_MNP=1;   gainOL_MNY=1;
gainMNLOCK_L=1; gainMNLOCK_P=1; gainMNLOCK_Y=1;
%BF
gainBFL=1;  gainBFT=1;  gainBFV=1;  gainBFR=1;  gainBFP=1;  gainBFY=1;
%GAS
gainGASF0=1;    gainGASF1=1;    gainGASF2=1;    gainGASF3=1;    gainGASBF=1;
%IP
gainIPL=1;  gainIPT=1;  gainIPY=1;
Kopt_angle=0.1; Kopt_len=0.1; %tentative

%% Make damped model
st = linmod(mdlfile);
invl   =strrep(st.InputName, [mdlfile,'/'],'');
outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
sysc  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);

%%
rmpath(genpath('/kagra/kagranoisebudget/Common/Utils'));
rmpath(genpath('/kagra/kagranoisebudget/Dev/Utils'));


%%
text=model2fotonzpk(sysc,'injIMP','dispTMP');
save(['./SUS/',optic,'mdl_damped.mat'],'sysc')

%% Compare with the measurements

xmlfile = '/kagra/Dropbox/Subsystems/VIS/Automeasurements/TypeA/';
data = DttData(xmlfile);

[fr.tf] = transferFunction(data,chA,chB);