import matplotlib.pyplot as plt

from SuspensionModel.noise.typeA import photosensor,geophone,lvdt,oplev
from SuspensionModel.noise import seismicnoise


# Geophone
geo = geophone(unit='m')

# Seismicnoise
seis_99 = seismicnoise(unit='m',percentile='99',axis='hor')
seis_90 = seismicnoise(unit='m',percentile='90',axis='hor')
seis_01 = seismicnoise(unit='m',percentile='1' ,axis='hor')
seis_50 = seismicnoise(unit='m',percentile='50',axis='hor')
seis_10 = seismicnoise(unit='m',percentile='10',axis='hor')

# IP/GAS-LVDT
lvdt_ipl = lvdt('IPL')
lvdt_ipt = lvdt('IPT')
lvdt_ipy = lvdt('IPY')
lvdt_gasf0 = lvdt('GASF0')
lvdt_gasf1 = lvdt('GASF1')
lvdt_gasf2 = lvdt('GASF2')
lvdt_gasf3 = lvdt('GASF3')
lvdt_gasbf = lvdt('GASBF')

# BF-LVDT
lvdt_bfl = lvdt('BFL')
lvdt_bft = lvdt('BFT')
lvdt_bfv = lvdt('BFV')
lvdt_bfr = lvdt('BFR')
lvdt_bfp = lvdt('BFP')
lvdt_bfy = lvdt('BFY')

# plot
fig,ax = plt.subplots(1,1,figsize=(9,6))
disp = True
if disp:
    ax.plot_mmm(seis_50,seis_01,seis_99,color='k',alpha=0.1)
    ax.plot_mmm(seis_50,seis_10,seis_90,color='k')
    ax.loglog(lvdt_ipl,label='LVDT')
    ax.loglog(geo,label='Geophone')
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


# MN/IM-PS
ps_lon = photosensor('L')
ps_tra = photosensor('T')
ps_ver = photosensor('V')
ps_rol = photosensor('R')
ps_pit = photosensor('P')
ps_yaw = photosensor('Y')    

# TM/MN-Oplev
oplev_tml = oplev('TML')
oplev_tmp = oplev('TMP')
oplev_tmy = oplev('TMY')
oplev_mnl = oplev('MNL')
oplev_mnp = oplev('MNP')
oplev_mny = oplev('MNY')



    
