from scipy.interpolate import interp1d
from scipy import signal
import numpy as np
import matplotlib.pyplot as plt
from gwpy.frequencyseries import FrequencySeries
import astropy.units as u

# MN/IM-PS
def ps_noise(dof):
    '''
    '''
    noise = np.loadtxt('ps_6dof.txt')
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

def _ipgas_lvdt_noise(dof=None):
    '''
    '''
    noise = np.loadtxt('ipgas_lvdt.dat')
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

def _bf_lvdt_noise(dof):
    '''
    '''
    noise = np.loadtxt('bf_lvdt.dat',delimiter=',')
    freq, value = noise[:,0],noise[:,1]
    lvdt = FrequencySeries(value[2:],frequencies=freq[2:],
                           name='unkwon',
                           unit='m/Hz(1/2)')#*1e-6
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

def lvdt_noise(dof=None):
    '''
    '''
    if dof in ['BFL','BFT','BFV','BFR','BFP','BFY']:
        return _bf_lvdt_noise(dof)
    elif 'IP' in dof or 'GAS' in dof:
        return _ipgas_lvdt_noise(dof)

def oplev_noise(dof):
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


def seismic_noise(dof):
    '''
    '''
    noise = None
    return noise


def geophone_noise(unit='m'): #????
    '''
    *GEOnoiseproto_vel.dat
    The noise level of geophone preamp in [um/sec/rtHz],
    but the decrease of geophone response at low freqencies is not compensated.
    '''
    name = 'L-4C'        
    noise = FrequencySeries.read('GEOnoiseproto_vel.dat',format='txt')*1e-6
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
    plt.loglog(w/(2*np.pi),abs(h))
    plt.savefig('hoge.png')
    plt.close()
    mag = abs(h)
    _f = w/np.pi/2.0
    func = interp1d(_f,mag)
    vel2v = func(freq[1:])
    print(vel2v)
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

def seismicnoise(unit='m',axis='hor',percentile='90'):
    fname_fmt = './seismicnoise/{0}_{1}_DISP.txt'
    if axis=='hor':
        x = FrequencySeries.read(fname_fmt.format('X',percentile))
        y = FrequencySeries.read(fname_fmt.format('Y',percentile))
        noise = np.sqrt(x**2+y**2)
    elif axis=='vert':
        noise = FrequencySeries.read(fname_fmt.format('Z',percentile))        
    else:
        raise ValueError('!')
    
    noise.override_unit('m/s Hz(1/2)')
    noise.name = '{0}_{1}'.format(axis,percentile)
    return noise

if __name__ == '__main__':
    axis = 'hor'
    # Geophone
    geophone = geophone_noise(unit='m')

    seis_99 = seismicnoise(unit='m',percentile='99',axis='hor')
    seis_90 = seismicnoise(unit='m',percentile='90',axis='hor')
    seis_01 = seismicnoise(unit='m',percentile='1',axis='hor')
    seis_50 = seismicnoise(unit='m',percentile='50',axis='hor')
    seis_10 = seismicnoise(unit='m',percentile='10',axis='hor')
    
    # MN/IM-PS
    # ps_lon = ps_noise('L')
    # ps_tra = ps_noise('T')
    # ps_ver = ps_noise('V')
    # ps_rol = ps_noise('R')
    # ps_pit = ps_noise('P')
    # ps_yaw = ps_noise('Y')
    # IP/GAS-LVDT
    lvdt = lvdt_noise('IP')
    # lvdt_ipl = lvdt_noise('IPL')
    # lvdt_ipt = lvdt_noise('IPT')
    # lvdt_ipy = lvdt_noise('IPY')
    # lvdt_gasf0 = lvdt_noise('GASF0')
    # lvdt_gasf1 = lvdt_noise('GASF1')
    # lvdt_gasf2 = lvdt_noise('GASF2')
    # lvdt_gasf3 = lvdt_noise('GASF3')
    # lvdt_gasbf = lvdt_noise('GASBF')
    # BF-LVDT
    # lvdt_bfl = lvdt_noise('BFL')
    # lvdt_bft = lvdt_noise('BFT')
    # lvdt_bfv = lvdt_noise('BFV')
    # lvdt_bfr = lvdt_noise('BFR')
    # lvdt_bfp = lvdt_noise('BFP')
    # lvdt_bfy = lvdt_noise('BFY')
    # TM/MN-Oplev
    # oplev_tml = oplev_noise('TML')
    # oplev_tmp = oplev_noise('TMP')
    # oplev_tmy = oplev_noise('TMY')
    # oplev_mnl = oplev_noise('MNL')
    # oplev_mnp = oplev_noise('MNP')
    # oplev_mny = oplev_noise('MNY')

    # plot
    fig,ax = plt.subplots(1,1,figsize=(9,6))
    disp = True
    if disp:
        ax.plot_mmm(seis_50,seis_01,seis_99,color='k',alpha=0.1)
        ax.plot_mmm(seis_50,seis_10,seis_90,color='k')
        ax.loglog(lvdt,label='LVDT')        
        ax.loglog(geophone,label='Geophone')
        ax.set_ylabel('Displacement [m/rtHz]')
        ax.set_ylim(1e-12,1e-5)
        ax.set_xlim(1e-2,1e2)
    else:
        ax.loglog(lvdt_ipy,label=lvdt_ipy.name)
        ax.loglog(ps_yaw,label=ps_yaw.name)
        ax.loglog(oplev_tmy,label=oplev_tmy.name)
        ax.set_ylabel('Angle [rad/rtHz]')
    
    ax.grid(which='major',linestyle='--')
    ax.grid(which='minor',linestyle=':')
    ax.legend()    
    ax.set_xlabel('Frequency [Hz]')
    plt.savefig('sensornoise.png')
    plt.close()       
