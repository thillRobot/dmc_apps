%
% ME3050 - TTU 
% State Space System Toolbox with MATLAB
% Tristan Hill, March 05, 2020
%

clear variables;close all;clc

% define any constants needed
m1=
m2=
k1=
k2=
c1=

% define the components of the State Model
A=
B=
C=
D=

% use the SS function to create a system object
sys1=ss(A,B,C,D);

% use various function to simulate system response
figure(1);
initial(sys1,[1,0,0,0])