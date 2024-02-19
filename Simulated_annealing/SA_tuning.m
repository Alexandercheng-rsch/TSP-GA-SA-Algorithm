%%
%%inputcities,inital_temp,constant_decrement,k_max,num_neighbours,alpha,cooling_schedule,show_graph
addpath('Simulated_annealing');
addpath('Genetic_Algorithm');
cities = "att48.tsp";
cities = tsp_read(cities,48); 
%%
repmat(100,10)
temp_max = linspace(100,10000, 6)';
alpha = linspace(0.8, 0.99, 6)';
cooling_technique = [1;2;1;1;1;1];
cooling_schedule = round(linspace(100, 700, 6))';
%temp_max, alpha, cooling_method, cooling_schedule,max_iterations, show_graph)
params = table(temp_max ,alpha, cooling_technique, cooling_schedule);
acceleration = "multi";
[hyperparam, dist, std] = main_random_local_search("sa",params,@simulated_annealing,cities,acceleration);
%%
concat = [hyperparam,dist,std]
%% We want low distance and low std, which implies robustness and high performing.

candidates = [];

for i = 1:size(concat,1)
    if concat(i,5)<10905 & concat(i,6)<100
        candidates(end + 1) = i;
    end
end
candidates
%%
best = hyperparam(1,:)

%%
t_max = 100;
alpha = 0.99;
cooling_technique = 1;
cooling_schedule = 700;
iterations = 10000;
show_graph = false
[a,best_dist] = simulated_annealing(cities,t_max,alpha,cooling_technique,cooling_schedule,iterations,show_graph);
plotcities(cities(:,a))
%%
store_distance = []
for i = 1:30
    [~,best_dist] = simulated_annealing(cities,t_max,alpha,cooling_technique,cooling_schedule,iterations,show_graph);
    store_distance(end + 1) = best_dist;
end
calculate_mean = mean(store_distance);
calculate_std = std(store_distance);