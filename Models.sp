

******************************MODELS AND SUBCIRCUITS*****************

**** VOLTAGE CONTROLED SWITCH ****
* v(N)>0 => V(OUT) = V(IN1)
.SUBCKT  swt  IN1  IN2 OUT N   
G1 IN1 OUT VCR PWL(1) N 0 -0.5,100G 0.5,1m  
G2 IN2 OUT VCR PWL(1) N 0 -0.5,1m 0.5,100G  
.ENDS swt


**** Neuron ****
.SUBCKT NEURON in Q Qb CLK VDD VSS delay=100ns

.SUBCKT  COMPARATOR  2 3 4 8 
*pin order in VDD VSS out

VOS 1 0 DC 0V
M1 5 1 7 4 NMOS  L=1.800E-07   W=2.200E-07 
M2 6 2 7 4 NMOS  L=1.800E-07   W=2.200e-007 
M3 5 5 3 3 PMOS  L=1.800E-07   W=2.2e-007 
M4 6 5 3 3 PMOS  L=1.800E-07   W=2.2e-007 
M5 7 9 4 4 NMOS  L=1.800E-07   W=2.200e-007 
M6 8 6 3 3 PMOS  L=1.800E-07   W=2.2e-007   
M7 8 9 4 4 NMOS  L=1.800E-07   W=2.2e-007  
M8 9 9 4 4 NMOS  L=1.800E-07    W=5e-005 

.lib 'mm018.l' TT

mr1 9 0 111 111 NMOS   L=1.800E-07   W=2.200E-07 
mr2 111 0 0 0 NMOS   L=1.800E-07   W=2.200E-07 
.ENDS COMPARATOR




.SUBCKT not in  VDD VSS out 

mQ1 out in VSS VSS NMOS  L=1.800E-07  W=2.200E-07 
mQ3 out in VDD VDD PMOS  L=1.800E-07  W=2.200E-07

.lib 'mm018.l' TT

.ENDS not


rread in 0 1000000

Gdelmid dd 0 DELAY 0 in  TD=delay SCALE=1 NPDELAY=25ns
Rread2 dd 0 1 

Xcomp dd vdd vss vff COMPARATOR



.SUBCKT DFF D CLK Q VDD VSS 

.lib 'mm018.l' TT
*Mxxx nd ng ns mname
M11 D1H D VDD VDD PMOS L=1.800E-07  W=2.200E-07 
M12 D1L CLK D1H D1H PMOS L=1.800E-07  W=2.200E-07 
M13 D1L D VSS VSS NMOS L=1.800E-07  W=2.200E-07 

M21 D2H D1H VDD VDD PMOS L=1.800E-07  W=2.200E-07 
M22 D2H CLK D2L D2L NMOS L=1.800E-07  W=2.200E-07 
M23 D2L D1L VSS VSS NMOS L=1.800E-07  W=2.200E-07 

M31 Q D2H VDD VDD PMOS L=1.800E-07  W=2.200E-07  
M33 Q D2L VSS VSS NMOS L=1.800E-07  W=2.200E-07 

.ENDS DFF



Xdf Vff CLK Qb VDD VSS DFF
XNNN Qb VDD VSS Q not


.ENDS NEURON




