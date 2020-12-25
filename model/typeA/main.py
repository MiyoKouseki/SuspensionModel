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
    print(filter(lambda x: 'accGndL' in x, inputname))
    #print filter(lambda x: 'IPL' in x, inputname)
    # read as SISO
    #start = 'controlmodel/noiseActIPL'
    start = 'controlmodel/accGndL'
    #end = 'controlmodel/LVDT_IPL'
    end = 'controlmodel/dispBFL'
    idx_from = np.where(inputname==start)[0][0]
    idx_to = np.where(outputname==end)[0][0]
    print('From :',idx_from,inputname[idx_from])
    print('To   :',idx_to,outputname[idx_to])
    out = ss.returnScipySignalLTI()
    ss = out[idx_to][idx_from]
    ss_siso = control.ss(ss.A,ss.B,ss.C,ss.D)
    # print A[:8,:8]
    # print ss.A[:8,:8]
    # print ss_siso.A[:8,:8]
    # print A.shape,B.shape,C.shape,D.shape
    # print ss.A.shape,ss.B.shape,ss.C.shape,ss.D.shape
    # print ss_siso.A.shape,ss_siso.B.shape,ss_siso.C.shape,ss_siso.D.shape
    # print ss_siso.zero()
    
    # Plot
    wrap = lambda phases : ( phases + np.pi) % (2 * np.pi ) - np.pi
    f = np.logspace(-3,1,1001)
    mag, phase,w = matlab.bode(ss_siso,f*2.0*np.pi,Plot=False)
    mag = mag*(w**2)
    phase = np.rad2deg(wrap(phase-np.pi))
    fig,(ax0,ax1) = plt.subplots(2,1)
    f = w/2.0/np.pi
    ax0.loglog(f,mag)
    ax1.semilogx(f,phase)
    ax0.set_xlim(1e-2,1e1)
    ax1.set_xlim(1e-2,1e1)
    ax0.set_ylim(1e-20,1e1)
    ax1.set_ylim(-181,181)
    ax1.set_yticks(range(-180,181,90))
    ax1.set_xlabel('Frequency [Hz]')
    ax1.grid(which='major',color='black',linestyle='-')
    ax1.grid(which='minor',color='black',linestyle=':')
    ax0.grid(which='major',color='black',linestyle='-')
    ax0.grid(which='minor',color='black',linestyle=':')
    plt.savefig('TF.png')
    plt.close()
