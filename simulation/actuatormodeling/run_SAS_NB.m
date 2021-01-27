% Noise budget script for suspensions (checking actuation noises and saturations)
%
% Author: Yuta Michimura

%% Add paths
clear all
close all
%findNbSVNroot;  % find the root of Simulink NB
addpath(genpath('SimulinkNb'));
addpath(genpath('NoiseModel'));
%addpath(genpath([NbSVNroot 'Dev/Utils/']));

figdir = './results/';  % directory to save figures

set(0,'defaultAxesFontSize',12);
set(0,'defaultTextFontSize',12);
set(0,'defaultAxesFontName','helvetica');
set(0,'defaultTextFontName','helvetica');
set(0,'DefaultLineMarkerSize',15);
set(0,'DefaultLineLineWidth',2);
co = [0 0 1;
      0 0.5 0;
      1 0 0;
      0 0.75 0.75;
      0.75 0 0.75;
      0.75 0.75 0;
      0.25 0.25 0.25];
set(groot,'defaultAxesColorOrder',co)

%% Define some parameters, filters, and noises
% see the Simulink file (noiseModel) for each parameter
freq = logspace(-1,4,1000);
noiseModel = 'SAS';
IFO = 'K1';
RSE = 'BRSE';
MirName = 'ETM';    % ETM, BS, SRM, PRM, IMC
ALS = 'on';    % on or off

% Dictionaries
Filt = containers.Map;  % digital filter transfer functions [cnts/cnts]
Susp = containers.Map;  % suspension actuation transfer functions [m/N]
Noise = containers.Map; % all sorts of noises
Elec = containers.Map;  % electronics gain [V/V]
CoilDriver = containers.Map; % coil driver V-I conversion [Ohm]
Coil = containers.Map; % coil gain [N/V]
Magnet = containers.Map; % magnetic moment of magnet [J/T]

% Constants
c = 299792458;  % speed of light [m/s]
hbar = 1.0545718e-34;   % reduced Planck constant [Js]
lamb = 1064e-9; % wavelength [m]

% Suspention type
if strcmp(MirName,'ITM')
    MirIndex = 3;
    QuantIndex = 2;
    SUSType = 'Type-A';
    DOF = 'DARM';
    L = 3000;
elseif strcmp(MirName,'ETM')
    MirIndex = 5;
    QuantIndex = 2;
    SUSType = 'Type-A';
    DOF = 'DARM';
    L = 3000;
elseif strcmp(MirName,'BS')
    MirIndex = 7;
    QuantIndex = 4;
    SUSType = 'Type-B';
    DOF = 'MICH';
    L = 3.3299;
elseif strcmp(MirName,'PRM')
    MirIndex = 8;
    QuantIndex = 5;
    SUSType = 'Type-Bp';
    DOF = 'PRCL';
    L = 66.591;
elseif strcmp(MirName,'SRM')
    MirIndex = 9;
    QuantIndex = 6;
    SUSType = 'Type-B';
    DOF = 'SRCL';
    L = 66.591;
elseif strcmp(MirName,'IMC')
    SUSType = 'Type-C';
    DOF = 'IMCL';
    L = 26.65; % half round trip length [m]
end

% Optical gain
try
    % for Type-A, Type-B, and Type-Bp suspensions
    fid = fopen(['./OpticalGain/',RSE,'/OptGain',DOF,'.dat']);
    data = textscan(fid, '%f,%f,%f', 'CommentStyle','#', 'CollectOutput',true);
    data = cell2mat(data);
    OptGain = sqrt(data(500,2)^2+data(500,3)^2); % Optical gain [W/m] (use optical gain at 100 Hz)
catch
    % for other suspensions (Type-C)
    OptGain = 1e10; % FAKE!!!!
end
    
% Displacement noise requirement
try
    % for Type-A, Type-B, and Type-Bp suspensions
    fid = fopen(['./requirements/',RSE,'/DisplacementNoiseRequirement.dat']);
    data = textscan(fid, '%f,%f,%f,%f,%f,%f,%f,%f,%f', 'CommentStyle','#', 'CollectOutput',true);
    data = cell2mat(data);
    fclose(fid);
    TMDispReq = interp1(data(:,1), data(:,MirIndex), freq, 'linear');
catch
    % for other suspensions (Type-C)
    fid = fopen(['./requirements/',RSE,'/MCDisplacementNoiseRequirement.dat']);
    data = textscan(fid, '%f,%f', 'CommentStyle','#', 'CollectOutput',true);
    data = cell2mat(data);
    fclose(fid);
    TMDispReq = interp1(data(:,1), data(:,2), freq, 'linear');    
end

% Quantum noise
try
    % for Type-A, Type-B, and Type-Bp suspensions
    fid = fopen(['./Noises/DisplacementEquivalentQuantumNoises',RSE,'.dat']);
    data = textscan(fid, '%f,%f,%f,%f,%f,%f', 'CommentStyle','#', 'CollectOutput',true);
    data = cell2mat(data);
    fclose(fid);
    Noise('Quantum') = interp1(data(:,1), abs(data(:,QuantIndex)), freq, 'linear');
catch
    % for other suspensions (Type-C)
    F = 500;    % finesse
    P = 100;    % input power [W]
    m = 0.47;   % mirror mass [kg]
    tau = 2*L*F/pi/c;
    Omega = 2*pi*freq;
    shot = L.*sqrt(hbar*lamb/(4*pi*c*P).*(1/tau^2+Omega.^2));
    rad = 2*F/pi.*sqrt(16*pi*hbar*P./(c*lamb.*(1+Omega*tau))).*abs(myzpk(freq,[],[0.944,4.03],1/m/(0.944*2*pi)^2))';
    Noise('Quantum') = sqrt(shot.^2+rad.^2);
end
if (strcmp(MirName,'ITM') || strcmp(MirName,'ETM')) && strcmp(ALS,'on')
    % for Type-A in green
    figdir = './results/ALS';  % directory to save figures
    lamb = 532e-9; % wavelength [m]
    F = 2*pi/(0.06+0.06);    % finesse
    P = 20e-3;    % input power [W] (Prometheus output is 100 mW)
    m = 23;   % mirror mass [kg]
    tau = 2*L*F/pi/c;
    Omega = 2*pi*freq;
    shot = L.*sqrt(hbar*lamb/(4*pi*c*P).*(1/tau^2+Omega.^2));
    rad = 2*F/pi.*sqrt(16*pi*hbar*P./(c*lamb.*(1+Omega*tau))).*abs(myzpk(freq,[],[0.944,4.03],1/m/(0.944*2*pi)^2))';
    Noise('Quantum') = sqrt(shot.^2+rad.^2);
end

% Frequency noise
%IMCfreq = 8e-9*freq.^(-2)./(1+(2./freq).^(-8))/26.65;  % IMC frequency noise (assuming laser is completely following IMC) [/rtHz]
%fid = fopen(['./requirements/',RSE,'/MCFrequencyNoiseRequirement.dat']);
%data = textscan(fid, '%f,%f', 'CommentStyle','#', 'CollectOutput',true);
%data = cell2mat(data);
%fclose(fid);
%MCFreqReq = interp1(data(:,1), data(:,2), freq, 'linear');
%Noise('Frequency') = MCFreqReq/(c/lamb)*L;  % laser frequency noise after IMC [m/rtHz]

% ADC
ADC_V2C = 2^16/40;  % ADC factor [V/cnts]
noise = load('./Noises/adc_noise.txt');
Noise('ADC') = interp1(noise(:,1), noise(:,2), freq, 'linear');

% PD responce
PDResp = 200; % PD responce (FAKE FOR DARM) [V/W] http://granite.phys.s.u-tokyo.ac.jp/internal/2012_m_ishigaki.pdf

% DAC and its noise
DAC_C2V = 20/2^16;  % DAC factor [V/cnts]
DAC_Range = 2^16; % DAC range [cnts]
noise = load('./Noises/adc_noise.txt');
Noise('DAC') = interp1(noise(:,1), noise(:,2), freq, 'linear')*DAC_C2V;   % DAC noise [V/rtHz]; see http://gwwiki.icrr.u-tokyo.ac.jp/JGWwiki/CLIO/Tasks/DigitalControl/Caltech_setup?action=AttachFile&do=get&target=analog_system_investigation.pdf

% Magnetic noise
%noise = load('./Noises/IXCMagneticNoise_20161215Xarm.txt'); % measured by H. Tanaka in IXC.
noise = load('./Noises/magnetic_noise.txt'); % measured by Atsuta et al http://iopscience.iop.org/article/10.1088/1742-6596/716/1/012020
mg = interp1(noise(:,1), noise(:,2), freq, 'linear')/1;   % Magnetic gradient noise [T/m/rtHz]; divide the measurement by 1 m to convert magnetic field to gradient
mg(1:25) = mg(26); mg(569:end) = mg(569);  % extrapolation
Noise('MagneticGradient') = mg;
magvari = 0.2;  % magnetic moment variation; See http://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/private/DocDB/ShowDocument?docid=4459
gradvari = 0.1; % magnetic field gradient variation; See http://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/private/DocDB/ShowDocument?docid=4459

% Number of coils for longitudinal direction
TMCoilN = 4;
IMCoilN = 1;
MNCoilN = 2;
if strcmp(MirName,'Type-A')
    IMCoilN = 2;
end

% Coil-magnets and coil drivers
CoilDriver('HighPower') = 40*2;    % Ohm;  See https://dcc.ligo.org/LIGO-T0900232, https://dcc.ligo.org/LIGO-D0902747
Noise('HighPower') = 57e-9./freq+2.1e-9; % coil driver noise [V/rtHz]; See Figure 3 of https://dcc.ligo.org/LIGO-T080014
R1 = 750; R2 = 3900; C = 0.68e-6;
CoilDriver('LowPower') = myzpk('zpk',[1/(2*pi*C*R1)],[1/(2*pi*C*(R1+R2))],R2*2);  %Ohm; See https://dcc.ligo.org/LIGO-D070481, https://dcc.ligo.org/LIGO-T0900233
R2 = 700;
CoilDriver('LowPowerMod') = myzpk('zpk',[1/(2*pi*C*R1)],[1/(2*pi*C*(R1+R2))],R2*2);  %Ohm; modified version for Type-A MN and IM
Noise('LowPower') = 170e-9./freq+6.4e-9; % coil driver noise [V/rtHz]; See https://dcc.ligo.org/LIGO-T0900233 (1/f noise at low frequency is assumed)
Elec('Whitening') = myzpk('zpk',[1;1;1],[10;10;10],1);   % default
Elec('MN_DeWhitening') = myzpk('zpk',[10;10;10],[1;1;1],1);   % default
Elec('IM_DeWhitening') = myzpk('zpk',[10;10;10],[1;1;1],1);
Elec('TM_DeWhitening') = myzpk('zpk',[10;10;10],[1;1;1],1);
Magnet('MN') = 0;   % default
CoilDriver('MN') = 0;   % default
Coil('MN') = 0; % default
Noise('MN_Coil') = 0;   % default
if strcmp(MirName,'ITM') || strcmp(MirName,'ETM')
    Magnet('MN') = 380e-3/(4e-7*pi)*pi*(2e-3/2)^2*2e-3;   % https://www.26magnet.co.jp/webshop/cart.php?FORM_mode=view_goods_detail&FORM_goods_id=KE114
    Magnet('IM') = 240e-3/(4e-7*pi)*pi*(2e-3/2)^2*2e-3;
    Magnet('TM') = 240e-3/(4e-7*pi)*pi*(2e-3/2)^2*2e-3;
    % LOW POWER COIL DRIVERS FOR MN, IM and TM
    RcoilMN = 2; % resistance of coil (from Miyamoto; estimated resistance at cryogenic from measured value at room temperature)
    RcoilIM = 2; % resistance of coil (from Miyamoto; estimated resistance at cryogenic from measured value at room temperature)
    RcoilTM = 0.6; % resistance of coil (from Miyamoto; estimated resistance at cryogenic from measured value at room temperature)
    CoilDriver('MN') = CoilDriver('LowPowerMod')/1.33;  % 1.33 for voltage gain of Low power coil driver
    CoilDriver('IM') = CoilDriver('LowPowerMod')/1.33;  % 1.33 for voltage gain of Low power coil driver
    CoilDriver('TM') = CoilDriver('LowPower');  % NO GAIN NEEDED FOR TM STAGE!!!
    Coil('MN') = MNCoilN*0.433/(CoilDriver('MN')+RcoilMN);   % N/V; See https://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/private/DocDB/ShowDocument?docid=6476
    Coil('IM') = IMCoilN*0.0159/(CoilDriver('IM')+RcoilIM);   % N/V; See http://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/private/DocDB/ShowDocument?docid=5938
    Coil('TM') = TMCoilN*0.0015/(CoilDriver('TM')+RcoilTM);   % N/V; See http://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/private/DocDB/ShowDocument?docid=5938
    Noise('MN_Coil') = Noise('LowPower');
    Noise('IM_Coil') = Noise('LowPower');
    Noise('TM_Coil') = Noise('LowPower');
elseif strcmp(MirName,'PRM')
    Magnet('IM') = 8.78e5*pi*(10e-3/2)^2*10e-3;
    Magnet('TM') = 8.78e5*pi*(6e-3/2)^2*3e-3;
    % HIGH POWER COIL DRIVERS FOR BOTH IM AND TM
    RcoilIM = 13; % resistance of coil (from Okutomi)
    RcoilTM = 11; % resistance of coil (from Aso)
    CoilDriver('IM') = CoilDriver('HighPower');
    CoilDriver('TM') = CoilDriver('HighPower');
    Coil('IM') = IMCoilN*1.26/(CoilDriver('IM')+RcoilIM);   % N/V; See http://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/DocDB/ShowDocument?docid=3239
    Coil('TM') = TMCoilN*0.129/(CoilDriver('TM')+RcoilTM);   % N/V; See http://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/DocDB/ShowDocument?docid=3239
    Noise('IM_Coil') = Noise('HighPower');
    Noise('TM_Coil') = Noise('HighPower');
elseif strcmp(MirName,'BS')
    Magnet('IM') = 8.78e5*pi*(10e-3/2)^2*10e-3;
    Magnet('TM') = 8.78e5*pi*(2e-3/2)^2*3e-3;
    % LOW POWER COIL DRIVERS ARE USED FOR BOTH IM AND TM
    RcoilIM = 13; % resistance of coil (from Okutomi)
    RcoilTM = 11; % resistance of coil (from Aso)
    CoilDriver('IM') = CoilDriver('LowPower')/1.33;  % 1.33 for voltage gain of Low power coil driver
    CoilDriver('TM') = CoilDriver('LowPower')/1.33;  % 1.33 for voltage gain of Low power coil driver
    %CoilDriver('IM') = CoilDriver('HighPower');
    %CoilDriver('TM') = CoilDriver('HighPower');
    Coil('IM') = IMCoilN*1.25/(CoilDriver('IM')+RcoilIM);   % N/V; See http://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/DocDB/ShowDocument?docid=3239
    Coil('TM') = TMCoilN*0.0138/(CoilDriver('TM')+RcoilTM);   % N/V; See http://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/DocDB/ShowDocument?docid=3239
    Noise('IM_Coil') = Noise('LowPower');
    Noise('TM_Coil') = Noise('LowPower');
    %Noise('IM_Coil') = Noise('HighPower');
    %Noise('TM_Coil') = Noise('HighPower');
elseif strcmp(MirName,'SRM')
    Magnet('IM') = 8.78e5*pi*(10e-3/2)^2*10e-3;
    Magnet('TM') = 8.78e5*pi*(2e-3/2)^2*5e-3;
    % LOW POWER COIL DRIVERS ARE USED FOR BOTH IM AND TM
    RcoilIM = 13; % resistance of coil (from Okutomi)
    RcoilTM = 11; % resistance of coil (from Aso)
    CoilDriver('IM') = CoilDriver('LowPower')/1.33;  % 1.33 for voltage gain of Low power coil driver
    CoilDriver('TM') = CoilDriver('LowPower')/1.33;  % 1.33 for voltage gain of Low power coil driver
    %CoilDriver('IM') = CoilDriver('HighPower');
    %CoilDriver('TM') = CoilDriver('HighPower');
    Coil('IM') = IMCoilN*1.26/(CoilDriver('IM')+RcoilIM);   % N/V; See http://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/DocDB/ShowDocument?docid=3239
    Coil('TM') = TMCoilN*0.0225/(CoilDriver('TM')+RcoilTM);   % N/V; See http://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/DocDB/ShowDocument?docid=3239
    Noise('IM_Coil') = Noise('LowPower');
    Noise('TM_Coil') = Noise('LowPower');
    %Noise('IM_Coil') = Noise('HighPower');
    %Noise('TM_Coil') = Noise('HighPower');
elseif strcmp(MirName,'IMC')
    Magnet('IM') = 0;
    Magnet('TM') = 8.78e5*pi*(1e-3/2)^2*5e-3;
    RcoilTM = 2.5; % resistance of coil (from Aso)
    % TAMA COIL DRIVERS FOR TM
    CoilDriver('IM') = 0;   % no feedback on IM
    CoilDriver('TM') = CoilDriver('HighPower'); % replace to high power in the future
%    CoilDriver('TM') = 50;  % See http://tamago.mtk.nao.ac.jp/tama/ifo/general_lib/circuits/000414_coil_driver/coildrv.pdf
    Coil('IM') = 0;   % no feedback on IM
    m = pi*(95.95e-3/2)^2*29.5e-3*2.2e3; % IMC mass [kg]
    Coil('TM') = 6.9e-6*m*(0.944*2*pi)^2*50/CoilDriver('HighPower');   % replace to high power in the future
%    Coil('TM') = 6.9e-6*m*(0.944*2*pi)^2;   % N/V; See http://gwclio.icrr.u-tokyo.ac.jp/lcgtsubgroup/inoutoptics/2015/06/mce625-26.html
    Noise('IM_Coil') = 0; % no feedback on IM
    Noise('TM_Coil') = Noise('HighPower'); % replace to high power in the future
%    Noise('TM_Coil') = 0.92e-9+2e-8./freq+2e-11*freq.^0.5; % coil driver noise [V/rtHz]; See Figure 9 of http://tamago.mtk.nao.ac.jp/tama/ifo/general_lib/circuits/000414_coil_driver/coildrv.pdf
    Elec('Whitening') = 1; % no whitening filters
    Elec('IM_DeWhitening') = 1;
    Elec('TM_DeWhitening') = 1;
end

% Suspension chain transfer functions
Filt('MN') = 0;  % default
Susp('MN_TM') = 0;  % default
Susp('MN_TM_fit') = 0; % default
if strcmp(MirName,'ITM') || strcmp(MirName,'ETM')
    Filt('MN') = myzpk('zpk',[1;2],[0;0],-0.5)*myzpk('zpk',[],[30 1],1);  % cnts/cnts
    Filt('IM') = myzpk('zpk',[1;2],[0;0],-30)*myzpk('zpk',[],[50 1],1);  % cnts/cnts
    Filt('TM') = myzpk('zpk',[],[],1);  % cnts/cnts
    data = load('./suspensionTFs/TypeA_MN2TM.dat');
    gg = interp1(data(:,1), data(:,2), freq, 'linear');
    ph = interp1(data(:,1), data(:,3), freq, 'linear');
    Susp('MN_TM') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % TM act to TM [m/N]
    Susp('MN_TM_fit') = myzpk('zpk',[0.7259 100;0.7428 100;0.9682 100;1.553 100;2.12 100],[0.6177 100;0.7343 100;0.7514 100;0.9572 100;1.416 100;1.626 100;2.145 100;2.52 100],0.00048); % fitted Tf used just for OLTF plot (we need tfest fuction from System Identification Toolbox to avoid this)
    data = load('./suspensionTFs/TypeA_IM2TM.dat');
    gg = interp1(data(:,1), data(:,2), freq, 'linear');
    ph = interp1(data(:,1), data(:,3), freq, 'linear');
    Susp('IM_TM') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % IM act to TM [m/N]
    Susp('IM_TM_fit') = myzpk('zpk',[0.7259 100;0.7428 100;0.9795 100;1.518 100;2.072 10;2.195 10],[0.6177 100;0.7343 100;0.7514 100;0.9572 100;1.416 100;1.626 100;2.12 100;2.52 100],0.0011); % fitted Tf
    data = load('./suspensionTFs/TypeA_TM2TM.dat');
    gg = interp1(data(:,1), data(:,2), freq, 'linear');
    ph = interp1(data(:,1), data(:,3), freq, 'linear');
    Susp('TM_TM') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % TM act to TM [m/N]
    Susp('TM_TM_fit') = myzpk('zpk',[0.7176 100;0.7428 100;0.9682 100;1.277 100;1.589 100;2.145 100;2.491 100],[0.6177 100;0.7343 100;0.7514 100;0.9572 100;1.416 100;1.626 100;2.12 100;2.52 100],0.0023);   % fitted TF
%     dataH = load('./suspensionTFs/TypeA_seismic_TF.dat');
%     dataV = load('./suspensionTFs/TypeA_seismic_vertical.dat');
%     gg = interp1(dataH(:,1), dataH(:,2), freq, 'linear');gg(601:end)=gg(600)*freq(600)^18./freq(601:end).^18;  % extrapolation
%     ph = interp1(dataH(:,1), dataH(:,3), freq, 'linear');ph(601:end)=-180;  % extrapolation
%     Susp('Seism_TM') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % Seismic noise to TM [m/m]
%     gg = interp1(dataV(:,1), dataV(:,2), freq, 'linear');gg(601:end)=gg(600)*freq(600)^10./freq(601:end).^10;  % extrapolation
%     ph = interp1(dataV(:,1), dataV(:,3), freq, 'linear');ph(601:end)=-180;  % extrapolation
%     Susp('Seism_Vert') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % Seismic noise to TM from vertical coupling [m/m]
    % data = load('./suspensionTFs/tfGnd2TMctrled.txt'); % TF with damping by room temperature part
    data = load('./suspensionTFs/TypeA_seismic_TF.dat'); % guessed file    
    gg = interp1(data(:,1), data(:,2), freq, 'linear');gg(601:end)=gg(600)*freq(600)^18./freq(601:end).^18;  % extrapolation
    ph = interp1(data(:,1), data(:,3), freq, 'linear');ph(601:end)=-180;  % extrapolation
    Susp('Seism_TM') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % Seismic noise to TM [m/m]
    data = load('./suspensionTFs/TypeA_seismic_vertical.dat'); % guessed file
    gg = interp1(data(:,1), data(:,2), freq, 'linear');gg(601:end)=gg(600)*freq(600)^10./freq(601:end).^10;  % extrapolation
    ph = interp1(data(:,1), data(:,3), freq, 'linear');ph(601:end)=-180;  % extrapolation
    Susp('Seism_Vert') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % Seismic noise to TM from vertical coupling [m/m]
elseif strcmp(MirName,'PRM')
    Filt('IM') = myzpk('zpk',[1;2;2],[0;0;60],-50)*myzpk('zpk',[],[50 1],1);  % cnts/cnts
    Filt('TM') = myzpk('zpk',[],[],5e-5);  % cnts/cnts
    % Type-B parameters http://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/DocDB/ShowDocument?docid=571
    mIM = 15.6; % mass of IM [kg]
    mTM = 10.7;  % mass of TM [kg]
    lIM = 0.5;  % wire length from BF to IM [m]
    lTM = 0.5;  % wire length from IM to TM [m]
    g = 9.806;
    f1 = 1/(2*pi)*sqrt(g/lTM);
    f2 = 1/(2*pi)*sqrt(g/lIM);
    Susp('IM_TM') = myzpk('zpk',[],[f1 100;f2*sqrt(1+mTM/mIM) 100],1/(mTM+mIM)/(2*pi*f2)^2);
    Susp('IM_TM_fit') = Susp('IM_TM');
    Susp('TM_TM') = myzpk('zpk',[],[f1 100],1/mTM/(2*pi*f1)^2);
    Susp('TM_TM_fit') = Susp('TM_TM');
    dataH = load('./suspensionTFs/typeBp_TF_length.dat');
    dataV = load('./suspensionTFs/typeBp_TF_vertical.dat');
    gg = interp1(dataH(:,1), dataH(:,2), freq, 'linear');gg(601:end)=gg(600)*freq(600)^6./freq(601:end).^6;  % extrapolation
    ph = interp1(dataH(:,1), dataH(:,3), freq, 'linear');ph(601:end)=-180;  % extrapolation
    Susp('Seism_TM') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % Seismic noise to TM [m/m]
    gg = interp1(dataV(:,1), dataV(:,2), freq, 'linear');gg(601:end)=gg(600)*freq(600)^6./freq(601:end).^6;  % extrapolation
    ph = interp1(dataV(:,1), dataV(:,3), freq, 'linear');ph(601:end)=-180;  % extrapolation
    Susp('Seism_Vert') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % Seismic noise to TM from vertical coupling [m/m]
elseif strcmp(MirName,'BS')
    Filt('IM') = myzpk('zpk',[1;2],[0;0],-20)*myzpk('zpk',[],[50 1],1);  % cnts/cnts
    Filt('TM') = myzpk('zpk',[],[],0.04)*myzpk('zpk',[],[200 1],1);  % cnts/cnts
    data = load('./suspensionTFs/BS_IM2TM.dat');
    gg = interp1(data(:,1), data(:,2), freq, 'linear');gg(601:end)=gg(600)*freq(600)^4./freq(601:end).^4;  % extrapolation
    ph = interp1(data(:,1), data(:,3), freq, 'linear');ph(601:end)=-180;  % extrapolation
    Susp('IM_TM') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % IM act to TM [m/N]
    Susp('IM_TM_fit') = myzpk('zpk',[0.4487 20;0.6982 100;1.067 100;1.6 100],[0.4246 20;0.5495 100;0.7244 100;1.009 100;1.282 100;1.629 100],0.000744); % fitted Tf used just for OLTF plot (we need tfest fuction from System Identification Toolbox to avoid this)
    data = load('./suspensionTFs/BS_TM2TM.dat');
    gg = interp1(data(:,1), data(:,2), freq, 'linear');gg(601:end)=gg(600)*freq(600)^2./freq(601:end).^2;  % extrapolation
    ph = interp1(data(:,1), data(:,3), freq, 'linear');ph(601:end)=-180;  % extrapolation
    Susp('TM_TM') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % TM act to TM [m/N]
    Susp('TM_TM_fit') = myzpk('zpk',[],[0.6918 1000],0.0028);   % fitted TF
    dataH = load('./suspensionTFs/BS_seismic_TF.dat');
    dataV = load('./suspensionTFs/BS_seism_vertical.dat');
    gg = interp1(dataH(:,1), dataH(:,2), freq, 'linear');gg(601:end)=gg(600)*freq(600)^8./freq(601:end).^8;  % extrapolation
    ph = interp1(dataH(:,1), dataH(:,3), freq, 'linear');ph(601:end)=-180;  % extrapolation
    Susp('Seism_TM') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % Seismic noise to TM [m/m]
    gg = interp1(dataV(:,1), dataV(:,2), freq, 'linear');gg(601:end)=gg(600)*freq(600)^6./freq(601:end).^6;  % extrapolation
    ph = interp1(dataV(:,1), dataV(:,3), freq, 'linear');ph(601:end)=-180;  % extrapolation
    Susp('Seism_Vert') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % Seismic noise to TM from vertical coupling [m/m]
elseif strcmp(MirName,'SRM')
    Filt('IM') = myzpk('zpk',[1;2],[0;0],-20)*myzpk('zpk',[],[50 1],1);  % cnts/cnts
    Filt('TM') = myzpk('zpk',[],[],0.025)*myzpk('zpk',[],[200 1],1);  % cnts/cnts
    % Type-B parameters http://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/DocDB/ShowDocument?docid=571
    mIM = 15.6; % mass of IM [kg]
    mTM = 10.7;  % mass of TM [kg]
    lIM = 0.5;  % wire length from BF to IM [m]
    lTM = 0.5;  % wire length from IM to TM [m]
    g = 9.806;
    f1 = 1/(2*pi)*sqrt(g/lTM);
    f2 = 1/(2*pi)*sqrt(g/lIM);
    Susp('IM_TM') = myzpk('zpk',[],[f1 100;f2*sqrt(1+mTM/mIM) 100],1/(mTM+mIM)/(2*pi*f2)^2);
    Susp('IM_TM_fit') = Susp('IM_TM');
    Susp('TM_TM') = myzpk('zpk',[],[f1 100],1/mTM/(2*pi*f1)^2);
    Susp('TM_TM_fit') = Susp('TM_TM');
    dataH = load('./suspensionTFs/typeB_TF_length.dat');
    dataV = load('./suspensionTFs/typeB_TF_vertical.dat');
    gg = interp1(dataH(:,1), dataH(:,2), freq, 'linear');gg(601:end)=gg(600)*freq(600)^10./freq(601:end).^10;  % extrapolation
    ph = interp1(dataH(:,1), dataH(:,3), freq, 'linear');ph(601:end)=-180;  % extrapolation
    Susp('Seism_TM') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % Seismic noise to TM [m/m]
    gg = interp1(dataV(:,1), dataV(:,2), freq, 'linear');gg(601:end)=gg(600)*freq(600)^8./freq(601:end).^8;
    ph = interp1(dataV(:,1), dataV(:,3), freq, 'linear');ph(601:end)=-180;  % extrapolation
    Susp('Seism_Vert') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz');  % Seismic noise to TM from vertical coupling [m/m]
elseif strcmp(MirName,'IMC')
    Filt('IM') = 0;  % no feedback on IM
    Filt('TM') = 1e-4;  % cnts/cnts
    Susp('IM_TM') = 0;  % no feedback on IM
    Susp('IM_TM_fit') = 0; % no feedback on IM
    Susp('TM_TM') = myzpk('zpk',[],[0.944,4.03],1/m/(0.944*2*pi)^2);  % TM act to TM [m/N]; See http://gwclio.icrr.u-tokyo.ac.jp/lcgtsubgroup/inoutoptics/2015/06/mce625-26.html
    Susp('TM_TM_fit') = Susp('TM_TM');   % fitted TF
    dataH = load('./suspensionTFs/TypeC_seismic_TF.txt');
    gg = interp1(dataH(:,1), dataH(:,2), freq, 'linear');gg(601:end)=gg(600)*freq(600)^10./freq(601:end).^10;  % extrapolation
    ph = interp1(dataH(:,1), dataH(:,3), freq, 'linear');ph(601:end)=-180;  % extrapolation
    Susp('Seism_TM') = frd(gg.*exp(i*ph/180*pi),freq,'FrequencyUnit','Hz'); % Seismic noise to TM [m/m]; Generated with ./SuspensionTFs/LCGT_SAS_TypeC.m from Takahashi-san
    Susp('Seism_Vert') = myzpk('zpk',[],[6 20;32 20],1);  % Seismic noise to TM from vertical coupling [m/m]; Isolation ratio from stacks are not included, only from double-pendulum; From Arai-san's proto_iso_flex_damp.dat
end

% Common parameters
%noise = load('./Noises/kamiokaNoisy.txt');
noise = load('./Noises/kamiokaHNM.dat');  % see https://gwdoc.icrr.u-tokyo.ac.jp/cgi-bin/private/DocDB/ShowDocument?docid=2971
Noise('Seismic') = interp1(noise(:,1), noise(:,2), freq, 'linear');
VertCoup = 0.01;    % vertical coupling

% AI filters
% Anaglog AA/AI: 3rd-order Butterworth at 10kHz, notch at 65535Hz (LIGO-T070038, LIGO-D070081)
% Digital AA/AI: /opt/rtcds/rtscore/release/src/fe/controller.c
[z,p,k]=butter(3,2*pi*1e4,'low','s');
Elec('Digital_AI') = zpk(z,p,k);
Elec('Analog_AI') = zpk(z,p,k);
Elec('Digital_AA') = zpk(z,p,k);
Elec('Analog_AA') = zpk(z,p,k);

% LSC filter (including PD signal chain and such)
Filt('LSC') = myzpk('zpk',[20],[600],1e10/OptGain)*myzpk('zpk',[],[500 1],1);

% Switches
loopNames = {'Overall','TM','IM','MN'};
SW = ones(1,length(loopNames));

%% Plot noises, transfer functions
% used for modeling report
pleaseplot = 1; % make it 0 if you want to skip plotting
if pleaseplot
   % print Simulink model
%    try
%        print(['-s',noiseModel],'-dpdf',[figdir,noiseModel,'.pdf']);
%    catch
%        open(noiseModel);
%        print(['-s',noiseModel],'-dpdf',[figdir,noiseModel,'.pdf']);
%    end
   % plot suspension transfer functions
   figure(10)
   if strcmp(MirName,'ITM') || strcmp(MirName,'ETM')
     plotbode(freq,[Susp('TM_TM'),Susp('IM_TM'),Susp('MN_TM')])
     legend({'TM to TM','IM to TM','MN to TM'})
   elseif strcmp(MirName,'BS') || strcmp(MirName,'PRM') || strcmp(MirName,'SRM')
     plotbode(freq,[Susp('TM_TM'),Susp('IM_TM')])
     legend({'TM to TM','IM to TM'})
   elseif strcmp(MirName,'IMC')
     plotbode(freq,Susp('TM_TM'))
     legend({'TM to TM'})
   end   
   subplot(2,1,1)
   ylabel('Gain [m/N]')
   ylim([1e-9,1e1])
   set(gca,'YTick',logspace(-9,1,11));
   xlim([freq(1),freq(end)]);
   set(gca,'XTick',logspace(log10(freq(1)),log10(freq(end)),log10(freq(end))-log10(freq(1))+1));
   saveas(gcf,[figdir,MirName,'Susp.eps'],'epsc')
   % plot coil driver I-V conversion factors
   figure(20)
   if strcmp(MirName,'ITM') || strcmp(MirName,'ETM')
       plotbode(freq,[CoilDriver('TM'), CoilDriver('IM'), CoilDriver('MN')])
       legend({'low power (TM)','low power modified (IM)','low power modified (MN)'})
   elseif strcmp(MirName,'BS') || strcmp(MirName,'SRM')
       plotbode(freq,[CoilDriver('TM'), CoilDriver('IM')])
       legend({'low power (TM)','low power (IM)'})
   elseif strcmp(MirName,'PRM')
       plotbode(freq,[CoilDriver('TM'), CoilDriver('IM')])
       legend({'high power (TM)','high power (IM)'})
   elseif strcmp(MirName,'IMC')
       plotbode(freq,CoilDriver('TM'))
       legend({'IMC coil driver'})
   end
   xlim([freq(1),freq(end)]);
   set(gca,'XTick',logspace(log10(freq(1)),log10(freq(end)),log10(freq(end))-log10(freq(1))+1));
   subplot(2,1,1)
   ylabel('Gain [Ohm]')
   ylim([1e1,1e4])
   set(gca,'YTick',logspace(1,4,4));
   xlim([freq(1),freq(end)]);
   set(gca,'XTick',logspace(log10(freq(1)),log10(freq(end)),log10(freq(end))-log10(freq(1))+1));
   saveas(gcf,[figdir,MirName,'CoilDriver.eps'],'epsc')   
   % plot coil driver noises
   figure(30)
   if strcmp(MirName,'ITM') || strcmp(MirName,'ETM')
       plotspectrum(freq,[Noise('TM_Coil')',Noise('IM_Coil')',Noise('MN_Coil')'])
       legend({'low power (TM)','low power (IM)','low power (MN)'})
   elseif strcmp(MirName,'BS') || strcmp(MirName,'SRM')
       plotspectrum(freq,[Noise('TM_Coil')',Noise('IM_Coil')'])
       legend({'low power (TM)','low power (IM)'})
   elseif strcmp(MirName,'PRM')
       plotspectrum(freq,[Noise('TM_Coil')',Noise('IM_Coil')'])
       legend({'high power (TM)','high power (IM)'})
   elseif strcmp(MirName,'IMC')
       plotspectrum(freq,[Noise('TM_Coil')'])
       legend({'IMC coil driver'})
   end
   xlim([freq(1),freq(end)]);
   set(gca,'XTick',logspace(log10(freq(1)),log10(freq(end)),log10(freq(end))-log10(freq(1))+1));
   ylabel('Input equivalent noise [V/rtHz]')
   ylim([1e-9,1e-6])
   set(gca,'YTick',logspace(-9,-6,4));
   saveas(gcf,[figdir,MirName,'CoilDriverNoise.eps'],'epsc')
   % plot DAC noise
   figure(40)
   plotspectrum(freq,Noise('DAC'))
   xlim([freq(1),freq(end)]);
   set(gca,'XTick',logspace(log10(freq(1)),log10(freq(end)),log10(freq(end))-log10(freq(1))+1));
   ylabel('Noise [V/rtHz]')
   ylim([1e-6,1e-4])
   set(gca,'YTick',logspace(-6,-4,3));
   saveas(gcf,[figdir,'DACNoise.eps'],'epsc')
   % seismic attenuation ratio
   figure(50)
   plotbode(freq,Susp('Seism_TM'))
   plotbode(freq,Susp('Seism_Vert'))
   legend({'Seis to TM','Seis to TM vert'})
   xlim([freq(1),freq(end)]);
   subplot(2,1,1)
   ylabel('Gain [m/m]')
   ylim([1e-14,1e2])
   set(gca,'YTick',logspace(-14,2,17));
   xlim([freq(1),freq(end)]);
   set(gca,'XTick',logspace(log10(freq(1)),log10(freq(end)),log10(freq(end))-log10(freq(1))+1));
   saveas(gcf,[figdir,MirName,'Seis.eps'],'epsc')
   % plot seismic noise
   figure(60)
   plotspectrum(freq,Noise('Seismic'))
   xlim([freq(1),freq(end)]);
   set(gca,'XTick',logspace(log10(freq(1)),log10(freq(end)),log10(freq(end))-log10(freq(1))+1));
   ylabel('Seismic Noise [m/rtHz]')
   ylim([1e-13,1e-5])
   set(gca,'YTick',logspace(-13,-5,9));
   saveas(gcf,[figdir,'SeismicNoise.eps'],'epsc')
   % plot whitening/dewhitening filters
   figure(70)
   plotbode(freq,[Elec('Whitening'), Elec('TM_DeWhitening'),Elec('IM_DeWhitening'),Elec('MN_DeWhitening')])
   legend({'whitening','dewhitening (TM)','dewhitening (IM)','dewhitening (MN)'})
   xlim([freq(1),freq(end)]);
   set(gca,'XTick',logspace(log10(freq(1)),log10(freq(end)),log10(freq(end))-log10(freq(1))+1));
   subplot(2,1,1)
   ylabel('Gain [V/V, cnt/cnt]')
   ylim([1e-4,1e4])
   set(gca,'YTick',logspace(-4,4,9));
   xlim([freq(1),freq(end)]);
   set(gca,'XTick',logspace(log10(freq(1)),log10(freq(end)),log10(freq(end))-log10(freq(1))+1));
   saveas(gcf,[figdir,MirName,'Whitening.eps'],'epsc')
   % plot quantum noise
   figure(80)
   plotspectrum(freq,Noise('Quantum'))
   xlim([freq(1),freq(end)]);
   set(gca,'XTick',logspace(log10(freq(1)),log10(freq(end)),log10(freq(end))-log10(freq(1))+1));
   ylabel('Quantum Noise [m/rtHz]')
   ylim([1e-20,1e-13])
   set(gca,'YTick',logspace(-20,-13,8));
   saveas(gcf,[figdir,MirName,'QuantumNoise.eps'],'epsc')
   % plot magnetic gradient
   figure(90)
   plotspectrum(freq,Noise('MagneticGradient'))
   xlim([freq(1),freq(end)]);
   set(gca,'XTick',logspace(log10(freq(1)),log10(freq(end)),log10(freq(end))-log10(freq(1))+1));
   ylabel('Magnetic Gradient Noise [T/m/rtHz]')
   ylim([1e-13,1e-9])
   set(gca,'YTick',logspace(-13,-9,5));
   saveas(gcf,[figdir,'MagneticGradientNoise.eps'],'epsc')
end

%% Plot openloop transfer function
swact = 2:4;  % switches for each actuator loop
swtot = 1;  % switches for the total loop
OLTF=[];
% OLTF for each actuator loop
SW = zeros(1,length(loopNames));
SW(swtot) = ones(1,length(swtot));
[A,B,C,D]=linmod(noiseModel);
systm=ss(A,B,C,D);
for kk=swact
    OLTF=[OLTF,systm(kk,kk,:)];
end
% OLTF for total loop
SW = zeros(1,length(loopNames));
SW(swact) = ones(1,length(swact));
[A,B,C,D]=linmod(noiseModel);
systm=ss(A,B,C,D);
OLTF=[OLTF,systm(swtot,swtot,:)];
% plot OLTFs
figure(100)
plotbode(freq,OLTF);
% plot decoration
legend(loopNames{swact},loopNames{swtot});
subplot(2,1,1)
loglog([freq(1),freq(end)],[1,1],'k')
ylim([1e-6,1e6]);
xlim([freq(1),freq(end)]);
set(gca,'YTick',logspace(-6,6,7));
set(gca,'XTick',logspace(log10(freq(1)),log10(freq(end)),log10(freq(end))-log10(freq(1))+1));
title([MirName,' OLTF'])
subplot(2,1,2)
xlim([freq(1),freq(end)]);
set(gca,'XTick',logspace(log10(freq(1)),log10(freq(end)),log10(freq(end))-log10(freq(1))+1));
saveas(gcf,[figdir,MirName,'OLTF.png'])
saveas(gcf,[figdir,MirName,'OLTF.eps'],'epsc')

% turn on all the loop
SW = ones(1,length(loopNames));

%% Compute TM displacement noises and plot
% Compute noises
[noises, sys] = nbFromSimulink(noiseModel, freq, 'dof', 'TMDisp');

% save cached outputs
saveFunctionCache();

% Plot noise budget
set(0, 'DefaultAxesFontSize',14);
disp('Plotting noises')
nb = nbGroupNoises(noiseModel, noises, sys);
nb.sortModel();
matlabNoisePlot(nb);

figure(1)
loglog(freq,TMDispReq,'b-');  % plot requirement
ylim([1e-23,1e-10]);
xlim([1e-1,1e3]);
set(gca,'YTick',logspace(-23,-10,14));
set(gca,'XTick',logspace(-1,3,5));
leg = legend(gca);
legend({'Requirement (Safety 10)',leg.String{2:end}});    % Replace 'Measured' with 'Requirement'
set(legend(gca),'FontSize',8);
if strcmp(MirName,'PRM') || strcmp(MirName,'SRM') || strcmp(MirName,'IMC')
    set(legend(gca),'Location','SouthWest');
end
saveas(gcf,[figdir,MirName,'DispNoise.png'])
saveas(gcf,[figdir,MirName,'DispNoise.eps'],'epsc')

% save data
nbdata=[freq;TMDispReq];
for kk=1:length(nb.modelNoises)
    nbdata=[nbdata;nb.modelNoises{kk}.asd];
end
dlmwrite([figdir,MirName,'DispNoise.dat'],nbdata','delimiter','\t','precision',6);

figure(2)
loglog(freq,TMDispReq,'-','Color',[0 0.5 0]);  % plot requirement
ylim([1e-23,1e-10]);
xlim([1e-1,1e3]);
set(gca,'YTick',logspace(-23,-10,14));
set(gca,'XTick',logspace(-1,3,5));
leg = legend(gca);
legend({leg.String{:},'Requirement (Safety 10)'},'Interpreter','None');
set(legend(gca),'FontSize',8);
if strcmp(MirName,'PRM') || strcmp(MirName,'SRM') || strcmp(MirName,'IMC')
    set(legend(gca),'Location','SouthWest');
end
saveas(gcf,[figdir,MirName,'ActuatorNoise.png'])
saveas(gcf,[figdir,MirName,'ActuatorNoise.eps'],'epsc')

figure(3)
loglog(freq,TMDispReq,'-','Color',[0 0.5 0]);  % plot requirement
ylim([1e-23,1e-10]);
xlim([1e-1,1e3]);
set(gca,'YTick',logspace(-23,-10,14));
set(gca,'XTick',logspace(-1,3,5));
leg = legend(gca);
legend({leg.String{:},'Requirement (Safety 10)'},'Interpreter','None');
set(legend(gca),'FontSize',8);
if strcmp(MirName,'PRM') || strcmp(MirName,'SRM') || strcmp(MirName,'IMC')
    set(legend(gca),'Location','SouthWest');
end
saveas(gcf,[figdir,MirName,'MagneticNoise.png'])
saveas(gcf,[figdir,MirName,'MagneticNoise.eps'],'epsc')

nbTMdisp = nb;

%% Compute TM/IM/MN feedback signal noise budget (for saturation check)
if strcmp(MirName,'IMC')
    swact=2; % no IM for IMC
elseif strcmp(MirName,'BS') || strcmp(MirName,'PRM') || strcmp(MirName,'SRM')
    swact=2:3; % no MN for suspensions other than Type-A
end
fbdata=[freq];
for kk=swact
    close all
    % Compute noises
    [noises, sys] = nbFromSimulink(noiseModel, freq, 'dof', [loopNames{kk},'FB']);
    
    % save cached outputs
    saveFunctionCache();
    
    % Plot noise budget
    set(0, 'DefaultAxesFontSize',14);
    disp('Plotting noises')
    nb = nbGroupNoises(noiseModel, noises, sys);
    nb.sortModel();
    matlabNoisePlot(nb);
    
    figure(1)
    ylim([1e-5,1e6]);
    xlim([1e-1,1e3]);
    set(gca,'YTick',logspace(-5,6,12));
    set(gca,'XTick',logspace(-1,3,5));
    leg = legend(gca);
    legend({'DAC limit',leg.String{2:end}},'Interpreter','None');    % Replace 'Measured' with 'DAC limit'
    set(legend(gca),'FontSize',8);
    plotcumulativeRMS(nb.sumNoise.f,nb.sumNoise.asd,[0,0.5,0]);
    saveas(gcf,[figdir,MirName,loopNames{kk},'FB.png'])
    saveas(gcf,[figdir,MirName,loopNames{kk},'FB.eps'],'epsc')
    fbdata=[fbdata;nb.sumNoise.asd];
end
% save data
dlmwrite([figdir,MirName,'Feedback.dat'],fbdata','delimiter','\t','precision',6);

%% Actuator design summary
fprintf('==%s ACTUATOR DESIGN SUMMARY==\n', MirName);
% max force at DC (with 10 V)
try
    fprintf('TM max force at DC: \t %.1e N\n', dcgain(Coil('TM'))*10);
catch
    fprintf('TM max force at DC: \t %.1e N\n', Coil('TM')*10);
end
if strcmp(MirName,'IMC') ~= 1
    try
        fprintf('IM max force at DC: \t %.1e N\n', dcgain(Coil('IM'))*10);
    catch
        fprintf('IM max force at DC: \t %.1e N\n', Coil('IM')*10);
    end
end
if strcmp(MirName,'ITM') || strcmp(MirName,'ETM')
    fprintf('MN max force at DC: \t %.1e N\n', dcgain(Coil('MN'))*10);
end

% actuator efficiency
fprintf('TM actuator efficiency at DC: \t %.1e m/V\n', dcgain(Coil('TM')*Susp('TM_TM_fit')));
if strcmp(MirName,'IMC') ~= 1
    fprintf('IM actuator efficiency at DC: \t %.1e m/V\n', dcgain(Coil('IM')*Susp('IM_TM_fit')));
end
if strcmp(MirName,'ITM') || strcmp(MirName,'ETM')
    fprintf('MN actuator efficiency at DC: \t %.1e m/V\n', dcgain(Coil('MN')*Susp('MN_TM_fit')));
end

% max current at DC (with 10 V)
try
    fprintf('TM max current at DC: \t %.1e A\n', dcgain(10/(CoilDriver('TM')+RcoilTM)));
catch
    fprintf('TM max current at DC: \t %.1e A\n', 10/(CoilDriver('TM')+RcoilTM));
end
if strcmp(MirName,'IMC') ~= 1
    try
        fprintf('IM max current at DC: \t %.1e A\n', dcgain(10/(CoilDriver('IM')+RcoilTM)));
    catch
        fprintf('IM max current at DC: \t %.1e A\n', 10/(CoilDriver('IM')+RcoilTM));
    end
end
if strcmp(MirName,'ITM') || strcmp(MirName,'ETM')
    fprintf('MN max current at DC: \t %.1e A\n', dcgain(10/(CoilDriver('MN')+RcoilMN)));
end

% sum of DAC noise, coil driver noise, magnetic noise for each stage
Nf = 401;
noise10 = sqrt(nbTMdisp.modelNoises{1}.modelNoises{5}.asd(Nf)^2+nbTMdisp.modelNoises{1}.modelNoises{6}.asd(Nf)^2+nbTMdisp.modelNoises{2}.modelNoises{3}.asd(Nf)^2);
fprintf('TM noise at %.1f Hz: \t %.1e m/rtHz\n', freq(Nf), noise10); 
if strcmp(MirName,'IMC') ~= 1
    noise10 = sqrt(nbTMdisp.modelNoises{1}.modelNoises{1}.asd(Nf)^2+nbTMdisp.modelNoises{1}.modelNoises{2}.asd(Nf)^2+nbTMdisp.modelNoises{2}.modelNoises{1}.asd(Nf)^2);
    fprintf('IM noise at %.1f Hz: \t %.1e m/rtHz\n', freq(Nf), noise10); 
end
if strcmp(MirName,'ITM') || strcmp(MirName,'ETM')
    noise10 = sqrt(nbTMdisp.modelNoises{1}.modelNoises{3}.asd(Nf)^2+nbTMdisp.modelNoises{1}.modelNoises{4}.asd(Nf)^2+nbTMdisp.modelNoises{2}.modelNoises{2}.asd(Nf)^2);
    fprintf('MN noise at %.1f Hz: \t %.1e m/rtHz\n', freq(Nf), noise10);
end