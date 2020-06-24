from scipy.interpolate import interp1d
from scipy import signal
import numpy as np
import matplotlib.pyplot as plt
from gwpy.frequencyseries import FrequencySeries
import astropy.units as u

from importlib.resources import open_text
from . import data

def l4c(unit='m',plot=False): #????
    '''
    *GEOnoiseproto_vel.dat
    The noise level of geophone preamp in [um/sec/rtHz],
    but the decrease of geophone response at low freqencies is not compensated.
    '''
    name = 'L-4C'

    with open_text(data,'GEOnoiseproto_vel.dat') as fp:
        noise = FrequencySeries.read(fp,format='txt')*1e-6
        
    freq = noise.frequencies.value
    #
    eta = 0.28 
    mass = 0.970 #kg
    w0 = 1.0*(2.0*np.pi) #rad/s
    ge = 276 #v/(m/s)
    k = ge
    k = 1
    num,den = [-ge,0,0], [1,2*eta*w0,w0**2]
    num,den = [-1,0,0], [1,2*eta*w0,w0**2]
    w,h = signal.freqs(num,den,worN=np.logspace(-4,3,1000))
    
    if plot:
        plt.loglog(w/(2*np.pi),abs(h))
        plt.savefig('hoge.png')
        plt.close()
        
    mag = abs(h)
    _f = w/np.pi/2.0
    func = interp1d(_f,mag)
    vel2v = func(freq[1:])
    noise = noise[1:]/vel2v
    #
    if unit=='m/s':
        noise.override_unit('m/s Hz(1/2)')
        noise.name = 'L-4C'
        pass
    elif unit=='m':
        noise.override_unit('m/Hz(1/2)')
        noise.name = 'L-4C'
        freq = noise.frequencies.value        
        noise = noise/(2.0*np.pi*freq)
    return noise
