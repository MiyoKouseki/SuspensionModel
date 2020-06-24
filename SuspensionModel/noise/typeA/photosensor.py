from scipy.interpolate import interp1d
from scipy import signal
import numpy as np
import matplotlib.pyplot as plt
from gwpy.frequencyseries import FrequencySeries
import astropy.units as u

from importlib.resources import open_text
from . import data

# MN/IM-PS
def reflective_photosensor(dof):
    '''
    '''
    with open_text(data,'ps_6dof.txt') as fp:
        noise = np.loadtxt(fp)
        
    _dofs = ['H1','H2','H3','V1','V2','V3','L','T','V','R','P','Y']
    dofs = {'H1':'K1:VIS-ETMX_MN_PSINF_H1_IN',
            'H2':'K1:VIS-ETMX_MN_PSINF_H2_IN',
            'H3':'K1:VIS-ETMX_MN_PSINF_H3_IN',
            'V1':'K1:VIS-ETMX_MN_PSINF_V1_IN',
            'V2':'K1:VIS-ETMX_MN_PSINF_V2_IN',
            'V3':'K1:VIS-ETMX_MN_PSINF_V3_IN',
            'L':'K1:VIS-ETMX_MN_PSDAMP_L_IN1_DQ',
            'T':'K1:VIS-ETMX_MN_PSDAMP_T_IN1_DQ',
            'V':'K1:VIS-ETMX_MN_PSDAMP_V_IN1_DQ',
            'R':'K1:VIS-ETMX_MN_PSDAMP_R_IN1_DQ',
            'P':'K1:VIS-ETMX_MN_PSDAMP_P_IN1_DQ',
            'Y':'K1:VIS-ETMX_MN_PSDAMP_Y_IN1_DQ'}
    i = _dofs.index(dof)+1
    freq, value = noise[:,0],noise[:,i]
    ps_yaw = FrequencySeries(value,frequencies=freq,
                             name=dofs[dof],
                             unit='rad/Hz(1/2)')*1e-6
    return ps_yaw
