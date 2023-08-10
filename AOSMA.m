% The following is in large part the original code of the AOSMA. Only small 
% parts of the code are applied to the path finding problem 
%
% Christian Karg and Jonas Jakob Schwämmle
% ------------------------------------------------------------------------------------------------------------

% Adative Opposition Slime Mould Algorithm (AOSMA)
%
%
% Author and programmer: 
% Dr Manoj Kumar Naik
% Faculty of Engineering and Technology, Siksha O Anusandhan, Bhubaneswar, Odisha – 751030, India 
% e-mail:       naik.manoj.kumar@gmail.com
% ORCID:        https://orcid.org/0000-0002-8077-1811
% SCOPUS:       https://www.scopus.com/authid/detail.uri?authorId=35753522900
% Publons:      https://publons.com/researcher/2057920/manoj-kumar-naik/
% G-Scholar:    https://scholar.google.co.in/citations?user=tX-8Xw0AAAAJ&hl=en 
% Researchgate: https://www.researchgate.net/profile/Manoj_Naik9
% DBLP:         https://dblp.uni-trier.de/pers/k/Kumar:Naik_Manoj
%_____________________________________________________________________________________________________           
% Please cite to the main paper:
% ******************************
% Naik, Manoj Kumar; Panda, Rutuparna; Abraham, Ajith (2021): Adaptive 
% opposition slime mould algorithm. 
% In: Soft Comput 25 (22), S. 14297–14313. DOI: 10.1007/s00500-021-06140-2.
%
% This program using the framework of SMA by Ali Asghar Heidari
% https://aliasgharheidari.com/SMA.html
%_____________________________________________________________________________________________________

function [Destination_fitness,bestPositions,Convergence_curve, X]=AOSMA(N,Max_iter,lb,ub,dim,fobj, model, Function_name, showPlot, StpIt, StpEps)

bestPositions=zeros(1,dim);
Destination_fitness=inf;%change this to -inf for maximization problems
AllFitness = inf*ones(N,1);%record the fitness of all slime mold
weight = ones(N,dim);%fitness weight of each slime mold
%Initialize the set of random solutions

X=initialization(N,dim,ub,lb);
Convergence_curve=zeros(1,Max_iter);

it=1;  %Number of iterations
lb=ones(1,dim).*lb; % lower boundary 
ub=ones(1,dim).*ub; % upper boundary
z=0.03; % parameter

for i=1:N
        % Check if solutions go outside the search space and bring them back
        Flag4ub=X(i,:)>ub;
        Flag4lb=X(i,:)<lb;
        X(i,:)=(X(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        if strcmp(Function_name, 'F00')
            [AllFitness(i), ~] = fobj(X(i,:), model);
        else
            AllFitness(i) = fobj(X(i,:));
        end
        
end
% Main loop
while  it <= Max_iter
    oldfitness=AllFitness;
    [SmellOrder,SmellIndex] = sort(oldfitness);  %Eq.(7)
    worstFitness = SmellOrder(N);
    bestFitness = SmellOrder(1);

    S=bestFitness-worstFitness+eps;  % plus eps to avoid denominator zero

    %calculate the fitness weight of each slime mold
    for i=1:N
        for j=1:dim
            if i<=(N/2)  %Eq.(6)
                weight(SmellIndex(i),j) = 1+rand()*log10((bestFitness-SmellOrder(i))/(S)+1);
            else
                weight(SmellIndex(i),j) = 1-rand()*log10((bestFitness-SmellOrder(i))/(S)+1);
            end
        end
    end
    
    %update the best fitness value and best position
    if bestFitness < Destination_fitness
        bestPositions=X(SmellIndex(1),:);
        Destination_fitness = bestFitness;
    end
    a = atanh(-(it/Max_iter)+1);   %Eq.(11)
    b = 1-it/Max_iter;             %Eq.(12)
    % Update the Position of search agents
    for i=1:N       %Eq.(13)
        if rand<z     
            X(i,:) = (ub-lb)*rand+lb;   %Eq.(13c)
        else
            p =tanh(abs(oldfitness(i)-Destination_fitness));  %Eq.(4)
            vb = unifrnd(-a,a,1,dim);  
            vc = unifrnd(-b,b,1,dim);
            A = randi([1,N]);  % one positions randomly selected from population
            r2 = rand();
            for j=1:dim
                if r2<p    %Eq.(13a)
                    X(i,j) = bestPositions(j)+ vb(j)*(weight(i,j)*bestPositions(j)-X(A,j));
                else       %Eq.(13b)
                    X(i,j) = vc(j)*X(i,j);
                end
            end
        end
    end
    for i=1:N
        % Check if solutions go outside the search space and bring them back
        Flag4ub=X(i,:)>ub;
        Flag4lb=X(i,:)<lb;
        X(i,:)=(X(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        if strcmp(Function_name, 'F00')
            [AllFitness(i), ~] = fobj(X(i,:), model);
        else
            AllFitness(i) = fobj(X(i,:));
        end
    end
    for i=1:N
        if AllFitness(i)>oldfitness(i)              %Eq.(16)
            D(i,:)=min(X(i,:))+max(X(i,:))-X(i,:);  %Eq.(14)
            Flag4ub=D(i,:)>ub;
            Flag4lb=D(i,:)<lb;
            D(i,:)=(D(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
            if strcmp(Function_name, 'F00')
                [temp, ~] = fobj(D(i,:), model);
                if temp<AllFitness(i)           %Eq.(15)
                    X(i,:)=D(i,:);
                end
            else
                if fobj(D(i,:))<AllFitness(i)           %Eq.(15)
                    X(i,:)=D(i,:);
                end
            end
        end
    end
    Convergence_curve(it)=Destination_fitness;

    if it>200
        if sum(abs(diff(Convergence_curve(it-StpIt:it))))<StpEps
            break
        end
    end

    it=it+1;

    % Plot Solution
    if (mod(it-1, showPlot)==0) && strcmp('F00', Function_name) && showPlot
        figure(1);
        [temp, sol] = fobj(bestPositions, model);
        PlotSolution_SMA(sol, model);
        title(temp)
        pause(0.005);
    end
end
end