function [mmag, mphs] = mybode(sys,freqVec)
    [mag,rad] = bode(sys,freqVec*(2*pi));

    % adaptation to MIMO systems (modified by K.Okutomi)
    nin  = size(mag, 2);
    nout = size(mag, 1);
    mmag = cell(nout, nin);
    mphs = cell(nout, nin);

    for i=1:nout
        for j=1:nin
            mmag{i, j} = squeeze(mag(i, j, :))';
            mphs{i, j} = minimalphase(squeeze(rad(i, j, :))');
        end
    end
    
    if size(mmag) == [1, 1]
        mmag = mmag{1, 1};
        mphs = mphs{1, 1};
    end
end


function phs_min = minimalphase(phs_contin)
    abs = exp(1i*phs_contin*pi/180);
    phs_min = angle(abs)*180/pi;
end