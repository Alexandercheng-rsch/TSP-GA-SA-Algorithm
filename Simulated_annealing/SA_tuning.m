%%
%%inputcities,inital_temp,constant_decrement,k_max,num_neighbours,alpha,cooling_schedule,show_graph
addpath('Simulated_annealing');
addpath('Genetic_Algorithm');
cities = "att48.tsp";
cities = tsp_read(cities,48); 
%%

temp_max = [100;100;400;600;1000];
alpha = linspace(0.9, 0.99, 5)';
cooling_schedule = [100;200;300;400;500];
%temp_max, alpha, cooling_method, cooling_schedule,max_iterations, show_graph)
params = table(temp_max ,alpha,cooling_schedule);
acceleration = "multi";
[hyperparam, dist] = main_random_local_search("sa",params,@simulated_annealing,cities,acceleration);
%%
SA_combinations = [hyperparam,dist];
save('SA_parameter_search.mat', 'SA_combinations');

%%
t_max = 1000;
alpha = 0.99;
cooling_schedule = 500;
iterations = 10000;
show_graph = false

store_distance = [];
for i = 1:30
    [~,best_dist] = simulated_annealing(cities,t_max,alpha,cooling_schedule,iterations,show_graph);
    store_distance(end + 1) = best_dist
end
calculate_mean = mean(store_distance);
calculate_std = std(store_distance);

%%
t_max = 1000;
alpha = 0.999;
iterations = 10000;
cooling_schedule = 500;
show_graph = false
[~,best_dist] = simulated_annealing(cities,t_max,alpha,cooling_schedule,iterations,show_graph)