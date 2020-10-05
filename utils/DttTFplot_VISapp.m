function [status, freq, mag, phase] = DttTFplot_VISapp(filename,chA,chB)
addpath(genpath('/kagra/Dropbox/Subsystems/VIS/Scripts/DttData'));
status = 0;
freq = 0;
mag = 0;
phase = 0;
try
    data = DttData(filename);
    [freq,TF]=data.transferFunction(chA,chB);
    mag = abs(TF);
    phase = angle(TF)*180/pi;
catch ME
    if strcmp(ME.message,'file open not succesful')
        status = 1;
    elseif strncmp(ME.message,'Requested A channel',19)
        status = 2;
    elseif strncmp(ME.message,'Requested B channel',19)
        status = 3;
    else
        status=4;
    end
end
end
    
