%Importing the coordinates for TSP
addpath('Genetic_Algorithm');
cities = "att48.tsp";
cities = tsp_read(cities,48); 
%%
%%Defining the search space for local random search
crossover_prob = linspace(0.7,0.95,6)';
max_population = ceil(linspace(10,20,6))';
max_iterations = [10000;10000;10000;10000;10000;10000];
mutation_prob = linspace(0.001,0.05,6)';
selection_method = [1;1;1;1;1;1];
k = [5;6;7;8;5;5];
mutation_type = [1;1;1;1;1;1];
elitism_factor = linspace(0.05,0.2,6)'
tabs = table(crossover_prob,max_population,max_iterations,mutation_prob,selection_method,k,mutation_type,elitism_factor);
acceleration = "multi";

%%
[hyperparams, distances, stanard_devs] = main_random_local_search("ga",tabs,@GA_perm,cities,acceleration);
%%
combination = [hyperparams,distances, stanard_devs'];
save('GA_tune.mat','combination')
  
%% We want low distance and low std, which implies robustness and high performing.

candidates = [];

for i = 1:size(combination,1)
    if combination(i,9)<11100
        candidates(end + 1) = i;
    end
end

%%
hyperparams(1,:)
%%
crossover_prob = 0.95;
pop_size = 12;
iterations = 10000/pop_size;
mutation_prob = 0.05;
selection_method = 1;
k = 8;
mutation_type = 1;
elitism_factor = 0.14 ;
plots = false;
store = [];
for i = 1:30
    [~,b] = GA_perm(cities,crossover_prob,pop_size,iterations,mutation_prob,selection_method,k,mutation_type,elitism_factor,plots);
    store(end + 1) = b
end
calculate_mean = mean(store);
calculate_std = std(store);
%%









