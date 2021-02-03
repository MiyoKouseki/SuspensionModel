import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm

from measurements.susdtt import SusDtt
from models.susmodel import SusModel

def sustype(optic):
    if optic in ['PRM','PR2','PR3']:
        return 'typeBp'
    elif optic in ['BS','SRM','SR2','SR3']:
        return 'typeB'        
    elif optic in ['ETMX','ETMY','ITMX','ITMY']:
        return 'typeA'
    else:
        raise ValueError('{0}'.format(optics))

def bode_model(optic,stage,dof):    
    model = SusModel(optic)   
    start = 'ctrl_{2}/exc_{0}{1}'.format(stage,dof,sustype(optic))
    
    # These differencies should be eliminated..
    end = 'ctrl_{0}/dispTML'.format(sustype(optic))
    freq = np.logspace(-2,2,1001)
    freq,gain = model.tf(start,end,freq)
    return freq, gain



def bode(optic,stage,dof):
    freq, gain = bode_model(optic,stage,dof)
    _freq, _gain, _coh = bode_measurement(optic,stage,dof)
    gain *= np.mean((np.abs(_gain)[:5]/np.abs(gain)[:5])) #[1]
    # [1] Adjust the model data to the measured one. Note that the
    #     data points in lower frequency are unreliable.    
    return [freq,gain],[_freq,_gain,_coh]

def plot4(data,titles,fname):
    fig,ax = plt.subplots(3,4,sharex='col',sharey='row',figsize=(10,6))
    plt.subplots_adjust(hspace=0.1, wspace=0.15,
                        left=0.1, right=0.95,
                        top=0.88, bottom=0.1)
            
    for i in range(len(data)):
        model, measurement = data[i]
        freq, gain = model
        _freq, _gain, _coh = measurement        
        ax[0][i].loglog(freq,np.abs(gain),'k-',label='Model')
        ax[0][i].loglog(_freq,np.abs(_gain),'ro',markersize=2,
                        label='Measurement')
        ax[1][i].semilogx(freq,np.rad2deg(np.angle(gain)),'k-')
        ax[1][i].semilogx(_freq,np.rad2deg(np.angle(_gain)),'ro',
                          markersize=2,label='Measured')
        ax[2][i].semilogx(_freq,_coh,'ro',markersize=2)
        ax[0][i].set_title(titles[i])            
        ax[1][i].set_xlim(1e-2,5e1)    
        ax[1][i].set_yticks(range(-180,181,90))
        ax[2][i].set_xlabel('Frequency [Hz]')
        ax[1][i].grid(which='major',color='black',linestyle='-')
        ax[1][i].grid(which='minor',color='black',linestyle=':')
        ax[0][i].grid(which='major',color='black',linestyle='-')
        ax[0][i].grid(which='minor',color='black',linestyle=':')
        ax[2][i].grid(which='major',color='black',linestyle='-')
        ax[2][i].grid(which='minor',color='black',linestyle=':')
        ax[0][i].legend(loc='lower left',fontsize=5)
    ax[0][0].set_ylabel('Magnitude')
    ax[1][0].set_ylabel('Phase [Degree]')
    ax[2][0].set_ylabel('Coherence')
    ax[0][0].set_ylim(1e-5,1e2)
    ax[1][0].set_ylim(-181,181)
    ax[2][0].set_ylim(0,1)
    plt.savefig(fname)
    print(fname)
    plt.close()
    
if __name__=='__main__':
    freq, IP2TM = bode_model('ETMX','IP','L') # [m/V]        
    freq, BF2TM = bode_model('ETMX','BF','L') # [m/V]    
    freq, PF2TM = bode_model('ETMX','PF','L') # [m/V]
    freq, MN2TM = bode_model('ETMX','MN','L') # [m/V]
    freq, IM2TM = bode_model('ETMX','IM','L') # [m/V]
    freq, TM2TM = bode_model('ETMX','TM','L') # [m/V]
    #
    fig,ax = plt.subplots(1,1,sharex='col',sharey='row',figsize=(6,6))
    ax.set_title('L -> L')
    #ax.loglog(freq,np.abs(IP2TM),label='IP2TM',color='c')
    #ax.loglog(freq,np.abs(BF2TM),label='BF2TM',color='m')
    ax.loglog(freq,np.abs(PF2TM),label='PF2TM',color='k')
    ax.loglog(freq,np.abs(MN2TM),label='MN2TM',color='r')
    ax.loglog(freq,np.abs(IM2TM),label='IM2TM',color='b')
    ax.loglog(freq,np.abs(TM2TM),label='TM2TM',color='g')
    ax.grid(which='major',color='black',linestyle='-')
    ax.grid(which='minor',color='black',linestyle=':')
    ax.set_ylim(1e-19,1e0)
    ax.set_ylabel('Gain [m/N]')
    ax.set_xlabel('Frequency [Hz]')
    ax.legend()
    plt.savefig('hoge.png')
    plt.close()
