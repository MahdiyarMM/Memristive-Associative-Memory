%% initialization
clc
close all
%clear all

%% load patterns
% PicA(:,:,:)=imread('C:\Users\Surface\Documents\MATLAB\BAM\A.jpg');
% PicB(:,:,:)=imread('C:\Users\Surface\Documents\MATLAB\BAM\B.jpg');
% Pic1(:,:,:)=imread('C:\Users\Surface\Documents\MATLAB\BAM\1.jpg');
% Pic2(:,:,:)=imread('C:\Users\Surface\Documents\MATLAB\BAM\2.jpg');
% PicIn(:,:,:)=imread('C:\Users\Surface\Documents\MATLAB\BAM\nb.jpg');
% 
% PA = 2*PictoPat(PicA,7,7)-1;
% PB = 2*PictoPat(PicB,7,7)-1;
% P1 = 2*PictoPat(Pic1,5,5)-1;
% P2 = 2*PictoPat(Pic2,5,5)-1;
% P_in = 2*PictoPat(PicIn,7,7)-1;
% 
% p_x = [PA
%        PB];
% p_y = [P1
%        P2];
% 



p_y = [[-1,1,1,-1,1,-1,-1,1,1,-1,-1,1,1,1,1,1,1,-1,-1,1,1,-1,-1,1]
       [1,1,1,-1,1,-1,-1,1,1,1,1,-1,1,-1,-1,1,1,-1,-1,1,1,1,1,-1]
       [-1,1,1,-1,1,-1,-1,1,1,-1,-1,-1,1,-1,-1,-1,1,-1,-1,1,-1,1,1,-1]];
p_x = [[-1,-1,1,-1,-1,-1,1,-1,-1,-1,1,-1,-1,-1,1,-1,-1,-1,1,-1,-1,-1,1,-1]
       [1,1,1,1,-1,-1,-1,1,1,1,1,1,1,-1,-1,-1,1,-1,-1,-1,1,1,1,1]
       [1,1,1,1,-1,-1,-1,1,1,1,1,1,-1,-1,-1,1,-1,-1,-1,1,1,1,1,1]];
   
% P_in = [0,0,1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,1,1,1,0];
%  
% P_in = 2*P_in-1;
P_in = [1,-1,1,-1,-1,-1,1,1,-1,-1,-1,-1,-1,-1,1,-1,-1,-1,1,-1,-1,-1,1,-1];

inpx = P_in;
inpy = p_y(1,:);

inpx = inpx/10;
inpy = inpy/10;

s = size(p_x);
nnx = s(2);
s = size(p_y);
nny = s(2);
np = s(1);

%% Weight

w = zeros(nnx,nny);
for ii=1:np
    w = w + p_x(ii,:)'*p_y(ii,:);  
end

w = w/np;

pp = zeros(1,nnx*nny);
pn = zeros(1,nnx*nny);
np = zeros(1,nnx*nny);

for ii=1:nnx
    for jj=1:nny
    if w(ii,jj)>0
    pp((ii-1)*nny + jj) = 1/((1/7-1/16)*w(ii,jj)+1/16);
    pn((ii-1)*nny + jj) = 16;
    else
    pp((ii-1)*nny + jj) = 16;
    pn((ii-1)*nny + jj) = 1/((1/7-1/16)*(-w(ii,jj))+1/16);     
    end
    
    end
end
np = pn;
%% Write
m = fopen('D:\Paper\BAM\Simulation\HSPICE\m.txt','w');
fprintf(m,'\n');
fclose(m);
m = fopen('D:\Paper\BAM\Simulation\HSPICE\m.txt','wt');
fprintf(m,'');
fprintf(m ,'.SUBCKT  crb ');
writecorx = 1:1:nnx;
fmt = 'cpx%d ';
fprintf(m, fmt,writecorx);
writecorx = 1:1:nnx;
fmt = 'cnx%d ';
fprintf(m, fmt,writecorx);
writecory = 1:1:nny;
fmt = 'cpy%d ';
fprintf(m, fmt,writecory);
writecory = 1:1:nny;
fmt = 'cny%d ';
fprintf(m, fmt,writecory);
fmt = '\n\n';
fprintf(m, fmt);

wt = zeros(5,nny*nnx);
for ii=1:writecorx(nnx)
  for jj=1:writecory(nny)
     wt(1,(ii-1)*nny + jj) = ii;
     wt(2,(ii-1)*nny + jj) = jj;
     wt(3,(ii-1)*nny + jj) = ii;
     wt(4,(ii-1)*nny + jj) = jj;
     wt(5,(ii-1)*nny + jj) = pp((ii-1)*nny + jj);
  end
end
fmt = 'rpp%d_%d cpx%d cpy%d %.4fmeg\n';
fprintf(m, fmt,wt);

fmt = '\n\n';
fprintf(m, fmt);


wt = zeros(5,nny*nnx);
for ii=1:writecorx(nnx)
  for jj=1:writecory(nny)
     wt(1,(ii-1)*nny + jj) = ii;
     wt(2,(ii-1)*nny + jj) = jj;
     wt(3,(ii-1)*nny + jj) = ii;
     wt(4,(ii-1)*nny + jj) = jj;
     wt(5,(ii-1)*nny + jj) = pn((ii-1)*nny + jj);
  end
end
fmt = 'rpn%d_%d cpx%d cny%d %.4fmeg\n';
fprintf(m, fmt,wt);

fmt = '\n\n';
fprintf(m, fmt);


wt = zeros(5,nny*nnx);
for ii=1:writecorx(nnx)
  for jj=1:writecory(nny)
     wt(1,(ii-1)*nny + jj) = ii;
     wt(2,(ii-1)*nny + jj) = jj;
     wt(3,(ii-1)*nny + jj) = ii;
     wt(4,(ii-1)*nny + jj) = jj;
     wt(5,(ii-1)*nny + jj) = np((ii-1)*nny + jj);
  end
end
fmt = 'rnp%d_%d cnx%d cpy%d %.4fmeg\n';
fprintf(m, fmt,wt);

fmt = '\n\n';
fprintf(m, fmt);


wt = zeros(5,nny*nnx);
for ii=1:writecorx(nnx)
  for jj=1:writecory(nny)
     wt(1,(ii-1)*nny + jj) = ii;
     wt(2,(ii-1)*nny + jj) = jj;
     wt(3,(ii-1)*nny + jj) = ii;
     wt(4,(ii-1)*nny + jj) = jj;
     wt(5,(ii-1)*nny + jj) = 16;
  end
end
fmt = 'rnn%d_%d cnx%d cny%d %.4fmeg\n';
fprintf(m, fmt,wt);

fmt = '\n\n';
fprintf(m, fmt);

fmt = '.ENDS crb';
fprintf(m, fmt);

fmt = '\n\n';
fprintf(m, fmt);

fmt = '******************************END OF MODELS AND SUBCIRCUITS*****************\n******************************SIMULATION***********************************\n*******Circuit Architecture*************** \n*Crossbar';
fprintf(m, fmt);

fmt = '\nxcrb ';
fprintf(m, fmt);


fmt = 'cpx%d ';
fprintf(m, fmt,writecorx);
fmt = 'cnx%d ';
fprintf(m, fmt,writecorx);
fmt = 'cpy%d ';
fprintf(m, fmt,writecory);
fmt = 'cny%d ';
fprintf(m, fmt,writecory);

fmt = 'crb\n';
fprintf(m, fmt);

fmt = '\n\n*crossbar switches rows\n';
fprintf(m, fmt);

fmt = 'xscrbxp%d px%d wx%d cpx%d LS swt\n';
fprintf(m, fmt,[writecorx
                writecorx
                writecorx 
                writecorx]);

fmt = '\n\n';
fprintf(m, fmt);

fmt = 'xscrbxn%d nx%d hzx%d cnx%d LS swt\n';
fprintf(m, fmt,[writecorx
                writecorx
                writecorx 
                writecorx]);
            
fmt = '\n\n*crossbar switches colomns\n';
fprintf(m, fmt);

fmt = 'xscrbyp%d wy%d py%d cpy%d LS swt\n';
fprintf(m, fmt,[writecory
                writecory
                writecory 
                writecory]);
            
fmt = '\n\n';
fprintf(m, fmt);

fmt = 'xscrbyn%d hzy%d ny%d cny%d LS swt\n';
fprintf(m, fmt,[writecory
                writecory
                writecory 
                writecory]);
            
fmt = '\n\n*high z resistors\n';
fprintf(m, fmt);

fmt = 'Rhzx%d hzx%d 0 500G\n';
fprintf(m, fmt,[writecorx
                writecorx]);

fmt = '\n\n';
fprintf(m, fmt);

fmt = 'Rhzy%d hzy%d 0 500G\n';
fprintf(m, fmt,[writecory
                writecory]);

fmt = '\n\n*neurons\n';
fprintf(m, fmt);



fmt = 'xnx%d inx%d px%d nx%d CLKx VDD VSS NEURON delay=0us\n';
fprintf(m, fmt,[writecorx
                writecorx
                writecorx 
                writecorx]);
fmt = '\n\n';
fprintf(m, fmt);
            
fmt = 'xny%d iny%d py%d ny%d CLKy VDD VSS NEURON delay=0us\n';
fprintf(m, fmt,[writecory
                writecory
                writecory 
                writecory]);        

            
fmt = '\n\n*Neuron switches for pattern assignment\n';
fprintf(m, fmt);


fmt = 'xsnx%d patx%d wx%d inx%d ctrlx swt\n';
fprintf(m, fmt,[writecorx
                writecorx
                writecorx 
                writecorx]);
            
fmt = '\n\n';
fprintf(m, fmt);

fmt = 'xsny%d paty%d wy%d iny%d ctrly swt\n';
fprintf(m, fmt,[writecory
                writecory
                writecory 
                writecory]); 
            
fmt = '\n\n* voltage sources\n\nVDD VDD 0 DC 0.5VOLT\nVSS VSS 0 DC -0.5VOLT\n\n*input pattern\n';
fprintf(m, fmt);


fmt = 'vpatx%d patx%d 0 %.4f\n';
fprintf(m, fmt,[writecorx
                writecorx
                inpx]);
fmt = '\n\n';
fprintf(m, fmt);
            
fmt = 'vpaty%d paty%d 0 %.4f\n';
fprintf(m, fmt,[writecory
                writecory
                inpy]);
            
fmt = '\n\n******Control Signals***********\n*CLK\n';
fprintf(m, fmt);

fmt = 'VCLKx CLKx 0 PULSE 0.5 -0.5 .5us .1ns .1ns 0.1us 1us\nVCLKy CLKy 0 PULSE 0.5 -0.5 1us .1ns .1ns 0.1us 1us\n';
fprintf(m, fmt);


fmt = '\n*Layer state x to Y->0.5 y to X->-0.5 \n';
fprintf(m, fmt);

fmt = 'VLS LS 0 PULSE -0.5 0.5 0.75us .1ns .1ns 0.5us 1us \n\n';
fprintf(m, fmt);

fmt = '*ctrl _input control siganl_\nvctrlx ctrlx 0 PWL 0 0.5 0.75us 0.5 .751us -0.5 500us -0.5\nvctrly ctrly 0 -0.5\n\n.tran 0.01ns  3us UIC\n.option list node post=1';
fprintf(m, fmt);

fclose(m);