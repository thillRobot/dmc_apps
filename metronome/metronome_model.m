function metronome_model(obj,event,p,lhan,mhan)

%         global g m k x0 xdot0 i t dt
        if p.j==1
            thm(p.j)=p.th0;
        end
%       xm=[xm xm(i)+1];
        
%         p.t=p.t+p.dt;
%         p.j=p.j+1
        event.Type
%         lh
        
        j=obj.TasksExecuted;
        t=j*p.dt;

        % the free metronome has no damping
    
%         if p.dr<1 %underdamped 
%             ym=exp(-p.dr*p.wn*t)*(p.y0*cos(p.wd*t)+(p.ydot0+p.dr*p.wn*p.y0)/p.wd*sin(p.wd*t));
%         elseif p.dr==1 %critically damped
%             ym=p.y0*exp(-p.wn*t)+(p.ydot0+p.wn*p.y0)*t*exp(-p.wn*t);
%         else %overdamped
%             C1=(-p.ydot0+(-p.dr+sqrt(p.dr^2-1))*p.wn*p.y0)/(2*p.wn*sqrt(p.dr^2-1));
%             C2=(p.ydot0+(p.dr+sqrt(p.dr^2-1))*p.wn*p.y0)/(2*p.wn*sqrt(p.dr^2-1));
%             ym=exp(-p.dr*p.wn*t)*(C1*exp(-p.wn*sqrt(p.dr^2-1)*t) + C2*exp(p.wn*sqrt(p.dr^2-1)*t));
%         end

        

        thm=p.th0*cos(p.wn*t);
             
        xm=p.l*cos(pi/2-thm)+p.m_offx;
        ym=p.l*sin(pi/2-thm)+p.m_offy;
        
%         m_x=[0p.bwt p.bwt 0]+p.bps;
%         m_y=[0 0 p.bht p.bht]+ym;
        
        % draw a round mass
        m_th=0:.01:2*pi;
        m_x=p.m_radius*cos(m_th)+xm;
        
        m_y=p.m_radius*sin(m_th)+ym;
    
        
        set(mhan,'xdata',m_x);
        set(mhan,'ydata',m_y);
        
        set(lhan,'xdata',[get(lhan,'xdata') t]);
        set(lhan,'ydata',[get(lhan,'ydata') thm*p.scale]);
%         
end

