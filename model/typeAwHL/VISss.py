# -*- coding: utf-8 -*-
"""
Created on Wed Oct 09 09:21:46 2019

@author: Ayaka
"""

import os,sys
import numpy as np
import scipy as sc
#import pandas as pd

from matplotlib import pylab as plt
#import seaborn as sb
#sys.path.append('C:\\Users\\ayaka\\Dropbox (個人)\\Shoda\\src\\VIScontrolDesigner\\MakeSSModels')
import control
from control import matlab

class sysc0:
    def __init__(self, optic):
        ## Load files
        direc = os.path.dirname((__file__))
        A = np.loadtxt(os.path.join(direc,optic+'A.dat'), delimiter=',')
        B = np.loadtxt(os.path.join(direc,optic+'B.dat'), delimiter=',')
        C = np.loadtxt(os.path.join(direc,optic+'C.dat'), delimiter=',')
        D = np.loadtxt(os.path.join(direc,optic+'D.dat'), delimiter=',')
        
        if 'PR' in optic:
            Type = 'TypeBp'
        elif ('SR' in optic) or (optic=='BS'):
            Type = 'TypeB'
        elif 'TM' in optic:
            Type = 'TypeA'
        f = open(os.path.join(direc,Type+'Input.dat'))
        Invs = f.read()
        f.close()
        Invs = Invs.split('\n')
        
        f = open(os.path.join(direc,Type+'Output.dat'))
        Outvs = f.read()
        f.close()
        Outvs = Outvs.split('\n')
        
        ## Define attributes
        self.optic = optic
        self.type = Type
        self.A = A
        self.B = B
        self.C = C
        self.D = D
        self.InputNames = Invs
        self.OutputNames = Outvs
        
    def bode(self, inv, outv, freq):
        """
        Derive magnitude and phase of the TF from inv to outv.
        """
        sys = control.StateSpace(self.A, self.B, self.C, self.D)
        ninv = self.InputNames.index(inv)
        noutv = self.OutputNames.index(outv)
        [mag,phase,freq2] = matlab.bode(sys[noutv,ninv], freq*2*np.pi)
        phase = (phase + np.pi) % (2 * np.pi) - np.pi
        phase = 180.0/np.pi*phase
        return mag, phase
        
    def TF(self, inv, outv, freq, **kwargs):
        """
        Derive the TF (P) from inv to outv with the complex numbers
        """
        if 'Plot' in kwargs:
            Plot = kwargs['Plot']
        else:
            Plot = False
        sys = control.StateSpace(self.A, self.B, self.C, self.D)
        ninv = self.InputNames.index(inv)
        noutv = self.OutputNames.index(outv)
        [mag,phase,freq2] = matlab.bode(sys[noutv,ninv], freq*2*np.pi,Plot=Plot)
        G = mag*(np.e**(1j*phase))
        return G
    
    def fotonzpk(self, inv, outv):
        """
        Convert the TF to the zpk expression.
        """
        sys = control.StateSpace(self.A, self.B, self.C, self.D)
        ninv = self.InputNames.index(inv)
        noutv = self.OutputNames.index(outv)
        sys = sys[noutv,ninv]
        zpk = matlab.ss2zpk(sys.A, sys.B, sys.C, sys.D)
        
        #
        zz = zpk[0]/2./np.pi
        pp = zpk[1]/2./np.pi
        kk = zpk[2]/2./np.pi
        
        zz = list(np.round(zz,3))
        pp = list(np.round(pp,3))
        
        while set(zz) & set(pp):
            comm = list(set(zz)&set(pp))
            zz.remove(comm[0])
            pp.remove(comm[0])
        
        for i in range(len(zz)):
            if np.real(zz[i]) < 0:
                zz[i] = -1*zz[i]
        for i in range(len(pp)):
            if np.real(pp[i]) < 0:
                pp[i] = -1*pp[i]
        
        return zz, pp, kk

