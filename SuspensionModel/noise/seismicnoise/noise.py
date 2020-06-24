from scipy.interpolate import interp1d
from scipy import signal
import numpy as np
import matplotlib.pyplot as plt
from gwpy.frequencyseries import FrequencySeries
import astropy.units as u

from importlib.resources import open_text
from . import data


def seismicnoise(unit='m',axis='hor',percentile='90'):
    '''
    '''
    fname_fmt = '{0}_{1}_DISP.txt'        
    if axis=='hor':
        with open_text(data,fname_fmt.format('X',percentile)) as fp:
            x = FrequencySeries.read(fp,format='txt')
        with open_text(data,fname_fmt.format('Y',percentile)) as fp:
            y = FrequencySeries.read(fp,format='txt')
        noise = np.sqrt(x**2+y**2)       
    elif axis=='vert':
        with open_text(data,fname_fmt.format('Z',percentile)) as fp:
            noise = FrequencySeries.read(fp,format='txt')        
    else:
        raise ValueError('!')
    
    noise.override_unit('m/s Hz(1/2)')
    noise.name = '{0}_{1}'.format(axis,percentile)
    return noise
