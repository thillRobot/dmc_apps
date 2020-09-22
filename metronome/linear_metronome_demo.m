function [p]=linear_metronome_demo()
    
    clc;close all
    
    % default system parameters, can be changed by UI
    endmass=20;
    rodlength=.4;
    springrate=58;
    
    % call this function to define remaining constant and derived params
    p=linear_metronome_parameters(endmass,rodlength,springrate); 
    
    xm=p.l*cos(p.th0+pi/2); % a point at a radius l
    ym=p.l*sin(p.th0+pi/2);
    
    m_th=0:.01:2*pi;    
    m_x=p.m_radius*cos(m_th)+xm; % a circle of points at that point
    m_y=p.m_radius*sin(m_th)+ym; % for the 'mass'
    
    r_x=[0 xm-p.m_radius*cos(p.th0+pi/2)]; % a line for the 'rod'
    r_y=[0 ym-p.m_radius*sin(p.th0+pi/2)]; % subtract the portion overlapping the mass

    % Create a figure and axes
    f = figure('Visible','off');
    %     ax = axes('Units','pixels');
    % Create push button - Start button
    
    % setup the welcome button
    wlcm_str=sprintf('Linear Metronome Demo - ME3050');
    wlcm_txt = uicontrol('Style','text',...
            'Position',[150 375 250 30],...
            'String',wlcm_str);
    btn_str=sprintf('Click Here to Begin');
    btn = uicontrol('Style', 'pushbutton', 'String',btn_str,...
        'Position', [10 380 150 30],...
        'Callback', @reset_cb);  
    % Make figure visble after adding all components
    set(f,'Visible','on')

    
  
    %create the timer object 
    th=timer;
    l=[]; %define multi scope vars here 
    box=[];
    rod=[];
    
    
    %define the GUI callbacks
    function mass_cb(source,callbackdata)
        val = get(source,'Value');
        p.m=val;
        % recalculate derived params after UI change
        p=linear_metronome_parameters(p.m,p.l,p.kt);  
        show_case()
        p
    end
    
    function length_cb(source,callbackdata)
        val = get(source,'Value');
        p.l=val;
        % recalculate derived params after UI change
        p=linear_metronome_parameters(p.m,p.l,p.kt); 
        show_case()
        p
    end
    
    function spring_cb(source,callbackdata)
        val = get(source,'Value');
        p.kt=val;
       % recalculate derived params after UI change
        p=linear_metronome_parameters(p.m,p.l,p.kt);
        
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
        % prepare the plot - setup two separate axis
        % axis equal

        % axis 1 is the time plot
        ax1 = axes('Parent',f,'Units','normalized','Position',[.3 .1 .6 .3]);
        grid(ax1,'on')
        set(ax1,'XLim',[0,10],'YLim',[-.2,.2])
     
        % axis 2 is the animation
        ax2 = axes('Parent',f,'Units','normalized','Position',[.5 .5 .6 .3]);
        set(ax2,'XLim',[-1,1],'YLim',[-1,1],'DataAspectRatio',[1 1 1])
        grid(ax2,'on')

        axes(ax1) % axis 1 is the time plot
        l=line(p.t,p.th0,...
            'userdata',0,...
            'marker','.',...
            'color','black',...
            'markersize',2,...
            'linestyle','-');
        % 
        axes(ax2) % axis 2 is the animation
        box=patch(m_x,m_y,'red',...
            'userdata',0,...
            'marker','none',...
            'linestyle','-');
        rod=line(r_x,r_y,...
            'userdata',0,...
            'marker','.',...
            'color','black',...
            'markersize',2,...
            'linestyle','-',...
            'LineWidth',3);
        shg; % show graph window 
        
        show_case()
        
        % Create push button - Start
        btn = uicontrol('Style', 'pushbutton', 'String', 'Reset',...
            'Position', [10 350 50 20],...
            'Callback', @reset_cb);

        % Create push button - Reset
        btn = uicontrol('Style', 'pushbutton', 'String', 'Start',...
            'Position', [60 350 50 20],...
            'Callback', @start_cb);
       
%         %Create slider - initial position
%         sld = uicontrol('Style', 'slider',...
%             'Min',1,'Max',5000,'Value',p.y0,...
%             'Position', [250 20 120 20],...
%             'Callback', @y0_cb); 
%         % Add a text uicontrol to label the slider
%         txt = uicontrol('Style','text',...
%             'Position',[250 40 120 20],...
%             'String',sprintf('Y0=:%5.2f',p.y0)); 
        
%         % Create slider - initial velocity
%         sld = uicontrol('Style', 'slider',...
%             'Min',0,'Max',10,'Value',p.ydot0,...
%             'Position', [250 60 120 20],...
%             'Callback', @ydot0_cb); 
%         % Add a text uicontrol to label the slider
%         txt = uicontrol('Style','text',...
%             'Position',[250 80 120 20],...
%             'String',sprintf('Ydot0=:%5.2f',p.ydot0));
        sldr_xpos=20;
        sldr_width=100;
        sldr_ypos=200;
        sldr_height=20;
        %Create slider - mass
        sld = uicontrol('Style', 'slider',...
            'Min',1e-3,'Max',100,'Value',p.m,...
            'Position', [sldr_xpos sldr_ypos sldr_width sldr_height],...
            'Callback', @mass_cb); 
        
        % Create slider - length
        sld = uicontrol('Style', 'slider',...
            'Min',0,'Max',10,'Value',p.l,...
            'Position', [sldr_xpos sldr_ypos+50 sldr_width sldr_height],...
            'Callback', @length_cb); 
    
        % Create slider - spring constant
        sld = uicontrol('Style', 'slider',...
            'Min',0,'Max',100,'Value',p.kt,...
            'Position', [sldr_xpos sldr_ypos+100 sldr_width sldr_height],...
            'Callback', @spring_cb); 
       
        %show_case()
        % Make figure visble after adding all components
%         f.Visible = 'on';
        set(f,'Visible','on')
        show_case()
    end

    function start_cb(source,callbackdata)
     
        th.TimerFcn={@linear_metronome_model,p,l,box,rod};
        th.StopFcn={@model_stop};
        set(th,...
            'period',p.dt,...
            'TasksToExecute', p.numtasks,...
            'executionmode','fixedrate');
        start(th);
     
    end

    function show_case()
        

%          if p.dr==1
%              case_str=sprintf('Damping Ratio: %.2f\n Critically Damped',p.dr);
%          elseif p.dr>1
%              case_str=sprintf('Damping Ratio: %.2f\n Overdamped',p.dr);
%          else
%              case_str=sprintf('Damping Ratio: %.2f\n Underamped',p.dr);
%          end
        
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
         
        % Add a text uicontrol to label the slider. 
        wn_str=sprintf('Natural Frequency\n w_n(rad/s): %.2f, f(Hz): %.2f',p.wn,p.fn);
        txt = uicontrol('Style','text','HorizontalAlignment','left',...
            'Position',[150 300 200 50],...
            'String',wn_str); 
        sc_str=sprintf('Stability Criterion\n (Kt-mgl): %.2f',p.sc);
        txt = uicontrol('Style','text','HorizontalAlignment','left',...
            'Position',[150 260 200 50],...
            'String',sc_str); 
         
        txt_xpos=20;
        txt_width=100;
        txt_ypos=220;
        txt_height=20;
        txt = uicontrol('Style','text','HorizontalAlignment','left',...
            'Position',[txt_xpos txt_ypos txt_width txt_height],...
            'String',sprintf('m: %5.3f',p.m));
        
        % Add a text uicontrol to label the slider.
        txt = uicontrol('Style','text','HorizontalAlignment','left',...
            'Position',[txt_xpos txt_ypos+50 txt_width txt_height],...
            'String',sprintf('l: %5.3f',p.l));
        
        % Add a text uicontrol to label the slider.
        txt = uicontrol('Style','text','HorizontalAlignment','left',...
            'Position',[txt_xpos txt_ypos+100 txt_width txt_height],...
            'String',sprintf('kt: %5.3f',p.kt));
        
         
    end
    

end