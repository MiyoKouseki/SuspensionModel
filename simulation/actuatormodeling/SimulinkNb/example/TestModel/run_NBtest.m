% Noise budget test script
%
% $Id$

%% Add paths
clear all
close all
addpath('../');
findNbSVNroot;
addpath(genpath([NbSVNroot 'Common/Utils']));
addpath(genpath([NbSVNroot 'Dev/Utils/']));

%% Define some filters and plot expected OLTF
Sen = 5e3;
Filt = zpk(-2*pi*10,-2*pi*100,10);
Act = zpk([],[-2*pi*(0.1+0.995*i) -2*pi*(0.1-0.995*i)],10);
Gol = Sen*Filt*Act;
figure(100)
bode(Gol)
grid on

%% Define some parameters and get live parts parameters
freq = logspace(-2,3,1000);
liveModel = 'TEST_Live_2014';
dof = 'TST';    % name of DOF to plot NB
startTime = 1078250000;   % start GPS time
durationTime = 512;
IFO = 'H1';
site = 'LHO';

% Try setting different NDS server if you couldn't get data
% setenv('LIGONDSIP','h1nds1:8088');
% mdv_config;

% load cached outputs
loadFunctionCache()

% get live parts parameters
% liveParts(liveModel, startTime, durationTime, freq)
cnst = 1;

%% Compute noises and save cache
% Compute noises
[noises, sys] = nbFromSimulink(liveModel, freq, 'dof', dof);

% save cached outputs
saveFunctionCache();

%% Make a quick NB plot
disp('Plotting noises')
nb = nbGroupNoises(liveModel, noises, sys);

% Get noise data from DAQ. Put NdNoiseSource block with DAQ channel
% specified. Put something (e.g. 1) in ASD parameter of that block.
%nb = nbAcquireData(liveModel, sys, nb, startTime, durationTime);

nb.sortModel();
matlabNoisePlot(nb);
figure(1)
ylim([1e-6,1e1])

%% plot expected curve from calculation

[mag,ph]=bode((1+Gol)/(Filt*Sen),2*pi*freq);
loglog(freq,squeeze(mag),'b.')
hold on

[mag,ph]=bode(1/Sen,2*pi*freq);
loglog(freq,freq./freq/Sen,'r.')

