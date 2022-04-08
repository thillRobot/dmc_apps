
% Armature Controlled DC motor Model
% Ch 6 - System Dynamics - Palm

clear variables
close all

I=9e-5
Ra=0.5
c=1e-4
La=2e-3

% transfer function for Ia(s)/Va(s) 
sys1=tf([I,c],[La*I,I*Ra+c*La,c])

[Ia_step,t_step]=step(sys1)

figure(1)
plot(t_step,Ia_step)