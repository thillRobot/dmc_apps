%
% ME3050 - TTU 
% State Space System Toolbox with MATLAB
% Half Car Suspension Model
% Tristan Hill, September 29, 2020
%

clear variables;close all;clc

% define any constants needed
m=150
k1=200
c1=50
k2=200
c2=50
l1=1
l2=1

b=2
h=1
Io=1/12*m*(b^2+h^2)

% define the components of the State Space Model
% I derived theses by hand and scanned the pages, it is very hard to read
A=[0   , 1 , 0 , 0 
   -(k1+k2)/m, -(c1+c2)/m, (-l1^2*k1-l2^2*k2)/m, (l1*c1-l2*c2)/m
   0  , 0, 0 , 1
   (k1*l1-k2*l2)/Io, (c1*l1-c2*l2)/Io,(-l1^2*k1-l2^2*k2)/Io (-l1^2*c1-l2^2*c2)/Io ]
B=[c2/m
    c2*(c1+c2)/m^2+c2*l2*(l1*c1-l2*c2)/(m*Io)+k2/m
    c2*l2/Io
    c2*(c1*l1-c2*l2)/(Io*m)+c2*l2*(-l1^2*c1-l2^2)/Io^2+k2*l2/Io]
C=[1, 0, 0, 0
   0, 1, 0, 0
   0, 0, 1, 0
   0, 0, 0, 1]

D=[0 
   c2/m
   0
   c2*l2/Io]

% use the SS function to create a system object
sys1=ss(A,B,C,D);

sys1.OutputName={'x1','x2','x3','x4'}

% use various function to simulate system response
%figure(1);
%initial(sys1,[0,0])
% 
time=0:0.1:25

figure(2);
opts=stepDataOptions('StepAmplitude',10)
step(sys1,time,opts)
% 
% figure(3);
% impulse(sys1)

