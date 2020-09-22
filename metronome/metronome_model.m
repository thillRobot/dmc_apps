function metronome_model(obj,event,p,lhan,mhan,rhan)

        % treat the initial condtion the first time around
        if p.j==1
            thm(p.j)=p.th0;
        end
        
        j=obj.TasksExecuted;
        t=j*p.dt;

        % compute the response based on time
        % the free metronome has no damping
        % this response equation is valid for the small angle identity 
        thm=p.th0*cos(p.wn*t);
        
        % draw a point at the end of the pendulum
        xm=p.l*cos(thm+pi/2);%+p.m_offx;
        ym=p.l*sin(thm+pi/2);%+p.m_offy;
        
        % draw a round mass
        m_th=0:.01:2*pi;
        m_x=p.m_radius*cos(m_th)+xm;      
        m_y=p.m_radius*sin(m_th)+ym;
    
        set(rhan,'xdata',[0 xm]); % the rod
        set(rhan,'ydata',[0 ym]);    
        
        set(mhan,'xdata',m_x); % the mass
        set(mhan,'ydata',m_y);
        
        set(lhan,'xdata',[get(lhan,'xdata') t]); % the timeplot
        set(lhan,'ydata',[get(lhan,'ydata') thm]);
      
end

