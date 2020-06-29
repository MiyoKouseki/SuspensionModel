#%%
import numpy as np
import sys
import os
from matplotlib import pylab as plt
from gwpy.frequencyseries import FrequencySeries
from scipy import signal as sig, interpolate
import seaborn as sns
sns.set('notebook', 'whitegrid', 'colorblind', font_scale=1.5, font='Times New Roman',
        rc={"lines.linewidth": 2, 'grid.linestyle': '--'})

cdir = os.getcwd()
rootdir = cdir.split(os.sep+'simulation')[0]
sys.path.append(os.path.join(rootdir,'model','TypeAwHL'))
from VISss import sysc0

noisedir = os.path.join(rootdir,'noise')
sys.path.append(noisedir)
import noise

# %% initial parameters
EX = sysc0('dampedETMX2')
freq = np.linspace(0.01,10,num=1000)

#%% Load noise
ps_l = noise.ps_noise('L')
ip_l = noise.lvdt_noise('IPL')
bf_l = noise.lvdt_noise('BFL')
seis = noise.seismicnoise()

data_interp = interpolate.interp1d(seis.frequencies,seis.value)
data = data_interp(freq)
seis_i = FrequencySeries(data,frequencies=freq,
                           unit='m/rtHz')

data_interp = interpolate.interp1d(ps_l.frequencies,ps_l.value)
data = data_interp(freq)
psl_i = FrequencySeries(data,frequencies=freq,
                           unit='m/rtHz')

data_interp = interpolate.interp1d(ip_l.frequencies,ip_l.value)
data = data_interp(freq)
ipl_i = FrequencySeries(data,frequencies=freq,
                           unit='m/Hz(1/2)')

data_interp = interpolate.interp1d(np.append(0,bf_l.frequencies.value),np.append(0,bf_l.value))
data = data_interp(freq)
bfl_i = FrequencySeries(data,frequencies=freq,
                           unit='m/Hz(1/2)')
# plot
#plt.loglog(ps_l, ip_l,bf_l,seis)
#plt.legend(['ps','IP LVDT','BF LVDT','seismic'])

# %% tfs

TFgnd = abs(EX.TF('accGndL','dispTML',freq,Plot=False))
TFgndHL = abs(EX.TF('accHL1GndL','dispTML',freq,Plot=False))
TFIMps = abs(EX.TF('noisePS_IML','dispTML',freq,Plot=False))
TFMNps = abs(EX.TF('noisePS_MNL','dispTML',freq,Plot=False))
TFBFLVDT = abs(EX.TF('noiseLVDT_BFL','dispTML',freq,Plot=False))
TFIPLVDT = abs(EX.TF('noiseLVDT_IPL','dispTML',freq,Plot=False))

# %% TML displacement

disp_seis = seis_i*TFgnd*(2*np.pi*freq)*(2*np.pi*freq)
disp_seisHL = seis_i*TFgndHL*(2*np.pi*freq)*(2*np.pi*freq)
disp_IMPS = psl_i*TFIMps 
disp_MNPS = psl_i*TFMNps 
disp_BFLVDT = bfl_i*TFBFLVDT 
disp_IPLVDT = ipl_i*TFIPLVDT

#%%
total = (disp_seis.value*disp_seis.value
        + disp_seisHL.value*disp_seisHL.value
        + disp_IMPS.value*disp_IMPS.value
        + disp_MNPS.value*disp_MNPS.value
        + disp_BFLVDT.value*disp_BFLVDT.value
        + disp_IPLVDT.value*disp_IPLVDT.value
        )**0.5
# %%

plt.loglog(disp_seis,'--',label='seismic')
plt.loglog(disp_seisHL,'--',label='seismic via HL')
plt.loglog(disp_IMPS,label='IM PS')
plt.loglog(disp_MNPS,label='MN PS')
plt.loglog(disp_BFLVDT,label='BF LVDT')
plt.loglog(disp_IPLVDT,label='IP LVDT')
plt.loglog(freq,total,'k:',label='total')
plt.legend()
plt.xlabel('Frequency [Hz]')
plt.ylabel('Displacement [m/rtHz]')
plt.ylim([1.e-22,1.e-4])
plt.savefig('./figs/dampedTM_disp2.png',bbox_inches="tight")


# %%

freeEX = sysc0('freeETMX2')
TFTML = freeEX.TF('injTML','dispTML',freq)
TFMNL = freeEX.TF('injMNL','dispTML',freq)
Ftm = EX.TF('ISC_TML','fbTMLOCKLmon',freq)
Fmn = EX.TF('ISC_TML','fbMNLOCKLmon',freq)

#%% check TM, MN TF
plt.loglog(freq,abs(TFTML)*1.e-6,label='TM')
plt.loglog(freq,abs(TFMNL)*1.e-6,label='MN')
plt.legend()
plt.xlabel('Frequency [Hz]')
plt.ylabel('TF [m/cnt]')
plt.savefig('./figs/TFs_TM_MN_mpcnt.png',bbox_inches="tight")
#%% check cross-over
plt.loglog(freq,abs(Ftm*TFTML),label='TM loop')
plt.loglog(freq,abs(Fmn*TFMNL),label='MN loop')
plt.loglog(freq,abs(Ftm*TFTML+Fmn*TFMNL), label='SUM')
plt.legend()
plt.xlabel('Frequency [Hz]')
plt.ylabel('TF [m/cnt]')
plt.savefig('./figs/ServoTFs_TM_MN.png',bbox_inches="tight")

# %% estimated Feedback signals

FB_TM = total*abs(Ftm/(Ftm*TFTML+Fmn*TFMNL))
FB_MN = total*abs(Fmn/(Ftm*TFTML+Fmn*TFMNL))

plt.loglog(freq, FB_TM*1.e+6, label='TM FBsig')
plt.loglog(freq, FB_MN*1.e+6, label='MN FBsig')
plt.legend()
plt.xlabel('Frequency [Hz]')
plt.ylabel('FBsig [cnt]')
plt.ylim([0.1,1.e+5])
plt.savefig('./figs/FBsignals2.png',bbox_inches="tight")

#%% Naive test

plt.loglog(freq, total/abs(TFTML)*1.e+6, label='Xdisp/TF_TML')
plt.loglog(freq, total/abs(TFMNL)*1.e+6, label='Xdisp/TF_MNL')
plt.legend()
plt.ylim([0.1,1.e+5])
plt.xlabel('Frequency [Hz]')
plt.ylabel('FBsig [cnt]')
plt.savefig('./figs/Disp_devided_by_TFs.png',bbox_inches="tight")

# %%
TFs = [TFgnd, TFgndHL, TFIMps, TFMNps, TFBFLVDT,TFIPLVDT,TFTML,TFMNL,Ftm,Fmn]
import pickle
with open('TFs.pkl', 'wb') as pklfile:
  pickle.dump(TFs , pklfile)
#%%
import pickle
with open('TFs.pkl', 'rb') as pklfile:
  [TFgnd, TFgndHL, TFIMps, TFMNps, TFBFLVDT,TFIPLVDT,TFTML,TFMNL,Ftm,Fmn] = pickle.load(pklfile)

#%%
