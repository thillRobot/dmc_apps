function mck_model(obj,event,p,lhan,mhan)

%         global g m k x0 xdot0 i t dt
        if p.j==1
            ym(p.j)=p.y0;
        end
%       xm=[xm xm(i)+1];
        
%         p.t=p.t+p.dt;
%         p.j=p.j+1
        event.Type
%         lh
        
        j=obj.TasksExecuted;
        t=j*p.dt;

        if p.dr<1 %underdamped 
            ym=exp(-p.dr*p.wn*t)*(p.y0*cos(p.wd*t)+(p.ydot0+p.dr*p.wn*p.y0)/p.wd*sin(p.wd*t));
        elseif p.dr==1 %critically damped
            ym=p.y0*exp(-p.wn*t)+(p.ydot0+p.wn*p.y0)*t*exp(-p.wn*t);
        else %overdamped
            C1=(-p.ydot0+(-p.dr+sqrt(p.dr^2-1))*p.wn*p.y0)/(2*p.wn*sqrt(p.dr^2-1));
            C2=(p.ydot0+(p.dr+sqrt(p.dr^2-1))*p.wn*p.y0)/(2*p.wn*sqrt(p.dr^2-1));
            ym=exp(-p.dr*p.wn*t)*(C1*exp(-p.wn*sqrt(p.dr^2-1)*t) + C2*exp(p.wn*sqrt(p.dr^2-1)*t));
        end
        
%         m_x=[0 p.bwt p.bwt 0]+p.bps;
%         m_y=[0 0 p.bht p.bht]+ym;
        
        m_th=0:.01:2*pi;
    
        m_x=p.m_radius*cos(m_th)+p.m_offx;
        m_y=p.m_radius*sin(m_th)+ym;
    
        
        set(mhan,'xdata',m_x);
        set(mhan,'ydata',m_y);
        
        set(lhan,'xdata',[get(lhan,'xdata') t]);
        set(lhan,'ydata',[get(lhan,'ydata') ym]);
%         
end

