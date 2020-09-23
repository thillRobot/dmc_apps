function [P] = linear_metronome_parameters(M,L,KT)
%LINEAR_METRONOME_PARAMETERS This function defines the params as a struct
% 
% The constant and derived parameters are defined in this function
% The parameters that define the simulation are also defined here
    
%define timer function params
    P.j=1; %timer index ?
    P.t=0; %start time
    P.stoptime=10;
    P.dt=.01; %time increment
    P.numtasks=round(P.stoptime/P.dt);
    
    % physical parameters
    P.g=9.8; %m/s^2
    P.m=M; %mass 
    P.k=50; %stiffness
    P.c=0; %damping
    P.l=L;
    P.Io=P.m*P.l^2;
    P.kt=KT;

    % derived parameters
    P.wn=sqrt((P.kt-P.g*P.m*P.l)/P.Io); % natural frequency (rad/s)
    P.fn=P.wn/(2*pi);                   % natural frequency (Hz)
    P.dr=P.c/(2*sqrt(P.m*P.k));         % damping ratio
    P.wd=P.wn*sqrt(1-P.dr^2);           % damped natural frequency (rad/s)
    P.sc=P.kt-P.g*P.m*P.l; %stability criterion
          
    % intitial conditions    
    P.th0=2*pi/180;
    P.y0=1;
    P.ydot0=1;
    
    % setup the graphics
    P.m_radius=.1;
    
end

