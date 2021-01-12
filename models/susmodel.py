import scipy.io
import scipy
from control import matlab,tf
import control
from control import StateSpace
import numpy as np
from scipy import signal
import matplotlib.pyplot as plt

# Read linearized model as ABCD matrix

# ------------------------------------------------------------------------------

class SusModel():
    def __init__(self,optic,state='safe'):
        prefix = './models/abcd/'
        fname = prefix+'{0}_{1}.mat'.format(optic,state)
        mat_dict = scipy.io.loadmat(fname)
        st = mat_dict['linss']
        A,B,C,D,statename,outputname,inputname,operpoint,ts = st[0][0]
        self.ss_mimo = control.matlab.ss(A, B, C, D)
        self.inputname = np.asarray([i[0][0] for i in inputname])
        self.outputname = np.asarray([i[0][0] for i in outputname])

    def ss(self,start,end):
        '''
        '''
        idx_from = np.where(self.inputname==start)[0][0]
        idx_to = np.where(self.outputname==end)[0][0]
        print('From :',idx_from,self.inputname[idx_from])
        print('To   :',idx_to,self.outputname[idx_to])
        out = self.ss_mimo.returnScipySignalLTI()
        ss = out[idx_to][idx_from]
        self.ss_siso = control.ss(ss.A,ss.B,ss.C,ss.D)

    def tf(self,_input,_output,freq):
        ''' 

        ----
        Parameters:
        
        
        ----
        Returns
        '''
        self.ss(_input,_output)
        mag, phase, omega = matlab.bode(self.ss_siso,freq*2.0*np.pi,Plot=False)
        gain = mag*(np.exp(1j*phase))
        return freq,gain

    def bode(self,_input,_output,freq):
        #wrap = lambda phases : ( phases + np.pi) % (2 * np.pi ) - np.pi    
        #phase = np.rad2deg(wrap(phase))        
        pass
    
   
if __name__ == '__main__':    

    pr3 = SusModel('PR3')
    start = 'ctrl_typeBp/exc_IML'
    end = 'ctrl_typeBp/OSEM_IML'
    freq = np.logspace(-2,1,1001)    
    freq,IML2IML = pr3.tf(start,end,freq)
    
    fig,(ax0,ax1) = plt.subplots(2,1)
    ax0.loglog(freq,np.abs(IML2IML))
    ax1.semilogx(freq,np.rad2deg(np.angle(IML2IML)))    
    ax0.set_xlim(1e-2,1e1)
    ax0.set_ylabel('Magnitude')
    ax1.set_xlim(1e-2,1e1)
    ax1.set_ylim(-181,181)
    ax1.set_yticks(range(-180,181,90))
    ax1.set_xlabel('Frequency [Hz]')
    ax1.set_ylabel('Phase [Degree]')
    ax1.grid(which='major',color='black',linestyle='-')
    ax1.grid(which='minor',color='black',linestyle=':')
    ax0.grid(which='major',color='black',linestyle='-')
    ax0.grid(which='minor',color='black',linestyle=':')
    plt.savefig('TF.png')
    plt.close()
