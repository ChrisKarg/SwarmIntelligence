
% In this main file one of the algorithms to be selected (SMA, LSMA, AOSMA) 
% can be run once. For multiple runs and comparisons, you can use the 
% main_Compare file. The basic code for the SMA algorithm is based on:
%
% Slime Mould Algorithm: A New Method for Stochastic Optimization
% Shimin Li, Huiling Chen, Mingjing Wang, Ali Asghar Heidari, Seyedali Mirjalili
% Future Generation Computer Systems,2020
% DOI: https://doi.org/10.1016/j.future.2020.03.055
% https://www.sciencedirect.com/science/article/pii/S0167739X19320941
%
% For the code structure of the oprtimization problem of path finding, to 
% which the algorithms are applied, is inspired by Yarpiz:
%
% https://yarpiz.com/50/ypea102-particle-swarm-optimization
%---------------------------------------------------------------------------------------------------------------------------


clear all 
close all
clc

%% Intitialisierung
showPlot = 7; % Wie oft soll die aktuelle Lösung geplottet werden (0 -> nie
% , 1 -> jedes Mail, 2 -> jedes zweite Mal,..., 5 -> jedes fünfte Mal, ...)

N=30; % Number of search agents

Function_name='F00'; % Name of the test function, range from F10-F13

T=400; % Maximum number of iterations

NumberofPoints = 4;

dimSize = NumberofPoints*2;   %dimension size

StpIt = 100; % nach, wie vielen Runden bei keiner Änderung gestoppt werden soll
StpEps = 1e-2; % Schranke für keine Änderung

%% Code
% Load details of the selected benchmark function
[lb,ub,dim,fobj]=Get_Functions_SMA(Function_name,dimSize);

% Festlegen der Karte, inkl. Start und Endpunkt
[model, lb, ub] = CreateModelSMA(lb,ub, 1); 

% SMA Algorithmus
[Destination_fitness,bestPositions,Convergence_curve,X] = SMA(N,T,lb,ub,dim,fobj, model, Function_name, showPlot, StpIt, StpEps);

%% Plots
% Convergernce Curve
figure,
hold on
semilogy(Convergence_curve,'Color','b','LineWidth',4);
title('Convergence curve')
xlabel('Iteration');
ylabel('Best fitness obtained so far');
axis tight
grid off
box on
legend('SMA')

% Endgültiges Ergebnis
figure
if strcmp(Function_name, 'F00')
    [AllFitness, sol] = fobj(bestPositions, model);
    PlotSolution_SMA(sol, model);
    title(['Bestes Ergebnis des SMAs mit einer Pfadlänge von ' num2str(AllFitness)])
else
    points = [start bestPositions End];
    points2 = zeros(length(points)/2, 2);
    k=1;
    for i=1:2:length(points)
        points2(k,:) = [points(i) points(i+1)]';
        k=k+1;
    end
    plot(points2(:,1),points2(:,2),'--o')
end


display(['The best location of SMA is: ', num2str(bestPositions)]);
display(['The best fitness of SMA is: ', num2str(Destination_fitness)]);