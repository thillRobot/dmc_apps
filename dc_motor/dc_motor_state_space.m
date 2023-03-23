% ME3050 - Dynamics Modeling and Controls
% Tristan Hill - Spring 2023
% DC Motor Example (System Dynamics 4th ed., Palm, Pg 376-378)  
clear; close all; clc

% define system parameters
KT=0.05;  % (N*m/A)
Kb=KT;    % (N*m/A)
c=10e-4;  % (N*m*s/rad)   
Ra=0.5;   % (Ohm)
La=2e-3;  % (H)
I=9e-5;   % (kg*m^2)

% define components of the state equation
A=[-Ra/La -Kb/La
   KT/I -c/I];
% B matrix is 2x2 because u vector is 2x1
B=[1/La 0 
   0 -1/I];

% use first two states as outputs
C=[1 0
   0 1];
% the D matrix shape of B matrix 
D=[0 0
   0 0];

% calculate the steady state step response
Va=12;
TL=0;
ia_ss=(c*Va+Kb*TL)/(c*Ra+Kb*KT)
w_ss=(KT*Va-Ra*TL)/(c*Ra+Kb*KT)


% create a state space model object
sys1=ss(A,B,C,D);

% simulate a step response 
figure(1)
time=0:0.001:0.25;
opts=stepDataOptions('StepAmplitude',Va);
step(sys1,time,opts); grid on