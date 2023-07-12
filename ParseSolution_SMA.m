%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPAP115
% Project Title: Path Planning using PSO in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function sol2=ParseSolution_SMA(sol1,model)

    x=sol1.x;
    y=sol1.y;
    
    xs=model.xs;
    ys=model.ys;
    xt=model.xt;
    yt=model.yt;
    xobs=model.xobs;
    yobs=model.yobs;
    robs=model.robs;
    
    XS=[xs x xt];
    YS=[ys y yt];
    k=numel(XS);
    TS=linspace(0,1,k);
    
    tt=linspace(0,1,200);
    xx=spline(TS,XS,tt); %Spline Interpolation zwischen allen Punkten inklusive Start und Endpunkt
    yy=spline(TS,YS,tt);
    
    dx=diff(xx);     %Differenz zwischen benachbarten Einträgen von xx
    dy=diff(yy);
    
    L=sum(sqrt(dx.^2+dy.^2));        %Länge des Weges
    
    nobs = numel(xobs); % Number of Obstacles
    Violation = 0;

    % wird überprüft ob Splines durch die Hindernisse laufen 
    %wenn violation ==0 dann ist Lösung korrekt
    for k=1:nobs
        d=sqrt((xx-xobs(k)).^2+(yy-yobs(k)).^2);
        v=max(1-d/robs(k),0);
        Violation=Violation+mean(v);
    end
    
    sol2.TS=TS;
    sol2.XS=XS;
    sol2.YS=YS;
    sol2.tt=tt;
    sol2.xx=xx;
    sol2.yy=yy;
    sol2.dx=dx;
    sol2.dy=dy;
    sol2.L=L;
    sol2.Violation=Violation;
    sol2.IsFeasible=(Violation==0);
        
end
