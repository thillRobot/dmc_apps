%% ME3050 - Mech. Engr. Analysis
%
%  Tristan Hill - 7/24/2014 - 04/05/2017
%
%  Modeling Rotational Systems - Non Linear Pendulum Problem - ODE45 soln
%
%%

clc
clear variables;
close all;

m=1;g=9.8;
l=20*(1/100);
%uo=50*pi/180; %u=theta
% vo=0; %let v = d(theta)/dt =du/dt
% c=1; %drag
Io=m*l^2;

kt=.056; %0.056 in-lbs/deg https://www.thespringstore.com/torsion-spring-torque-calculator.html

kt=1.5;
kt=kt*(1/8.85)*(180/pi);

wn=sqrt((kt-m*g*l)/Io)
f=wn/(2*pi)
% r1=sqrt(-(kt-m*g*l)/Io)


%define the system of 2 ODEs
ode_sys=@(t,z) [z(2)
                (m*g*l*sin(z(1))-kt*z(1))/Io];

%define the initial conditions [ theta(0), dtheta/dt(0) ] 
theta0=5*pi/180;
thetadot0=0;
initcond=[theta0,thetadot0];

% colors=['r*';'b*';'g*'];          
% time=0:0.1:3; %setup the independent variable 
tstart=0;
tstop=3;
dt=.01;
time=tstart:dt:tstop;

[t45,z45]=ode45(ode_sys,[tstart tstop],initcond);

z45_deg=z45*(180/pi);

% check against trial solution method

zcheck=theta0*cos(wn*time)*(180/pi)

figure(2);hold on
plot(t45,z45_deg(:,1),'r')
plot(time,zcheck,'b')
% plot(t45,z45_deg(:,2),'b')
title('Non-Linear Pendulum - Time Response with ODE45')
legend('Angular Position (deg) - ODE45 ','Angular Position (deg) - Trial Solution')
xlabel('time(s)')
% ylabel('angular position (deg)')
