function [p]=mck_demo()

    close all;clc
    %define timer function params
    p.j=1; %timer index ?
    p.t=0; %start time
    p.stoptime=5;
    p.dt=.01; %time increment
    p.numtasks=round(p.stoptime/p.dt);
    
    p.g=9.8; %m/s^2
    p.m=1; %mass 
    p.k=50; %*pi^2 %stiffness
    p.c=0; %damping
    % intitial conditions 

    p.y0=5;
    p.ydot0=1;
    p.wn=sqrt(p.k/p.m);
    p.fn=p.wn/(2*pi);
    
    p.dr=p.c/(2*sqrt(p.m*p.k));

    p.wd=p.wn*sqrt(1-p.dr^2);
   
    %draw a box
    p.bht=5;
    p.bwt=3;
    p.bps=0;
    px=[0 p.bwt p.bwt 0]+p.bps;
    py=[0 0 p.bht p.bht]+p.y0;

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
    l=[]; %dummy multi scope vars ???
    box=[];
    
    %define the GUI callbacks
    function mass_cb(source,callbackdata)
        val = get(source,'Value');
        p.m=val;
          %recalculate after params have been changed
        p.wn=sqrt(p.k/p.m);
        p.dr=p.c/(2*sqrt(p.m*p.k));
        p.wd=p.wn*sqrt(1-p.dr^2);
        show_case()
        p
    end
    function damper_cb(source,callbackdata)
        val = get(source,'Value');
        p.c=val;
          %recalculate after params have been changed
        p.wn=sqrt(p.k/p.m);
        p.dr=p.c/(2*sqrt(p.m*p.k));
        p.wd=p.wn*sqrt(1-p.dr^2);
        show_case()
        p
    end
    function spring_cb(source,callbackdata)
        val = get(source,'Value');
        p.k=val;
          %recalculate after params have been changed
        p.wn=sqrt(p.k/p.m);
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
        ax1 = axes('Parent',f,'Units','normalized','Position',[.2 .6 .6 .3]);
        grid(ax1,'on')
        set(ax1,'XLim',[0,5],'YLim',[-5,5],'YMinorGrid','on','XMinorGrid','on')
        
         
        l=line(p.t,p.y0,...
            'userdata',0,...
            'marker','.',...
            'color','black',...
            'markersize',2,...
            'linestyle','-');
        

        ax2 = axes('Parent',f,'Units','normalized','Position',[.1 .2 .6 .3]);
        set(ax2,'XLim',[-5,5],'YLim',[-10,15],'DataAspectRatio',[5 10 1])
        grid(ax2,'on')
%         axes('xlim',[-10,15],'ylim',[-10,15]);
       
        box=patch(px,py,'red',...
            'userdata',0,...
            'marker','none',...
            'linestyle','-');
        % 
        
        shg; % show graph window 
        
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
%             'Min',0,'Max',5000,'Value',p.y0,...
%             'Position', [250 20 120 20],...
%             'Callback', @y0_cb); 
%         % Add a text uicontrol to label the slider.
%         txt = uicontrol('Style','text',...
%             'Position',[250 40 120 20],...
%             'String',sprintf('Y0=:%5.2f',p.y0)); 
%         
%         % Create slider - initial velocity
%         sld = uicontrol('Style', 'slider',...
%             'Min',0,'Max',10,'Value',p.ydot0,...
%             'Position', [250 60 120 20],...
%             'Callback', @ydot0_cb); 
%         % Add a text uicontrol to label the slider.
%         txt = uicontrol('Style','text',...
%             'Position',[250 80 120 20],...
%             'String',sprintf('Ydot0=:%5.2f',p.ydot0));
        dely=0
        delx=-150
        %Create slider - mass
        sld = uicontrol('Style', 'slider',...
            'Min',1e-3,'Max',100,'Value',p.m,...
            'Position', [400+delx 20+dely 120 20],...
            'Callback', @mass_cb); 
        % Add a text uicontrol to label the slider.
        txt = uicontrol('Style','text',...
            'Position',[400+delx 40+dely 120 20],...
            'String',sprintf('Mass=:%5.2f',p.m)); 
        
        % Create slider - damping constant
        sld = uicontrol('Style', 'slider',...
            'Min',0,'Max',100,'Value',p.c,...
            'Position', [400+delx 60+dely 120 20],...
            'Callback', @damper_cb); 
         % Add a text uicontrol to label the slider.
        txt = uicontrol('Style','text',...
            'Position',[400+delx 80+dely 120 20],...
            'String',sprintf('C=:%5.2f',p.c));
        
        % Create slider - spring constant
        sld = uicontrol('Style', 'slider',...
            'Min',0,'Max',100,'Value',p.k,...
            'Position', [400+delx 100+dely 120 20],...
            'Callback', @spring_cb); 
        % Add a text uicontrol to label the slider.
        txt = uicontrol('Style','text',...
            'Position',[400+delx 120+dely 120 20],...
            'String',sprintf('K=:%5.2f',p.k));
        

        %show_case()
        % Make figure visble after adding all components
%         f.Visible = 'on';
        set(f,'Visible','on')
        show_case()
    end

    function start_cb(source,callbackdata)
     
        th.TimerFcn={@mck_model,p,l,box};
        th.StopFcn={@mck_stop};
        set(th,...
            'period',p.dt,...
            'TasksToExecute', p.numtasks,...
            'executionmode','fixedrate');
        start(th);
     
    end

    function show_case()
         % Add a text uicontrol to label the slider.
        dely=0; %the boxesa around the UI need to be fixed, it is done really poorly now 
        delx=-150;
         if p.dr==1
             case_str=sprintf('Critically Damped\nDamping Ratio: %.2f',p.dr);
         elseif p.dr>1
             case_str=sprintf('Overdamped\nDamping Ratio: %.2f',p.dr);
         else
             case_str=sprintf('Underamped\nDamping Ratio: %.2f',p.dr);
         end
         txt = uicontrol('Style','text',...
            'Position',[400+delx 160+dely 150 50],...
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
            'Position',[400+delx 120+dely 120 20],...
            'String',sprintf('K=:%5.3f',p.k));
        
        % Add a text uicontrol to label the slider.
        txt = uicontrol('Style','text',...
            'Position',[400+delx 80+dely 120 20],...
            'String',sprintf('C=:%5.3f',p.c));
        
        % Add a text uicontrol to label the slider.
        txt = uicontrol('Style','text',...
            'Position',[400+delx 40+dely 120 20],...
            'String',sprintf('Mass=:%5.3f',p.m));
        
         
    end
    

end