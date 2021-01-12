import numpy as np
import matplotlib.pyplot as plt

from measurements.susdtt import SusDtt
from models.susmodel import SusModel

def bode_model(optic,stage,dof):    
    model = SusModel(optic)   
    start = 'ctrl_typeBp/exc_{0}{1}'.format(stage,dof)
    end = 'ctrl_typeBp/OSEM_{0}{1}'.format(stage,dof)
    freq = np.logspace(-2,1,1001)    
    freq,gain = model.tf(start,end,freq)
    #gain *= 0.2
    return freq, gain

def bode_measurement(optic,stage,dof):
    prefix = './measurements/typeBp/klog8634/'
    fname = prefix + '{0}_{1}{2}_exc_190411man.xml'.format(optic,stage,dof)
    meas = SusDtt(fname)
    _from = 'K1:VIS-{0}_{1}_TEST_{2}_EXC'.format(optic,stage,dof)
    _to = 'K1:VIS-{0}_{1}_DAMP_{2}_IN1_DQ'.format(optic,stage,dof)
    _freq, _gain, _coh = meas.tf(_from,_to)
    return _freq, _gain, _coh


if __name__=='__main__':    
    fig,ax = plt.subplots(3,3,sharex='col',sharey='row',figsize=(10,6))
    plt.subplots_adjust(hspace=0.1, wspace=0.15,
                        left=0.1, right=0.95,
                        top=0.88, bottom=0.1)
    optics = ['PR3']
    stages = ['IM']    
    dofs = ['L','T','V']
    optic = optics[0]
    stage = stages[0]
    title = 'Compliance of PR3_IM_{L,T,V}'
    plt.suptitle(title,fontsize=18)
    for i,dof in enumerate(dofs[:3]):
        freq, gain = bode_model(optic,stage,dof)
        _freq, _gain, _coh = bode_measurement(optic,stage,dof)
        gain *= np.mean((np.abs(_gain)[:5]/np.abs(gain)[:5])) #[1]
        ax[0][i].loglog(freq,np.abs(gain),'k-',label='Model')
        ax[0][i].loglog(_freq,np.abs(_gain),'ro',markersize=2,label='Measurement')
        ax[1][i].semilogx(freq,np.rad2deg(np.angle(gain)),'k-')
        ax[1][i].semilogx(_freq,np.rad2deg(np.angle(_gain)),'ro',markersize=2,label='Measured')
        ax[0][i].set_title('{0} -> {1}'.format(dof,dof))
        ax[2][i].semilogx(_freq,_coh,'ro',markersize=2)
        ax[1][i].set_xlim(1e-2,1e1)    
        ax[1][i].set_yticks(range(-180,181,90))
        ax[2][i].set_xlabel('Frequency [Hz]')
        ax[1][i].grid(which='major',color='black',linestyle='-')
        ax[1][i].grid(which='minor',color='black',linestyle=':')
        ax[0][i].grid(which='major',color='black',linestyle='-')
        ax[0][i].grid(which='minor',color='black',linestyle=':')
        ax[2][i].grid(which='major',color='black',linestyle='-')
        ax[2][i].grid(which='minor',color='black',linestyle=':')
        ax[0][i].legend(loc='upper left')
    ax[0][0].set_ylabel('Magnitude')
    ax[1][0].set_ylabel('Phase [Degree]')
    ax[2][0].set_ylabel('Coherence')
    ax[0][0].set_ylim(1e-4,1e2)
    ax[1][0].set_ylim(-181,181)
    ax[2][0].set_ylim(0,1)
    #plt.tight_layout()
    plt.savefig('TF.png')
    plt.close()
    
    # [1] Adjust the model data to the measured one. Note that the data points in lower frequency are unreliable.
