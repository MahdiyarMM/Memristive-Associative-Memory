
.SUBCKT  swt  IN1  IN2 OUT N   
G1 IN1 OUT VCR PWL(1) N 0 -0.5,100G 0.5,1m  
G2 IN2 OUT VCR PWL(1) N 0 -0.5,1m 0.5,100G  
.ENDS swt

vVDC1 in1 0 dc 1,7
vVDC2 in2 0 dc -4
xs1 in1 in2 out ctrl swt
xs2 out3 out4 out ctrl2 swt
vc ctrl 0 PWL 0 -0.5 40us -0.5 40.01us 0.5 80us 0.5
vc2 ctrl2 0 PWL 0 -0.5 20us -0.5 20.01us 0.5 40us 0.5 40.01us -0.5 80us -0.5
Rf1 out3 0 1
Rf2 out4 0 1

.tran 100ns 80us UIC
.option list node post=1
.end