import dtt2hdf
from dtt2hdf import read_diaggui,DiagAccess

class SusDtt():
    def __init__(self,fname):
        self.data = DiagAccess(fname)

    def tf(self,_input,_output):
        _tf = self.data.xfer(_output,_input).xfer
        _coh = self.data.xfer(_output,_input).coh
        _omega = self.data.xfer(_output,_input).FHz
        return _omega,_tf,_coh       

if __name__=="__main__":
    pr3 = SusDtt('./typeBp/klog8634/PR3_IML_exc_190411man.xml')
    _from = 'K1:VIS-PR3_IM_TEST_L_EXC'
    _to = 'K1:VIS-PR3_IM_DAMP_L_IN1_DQ'
    freq, gain, coh = pr3.tf(_from,_to)
    
