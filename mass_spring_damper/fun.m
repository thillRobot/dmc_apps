function [y] = fun(x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    p.g=9.8; %m/s^2
    p.m=1; %mass 
    p.k=2; %stiffness
    p.c=0; %damping
    % intitial conditions 
    
    p.l=x;
    p.Io=p.m*p.l^2;
    p.kt=2;
    
    y=sqrt((p.kt-p.g*p.m*p.l)/p.Io)-4*pi;
end

