function bol = isvalid(points)
XS = zeros(length(points)/2+2);
YS = zeros(length(points)/2+2);
XS(1) = start(1);
XS(end) = start(2);

YS(1) = start(1);
YS(end) = start(2);

    for k=2:2:length(points)
        XS = points(k);
        YS = points(k+1);        
    end


    k=numel(XS);
    TS=linspace(0,1,k);
    
    tt=linspace(0,1,100);
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

end