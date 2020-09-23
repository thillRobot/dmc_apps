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
    m_x=p.m_radius*cos(m_th)+xm; % a circle of points around that point
    m_y=p.m_radius*sin(m_th)+ym; % for the 'mass'
    
    r_x=[0 xm-p.m_radius*cos(p.th0+pi/2)]; % a line for the 'rod'
    r_y=[0 ym-p.m_radius*sin(p.th0+pi/2)]; % subtract the portion overlapping the mass

    % Create a figure and axes
    f = figure('Visible','off');
    % ax = axes('Units','pixels');
   
    % create a uipanel to contain the different components of th app   
    main_panel = uipanel('Title','Linear Metronome Demo - ME3050','FontSize',12,...
             'BackgroundColor','white',...
             'Position',[.01 .01 .98 .98],...
             'Visible','on');
    ctrl_panel = uipanel('Parent',main_panel,'Title','User Controls','FontSize',12,...
             'Position',[.03 .05 .27 .95],...
             'Visible','off');
    data_panel = uipanel('Parent',main_panel,'Title','Model Data','FontSize',12,...
             'Position',[.32 .6 .37 .4],...
             'Visible','off');

    btn_str=sprintf('Click Here to Begin');
    wlcm_btn = uicontrol('Parent',main_panel,'Style', 'pushbutton', 'String',btn_str,...
        'Position', [20 320 150 36],...
        'Callback', @reset_cb,...
        'Visible','on');
     
   % Create push button - Start
    reset_btn = uicontrol('Parent',ctrl_panel,'Style', 'pushbutton', 'String', 'Reset',...
        'Position', [10 260 60 30],...
        'Callback', @reset_cb,...
        'Visible','off');

    % Create push button - Reset
    start_btn = uicontrol('Parent',ctrl_panel,'Style', 'pushbutton', 'String', 'Start',...
        'Position', [80 260 60 30],...
        'Callback', @start_cb,...
        'Visible','off');
     
    sldr_xpos=10;
    sldr_width=100;
    sldr_ypos=20;
    sldr_height=20;
     %Create slider - mass
    mass_sldr = uicontrol('Parent',ctrl_panel,'Style', 'slider',...
        'Min',1e-3,'Max',100,'Value',p.m,...
        'Position', [sldr_xpos sldr_ypos+150 sldr_width sldr_height],...
        'Callback', @mass_cb,...
        'Visible','off'); 
    % Create slider - length
    length_sldr = uicontrol('Parent',ctrl_panel,'Style', 'slider',...
        'Min',0,'Max',2,'Value',p.l,...
        'Position', [sldr_xpos sldr_ypos+100 sldr_width sldr_height],...
        'Callback', @length_cb,...
        'Visible','off'); 
    % Create slider - spring constant
    spring_sldr = uicontrol('Parent',ctrl_panel,'Style', 'slider',...
        'Min',0,'Max',500,'Value',p.kt,...
        'Position', [sldr_xpos sldr_ypos+50 sldr_width sldr_height],...
        'Callback', @spring_cb,...
        'Visible','off'); 
    %Create slider - initial theta
    theta0_sldr = uicontrol('Parent',ctrl_panel,'Style', 'slider',...
        'Min',0,'Max',20,'Value',p.th0,...
        'Position', [sldr_xpos sldr_ypos sldr_width sldr_height],...
        'Callback', @theta0_cb,...
        'Visible','off'); 
           % Add text uicontrol to label the sliders
    txt_xpos=10;
    txt_width=100;
    txt_ypos=40;
    txt_height=20;
    mass_txt = uicontrol('Parent',ctrl_panel,'Style','text','HorizontalAlignment','left',...
        'Position',[txt_xpos txt_ypos+150 txt_width txt_height],...
        'String',sprintf('m: %5.3f',p.m),...
        'Visible','off'); 

    length_txt = uicontrol('Parent',ctrl_panel,'Style','text','HorizontalAlignment','left',...
        'Position',[txt_xpos txt_ypos+100 txt_width txt_height],...
        'String',sprintf('l: %5.3f',p.l),...
        'Visible','off'); 

    spring_txt = uicontrol('Parent',ctrl_panel,'Style','text','HorizontalAlignment','left',...
        'Position',[txt_xpos txt_ypos+50 txt_width txt_height],...
        'String',sprintf('kt: %5.3f',p.kt),...
        'Visible','off'); 

    theta0_txt = uicontrol('Parent',ctrl_panel,'Style','text','HorizontalAlignment','left',...
        'Position',[txt_xpos txt_ypos txt_width txt_height],...
        'String',sprintf('th0: %5.3f',p.th0),...
        'Visible','off'); 
    
    wn_str=sprintf('Natural Frequency\n w_n(rad/s): %.2f, f(Hz): %.2f',p.wn,p.fn);
    if p.sc>0
        sc_str=sprintf('Stability Criterion: Stable\n (kt-mgl): %.2f',p.sc);
    else
        sc_str=sprintf('Stability Criterion: Unstable!\n (kt-mgl): %.2f',p.sc);
    end
    wn_txt = uicontrol('Parent',data_panel,'Style','text','HorizontalAlignment','left',...
        'Position',[10 80 200 50],...
        'String',wn_str,...
        'Visible','off'); 
    sc_txt = uicontrol('Parent',data_panel,'Style','text','HorizontalAlignment','left',...
        'Position',[10 30 200 50],...
        'String',sc_str,...
        'Visible','off');         
    
    % prepare the plot - setup two separate axes 
    % axis 1 is the time plot
    ax1 = axes('Parent',main_panel,'Units','normalized',...
                'Position',[.4 .1 .5 .3],...
                'Visible','off');  
    set(ax1,'XLim',[0,10],'YLim',[-.2,.2])
    grid(ax1,'on')
    % axis 2 is the animation
    ax2 = axes('Parent',main_panel,'Units','normalized',...
                'Position',[.6 .5 .5 .3],...
                'Visible','off');
    set(ax2,'XLim',[-1,1],'YLim',[-1,1],'DataAspectRatio',[1 1 1])
    grid(ax2,'on')

    axes(ax1) % axis 1 is the time plot
    l=line(p.t,p.th0,...
        'userdata',0,...
        'marker','.',...
        'color','black',...
        'markersize',2,...
        'linestyle','-',...
        'Visible','off');

    axes(ax2) % axis 2 is the animation
    box=patch(m_x,m_y,'red',...
        'userdata',0,...
        'marker','none',...
        'linestyle','-',...
        'Visible','off');
    rod=line(r_x,r_y,...
        'userdata',0,...
        'marker','.',...
        'color','black',...
        'markersize',2,...
        'linestyle','-',...
        'LineWidth',3,...
        'Visible','off');
    
    % Make figure visble after adding all components
    set(f,'Visible','on')

    %create the timer object and others
    th=timer;

    startup=1; % flag for startup in 'reset_cb'
    
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
    
    function theta0_cb(source,callbackdata)
        val = get(source,'Value');
        p.th0=val;
        show_case()
    end

    

    function reset_cb(source,callbackdata)
        
        % delete the startup/welcome button, only the first time
        if startup
            
            set(ax1,'Visible','on')
            set(ax2,'Visible','on')
            
            set(box,'Visible','on')
            set(rod,'Visible','on')
            set(l,'Visible','on')
            set(ctrl_panel,'Visible','on')
            set(data_panel,'Visible','on')
                      
            set(wlcm_btn,'Visible','off') % off
            set(reset_btn,'Visible','on')
            set(start_btn,'Visible','on')
            
            set(mass_sldr,'Visible','on')
            set(length_sldr,'Visible','on')
            set(spring_sldr,'Visible','on')
            set(theta0_sldr,'Visible','on')
            
            set(mass_txt,'Visible','on')
            set(length_txt,'Visible','on')
            set(spring_txt,'Visible','on')
            set(theta0_txt,'Visible','on')
            set(wn_txt,'Visible','on')
            set(sc_txt,'Visible','on')
                     
            startup=0;
        end
        stop(th)
        th=timer;
         
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
        
        thm=p.th0;%*cos(p.wn*t);
        
        % draw a point at the end of the pendulum
        xm=p.l*cos(thm+pi/2);%+p.m_offx;
        ym=p.l*sin(thm+pi/2);%+p.m_offy;
        
        % draw a round mass
        m_th=0:.01:2*pi;
        m_x=p.m_radius*cos(m_th)+xm;      
        m_y=p.m_radius*sin(m_th)+ym;
        
        r_x=[0 xm-p.m_radius*cos(thm+pi/2)]; % a line for the 'rod'
        r_y=[0 ym-p.m_radius*sin(thm+pi/2)]; % subtract the portion overlapping the mass
    
        
        set(rod,'xdata',r_x); % picture of the rod
        set(rod,'ydata',r_y);    
        
        set(box,'xdata',m_x); % picture of the mass
        set(box,'ydata',m_y);
        
        set(l,'xdata',0); % the timeplot
        set(l,'ydata',thm);

        % Add a text uicontrol to show the derived parameters 
        wn_str=sprintf('Natural Frequency\n w_n(rad/s): %.2f, f(Hz): %.2f',p.wn,p.fn);
       
        if p.sc>0
            sc_str=sprintf('Stability Criterion: Stable\n (kt-mgl): %.2f',p.sc);
        else
            sc_str=sprintf('Stability Criterion: Unstable!\n (kt-mgl): %.2f',p.sc);
        end
        set(wn_txt,'String',wn_str);
        set(sc_txt,'String',sc_str);

        set(mass_txt,'String',sprintf('m: %5.3f',p.m));
        set(length_txt,'String',sprintf('l: %5.3f',p.l));
        set(spring_txt,'String',sprintf('kt: %5.3f',p.kt));
        set(theta0_txt,'String',sprintf('th0: %5.3f',p.th0));
    
    end
    

end