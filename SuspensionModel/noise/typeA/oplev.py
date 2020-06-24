from scipy.interpolate import interp1d
from scipy import signal
import numpy as np
import matplotlib.pyplot as plt
from gwpy.frequencyseries import FrequencySeries
import astropy.units as u

from importlib.resources import open_text
from . import data


def oplev(dof):
    '''
    '''
    freq = np.logspace(-3,2,1000)    
    if dof in ['TML','MNL']:
        value = np.ones(1000)*1e-9
        oplev = FrequencySeries(value,frequencies=freq,
                                name='Oplev_Long',
                                unit='m/Hz(1/2)')
    elif dof in ['TMP','TMY','MNP','MNY']:        
        value = np.ones(1000)*1e-9
        oplev = FrequencySeries(value,frequencies=freq,
                                name='Oplev_Tilt',
                                unit='rad/Hz(1/2)')
    else:
        raise ValueError('Invalid dof {0}'.format(dof))
    
    return oplev


