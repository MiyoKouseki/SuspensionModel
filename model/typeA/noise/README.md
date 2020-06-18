# Type-A sensor and actuator noise
## Sensors and actuators

| Item | Used for | Typical Noise Data |
|---|---|---|
| IP/GAS-LVDT | IP\_{L,T,Y}, GAS\_{F0,F1,F2,F3,BF} | ipgas_lvdt.dat |
| BF-LVDT | BF\_{L,T,V,Y,R,P} | bf_lvdt.dat |
| PS | {MN,IM}\_{L,T,V,Y,R,P} | ps_6dof.txt |
| Oplev | TM\_{L,P,Y} | from JGW-T1202403-v1 |
| hoge | huge | poyo |

The original noise data are copied from Fuji-kun's working space according to his Matlab script[1]. However, actuator noise is listed because he did not use. This issue and the other are listed in 'Remainning Issues' below.


## Usage 
```
from SuspensionModel.model.typeA import noise
from numpy as np

freq = np.logspace(-2,3,1000)

# sensor noise
mn_l = noise.photosensor(freq, 'MN','L')
ip_p = noise.ipgas_lvdt(freq, 'IP','P')
gas_f0 = noise.ipgas_lvdt(freq, 'GAS','F0')
bf_t = noise.bf_lvdt(freq, 'BF','T')
tm_l = noise.oplev(freq, 'TM','L')

# actuator noise
...

```

## Typical Noise Data
### ipgas_lvdt.dat
* Copied from `LVDTnoiseADC_disp.dat` [2]
* When and how was this data taken?

### bf_lvdt.dat
* Copied from `F7LVDTprotonoise.dat` [3]
* When and how was this data taken?
 
### ps_6dof.txt
* Copied from `ETMX_MN_PS_noise_level_20191107.txt` [4]
* When and how was this data taken?



## Remainning Issues
 - Read klog how were typical data measured.
 - Find actual OpLev noise. (allthough high frequency region is fine)
 - Find actual actuator noise. Fuji-kun did not use the actuator noise in his calculation. He also mentioned that Tanioka-kun would have some measured data when he worked on TMS-VIS.


## Reference
 1. `/kagra/Dropbox/Personal/Fujii/TypeA/simulation/IPdcdamp_IPsc_20191105config_closed_wMNPS_6dof_IMY_sensnoise.m`
 2. `/kagra/Dropbox/Personal/Fujii/TypeA/simulation/noise/LVDTnoiseADC_disp.dat`
 3. `/kagra/Dropbox/Personal/Fujii/TypeA/simulation/noise/F7LVDTprotonoise.dat`
 4. `/users/VIS/TypeA/general/LogNotes/20191107/ETMX_MN_PS_noise_level_20191107.txt`


