function plotspectrum(freq,varargin);
% plot many spectrums

spe=[varargin{:}];
loglog(freq,spe);
grid on;
xlabel('Frequency [Hz]');
ylabel('Noise [?/rtHz]');