function [best_tour, best_distance] = GA_perm(inputcities, crossover_prob, max_pop, max_iter, mutation_prob, k, eliteFraction, plot_graph)
    %fixed variables
    num_cities = size(inputcities,2);
    %%Default parameters if nothing is entered
    if nargin <8|| isempty(plot_graph)
    plot_graph = false;
    end
    %%Generating a random population
    pop = spawn_pop(max_pop,num_cities);
    numElites = max(1,round(eliteFraction * max_pop));
    %%Evaluating the fitness of the population
    %%
    [eval_dist,eval_pop,~] = evaluate_fitness(pop,inputcities);
    %%
    distance_log = zeros(1,max_pop*max_iter);
    distance_log(1,1:max_pop) = eval_dist;

    termination = false;
    t = 1;
    while termination==false

        parents = tournament_selection(eval_pop,k,max_pop,eval_dist);


        
        %%crossover
        offspring = parents;
        for i = 1:max_pop-1
            p_crossover = rand();
            %Crossover if applicable
            if p_crossover <= crossover_prob
                [child1, child2] = ox1(parents(i,:),parents(i+1,:));
                offspring(i,:) = child1;
                offspring(i+1,:) = child2;
            end
            %Performing mutating
            p_mutate = rand();
            if p_mutate <= mutation_prob
                p = randperm(2,1);
                if p == 1
                    offspring(i,:) = RSM(offspring(i,:));
                    offspring(i+1,:) = RSM(offspring(i+1,:));
                else
                    offspring(i,:) = inversion_mutation(offspring(i,:));
                    offspring(i+1,:) = inversion_mutation(offspring(i+1,:));
                    end

            end
        end

      
        [eval_dist,eval_pop,sorted_idx] = evaluate_fitness(offspring,inputcities);
        distance_log(1,max_pop*t+1:max_pop*t+max_pop) = eval_dist;

       

        eval_route = offspring(sorted_idx,:);



        

        elites = eval_route(1:numElites,:);
        random = randsample(numElites+1:max_pop,max_pop - numElites);

        eval_pop = [elites;eval_route(random,:)];
        eval_dist = [eval_dist(:,1:numElites),eval_dist(:,random)];

     
   




  
        if plot_graph == 1
            plotcities(inputcities(:,eval_pop(1,:))); % plotting the best performer
        end


        t = t+1;


        if (t>max_iter)
            termination=true;
        end
        


    end
    [sorted_log, ~] = sort(distance_log,'ascend');

    best_distance = sorted_log(:,1);
    best_tour = eval_pop(1,:);

end

function [pop] = spawn_pop(num_pop,num_cities)
    pop = zeros([num_pop num_cities]);
    for i = 1:size(pop,1)
        pop(i,:) = randperm(num_cities);
    end
end

function [child_1, child_2] = ox1(parent_1, parent_2)

child_1 = zeros(size(parent_1));
child_2 = zeros(size(parent_2));
n = size(parent_1,2);
crossover_point = sort(randperm(n - 1,2));
child_1(crossover_point(1):crossover_point(2)) = parent_1(crossover_point(1):crossover_point(2));
child_2(crossover_point(1):crossover_point(2)) = parent_2(crossover_point(1):crossover_point(2));

i = crossover_point(2) + 1;
k = 1;
used = [parent_2(crossover_point(2)+1:n),parent_2(1:crossover_point(2))];
used(ismember(used,child_1)) = [];
while true 

    if i == crossover_point(1)
        break
    end
    child_1(i) = used(k);
    i = mod(i, n) + 1 ;
    k = k + 1;
  
end

i = crossover_point(2) + 1;
k = 1;
used = [parent_1(crossover_point(2)+1:n),parent_1(1:crossover_point(2))];
used(ismember(used,child_2)) = [];

while true 

    if i == crossover_point(1)
        break
    end
    child_2(i) = used(k);
    i = mod(i, n) + 1 ;
    k = k + 1;

end
end

function [dist] = idx2dist(index,inputcities)
dist = zeros(1,size(index,1));
for i = 1:size(index,1)
    dist(:,i) = distance(inputcities(:,index(i,:)));
end
end


function [evaluated_dist, best_route, sorted_idx] = evaluate_fitness(population,inputcities)
population_distances = idx2dist(population,inputcities);
[sorted_dist, sorted_idx] = sort(population_distances,"ascend");
evaluated_dist = sorted_dist;
best_route = population(sorted_idx,:);
end
 



    

