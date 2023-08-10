% Author and Programmer:
% Christian Karg and Jonas Jakob Schwämmle
% 
% In this main_Compare file all of the algorithms (SMA, LSMA, AOSMA) 
% can be run multiple times. For one single run you can use the 
% main file. 
%
% For the code structure of the oprtimization problem of path finding, to 
% which the algorithms are applied, is inspired by Yarpiz:
%
% https://yarpiz.com/50/ypea102-particle-swarm-optimization
%
%---------------------------------------------------------------------------------------------------------------------------


clear all 
close all
clc

%% Intitialisierung
showPlot = 0; % Wie oft soll die aktuelle Lösung geplottet werden (0 -> nie
% , 1 -> jedes Mail, 2 -> jedes zweite Mal,..., 5 -> jedes fünfte Mal, ...)

Function_name='F00'; % Name of the test function, range from F10-F13

Cards = 6; %Number of Cards, you want to run the algorithm %shouldn´t change that

export = 0; % you can save the figures

StpIt = 100; % nach, wie vielen Runden bei keiner Änderung gestoppt werden soll
StpEps = 1e-2; % Schranke für keine Änderung


for N = [30] % 30, 65, 100 % Number of search agents
for T = [300] %200 % 300 %500 % Maximum number of iterations
for Times = [1] % 10 %20 % 30 %Number of independent times you want to run the algorithm
for NumberofPoints = [4] %3,4, 7 %dimension size
close all
s = ['_NrA' num2str(N) '_MaxIt' num2str(T) '_Tms' num2str(Times) '_Pts' num2str(NumberofPoints) '.jpg'];

%% Code
% Load details of the selected benchmark function
dimSize = NumberofPoints*2; 
[lb,ub,dim,fobj]=Get_Functions_SMA(Function_name,dimSize);

% Initialisierung der Variablen
Destination_fitness = cell(3,Cards);
bestPositions = cell(3,Cards);
Convergence_curve = cell(3,Cards);
time = cell(3,Cards);
model = cell(Cards,1);
for j = 1:Cards
    % Festlegen der Karte, inkl. Oberer und unterer Grenze
    [model{j}, lb, ub] = CreateModelSMA(lb,ub, j);
    for i=1:Times
        % SMA
        tic;
        [Destination_fitness{1, j}(i), bestPositions{1, j}(i,:),Convergence_curve{1, j}(i,:)]=SMA(N,T,lb,ub,dim,fobj, model{j}, Function_name, showPlot, StpIt, StpEps);
        % display(['The optimal fitness of SMA is: ', num2str(Destination_fitness{1, j}(i))]);
        time{1, j}(i) = toc;
        % AOSMA
        tic;
        [Destination_fitness{2, j}(i), bestPositions{2, j}(i,:),Convergence_curve{2, j}(i,:)]=AOSMA(N,T,lb,ub,dim,fobj, model{j}, Function_name, showPlot, StpIt, StpEps);
        % display(['The optimal fitness of AOSMA is: ', num2str(Destination_fitness{2, j}(i))]);
        time{2, j}(i) = toc;
        % LSMA
        tic;
        [Destination_fitness{3, j}(i), bestPositions{3, j}(i,:),Convergence_curve{3, j}(i,:)]=LSMA(N,T,lb,ub,dim,fobj, model{j}, Function_name, showPlot, StpIt, StpEps);
        % display(['The optimal fitness of LSMA is: ', num2str(Destination_fitness{3, j}(i))]);
        time{3, j}(i) = toc;
    end
end

%% Plots und Statistiken
%% Plot jeder Karte mit der besten Lösung der drei Algorithmen (Zweimal 3x3
% Plot)
% Initialisierung der Variablen
bestfitness = zeros(3, Cards);
index = zeros(3, Cards);
bestSolPos = cell(3, Cards);
AllFitness = zeros(3,Cards);
% Abrufen der Daten
for j =1:Cards
    for i = 1:3
        [bestfitness(i,j),index(i,j)]=min(Destination_fitness{i, j});
        bestSolPos{i,j} = bestPositions{i, j}(index(i,j),:);
        bestCon{i,j} = Convergence_curve{i, j}(index(i,j),:);
    end
end
% Darstellung der Ergebnisse
figure('units','normalized','outerposition',[0 0 1 1]);
str = {'SMA', 'AOSMA', 'LSMA'};
for j=1:Cards/2
    for i=1:3
        subplot(3,3, (j-1)*3+i);
        [AllFitness(i,j), sol] = fobj(bestSolPos{i,j}, model{j});
        PlotSolution_SMA(sol, model{j});
        title([str{i} ' - Path length: ' num2str(AllFitness(i,j))])
    end
end
if export == 1
    saveas(gcf,['Pfade_Teil1' s])
end

figure('units','normalized','outerposition',[0 0 1 1]);
for j=(Cards/2)+1:Cards
    for i=1:3
        subplot(3,3, (j-((Cards/2)+1))*3+i);
        [AllFitness(i,j), sol] = fobj(bestSolPos{i,j}, model{j});
        PlotSolution_SMA(sol, model{j});
        title([str{i} ' - Path length: ' num2str(AllFitness(i,j))])
    end
end

if export == 1
    saveas(gcf,['Pfade_Teil2' s])
end
%% Plot jeder Karte mit der Konvergenz besten Lösung der drei Algorithmen (Zweimal 3x3
% Plot)
figure('units','normalized','outerposition',[0 0 1 1]);
for j=1:Cards/2
    for i=1:3
        subplot(3,3, (j-1)*3+i);
        semilogy(bestCon{i,j},'Color','b','LineWidth',4);
        title(['Convergence Curve of ' str{i} ' for Card ' num2str(j)]);
        xlabel('Iteration');
        ylabel('Path length');
        axis tight
        grid off
        box on
        legend(str{i})
    end
end
if export == 1
    saveas(gcf,['Konvergenzkurve_Teil1' s])
end

figure('units','normalized','outerposition',[0 0 1 1]);
for j=(Cards/2)+1:Cards
    for i=1:3
        subplot(3,3, (j-((Cards/2)+1))*3+i);
        semilogy(bestCon{i,j},'Color','b','LineWidth',4);
        title(['Convergence Curve of ' str{i} ' for Card ' num2str(j)])
        xlabel('Iteration');
        ylabel('Path length');
        axis tight
        grid off
        box on
        legend(str{i})
    end
end
if export == 1
    saveas(gcf,['Konvergenzkurve_Teil2' s])
end
%% Statistiken
figure('units','normalized','outerposition',[0 0 1 1]);
% Statstik/Balkendiagramm (x-Achse: Karten, y-Achse: duchschnittliche Lösung der drei
% Algorithmen)
avgSol = zeros(3, Cards);
for j=1: Cards
    for i =1:3
        avgSol(i,j) = mean(Destination_fitness{i,j});
    end
end
subplot(2,2,1);
bar(avgSol');
xlabel('Karte');
ylabel('Durchschnittliche Pfadlänge');
title('Durchschnittliche Pfadlänge für die einzelnen Karten');
legend({'SMA', 'AOSMA', 'LSMA'}, 'Location','northwest');

% Statstik/Balkendiagramm (x-Achse: Karten, y-Achse: beste Lösung der drei
% Algorithmen)
subplot(2,2,2);
bar(AllFitness');
xlabel('Karte');
ylabel('Pfadlänge');
title('Beste Pfadlänge für die einzelnen Karten');
legend({'SMA', 'AOSMA', 'LSMA'}, 'Location','northwest');

% Statstik/Balkendiagramm (x-Achse: Karten, y-Achse: durchschnittliche Standardabweichung
% der drei Algorithmen)
stdDev = zeros(3, Cards);
for j = 1:Cards
    for i =1:3
        stdDev(i,j) = std(Destination_fitness{i,j});
    end
end
subplot(2,2,3);
bar(stdDev');
xlabel('Karte');
ylabel('Standardabweichung');
title('Standardabweichung der Pfadlänge für die einzelnen Karten');
legend({'SMA', 'AOSMA', 'LSMA'}, 'Location','northwest');

% Statistik/Balkendiagramm (x-Achse: Karten, y-Achse: durchschnittliche
% Zeit)

avgTime = zeros(3, Cards);
for j=1: Cards
    for i =1:3
        avgTime(i,j) = mean(time{i,j});
    end
end
subplot(2,2,4);
bar(avgTime');
xlabel('Karte');
ylabel('Zeit');
title('Durchschnittliche Zeit für die einzelnen Karten');
legend({'SMA', 'AOSMA', 'LSMA'}, 'Location','northwest');
if export == 1
    saveas(gcf,['Statistiken' s])
end

            end
        end
    end
end