%
% ME3050 - TTU 
% State Space System Toolbox with MATLAB
% Tristan Hill, March 05, 2020
%

clear variables;close all;clc

% define any constants needed
m=150
k1=200
c1=50
%f=0

% define the components of the State Model
A=[0   , 1
   -k1/m,-c1/m]
B=[0 
   1/m]
C=[1, 0
   k1, 0
   -k1/m, -c1/m]
D=[0 
   0
   1/m]

% use the SS function to create a system object
sys1=ss(A,B,C,D);

sys1.OutputName={'pos','spring force','accel'}

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

