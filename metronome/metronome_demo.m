function [p]=metronome_demo()
    
    clc
    close all

    %define timer function params
    p.j=1; %timer index ?
    p.t=0; %start time
    p.stoptime=2;
    p.dt=.005; %time increment
    p.numtasks=round(p.stoptime/p.dt);
    
    p.scale=20
    p.scale2=2
    p.g=9.8; %m/s^2
    p.m=2; %mass 
    p.k=5; %stiffness
    p.c=0; %damping
    % intitial conditions 
    
    p.l=.05
    p.Io=p.m*p.l^2
    p.kt=2

    p.th0=2*pi/180;
    p.y0=1;
    p.ydot0=1;
    p.wn=sqrt((p.kt-p.g*p.m*p.l)/p.Io);
    p.fn=p.wn/(2*pi)
    
    
    p.dr=p.c/(2*sqrt(p.m*p.k));

    p.wd=p.wn*sqrt(1-p.dr^2);
   
    %draw a round mass
    p.m_radius=1;
    
    p.m_offx=-5;  
    p.m_offy=p.l*sin(pi/180+p.th0);
    
    m_th=0:.01:2*pi;    
    m_x=p.m_radius*cos(m_th)+p.m_offx;
    m_y=p.m_radius*sin(m_th)+p.m_offy;
    
    
%     py=[0 0 p.bht p.bht]+p.y0;

   % Create a figure and axes
    f = figure('Visible','off');
    %     ax = axes('Units','pixels');
    % Create push button - Welcome button
    btn = uicontrol('Style', 'pushbutton', 'String', 'ME 3050 Dynamics Simulator',...
        'Position', [150 390 200 30],...
        'Callback', @reset_cb);  
    % Make figure visble after adding all components
    set(f,'Visible','on')
%     f.Visible = 'on';
    
  
    %create the timer object 
    th=timer;
    l=[]; %dummy multi scope vars
    box=[];
    
    
    
    %define the GUI callbacks
    function mass_cb(source,callbackdata)
        val = get(source,'Value');
        p.m=val;
          %recalculate after params have been changed
        p.wn=sqrt((p.kt-p.g*p.m*p.l)/p.Io);
        p.dr=p.c/(2*sqrt(p.m*p.k));
        p.wd=p.wn*sqrt(1-p.dr^2);
        show_case()
        p
    end
    function length_cb(source,callbackdata)
        val = get(source,'Value');
        p.l=val;
          %recalculate after params have been changed
        p.wn=sqrt((p.kt-p.g*p.m*p.l)/p.Io);
        p.dr=p.c/(2*sqrt(p.m*p.k));
        p.wd=p.wn*sqrt(1-p.dr^2);
        show_case()
        p
    end
    function spring_cb(source,callbackdata)
        val = get(source,'Value');
        p.kt=val;
          %recalculate after params have been changed
         p.wn=sqrt((p.kt-p.g*p.m*p.l)/p.Io);
        p.dr=p.c/(2*sqrt(p.m*p.k));
        p.wd=p.wn*sqrt(1-p.dr^2);
        show_case()
        p
    end
    function ydot0_cb(source,callbackdata)
        val = get(source,'Value');
        p.ydot0=val;
        show_case()
    end
    function y0_cb(source,callbackdata)
        val = get(source,'Value');
        p.y0=val;
        show_case()
    end

    

    function reset_cb(source,callbackdata)
        
        
        
        
        stop(th)
        th=timer;
        % prepare the plot
        axes('xlim',[-10,10],'ylim',[-5,5]);
        grid on
        l=line(p.t,p.th0,...
            'userdata',0,...
            'marker','.',...
            'color','black',...
            'markersize',2,...
            'linestyle','-');
        % 
        box=patch(m_x,m_y,'red',...
            'userdata',0,...
            'marker','none',...
            'linestyle','-');
        shg; % show graph window 
        
%         p.m=100; %mass 
%         p.k=250; %stiffness
%         p.c=100; %damping
%         % intitial conditions 
% 
%         p.y0=10;
%         p.ydot0=1;
        
        show_case()
        % Create push button - Start
        btn = uicontrol('Style', 'pushbutton', 'String', 'Reset',...
            'Position', [100 20 50 20],...
            'Callback', @reset_cb);

        % Create push button - Reset
        btn = uicontrol('Style', 'pushbutton', 'String', 'Start',...
            'Position', [150 20 50 20],...
            'Callback', @start_cb);
       
%         %Create slider - initial position
%         sld = uicontrol('Style', 'slider',...
%             'Min',1,'Max',5000,'Value',p.y0,...
%             'Position', [250 20 120 20],...
%             'Callback', @y0_cb); 
%         % Add a text uicontrol to label the slider.
%         txt = uicontrol('Style','text',...
%             'Position',[250 40 120 20],...
%             'String',sprintf('Y0=:%5.2f',p.y0)); 
        
%         % Create slider - initial velocity
%         sld = uicontrol('Style', 'slider',...
%             'Min',0,'Max',10,'Value',p.ydot0,...
%             'Position', [250 60 120 20],...
%             'Callback', @ydot0_cb); 
%         % Add a text uicontrol to label the slider.
%         txt = uicontrol('Style','text',...
%             'Position',[250 80 120 20],...
%             'String',sprintf('Ydot0=:%5.2f',p.ydot0));
        
        %Create slider - mass
        sld = uicontrol('Style', 'slider',...
            'Min',1e-3,'Max',100,'Value',p.m,...
            'Position', [400 20 120 20],...
            'Callback', @mass_cb); 
        % Add a text uicontrol to label the slider.
        txt = uicontrol('Style','text',...
            'Position',[400 40 120 20],...
            'String',sprintf('Mass=:%5.2f',p.m)); 
        
        % Create slider - length
        sld = uicontrol('Style', 'slider',...
            'Min',0,'Max',10,'Value',p.l,...
            'Position', [400 60 120 20],...
            'Callback', @length_cb); 
         % Add a text uicontrol to label the slider.
        txt = uicontrol('Style','text',...
            'Position',[400 80 120 20],...
            'String',sprintf('L=:%5.2f',p.l));
        
        % Create slider - spring constant
        sld = uicontrol('Style', 'slider',...
            'Min',0,'Max',100,'Value',p.kt,...
            'Position', [400 100 120 20],...
            'Callback', @spring_cb); 
        % Add a text uicontrol to label the slider.
        txt = uicontrol('Style','text',...
            'Position',[400 120 120 20],...
            'String',sprintf('Kt=:%5.2f',p.kt));
        
       
        
        
        %show_case()
        % Make figure visble after adding all components
%         f.Visible = 'on';
        set(f,'Visible','on')
        show_case()
    end

    function start_cb(source,callbackdata)
     
        th.TimerFcn={@metronome_model,p,l,box};
        th.StopFcn={@model_stop};
        set(th,...
            'period',p.dt,...
            'TasksToExecute', p.numtasks,...
            'executionmode','fixedrate');
        start(th);
     
    end

    function show_case()
         % Add a text uicontrol to label the slider.

         if p.dr==1
             case_str=sprintf('Damping Ratio: %f\n Critically Damped',p.dr);
         elseif p.dr>1
             case_str=sprintf('Damping Ratio: %f\n Overdamped',p.dr);
         else
             case_str=sprintf('Damping Ratio: %f\n Underamped',p.dr);
         end
         txt = uicontrol('Style','text',...
            'Position',[150 360 200 30],...
            'String',case_str);
        
%         % Add a text uicontrol to label the slider.
%         txt = uicontrol('Style','text',...
%             'Position',[250 40 120 20],...
%             'String',sprintf('Y0=:%5.2f',p.y0)); 
%         
%         % Add a text uicontrol to label the slider.
%         txt = uicontrol('Style','text',...
%             'Position',[250 80 120 20],...
%             'String',sprintf('Ydot0=:%5.2f',p.ydot0));
        
        % Add a text uicontrol to label the slider.
        txt = uicontrol('Style','text',...
            'Position',[400 120 120 20],...
            'String',sprintf('KT=:%5.3f',p.kt));
        
        % Add a text uicontrol to label the slider.
        txt = uicontrol('Style','text',...
            'Position',[400 80 120 20],...
            'String',sprintf('l=:%5.3f',p.l));
        
        % Add a text uicontrol to label the slider.
        txt = uicontrol('Style','text',...
            'Position',[400 40 120 20],...
            'String',sprintf('Mass=:%5.3f',p.m));
        
         
    end
    

end