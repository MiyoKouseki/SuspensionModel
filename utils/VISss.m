function sysc = VISss(optic,state,varargin)
% VISss gives space state model of the VIS control model
% sys = VISss(optic, state, option)
% optic: optic to be loaded (i.e.,'BS')
% state: state of the control, 'safe', 'damped', or 'aligned'
% option: if you use this from different computer than k1script, define
% 'SUSpath' as path to the directory where the parameter mat files are.
% 'Freq' can be defined (may be used for future...)

%% Default Parameter
SUSpath = '/kagra/Dropbox/Subsystems/VIS/Scripts/SuspensionControlModel/script/SUS';
freq = logspace(-2,2,1000);

%% varagin check
nin = length(varargin);
if rem(nin,2)==1
    error('VISss:InputError','Number of varagin must be even.')
end

for n = 1:nin/2
    if strcmp(varargin{2*n-1},'SUSpath')
        SUSpath = varargin{2*n};
    elseif strcmp(varargin{2*n-1}, 'Freq')
        freq = varargin{2*n};
    end
end


%% Load model
addpath(genpath(SUSpath));

sysc = [];
if strncmp(state,'s',1)
    load(strcat(optic,'mdl_realparams_safe.mat'));
    
elseif strncmp(state,'d',1)
    load([optic,'mdl_realparams_damped.mat']);
    Filt = getCurrentLiveFilt(optic,freq);
    st = linmod(mdlfile);
    invl   =strrep(st.InputName, [mdlfile,'/'],'');
    outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
    sysc  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);
elseif strncmp(state,'a',1)
    load([optic,'mdl_realparams_aligned.mat']);
    Filt = getCurrentLiveFilt(optic,freq);
    st = linmod(mdlfile);
    invl   =strrep(st.InputName, [mdlfile,'/'],'');
    outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
    sysc  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);
end

end
