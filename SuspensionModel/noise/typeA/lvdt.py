from scipy.interpolate import interp1d
from scipy import signal
import numpy as np
import matplotlib.pyplot as plt
from gwpy.frequencyseries import FrequencySeries
import astropy.units as u

from importlib.resources import open_text
from . import data


def _ipgas_lvdt(dof=None):
    '''
    '''
    with open_text(data,'ipgas_lvdt.dat') as fp:
        noise = np.loadtxt(fp)
    
    freq, value = noise[:,0],noise[:,1]
    lvdt = FrequencySeries(value,frequencies=freq,
                        name='unkwon',
                        unit='m/Hz(1/2)')*1e-6
    if dof=='IP':
        lvdt = lvdt
    elif dof in ['IPL','IPT']:
        lvdt = lvdt/np.sqrt(3.0/2.0)
    elif dof in ['IPY']:
        Y2L = 600e-3*(u.m/u.rad)        
        lvdt = lvdt/np.sqrt(3.0)/Y2L
    elif dof in ['GASF0','GASF1','GASF2','GASF3','GASBF']:
        lvdt = lvdt*2
        lvdt.name = 'LVDT_{0}'.format(dof)            
    else:
        raise ValueError('Invalid dof {0}'.format(dof))
    lvdt.name = 'LVDT_{0}'.format(dof)
    return lvdt

def _bf_lvdt(dof):
    '''
    '''
    with open_text(data,'bf_lvdt.dat') as fp:
        noise = np.loadtxt(fp,delimiter=',')
        
    freq, value = noise[:,0],noise[:,1]
    lvdt = FrequencySeries(value[2:],frequencies=freq[2:],
                           name='unkwon',
                           unit='m/Hz(1/2)')
    if dof in ['BFL','BFT',]:
        lvdt = lvdt/np.sqrt(3.0/2.0)
    elif dof in ['BFV']:
        lvdt = lvdt/np.sqrt(3.0)
    elif dof in ['BFR','BFP']:
        Y2L = 440e-3*(u.m/u.rad)              
        lvdt = lvdt/np.sqrt(3.0/2.0)/Y2L        
    elif dof in ['BFY']:
        Y2L = 440e-3*(u.m/u.rad)        
        lvdt = lvdt/np.sqrt(3.0)/Y2L
    else:
        raise ValueError('Invalid dof {0}'.format(dof))
    lvdt.name = 'LVDT_{0}'.format(dof)
    return lvdt


def _lvdt(dof=None):
    '''
    '''
    if dof in ['BFL','BFT','BFV','BFR','BFP','BFY']:
        return _bf_lvdt(dof)
    elif 'IP' in dof or 'GAS' in dof:
        return _ipgas_lvdt(dof)
