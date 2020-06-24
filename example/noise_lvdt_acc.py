import numpy as np
import matplotlib.pyplot as plt

from SuspensionModel.noise.typeA import geophone,lvdt
from SuspensionModel.noise import seismicnoise

# compare lvdt and geophone and seismicnoise
seis_99 = seismicnoise(unit='m',percentile='99',axis='hor')
seis_90 = seismicnoise(unit='m',percentile='90',axis='hor')
seis_01 = seismicnoise(unit='m',percentile='1' ,axis='hor')
seis_50 = seismicnoise(unit='m',percentile='50',axis='hor')
seis_10 = seismicnoise(unit='m',percentile='10',axis='hor')
lvdt_ip = lvdt('IPL')
lvdt_bf = lvdt('BFL')
geo = geophone(unit='m')

fig,ax = plt.subplots(1,1,figsize=(9,6))
ax.plot_mmm(seis_50,seis_01,seis_99,color='k',alpha=0.1)
ax.plot_mmm(seis_50,seis_10,seis_90,color='k')
ax.loglog(lvdt_ip,label='LVDT(IP)')
ax.loglog(lvdt_bf,label='LVDT(BF)')
ax.loglog(geo,label='Geophone')
ax.set_ylabel('Displacement [m/rtHz]')
ax.set_ylim(1e-12,1e-5)
ax.set_xlim(1e-2,1e2)
ax.grid(which='major',linestyle='--')
ax.grid(which='minor',linestyle=':')
ax.legend()
ax.set_xlabel('Frequency [Hz]')
plt.savefig('noise_lvdt_acc.png')
plt.close()
