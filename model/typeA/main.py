import scipy.io
import scipy
from control import matlab,tf
import control
from control import StateSpace
import numpy as np
from scipy import signal
import matplotlib.pyplot as plt

# Read linearized model as ABCD matrix

def tf(ss,start,end):
    mat_dict = scipy.io.loadmat("./linmod/noctrl.mat")
    st = mat_dict['linss']
    A,B,C,D,statename,outputname,inputname,operpoint,ts = st[0][0]
    ss = control.matlab.ss(A, B, C, D)
    inputname = np.asarray([i[0][0] for i in inputname])
    outputname = np.asarray([i[0][0] for i in outputname])
    
    idx_from = np.where(inputname==start)[0][0]
    idx_to = np.where(outputname==end)[0][0]
    print('From :',idx_from,inputname[idx_from])
    print('To   :',idx_to,outputname[idx_to])
    out = ss.returnScipySignalLTI()
    ss = out[idx_to][idx_from]
    ss_siso = control.ss(ss.A,ss.B,ss.C,ss.D)
    return ss_siso

if __name__ == '__main__':
    mat_dict = scipy.io.loadmat("./linmod/noctrl.mat")
    st = mat_dict['linss']
    A,B,C,D,statename,outputname,inputname,operpoint,ts = st[0][0]
    ss = control.matlab.ss(A, B, C, D)
    inputname = np.asarray([i[0][0] for i in inputname])
    outputname = np.asarray([i[0][0] for i in outputname])
    
    # read as SISO
    #start = 'controlmodel/noiseActIPL'
    #end = 'controlmodel/LVDT_IPL'
    start = 'TypeA_siso180515/noiseActMNL'
    start = 'TypeA_siso180515/accGndV'
    end = 'TypeA_siso180515/dispTML'
    print(inputname)
    idx_from = np.where(inputname==start)[0][0]
    idx_to = np.where(outputname==end)[0][0]
    print('From :',idx_from,inputname[idx_from])
    print('To   :',idx_to,outputname[idx_to])
    out = ss.returnScipySignalLTI()
    ss = out[idx_to][idx_from]
    ss_siso = control.ss(ss.A,ss.B,ss.C,ss.D)
    
    # Plot
    wrap = lambda phases : ( phases + np.pi) % (2 * np.pi ) - np.pi
    f = np.logspace(-2,1,1001)
    mag, phase,w = matlab.bode(ss_siso,f*2.0*np.pi,Plot=False)
    mag = mag*(w**2)
    phase = -1*phase
    phase = np.rad2deg(wrap(phase))    
    fig,(ax0,ax1) = plt.subplots(2,1)
    f = w/2.0/np.pi
    ax0.loglog(f,mag)
    ax1.semilogx(f,phase)
    ax0.set_xlim(1e-2,1e1)
    ax0.set_ylabel('Magnitude')
    ax1.set_xlim(1e-2,1e1)
    #ax0.set_ylim(1e-20,1e1)
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
