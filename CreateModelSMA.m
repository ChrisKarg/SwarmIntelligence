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

function [model, lb, ub] =CreateModelSMA(lb, ub, i)

    % Source

    
    % Target (Destination)

    
    switch i
        case 1
            nrO = 3;
            xs=0;
            ys=0;
            xobs=[1.5 4.0 1.2];
            yobs=[4.5 3.0 1.5];
            robs=[1.5 1.0 0.8];
            xt=4;
            yt=6;
            lb = 3;
            ub = 9;
        case 2
            nrO = 3;
            xs=0;
            ys=0;
            xobs=[1 1.8 4.5];
            yobs=[1 5.0 0.9];
            robs=[0.8 1.5 1];
            xt=4;
            yt=6;
            lb = 3;
            ub = 9;
        case 3
            nrO = 6;
            xs=0;
            ys=0;
            xobs=[1.5 8.5 3.2 6.0 1.2 7.0];
            yobs=[4.5 6.5 2.5 3.5 1.5 8.0];
            robs=[1.5 0.9 0.4 0.6 0.8 0.6];
            xt = 10;
            yt = 10;
            lb = 3;
            ub = 13;
        case 4
            nrO = 13;
            xs=3;
            ys=3;
            xobs = [1.5 4.0 1.2 5.2 9.5 6.5 10.8 5.9 3.4 8.6 11.6 3.3 11.8];
            yobs = [4.5 3.0 1.5 3.7 10.3 7.3 6.3 9.9 5.6 8.2 8.6 11.5 11.5];
            robs = [0.5 0.4 0.4 0.8 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7];
            xt = 14;
            yt = 14;
            lb = 0;
            ub = 17;
        case 5
            nrO = 30;
            xs=3;
            ys=3;
            xobs = [10.1 10.6 11.1 11.6 12.1 11.2 11.7 12.2 12.7 13.2 11.4 11.9 12.4 12.9 13.4 8 8.5 9 9.5 10 9.3 9.8 10.3 10.8 11.3 5.9 6.4 6.9 7.4 7.9];
            yobs = [8.8 8.8 8.8 8.8 8.8 11.7 11.7 11.7 11.7 11.7 9.3 9.3 9.3 9.3 9.3 5.3 5.3 5.3 5.3 5.3 6.7 6.7 6.7 6.7 6.7 8.4 8.4 8.4 8.4 8.4];
            robs = [0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4];
            xt = 14;
            yt = 14;
            lb = 0;
            ub = 17;
        case 6
            nrO = 45;
            xs=3;
            ys=3;
            xobs = [4 4 4 4 4 4 4 4 4 6 6 6 6 6 6 6 6 6 8 8 8 8 8 8 8 8 8 10 10 10 10 10 10 10 10 10 12 12 12 12 12 14 14 14 14];
            yobs = [3 3.5 4 4.5 5 5.5 6 6.5 7 8 8.5 9 9.5 10 10.5 11 11.5 12 1 1.5 2 2.5 3 3.4 4 4.5 5 6 6.5 7 7.5 8 8.5 9 9.5 10 10 10.5 11 11.5 12 10 10.5 11 11.5];
            robs = [0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4];
            xt = 15;
            yt = 15;
            lb = 0;
            ub = 18;
    end
    
    xmin=-lb;
    xmax= ub;
    
    ymin=-lb;
    ymax= ub;
    
    model.xs=xs;
    model.ys=ys;
    model.xt=xt;
    model.yt=yt;
    model.xobs=xobs;
    model.yobs=yobs;
    model.robs=robs;
    model.n=nrO;
    model.xmin=xmin;
    model.xmax=xmax;
    model.ymin=ymin;
    model.ymax=ymax;
    
end