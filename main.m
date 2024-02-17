%Importing the coordinates for TSP
addpath('Genetic_Algorithm');
file = "att48.tsp";
file = tsp_read(file,48); 
%%
%%Defining the search space for local random search
crossover_prob = [0.7:0.06:1]';
max_population = [9;10;13;15;17;20];
max_iterations = [100;100;100;100;100;100];
mutation_prob = [0.05:0.03:0.2]';
selection_method = [1;2;1;1;1;1;];
k = [3;4;5;6;7;8];
mutation_type = [1;2;3;1;1;1];
elitism_factor = [0.03:0.012:0.1]'
tabs = table(crossover_prob,max_population,max_iterations,mutation_prob,selection_method,k,mutation_type,elitism_factor);
acceleration = "cuda";

%%
store = [];
n = 5
for i = 1:n
    tic
    [b,c] = main_random_local_search("ga",tabs,@GA_perm,file,acceleration);
    toc
    combo_cat_with_dist_1 = cat(2,b,c);
    store = [store;combo_cat_with_dist_1];
end

%%
[mean_elements,std_elements, clusters] = cluster_calculator(store);

mean_elements = cell2mat(mean_elements);
std_elements = cell2mat(std_elements);
%%
clusters{27}
  
%% We want low distance and low std, which implies robustness and high performing.

candidates = [];

for i = 1:length(mean_elements)
    if mean_elements(i)<13400 && std_elements(i)<100
        candidates(end + 1) = i;
    end
end
candidates
%%

%%
[a,b] = sort(all);
asd = candidates(b)
asd(1:5)
%%
clusters{1699}
%%
crossover_prob = 0.88;
pop_size = 20;
iterations = 10000/pop_size;
mutation_prob = 0.17;
selection_method = 1;
k = 5;
mutation_type = 2;
elitism_factor = 0.078;
plots = false;
store = [];
for i = 1:30
    [~,b] = GA_perm(file,crossover_prob,pop_size,iterations,mutation_prob,selection_method,k,mutation_type,elitism_factor,plots);
    store(end + 1) = b
end
calculate_mean = mean(store);
calculate_std = std(store);
%%











%%
%%inputcities,inital_temp,constant_decrement,k_max,num_neighbours,alpha,cooling_schedule,show_graph
addpath('Simulated_annealing');
%%
inital_t = 90;
constant_decrement = 1.9;
k_max = 10000;
num_neighbours = 5
cooling_technique = 3;
alpha = 0.95;
show_graph = true;
cooling_schedule = 1;
[x_best,best_dist] = simulated_annealing(file,inital_t,constant_decrement,k_max,num_neighbours,alpha,cooling_technique,cooling_schedule,show_graph)

%%cooling methods: 1 - exponential 2- Linear 3 - Boltzman
%%
inital_temp = [90;95;100;110;120;130;150];
constant_decrement = [1;2;3;4;5;6;7];
k_max = [100;100;100;100;100;100;100];
num_neighbours = [1;2;3;4;5;6;7];
alpha = [1;1;1;1;1;1;1;];
cooling_technique = [2;2;2;2;2;2;2];
cooling_schedule = [0;1;2;3;4;5;6];
params = table(inital_temp,constant_decrement,k_max,num_neighbours,alpha,cooling_technique,cooling_schedule);
acceleration = "cuda";

n = 30;
for i = 1:n
    [b,c] = main_random_local_search("sa",params,@simulated_annealing,file,acceleration);
    combo_cat_with_dist = cat(2,b,c);
    if i==2
        concated_list_1 = cat(1,combo_cat_with_dist,combo_cat_with_dist);
    elseif i>2
        concated_list_1 = cat(1,concated_list_1,combo_cat_with_dist);
    end
end

%%


inital_temp = [90;95;100;110;120;130;150];
constant_decrement = [1;1;1;1;1;1;1];
k_max = [100;100;100;100;100;100;100];
num_neighbours = [1;2;3;4;5;6;7];
alpha = [0.8;0.85;0.9;0.93;0.94;0.95;0.99];
cooling_technique = [1;1;1;1;1;1;1];
cooling_schedule = [0;1;2;3;4;5;6];
params = table(inital_temp,constant_decrement,k_max,num_neighbours,alpha,cooling_technique,cooling_schedule);
acceleration = "cuda";
%[hyperparam_2, dist_2] = main_random_local_search("sa",params,@simulated_annealing,file,accel)

n = 30;
for i = 1:n
    [b,c] = main_random_local_search("sa",params,@simulated_annealing,file,acceleration);
    combo_cat_with_dist = cat(2,b,c);
    if i==2
        concated_list_2 = cat(1,combo_cat_with_dist,combo_cat_with_dist);
    elseif i>2
        concated_list_2 = cat(1,concated_list_2,combo_cat_with_dist);
    end
end


%%
inital_temp = [90;95;100;110;120;130;150];
constant_decrement = [1;1;1;1;1;1;1];
k_max = [100;100;100;100;100;100;100];
num_neighbours = [1;2;3;4;5;6;7];
alpha = [1;1;1;1;1;1;1];
cooling_technique = [3;3;3;3;3;3;3];
cooling_schedule = [0;1;2;3;4;5;6];
params = table(inital_temp,constant_decrement,k_max,num_neighbours,alpha,cooling_technique,cooling_schedule);
acceleration = "cuda";


n = 30;
for i = 1:n
    [b,c] = main_random_local_search("sa",params,@simulated_annealing,file,acceleration);
    combo_cat_with_dist = cat(2,b,c);
    if i==2
        concated_list_3 = cat(1,combo_cat_with_dist,combo_cat_with_dist);
    elseif i>2
        concated_list_3 = cat(1,concated_list_3,combo_cat_with_dist);
    end
end

%%
cat_1_and_2 = cat(1,concated_list_1,concated_list_2);
cat_all = cat(1,cat_1_and_2,concated_list_3);
%%

[mean_elements,std_elements, clusters] = cluster_calculator(cat_all);

mean_elements = cell2mat(mean_elements);
std_elements = cell2mat(std_elements);
[sorted_std,idx_std] = sort(std_elements,'ascend');
[sorted_mean,idx_mean] = sort(mean_elements,'ascend');

%% We want low distance and low std, which implies robustness and high performing.
threshold = 1;
candidates = [];
termination_flag = false
for i = 1:size(sorted_mean,1)
    for j = i+1:size(sorted_std,1)-1
        if idx_std(i)==idx_mean(j)  && termination_flag==false
            candidates(1 + end) = idx_mean(j);
        elseif j > 3000
            termination_flag = true;
        end
    end
    if termination_flag
        break
    end
end
%%
winner = clusters{candidates(1)};
mean(winner(:,8))
std(winner(:,8))
%%

inital_t = 1000000;

constant_decrement = 1;
k_max = 10000;
num_neighbours = 0 
cooling_method = 1;
alpha = 0.999;
show_graph = false;
cooling_schedule = 10;
[good,best_dist] = simulated_annealing(file, inital_t, constant_decrement, k_max, num_neighbours, alpha, cooling_method, cooling_schedule, show_graph)
plotcities(file(:,good))







































