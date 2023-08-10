% The following is in large part the original code of the LSMA. Only small 
% parts of the code are applied to the path finding problem 
%
% Christian Karg and Jonas Jakob Schwämmle
% ------------------------------------------------------------------------------------------------------------

% Leader Slime Mould Algorithm (LSMA) source Code Version 1.0
%
% Developed in MATLAB R2018b
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
% M. K. Naik, R. Panda, and A. Abraham, “Normalized square difference based 
% multilevel thresholding technique for multispectral images using leader slime 
% mould algorithm,” J. King Saud Univ. - Comput. Inf. Sci., Nov. 2020, 
% doi: 10.1016/j.jksuci.2020.10.030.
%
% This program using the framework of SMA by Ali Asghar Heidari
% https://aliasgharheidari.com/SMA.html
%_____________________________________________________________________________________________________

function [Destination_fitness,bestPositions,Convergence_curve, X]=LSMA(N,Max_iter,lb,ub,dim,fobj, model, Function_name, showPlot, StpIt, StpEps)
bestPositions=zeros(1,dim);
Destination_fitness=inf;%change this to -inf for maximization problems
AllFitness = inf*ones(N,1);%record the fitness of all slime mold
weight = ones(N,dim);%fitness weight of each slime mold

%Initialize the set of random solutions
X=initialization(N,dim,ub,lb);  %Eq. (16)
Convergence_curve=zeros(1,Max_iter);

it=1;  %Number of iterations
lb=ones(1,dim).*lb; % lower boundary 
ub=ones(1,dim).*ub; % upper boundary
z=0.03; % parameter

% Main loop
while  it <= Max_iter
    
    %sort the fitness
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
    [SmellOrder,SmellIndex] = sort(AllFitness);  %Eq.(20)
    worstFitness = SmellOrder(N); %Eq. (23)
    bestFitness = SmellOrder(1);  %Eq. (22)
    bestPositions2=X(SmellIndex(2),:);%Leader 2
    bestPositions3=X(SmellIndex(3),:);%Leader 3
    
    S=bestFitness-worstFitness+eps;  % plus eps to avoid denominator zero

    %calculate the fitness weight of each slime mold
    for i=1:N
        for j=1:dim
            if i<=(N/2)  %Eq.(21)
                weight(SmellIndex(i),j) = 1+rand()*log10((bestFitness-SmellOrder(i))/(S)+1);
            else
                weight(SmellIndex(i),j) = 1-rand()*log10((bestFitness-SmellOrder(i))/(S)+1);
            end
        end
    end
    
    %update the best fitness value and best position
    if bestFitness < Destination_fitness
        bestPositions=X(SmellIndex(1),:); %Leader 1
        Destination_fitness = bestFitness;
    end
     
    a = atanh(-(it/Max_iter)+1);   %Eq.(18)
    b = 1-it/Max_iter;             %Eq.(19) 
    % Update the Position of search agents
    for i=1:N
        if rand<z     %Eq.(24.a)
            X(i,:) = (ub-lb)*rand+lb;
        else
            p =tanh(abs(AllFitness(i)-Destination_fitness));  %Eq.(17)
            vb = unifrnd(-a,a,1,dim);  
            vc = unifrnd(-b,b,1,dim);
            A = randi([1,N]);  % two positions randomly selected from population
            B = randi([1,N]);
            r1 = rand();
            for j=1:dim
                if r1<p    %Eq.(24.b)
                    X(i,j) = bestPositions(j)+ vb(j)*(((weight(i,j)*bestPositions2(j)...
                        -X(A,j))+(weight(i,j)*bestPositions3(j)-X(B,j))));
                else      %Eq.(24.c)
                    X(i,j) = vc(j)*X(i,j);
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

