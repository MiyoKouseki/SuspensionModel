function text = model2fotonzpk_damped(opt, inv, outv)
% gives you the zpk format text for photon
% input examples:
% opt='ETMX';
% outv = 'TMP'; It works only for TM output for now.
% inv = 'IMP';
%%
addpath('/kagra/Dropbox/Subsystems/VIS/Scripts/SuspensionControlModel/script/SUS/')
filename = strcat(opt,'mdl_damped.mat');
load(filename,'sysc');

%%
inv = strcmp('inj',inv);
outv = strcmp('disp',outv);

%%
zpksys = zpk(sysc(outv,inv));
zz = cell2mat(zpksys.Z)/2/pi;
pp = cell2mat(zpksys.P)/2/pi;

%% get k
%zmin = min(abs(zz));
%pmin = min(abs(pp));
%freqpmin = min(zmin,pmin)/10.;
[mag,~] = mybode(sysc(outv,inv),logspace(-4,1,10));
kk = mag(1);

%%
zz = round(zz,4);
pp = round(pp,4);
%kk = round(kk,4);
delz=[];
delp=[];
for i = 1:length(zz)
    for j = 1:length(pp)
        if zz(i)==pp(j) && ~any(delz(:)==i)
            delz=[delz; i];
            delp=[delp; j];
            break
        end
    end
end
%%
zz(delz)=[];
pp(delp)=[];


%%
for i =1:length(pp)
    if real(pp(i)) < 0
        pp(i) = -1*pp(i);
    end
end

%%
text = strcat('zpk(',mat2str(zz),',',mat2str(pp),',',num2str(kk),',"n")');

end
