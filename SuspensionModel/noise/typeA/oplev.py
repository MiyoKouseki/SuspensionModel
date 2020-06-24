import numpy as np

from gwpy.frequencyseries import FrequencySeries
import astropy.units as u

from importlib.resources import open_text
from . import data

# ------------------------------------------------------------------------------
def oplev(dof):
    '''
    '''
    num = 1000
    freq = np.logspace(-3,2,num)
    
    _dofs = ['TML','MNL','TMP','TMY','MNP','MNY']
    
    if dof in ['TML','MNL','IML']:
        value = np.ones(num)*1e-9
        unit = 'm/Hz(1/2)'
    elif dof in ['TMP','TMY','MNP','MNY','IMP','IMY']:        
        value = np.ones(1000)*1e-9
        unit = 'rad/Hz(1/2)'        
    else:
        raise ValueError('Invalid dof {0}. Please chose in {1}'.\
                         format(dof,_dofs))
                
    noise = FrequencySeries(value,frequencies=freq,
                            name='OPLEV_{0}'.format(dof),
                            unit=unit)
    return noise


