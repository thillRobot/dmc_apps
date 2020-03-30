%
% ME3050 - TTU 
% State Space System Toolbox with MATLAB
% Tristan Hill, March 05, 2020
%

clear variables;close all;clc

% define any constants needed
m=100;
k=200;
c=50;

x0=0;
v0=3;

time=0:.1:15;

% define the components of the State Space Model
A=[0, 1 ;-k/m, -c/m]

B=[0; 1/m];

C=[1, 0; k, 0; -k/m, -c/m]

D=[0;0;1/m]

% use the SS function to create a system object
sys1=ss(A,B,C,D);
sys1.OutputName={'Pos., x','Force, kx','Accel., d^2(x)/d(t)^2'};

% use various functions to simulate system response
% response from initial conditions
figure(1)
initial(sys1,[v0,x0],time)

% step response
figure(2)
opts=stepDataOptions('StepAmplitude',3);
step(sys1,time,opts)

% impulse response
figure(3)
impulse(sys1)

