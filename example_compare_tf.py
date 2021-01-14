import numpy as np
import matplotlib.pyplot as plt

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
    if stage=='IM':
        end = 'ctrl_{2}/OSEM_{0}{1}'.format(stage,dof,sustype(optic))
    elif stage in ['SF','BF'] and dof=='GAS':
        end = 'ctrl_{2}/LVDT_{0}{1}'.format(stage,dof,sustype(optic))
    elif stage in ['F0','F1','F2','F3'] and dof=='GAS':
        end = 'ctrl_{2}/LVDT_{0}{1}'.format(stage,dof,sustype(optic))        
    elif stage=='BF':
        end = 'ctrl_{2}/LVDT_{0}{1}'.format(stage,dof,sustype(optic))
    elif stage=='TM':
        end = 'ctrl_{2}/OpLev_{0}{1}'.format(stage,dof,sustype(optic))
    else:
        raise ValueError('{0}'.format(stage))
    freq = np.logspace(-2,2,1001)
    freq,gain = model.tf(start,end,freq)
    return freq, gain

def bode_measurement(optic,stage,dof):
    prefix = './measurements/{0}/'.format(optic)
    fname = prefix + '{0}_{1}{2}.xml'.format(optic,stage,dof)
    meas = SusDtt(fname)
    _from = 'K1:VIS-{0}_{1}_TEST_{2}_EXC'.format(optic,stage,dof)

    # These differencies should be eliminated..
    if optic=='PR2' and stage=='BF' and dof!='GAS':
        _to = 'K1:VIS-{0}_{1}_DAMP_{2}_IN1'.format(optic,stage,dof)
    elif optic=='PR2' and stage=='IM' and dof in ['L','R','P','Y']:
        _to = 'K1:VIS-{0}_{1}_DAMP_{2}_IN1'.format(optic,stage,dof)
    elif optic=='BS' and stage in ['F0','F1','BF']:
        _to = 'K1:VIS-{0}_{1}_DAMP_{2}_IN1'.format(optic,stage,dof)
    elif optic=='BS' and stage in ['IM'] and dof in ['L','T']:
        _to = 'K1:VIS-{0}_{1}_DAMP_{2}_IN1'.format(optic,stage,dof)        
    elif stage in ['IP','SF','BF','IM','F0','F1','F2','F3']:
        _to = 'K1:VIS-{0}_{1}_DAMP_{2}_IN1_DQ'.format(optic,stage,dof)        
    elif stage=='TM':
        _dict = {'L':'LEN','P':'PIT','Y':'YAW'}
        _to = 'K1:VIS-{0}_{1}_OPLEV_{2}_DIAG_DQ'.format(optic,stage,_dict[dof])
    else:
        raise ValueError('!')
        
    _freq, _gain, _coh = meas.tf(_from,_to)
    return _freq, _gain, _coh


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

def plot_compliance(optic,stage,dofs):
    titles = ['{0} -> {1}'.format(dof,dof) for dof in dofs]
    data = [bode(optic,stage,dof) for dof in dofs]
    fname = './figures/Compliance_{0}_{1}{2}.png'.\
      format(optic,stage,''.join(dofs))        
    plot4(data,titles,fname)

def plot_compliance_optics(optics,stage,dof):
    titles = optics
    data = [bode(optic,stage,dof) for optic in optics]
    fname = './figures/Compliance_{0}_{1}{2}.png'.\
      format('PRs',stage,dof)        
    plot4(data,titles,fname)
    

if __name__=='__main__':
    # For SRs
    optics = ['BS','SR2','SR3','SRM']
    for optic in optics[:1]:
        plot_compliance(optic,'F0',['GAS'])
        plot_compliance(optic,'F1',['GAS'])
        plot_compliance(optic,'BF',['GAS'])    
        plot_compliance(optic,'IM',['L','T','V'])
        plot_compliance(optic,'IM',['R','P','Y'])
        plot_compliance(optic,'TM',['L','P','Y'])
    exit()
    
    #plot_compliance_optics(optics,'F0','GAS')
    #exit()
    
    # For PRs
    optics = ['PR2','PR3','PRM']
    plot_compliance_optics(optics,'SF','GAS')
    for dof in ['L','T','V','R','P','Y','GAS']:
        plot_compliance_optics(optics,'BF',dof)
    for dof in ['L','T','V','R','P','Y']:
        plot_compliance_optics(optics,'IM',dof)
    for dof in ['L','P','Y']:
        plot_compliance_optics(optics,'TM',dof)        
        
    for optic in optics:
        plot_compliance(optic,'SF',['GAS'])
        plot_compliance(optic,'BF',['GAS'])    
        plot_compliance(optic,'BF',['L','T','V'])
        plot_compliance(optic,'BF',['R','P','Y'])    
        plot_compliance(optic,'IM',['L','T','V'])
        plot_compliance(optic,'IM',['R','P','Y'])
        plot_compliance(optic,'TM',['L','P','Y'])
